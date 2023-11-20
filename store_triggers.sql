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