CREATE OR REPLACE TRIGGER check_customer_of_order_exist
    BEFORE INSERT OR UPDATE OF customerid
    ON Orders_Details
    FOR EACH ROW
DECLARE
    invalid_customer EXCEPTION;
    confirm_data Orders_Details.customerid%TYPE;
BEGIN
    SELECT customerid INTO confirm_data FROM Orders_Details WHERE EXISTS(SELECT customerid FROM Customers_Details cd WHERE cd.customerid = :NEW.customerid);
    IF confirm_data IS NULL THEN
        dbms_output.put_line( 'Customer ID does not exist in the database!' );
        RAISE invalid_customer;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER check_if_review_item_exists
    BEFORE INSERT OR UPDATE OF product_name
    ON Product_Review
    FOR EACH ROW
DECLARE
    confirm_data Product_Review.product_name%TYPE;
    invalid_order_item EXCEPTION;
BEGIN
    SELECT product_name INTO confirm_data FROM Warehouse_inventory wi WHERE wi.product_name = :NEW.product_name;
    IF confirm_data IS NULL THEN
        dbms_output.put_line( 'Customer ID does not exist in the database!' );
        RAISE invalid_order_item;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER check_warehouse_address_exists
    BEFORE INSERT OR UPDATE OF addressid
    ON Warehouse_Details
    FOR EACH ROW
DECLARE
    confirm_data Warehouse_Details.addressid%TYPE;
    invalid_address EXCEPTION;
BEGIN
    SELECT addressid INTO confirm_data FROM Warehouse_Details WHERE EXISTS(SELECT addressid FROM Location_Details ld WHERE ld.addressid = :NEW.addressid);
    IF confirm_data IS NULL THEN
        dbms_output.put_line( 'Address does not exist' );
        RAISE invalid_address;
    END IF;
END;
/
DROP TRIGGER avg_review_score;
/
CREATE OR REPLACE TRIGGER illegal_order_handling
    BEFORE INSERT
    ON Orders_Details
    FOR EACH ROW
DECLARE
    not_enough_items EXCEPTION;
    items_available Warehouse_inventory.quantity%TYPE;
BEGIN
    SELECT wi.quantity INTO items_available FROM Warehouse_Inventory wi WHERE wi.product_name = :NEW.product_name;
    IF items_available < :NEW.quantity THEN
        RAISE not_enough_items;
    END IF;
END;
/
--TABLE AUDIT LOG TRIGGERS
CREATE OR REPLACE TRIGGER location_audit
AFTER INSERT OR UPDATE OR DELETE
ON location_details
FOR EACH ROW
DECLARE
    operation_type location_log.operation_type%TYPE;
BEGIN
    IF INSERTING THEN
        operation_type:= 'INSERT';
    END IF;
    IF UPDATING THEN
        operation_type:= 'UPDATE';
    END IF;
    IF DELETING THEN
        operation_type:= 'DELETE';
    END IF;
    INSERT INTO location_log
    (AddressID,
    operation_type,
    oldAddress,
    newAddress,
    oldCountry,
    newCountry,
    oldCity,
    newCity,
    timestamp
    )
    VALUES(
        :OLD.AddressID,
        operation_type,
        :OLD.address,
        :NEW.address,
        :OLD.country,
        :NEW.country,
        :OLD.city,
        :NEW.city,
        SYSDATE
    );
END;
/
CREATE OR REPLACE TRIGGER products_details_audit
AFTER INSERT OR UPDATE OR DELETE
ON products_details
FOR EACH ROW
DECLARE
    operation_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        operation_type := 'INSERT';
    ELSIF UPDATING THEN
        operation_type := 'UPDATE';
    ELSIF DELETING THEN
        operation_type := 'DELETE';
    END IF;

    INSERT INTO products_details_log (
        product_name,
        operation_type,
        old_price,
        new_price,
        old_store,
        new_store,
        old_product_category,
        new_product_category,
        timestamp
    )
    VALUES (
        :OLD.product_name,
        operation_type,
        :OLD.price,
        :NEW.price,
        :OLD.store,
        :NEW.store,
        :OLD.product_category,
        :NEW.product_category,
        SYSDATE
    );
END;
/
CREATE OR REPLACE TRIGGER customers_details_audit
AFTER INSERT OR UPDATE OR DELETE
ON customers_details
FOR EACH ROW
DECLARE
    operation_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        operation_type := 'INSERT';
    ELSIF UPDATING THEN
        operation_type := 'UPDATE';
    ELSIF DELETING THEN
        operation_type := 'DELETE';
    END IF;

    INSERT INTO customers_details_log (
        customerID,
        operation_type,
        old_customer_email,
        new_customer_email,
        old_first_name,
        new_first_name,
        old_last_name,
        new_last_name,
        old_AddressID,
        new_AddressID,
        timestamp
    )
    VALUES (
        :OLD.customerID,
        operation_type,
        :OLD.customer_email,
        :NEW.customer_email,
        :OLD.first_name,
        :NEW.first_name,
        :OLD.last_name,
        :NEW.last_name,
        :OLD.AddressID,
        :NEW.AddressID,
        SYSDATE
    );
END;
/
CREATE OR REPLACE TRIGGER orders_details_audit
AFTER INSERT OR UPDATE OR DELETE
ON orders_details
FOR EACH ROW
DECLARE
    operation_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        operation_type := 'INSERT';
    ELSIF UPDATING THEN
        operation_type := 'UPDATE';
    ELSIF DELETING THEN
        operation_type := 'DELETE';
    END IF;

    INSERT INTO orders_details_log (
        orderid,
        operation_type,
        old_customerID,
        new_customerID,
        old_product_name,
        new_product_name,
        old_price,
        new_price,
        old_quantity,
        new_quantity,
        old_order_date,
        new_order_date,
        timestamp
    )
    VALUES (
        :OLD.orderid,
        operation_type,
        :OLD.customerID,
        :NEW.customerID,
        :OLD.product_name,
        :NEW.product_name,
        :OLD.price,
        :NEW.price,
        :OLD.quantity,
        :NEW.quantity,
        :OLD.order_date,
        :NEW.order_date,
        SYSDATE
    );
END;
/
CREATE OR REPLACE TRIGGER warehouse_inventory_audit
AFTER INSERT OR UPDATE OR DELETE
ON warehouse_inventory
FOR EACH ROW
DECLARE
    operation_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        operation_type := 'INSERT';
    ELSIF UPDATING THEN
        operation_type := 'UPDATE';
    ELSIF DELETING THEN
        operation_type := 'DELETE';
    END IF;

    INSERT INTO warehouse_inventory_log (
        product_name,
        warehouse_name,
        operation_type,
        old_quantity,
        new_quantity,
        timestamp
    )
    VALUES (
        :OLD.product_name,
        :OLD.warehouse_name,
        operation_type,
        :OLD.quantity,
        :NEW.quantity,
        SYSDATE
    );
END;
/
CREATE OR REPLACE TRIGGER product_review_audit
AFTER INSERT OR UPDATE OR DELETE
ON product_review
FOR EACH ROW
DECLARE
    operation_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        operation_type := 'INSERT';
    ELSIF UPDATING THEN
        operation_type := 'UPDATE';
    ELSIF DELETING THEN
        operation_type := 'DELETE';
    END IF;

    INSERT INTO product_review_log (
        product_name,
        customerID,
        operation_type,
        old_review,
        new_review,
        old_review_description,
        new_review_description,
        old_review_flag,
        new_review_flag,
        timestamp
    )
    VALUES (
        :OLD.product_name,
        :OLD.customerID,
        operation_type,
        :OLD.review,
        :NEW.review,
        :OLD.review_description,
        :NEW.review_description,
        :OLD.review_flag,
        :NEW.review_flag,
        SYSDATE
    );
END;
/
CREATE OR REPLACE TRIGGER warehouse_details_audit
AFTER INSERT OR UPDATE OR DELETE
ON warehouse_details
FOR EACH ROW
DECLARE
    operation_type warehouse_details_log.operation_type%TYPE;
BEGIN
    IF INSERTING THEN
        operation_type := 'INSERT';
    ELSIF UPDATING THEN
        operation_type := 'UPDATE';
    ELSIF DELETING THEN
        operation_type := 'DELETE';
    END IF;

    INSERT INTO warehouse_details_log (
        warehouseName,
        operation_type,
        oldAddressID,
        newAddressID,
        timestamp
    )
    VALUES (
        :OLD.warehouse_name,
        operation_type,
        :OLD.AddressID,
        :NEW.AddressID,
        SYSDATE
    );
END;