CREATE OR REPLACE PACKAGE SuperStorePackage AS

    --Products table
    PROCEDURE AddProduct(product ProductObj);
    PROCEDURE UpdateProduct(productToChange VARCHAR2,newPrice NUMBER,newStore VARCHAR2,newCategory VARCHAR2);
    PROCEDURE DeleteProduct(productToRemove VARCHAR2);

    
    -- Warehouse table
    PROCEDURE AddWarehouse(warehouse warehouseObj);
    PROCEDURE UpdateWarehouse(warehouseToChange VARCHAR2, newWarehouseAddress NUMBER);
    PROCEDURE DeleteWarehouse(warehouseToRemove VARCHAR2);


    -- Orders table
    PROCEDURE AddOrder(orderO orderObj);
    PROCEDURE UpdateOrder(orderToChange NUMBER, newCustomerID NUMBER, newProductName VARCHAR2,newPrice NUMBER, newQuantity NUMBER, newOrderDate DATE);
    PROCEDURE DeleteOrder(orderToRemove NUMBER);

    
    -- Product Review Table
    PROCEDURE AddProductReview(reviewO productReviewObj);
    PROCEDURE UpdateProductReview(reviewToChange VARCHAR2,customerReviewerID NUMBER, newReview VARCHAR2, newReviewDescription VARCHAR2, newReviewFlag NUMBER);
    PROCEDURE DeleteProductReview(reviewToRemove VARCHAR2);

    
    -- Customers table
    PROCEDURE AddCustomer(customer customerObj);
    PROCEDURE UpdateCustomer(customerToChange NUMBER, customerEmail VARCHAR2, firstName VARCHAR2, lastName VARCHAR2, customerAddress NUMBER);
    PROCEDURE DeleteCustomer(customerToRemove NUMBER);  

    
    -- Warehouse Inventory
    PROCEDURE AddWarehouseInventory(inventory warehouseInventoryObj);
    PROCEDURE UpdateWarehouseInventory(productToChange VARCHAR2, warehouseToChange VARCHAR2, newQuantity NUMBER);
    PROCEDURE DeleteWarehouseInventory(productNameToRemove VARCHAR2, warehouseNameToRemove VARCHAR2);

    --Location
    PROCEDURE AddLocation(locationO locationObj);
    PROCEDURE DeleteLocation(AddressToRemove NUMBER);
    
    FUNCTION getAverageReview(productName VARCHAR2)
    RETURN NUMBER;
    
    --Function to audit log table changes
    --EXCEPTIONS
    --Missing data, duplicates
    DataNotFound EXCEPTION;
    existingRow EXCEPTION;
    invalidValue EXCEPTION;

    --TRIGGERS
    
END SuperStorePackage;
/

CREATE OR REPLACE PACKAGE BODY SuperStorePackage AS
    
    FUNCTION getAverageReview(productName VARCHAR2)
    RETURN NUMBER
    IS
        avg_score product_review.review%TYPE;
    BEGIN
        SELECT AVG(review) INTO avg_score 
        FROM Product_Review pr 
        INNER JOIN products_details pd
        ON pr.product_name = pd.product_name
        WHERE pr.product_name = pd.product_name 
        GROUP BY pr.product_name;
        RETURN avg_score;
    END;
    
    --Products table
    PROCEDURE AddProduct(product IN ProductObj)
    IS
        rowCount NUMBER;
    BEGIN
        
        SELECT COUNT(*)
        INTO rowCount
        FROM Products_details 
        WHERE product_name=product.product_name;
        
        IF( rowCount>0) THEN
            RAISE existingRow;
        END IF;
        
        IF (product.price <= 0) THEN
            RAISE invalidValue;
        END IF;
        
        
        INSERT INTO Products_Details(Product_name, price, store, product_category)
        VALUES(product.product_name, product.price, product.store, product.product_category);
        COMMIT;
        
        EXCEPTION
            WHEN existingRow THEN
                dbms_output.put_line('There already exists a row with that data, try changing the primary key related to that table');
            WHEN invalidValue THEN
                dbms_output.put_line('Price entered is not allowed');
    END AddProduct;
    
    PROCEDURE UpdateProduct(productToChange VARCHAR2, newPrice NUMBER, newStore VARCHAR2, newCategory VARCHAR2)
    AS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM products_details 
        WHERE product_name=productToChange;
        
        IF(rowCount=0)THEN
            RAISE DataNotFound;
        END IF;
        
        IF newPrice <= 0 THEN
            RAISE invalidValue;
        END IF;
        
        UPDATE Products_Details
        SET price = newPrice, store = newStore, product_category = newCategory
        WHERE product_name = productToChange;
        COMMIT;
        
        EXCEPTION
            WHEN invalidValue THEN
                dbms_output.put_line('Price entered is not allowed');
            WHEN DataNotFound THEN
                dbms_output.put_line('Row to change does not exist');
    END UpdateProduct;
    
    PROCEDURE DeleteProduct(productToRemove VARCHAR2)
    AS
        rowCount NUMBER;
    BEGIN
    
        SELECT COUNT(*)
        INTO rowCount
        FROM products_details 
        WHERE product_name=productToRemove;
        
        IF(rowCount=0)THEN
            RAISE DataNotFound;
        END IF;
        
        DELETE FROM Products_Details
        WHERE product_name = productToRemove;
        COMMIT;
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Row with product name does not exist');
    END DeleteProduct;
    
    
    -- Warehouse table
    PROCEDURE AddWarehouse(warehouse IN warehouseObj)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Warehouse_Details 
        WHERE warehouse_name = warehouse.warehouse_name;
    
        IF(rowCount > 0) THEN
            RAISE existingRow;
        END IF;
    
        INSERT INTO Warehouse_Details(warehouse_name, addressID)
        VALUES(warehouse.warehouse_name, warehouse.addressID);
        COMMIT;
    
        EXCEPTION
            WHEN existingRow THEN
                dbms_output.put_line('There already exists a warehouse with that name');
    END AddWarehouse;
        
    PROCEDURE UpdateWarehouse(warehouseToChange VARCHAR2, newWarehouseAddress NUMBER)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Warehouse_Details 
        WHERE warehouse_name = warehouseToChange;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        UPDATE Warehouse_Details
        SET addressID = newWarehouseAddress
        WHERE warehouse_name = warehouseToChange;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Warehouse to update does not exist');
    END UpdateWarehouse;    
    
    PROCEDURE DeleteWarehouse(warehouseToRemove VARCHAR2)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Warehouse_Details 
        WHERE warehouse_name = warehouseToRemove;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        DELETE FROM Warehouse_Details
        WHERE warehouse_name = warehouseToRemove;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Warehouse to delete does not exist');
    END DeleteWarehouse;
    
    
    -- Orders table
    PROCEDURE AddOrder(orderO IN orderObj)
    IS
        productRowCount NUMBER;
        customerRowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO productRowCount
        FROM Products_Details 
        WHERE product_name = orderO.product_name;
    
        IF(productRowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        SELECT COUNT(*)
        INTO customerRowCount
        FROM Customers_Details 
        WHERE customerID = orderO.customerID;
    
        IF(customerRowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        INSERT INTO Orders_Details(customerID, product_name,price, quantity, order_date)
        VALUES(orderO.customerID, orderO.product_name,orderO.price, orderO.quantity, orderO.order_date);
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Product or Customer in the order does not exist');
    END AddOrder;
    
    PROCEDURE UpdateOrder(orderToChange NUMBER, newCustomerID NUMBER, newProductName VARCHAR2,newPrice NUMBER, newQuantity NUMBER, newOrderDate DATE)
    IS
        orderRowCount NUMBER;
        productRowCount NUMBER;
        customerRowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO orderRowCount
        FROM Orders_Details 
        WHERE orderid = orderToChange;
    
        IF(orderRowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        SELECT COUNT(*)
        INTO productRowCount
        FROM Products_Details 
        WHERE product_name = newProductName;
    
        IF(productRowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        SELECT COUNT(*)
        INTO customerRowCount
        FROM Customers_Details 
        WHERE customerID = newCustomerID;
    
        IF(customerRowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        UPDATE Orders_Details
        SET customerID = newCustomerID, product_name = newProductName,price=newPrice, quantity = newQuantity, order_date = newOrderDate
        WHERE orderid = orderToChange;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Order, new Product, or new Customer in the order does not exist');
    END UpdateOrder;
    
    PROCEDURE DeleteOrder(orderToRemove NUMBER)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Orders_Details 
        WHERE orderid = orderToRemove;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        DELETE FROM Orders_Details
        WHERE orderid = orderToRemove;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Order to delete does not exist');
    END DeleteOrder;
    
    
    PROCEDURE AddProductReview(reviewO IN productReviewObj)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Products_Details 
        WHERE product_name = reviewO.product_name;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        INSERT INTO Product_Review(product_name,customerID, review, review_description, review_flag)
        VALUES(reviewO.product_name,reviewO.customerID, reviewO.review, reviewO.review_description, reviewO.review_flag);
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Product for the review does not exist');
    END AddProductReview;
    
    PROCEDURE UpdateProductReview(reviewToChange VARCHAR2,customerReviewerID NUMBER, newReview VARCHAR2, newReviewDescription VARCHAR2, newReviewFlag NUMBER)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Product_Review 
        WHERE product_name = reviewToChange;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        UPDATE Product_Review
        SET customerID = customerReviewerID,review = newReview, review_description = newReviewDescription, review_flag = newReviewFlag
        WHERE product_name = reviewToChange;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Product Review to update does not exist');
    END UpdateProductReview;
    
    PROCEDURE DeleteProductReview(reviewToRemove VARCHAR2)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Product_Review 
        WHERE product_name = reviewToRemove;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        DELETE FROM Product_Review
        WHERE product_name = reviewToRemove;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Product Review to delete does not exist');
    END DeleteProductReview;
    
    
    -- Customers table
    PROCEDURE AddCustomer(customer IN customerObj)
    AS
    BEGIN
        INSERT INTO Customers_Details(customer_email, first_name, last_name, addressID)
        VALUES(customer.customer_email, customer.first_name, customer.last_name, customer.addressID);
        COMMIT;
    END AddCustomer;
    
    PROCEDURE UpdateCustomer(customerToChange NUMBER, customerEmail VARCHAR2, firstName VARCHAR2, lastName VARCHAR2, customerAddress NUMBER)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Customers_Details 
        WHERE customerID = customerToChange;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        UPDATE Customers_Details
        SET customer_email = customerEmail, first_name = firstName, last_name = lastName, addressID = customerAddress
        WHERE customerID = customerToChange;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Customer to update does not exist');
    END UpdateCustomer;
    
    PROCEDURE DeleteCustomer(customerToRemove NUMBER)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Customers_Details 
        WHERE customerID = customerToRemove;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        DELETE FROM Customers_Details
        WHERE customerID = customerToRemove;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Customer to delete does not exist');
    END DeleteCustomer;
    
    
    -- Warehouse Inventory
    PROCEDURE AddWarehouseInventory(inventory IN warehouseInventoryObj)
    IS
        productRowCount NUMBER;
        warehouseRowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO productRowCount
        FROM Products_Details 
        WHERE product_name = inventory.product_name;
    
        IF(productRowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        SELECT COUNT(*)
        INTO warehouseRowCount
        FROM Warehouse_Details 
        WHERE warehouse_name = inventory.warehouse_name;
    
        IF(warehouseRowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        INSERT INTO Warehouse_Inventory(product_name, warehouse_name, quantity)
        VALUES(inventory.product_name, inventory.warehouse_name, inventory.quantity);
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Product or Warehouse in the inventory does not exist');
    END AddWarehouseInventory;
    
    PROCEDURE UpdateWarehouseInventory(productToChange VARCHAR2, warehouseToChange VARCHAR2, newQuantity NUMBER)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Warehouse_Inventory 
        WHERE product_name = productToChange AND warehouse_name = warehouseToChange;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        UPDATE Warehouse_Inventory
        SET quantity = newQuantity
        WHERE product_name = productToChange AND warehouse_name = warehouseToChange;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Warehouse Inventory to update does not exist');
    END UpdateWarehouseInventory;
    
    PROCEDURE DeleteWarehouseInventory(productNameToRemove VARCHAR2, warehouseNameToRemove VARCHAR2)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Warehouse_Inventory 
        WHERE product_name = productNameToRemove AND warehouse_name = warehouseNameToRemove;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        DELETE FROM Warehouse_Inventory
        WHERE product_name = productNameToRemove AND warehouse_name = warehouseNameToRemove;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Warehouse Inventory to delete does not exist');
    END DeleteWarehouseInventory;
    
    -- Location
    PROCEDURE AddLocation(locationO IN locationObj)
    AS
    BEGIN
        INSERT INTO Location_details(address,Country, City)
        VALUES(locationO.address, locationO.Country, locationO.City);
        COMMIT;
    END AddLocation;
    
    
    PROCEDURE DeleteLocation(addressToRemove NUMBER)
    IS
        rowCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rowCount
        FROM Location_details 
        WHERE AddressID = addressToRemove;
    
        IF(rowCount = 0) THEN
            RAISE DataNotFound;
        END IF;
    
        DELETE FROM Location_details
        WHERE AddressID = addressToRemove;
        COMMIT;
    
        EXCEPTION
            WHEN DataNotFound THEN
                dbms_output.put_line('Location to delete does not exist');
    END DeleteLocation;
    
END SuperStorePackage;
/
