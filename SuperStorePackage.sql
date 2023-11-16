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
    PROCEDURE UpdateOrder(orderToChange NUMBER, newCustomerID NUMBER, newProductName VARCHAR2, newQuantity NUMBER, newOrderDate DATE);
    PROCEDURE DeleteOrder(orderToRemove NUMBER);

    
    -- Product Review Table
    PROCEDURE AddProductReview(reviewO productReviewObj);
    PROCEDURE UpdateProductReview(reviewToChange VARCHAR2, newReview VARCHAR2, newReviewDescription VARCHAR2, newReviewFlag NUMBER);
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
    PROCEDURE UpdateLocation(addressToChange NUMBER, countryToChange VARCHAR2, cityToChange VARCHAR2);
    PROCEDURE DeleteLocation(AddressToRemove NUMBER);
    
    --EXCEPTIONS
    --Missing data, duplicates
    EXCEPTION missingRow;
    EXCEPTION IDNotFound;
    EXCEPTION existingRow;
    
    
    --TRIGGERS
    
END SuperStorePackage;
/
--Change headers and values to new 
CREATE OR REPLACE PACKAGE BODY SuperStorePackage AS

    --Products table
    PROCEDURE AddProduct(product IN ProductObj)
    IS
    BEGIN
        INSERT INTO Products_Details(Product_name, price, store, product_category)
        VALUES(product.product_name, product.price, product.store, product.product_category);
        COMMIT;
    END AddProduct;
    
    PROCEDURE UpdateProduct(productToChange VARCHAR2, newPrice NUMBER, newStore VARCHAR2, newCategory VARCHAR2)
    AS
    BEGIN
        UPDATE Products_Details
        SET price = newPrice, store = newStore, product_category = newCategory
        WHERE product_name = productToChange;
        COMMIT;
    END UpdateProduct;
    
    PROCEDURE DeleteProduct(productToRemove VARCHAR2)
    AS
    BEGIN
        DELETE FROM Products_Details
        WHERE product_name = productToRemove;
        COMMIT;
    END DeleteProduct;
    
    
    -- Warehouse table
    PROCEDURE AddWarehouse(warehouse IN warehouseObj)
    AS
    BEGIN
        INSERT INTO Warehouse_Details(warehouse_name, addressID)
        VALUES(warehouse.warehouse_name, warehouse.addressID);
        COMMIT;
    END AddWarehouse;
    
    PROCEDURE UpdateWarehouse(warehouseToChange VARCHAR2, newWarehouseAddress NUMBER)
    AS
    BEGIN
        UPDATE Warehouse_Details
        SET addressID = newWarehouseAddress
        WHERE warehouse_name = warehouseToChange;
        COMMIT;
    END UpdateWarehouse;
    
    PROCEDURE DeleteWarehouse(warehouseToRemove VARCHAR2)
    AS
    BEGIN
        DELETE FROM Warehouse_Details
        WHERE warehouse_name = warehouseToRemove;
        COMMIT;
    END DeleteWarehouse;
    
    
    -- Orders table
    PROCEDURE AddOrder(orderO IN orderObj)
    AS
    BEGIN
        INSERT INTO Orders_Details(customerID, product_name, quantity, order_date)
        VALUES(orderO.customerID, orderO.product_name, orderO.quantity, orderO.order_date);
        COMMIT;
    END AddOrder;
    
    PROCEDURE UpdateOrder(orderToChange NUMBER, newCustomerID NUMBER, newProductName VARCHAR2, newQuantity NUMBER, newOrderDate DATE)
    AS
    BEGIN
        UPDATE Orders_Details
        SET customerID = newCustomerID, product_name = newProductName, quantity = newQuantity, order_date = newOrderDate
        WHERE orderid = orderToChange;
        COMMIT;
    END UpdateOrder;
    
    PROCEDURE DeleteOrder(orderToRemove NUMBER)
    AS
    BEGIN
        DELETE FROM Orders_Details
        WHERE orderid = orderToRemove;
        COMMIT;
    END DeleteOrder;
    
    
    -- Product Review Table
    PROCEDURE AddProductReview(reviewO IN productReviewObj)
    AS
    BEGIN
        INSERT INTO Product_Review(product_name, review, review_description, review_flag)
        VALUES(reviewO.product_name, reviewO.review, reviewO.review_description, reviewO.review_flag);
        COMMIT;
    END AddProductReview;
    
    PROCEDURE UpdateProductReview(reviewToChange VARCHAR2, newReview VARCHAR2, newReviewDescription VARCHAR2, newReviewFlag NUMBER)
    AS
    BEGIN
        UPDATE Product_Review
        SET review = newReview, review_description = newReviewDescription, review_flag = newReviewFlag
        WHERE product_name = product_name;
        COMMIT;
    END UpdateProductReview;
    
    PROCEDURE DeleteProductReview(reviewToRemove VARCHAR2)
    AS
    BEGIN
        DELETE FROM Product_Review
        WHERE product_name = reviewToRemove;
        COMMIT;
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
    AS
    BEGIN
        UPDATE Customers_Details
        SET customer_email = customerEmail, first_name = firstName, last_name = lastName, addressID = customerAddress
        WHERE customerID = customerToChange;
        COMMIT;
    END UpdateCustomer;
    
    PROCEDURE DeleteCustomer(customerToRemove NUMBER)
    AS
    BEGIN
        DELETE FROM Customers_Details
        WHERE customerID = customerToRemove;
        COMMIT;
    END DeleteCustomer;
    
    
    -- Warehouse Inventory
    PROCEDURE AddWarehouseInventory(inventory IN warehouseInventoryObj)
    AS
    BEGIN
        INSERT INTO Warehouse_Inventory(product_name, warehouse_name, quantity)
        VALUES(inventory.product_name, inventory.warehouse_name, inventory.quantity);
        COMMIT;
    END AddWarehouseInventory;
    
    PROCEDURE UpdateWarehouseInventory(productToChange VARCHAR2, warehouseToChange VARCHAR2, newQuantity NUMBER)
    AS
    BEGIN
        UPDATE Warehouse_Inventory
        SET quantity = newQuantity
        WHERE product_name = productToChange AND warehouse_name = warehouseToChange;
        COMMIT;
    END UpdateWarehouseInventory;
    
    PROCEDURE DeleteWarehouseInventory(productNameToRemove VARCHAR2, warehouseNameToRemove VARCHAR2)
    AS
    BEGIN
        DELETE FROM Warehouse_Inventory
        WHERE product_name = productNameToRemove AND warehouse_name = warehouseNameToRemove;
        COMMIT;
    END DeleteWarehouseInventory;
    
    -- Location
    PROCEDURE AddLocation(locationO IN locationObj)
    AS
    BEGIN
        INSERT INTO Location_details(Country, City)
        VALUES(locationO.Country, locationO.City);
        COMMIT;
    END AddLocation;
    
    PROCEDURE UpdateLocation(addressToChange NUMBER, countryToChange VARCHAR2, cityToChange VARCHAR2)
    AS
    BEGIN
        UPDATE Location_details
        SET Country = countryToChange, City = cityToChange
        WHERE AddressID = addressToChange;
        COMMIT;
    END UpdateLocation;
    
    PROCEDURE DeleteLocation(addressToRemove NUMBER)
    AS
    BEGIN
        DELETE FROM Location_details
        WHERE AddressID = addressToRemove;
        COMMIT;
    END DeleteLocation;
    
    
    --Triggers
    
END SuperStorePackage;
/

