DROP PACKAGE SuperStorePackage;
CREATE OR REPLACE PACKAGE ProductsPackage AS
    
    --Products table
    PROCEDURE AddProduct(productName VARCHAR2,price NUMBER,store VARCHAR2,productCategory VARCHAR2);
    FUNCTION getProduct(productName VARCHAR2)
    RETURN productObj;
    PROCEDURE updateProduct(productName VARCHAR2,price NUMBER,store VARCHAR2,category VARCHAR2);
    PROCEDURE deleteProduct(productName VARCHAR2);
    TYPE productObj IS OBJECT(
        productName VARCHAR2(75),
        price NUMBER(5,2),
        store  VARCHAR2(100),
        category VARCHAR2(100)
        );
    
    -- Warehouse table
    PROCEDURE AddWarehouse(warehouseName VARCHAR2, warehouseAddress VARCHAR2);
    FUNCTION getWarehouse(warehouseName VARCHAR2)
    RETURN warehouseObj;
    PROCEDURE updateWarehouse(warehouseName VARCHAR2, warehouseAddress VARCHAR2);
    PROCEDURE deleteWarehouse(warehouseName VARCHAR2);
    TYPE warehouseObj IS OBJECT(
      warehouseName VARCHAR2(100),
      warehouseAddress VARCHAR2(150)
    );

    -- Orders table
    PROCEDURE AddOrder(customerID NUMBER, productName VARCHAR2, quantity NUMBER, orderDate DATE);
    FUNCTION getOrder(orderID NUMBER)
    RETURN orderObj;
    PROCEDURE updateOrder(orderID NUMBER, customerID NUMBER, productName VARCHAR2, quantity NUMBER, orderDate DATE);
    PROCEDURE deleteOrder(orderID NUMBER);
    TYPE orderObj IS OBJECT(
      orderID NUMBER(4),
      customerID NUMBER(4),
      productName VARCHAR2(75),
      quantity NUMBER(3),
      orderDate DATE
    );
    
    -- Product Review Table
    PROCEDURE AddOrderReview(orderID NUMBER, review VARCHAR2, reviewDescription VARCHAR2, reviewFlag VARCHAR2);
    FUNCTION GetOrderReview(orderID NUMBER)
    RETURN orderReviewObj;
    PROCEDURE UpdateOrderReview(orderID NUMBER, review VARCHAR2, reviewDescription VARCHAR2, reviewFlag VARCHAR2);
    PROCEDURE DeleteOrderReview(orderID NUMBER);
    TYPE orderReviewObj IS OBJECT (
        orderID NUMBER(4),
        review VARCHAR2(30),
        reviewDescription VARCHAR2(350),
        reviewFlag VARCHAR2(100)
    );
    
    -- Customers table
    PROCEDURE AddCustomer(customerEmail VARCHAR2, firstName VARCHAR2, lastName VARCHAR2, customerAddress VARCHAR2);
    FUNCTION getCustomer(customerID NUMBER)
    RETURN customerObj;
    PROCEDURE updateCustomer(customerID NUMBER, customerEmail VARCHAR2, firstName VARCHAR2, lastName VARCHAR2, customerAddress VARCHAR2);
    PROCEDURE deleteCustomer(customerID NUMBER);
    TYPE customerObj IS OBJECT(
      customerID NUMBER(4),
      customerEmail VARCHAR2(200),
      firstName VARCHAR2(100),
      lastName VARCHAR2(100),
      customerAddress VARCHAR2(150)
    );    
        
END ProductsPackage;

