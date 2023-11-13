CREATE OR REPLACE PACKAGE SuperStorePackage AS

    --Products table
    PROCEDURE AddProduct(product ProductObj);
    PROCEDURE UpdateProduct(productNameToChange VARCHAR2,price NUMBER,store VARCHAR2,category VARCHAR2);
    PROCEDURE DeleteProduct(productName VARCHAR2);

    
    -- Warehouse table
    PROCEDURE AddWarehouse(warehouse warehouseObj);
    PROCEDURE UpdateWarehouse(warehouseName VARCHAR2, warehouseAddress VARCHAR2);
    PROCEDURE DeleteWarehouse(warehouseName VARCHAR2);


    -- Orders table
    PROCEDURE AddOrder(orderO orderObj);
    PROCEDURE UpdateOrder(orderID NUMBER, customerID NUMBER, productName VARCHAR2, quantity NUMBER, orderDate DATE);
    PROCEDURE DeleteOrder(orderID NUMBER);

    
    -- Product Review Table
    PROCEDURE AddProductReview(reviewO productReviewObj);
    PROCEDURE UpdateProductReview(orderID NUMBER, review VARCHAR2, reviewDescription VARCHAR2, reviewFlag NUMBER);
    PROCEDURE DeleteProductReview(orderID NUMBER);

    
    -- Customers table
    PROCEDURE AddCustomer(customer customerObj);
    PROCEDURE UpdateCustomer(customerID NUMBER, customerEmail VARCHAR2, firstName VARCHAR2, lastName VARCHAR2, customerAddress VARCHAR2);
    PROCEDURE DeleteCustomer(customerID NUMBER);  

    
    -- Warehouse Inventory
    PROCEDURE AddWarehouseInventory(inventory warehouseInventoryObj);
    PROCEDURE UpdateWarehouseInventory(productName VARCHAR2, warehouseName VARCHAR2, quantity NUMBER);
    PROCEDURE DeleteWarehouseInventory(productName VARCHAR2, warehouseName VARCHAR2);

    FUNCTION GetCustomer(customerID NUMBER)
    RETURN customerObj;
--    FUNCTION GetProductReview(orderID NUMBER)
--    RETURN ProductReviewObj;
--    FUNCTION GetOrder(orderID NUMBER)
--    RETURN orderObj;
--    FUNCTION GetWarehouse(warehouseName VARCHAR2)
--    RETURN warehouseObj;
--    FUNCTION GetProduct(productName VARCHAR2)
--    RETURN productObj;
--    FUNCTION GetWarehouseInventory(productName VARCHAR2, warehouseName VARCHAR2)
--    RETURN warehouseInventoryObj;
    
    
    --EXCEPTIONS
    
    
    --TRIGGERS
    
END SuperStorePackage;
/
CREATE OR REPLACE PACKAGE BODY SuperStorePackage AS
    --Functions for Products Table
    PROCEDURE AddProduct
    (product IN productObj)
    IS
    BEGIN
        INSERT INTO Products_Details(Product_name,price,store,product_category)
        VALUES(product.product_name,product.price,product.store,product.product_category);
        COMMIT;
    END AddProduct;
    

    PROCEDURE UpdateProduct(productNameToChange VARCHAR2,price NUMBER,store VARCHAR2,category VARCHAR2)
    AS
    BEGIN
        UPDATE Products_Details
        SET
        price=price, store=store, product_category=category
        WHERE product_name = productNameToChange;
        COMMIT;
    END updateProduct;
    
    PROCEDURE DeleteProduct(productName VARCHAR2)
    AS
    BEGIN
        DELETE Products_Details
        WHERE product_name=productName;
        COMMIT;
    END deleteProduct;
    
    -- Procedure to Add Warehouse
    PROCEDURE AddWarehouse(warehouse IN warehouseObj)
    AS
    BEGIN
        INSERT INTO Warehouse_Details(warehouse_name, warehouse_address)
        VALUES(warehouse.warehouse_name,warehouse.warehouse_address);
        COMMIT;
    END AddWarehouse;
    

    -- Procedure to Update Warehouse
    PROCEDURE UpdateWarehouse(warehouseName VARCHAR2, warehouseAddress VARCHAR2)
    AS
    BEGIN
        UPDATE Warehouse_Details
        SET warehouse_address = warehouseAddress
        WHERE warehouse_name = warehouseName;
        COMMIT;
    END updateWarehouse;
    
    -- Procedure to Delete Warehouse
    PROCEDURE DeleteWarehouse(warehouseName VARCHAR2)
    AS
    BEGIN
        DELETE FROM Warehouse_Details
        WHERE warehouse_name = warehouseName;
        COMMIT;
    END deleteWarehouse;
    
    -- Procedure to Add Order
    PROCEDURE AddOrder(orderO IN orderObj)
    AS
    BEGIN
        INSERT INTO Orders_Details(customerID, product_name, quantity, order_date)
        VALUES (orderO.customerID,orderO.product_name,orderO.quantity,orderO.order_date);
        COMMIT;
    END AddOrder;
    
   
    -- Procedure to Update Order
    PROCEDURE UpdateOrder(orderID NUMBER, customerID NUMBER, productName VARCHAR2, quantity NUMBER, orderDate DATE)
    AS
    BEGIN
        UPDATE Orders_Details
        SET customerID = customerID, product_name = productName, quantity = quantity, order_date = orderDate
        WHERE orderid = orderID;
        COMMIT;
    END updateOrder;
    
    -- Procedure to Delete Order
    PROCEDURE DeleteOrder(orderID NUMBER)
    AS
    BEGIN
        DELETE FROM Orders_Details
        WHERE orderid = orderID;
        COMMIT;
    END deleteOrder;
    
    
     -- Product Review Table
    PROCEDURE AddProductReview(reviewO IN productReviewObj)
    AS
    BEGIN
        INSERT INTO Product_Review(orderid, review, review_description, review_flag)
        VALUES(reviewO.orderid,reviewO.review,reviewO.review_description,reviewO.review_flag);
        COMMIT;
    END AddProductReview;

    PROCEDURE UpdateProductReview(orderID NUMBER, review VARCHAR2, reviewDescription VARCHAR2, reviewFlag NUMBER)
    AS
    BEGIN
        UPDATE Product_Review
        SET review = review, review_description = reviewDescription, review_flag = reviewFlag
        WHERE orderid = orderID;
        COMMIT;
    END UpdateProductReview;

    PROCEDURE DeleteProductReview(orderID NUMBER)
    AS
    BEGIN
        DELETE FROM Product_Review
        WHERE orderid = orderID;
        COMMIT;
    END DeleteProductReview;
    
    
    -- Customers table
    PROCEDURE AddCustomer(customer IN customerObj)
    AS
    BEGIN
        INSERT INTO Customers_Details(customer_email, first_name, last_name, customer_address)
        VALUES(customer.customer_email,customer.first_name,customer.last_name,customer.customer_address);
        COMMIT;
    END AddCustomer;

    PROCEDURE UpdateCustomer(customerID NUMBER, customerEmail VARCHAR2, firstName VARCHAR2, lastName VARCHAR2, customerAddress VARCHAR2)
    AS
    BEGIN
        UPDATE Customers_Details
        SET customer_email = customerEmail, first_name = firstName, last_name = lastName, customer_address = customerAddress
        WHERE customerID = customerID;
        COMMIT;
    END UpdateCustomer;

    PROCEDURE DeleteCustomer(customerID NUMBER)
    AS
    BEGIN
        DELETE FROM Customers_Details
        WHERE customerID = customerID;
        COMMIT;
    END DeleteCustomer;

    -- Warehouse Inventory
    PROCEDURE AddWarehouseInventory(inventory IN warehouseInventoryObj)
    AS
    BEGIN
        INSERT INTO Warehouse_Inventory(product_name, warehouse_name, quantity)
        VALUES(inventory.product_name,inventory.warehouse_name,inventory.quantity);
        COMMIT;
    END AddWarehouseInventory;

    PROCEDURE UpdateWarehouseInventory(productName VARCHAR2, warehouseName VARCHAR2, quantity NUMBER)
    AS
    BEGIN
        UPDATE Warehouse_Inventory
        SET quantity = quantity
        WHERE product_name = productName AND warehouse_name = warehouseName;
        COMMIT;
    END UpdateWarehouseInventory;

    PROCEDURE DeleteWarehouseInventory(productName VARCHAR2, warehouseName VARCHAR2)
    AS
    BEGIN
        DELETE FROM Warehouse_Inventory
        WHERE product_name = productName AND warehouse_name = warehouseName;
        COMMIT;
    END DeleteWarehouseInventory;

 --GETTERS FOR THE TABLES
 --Idea of how to do my getter
    FUNCTION GetCustomer(customerID NUMBER)
    RETURN customerObj
    AS
        vCustomer customerObj;
    BEGIN
        SELECT customerID, customer_email, first_name, last_name, customer_address
        INTO vCustomer.customerID,vCustomer.customer_email,vCustomer.first_name,vCustomer.last_name,vCustomer.customer_address
        FROM Customers_Details
        WHERE customerID = customerID;

        RETURN vCustomer;

        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('No data found for customer ID given');
    END GetCustomer;
--
--    FUNCTION GetProductReview(orderID NUMBER)
--    RETURN ProductReviewObj
--    AS
--        vProductReview ProductReviewObj;
--    BEGIN
--        SELECT orderid, review, review_description, review_flag
--        INTO vProductReview
--        FROM Product_Review
--        WHERE orderid = orderID;
--
--        RETURN vProductReview;
--
--        EXCEPTION 
--            WHEN NO_DATA_FOUND THEN
--                dbms_output.put_line('No data found for order ID given');
--    END GetProductReview;
--
--  --Function to Get Order
--    FUNCTION getOrder(orderID NUMBER)
--    RETURN orderObj
--    AS
--        vOrder orderObj;
--    BEGIN
--        SELECT orderid, customerID, product_name, quantity, order_date
--        INTO vOrder
--        FROM Orders_Details
--        WHERE orderid = orderID;
--    
--        RETURN vOrder;
--    
--        EXCEPTION 
--            WHEN NO_DATA_FOUND THEN
--                dbms_output.put_line('No data found for order ID given');
--    END getOrder;
--
--    -- Function to Get Warehouse
--    FUNCTION GetWarehouse(warehouseName VARCHAR2)
--    RETURN warehouseObj
--    IS
--        vWarehouse warehouseObj;
--    BEGIN
--        SELECT warehouse_name,warehouse_address
--        INTO vWarehouse
--        FROM Warehouse_Details
--        WHERE warehouse_name = warehouseName;
--    
--        RETURN vWarehouse;
--    
--        EXCEPTION 
--            WHEN NO_DATA_FOUND THEN
--                dbms_output.put_line('No data found for warehouse name given');
--    END getWarehouse;
--
--    FUNCTION GetProduct(productName VARCHAR2)
--    RETURN productObj
--    AS
--        vProduct productObj;
--    BEGIN
--        SELECT product_name,price,store,product_category
--        INTO vProduct
--        FROM Products_details
--        WHERE product_name=productName;
--        
--        RETURN vProduct;
--    
--        EXCEPTION 
--            WHEN NO_DATA_FOUND THEN
--                dbms_output.put_line('No data found for product name given');
--    END getProduct;
--
--    FUNCTION GetWarehouseInventory(productName VARCHAR2, warehouseName VARCHAR2)
--    RETURN warehouseInventoryObj
--    AS
--        vWarehouseInventory warehouseInventoryObj;
--    BEGIN
--        SELECT product_name, warehouse_name, quantity
--        INTO vWarehouseInventory
--        FROM warehouse_inventory
--        WHERE product_name = productName AND warehouse_name = warehouseName;
--
--        RETURN vWarehouseInventory;
--
--        EXCEPTION 
--            WHEN NO_DATA_FOUND THEN
--                dbms_output.put_line('No data found for product in the warehouse');
--    END GetWarehouseInventory;
 
END SuperStorePackage;
/

