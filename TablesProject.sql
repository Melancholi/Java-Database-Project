--Add link to location from warehouse details
--Add link to location from customer details

DROP TABLE Warehouse_Inventory;
DROP TABLE Product_Review;
DROP TABLE Warehouse_Details;
DROP TABLE Orders_Details;
DROP TABLE Customers_Details;
DROP TABLE Products_Details;


CREATE TABLE Warehouse_details(
    warehouse_name VARCHAR2(100) PRIMARY KEY,
    warehouse_address VARCHAR2(150)
    );
CREATE TABLE Customers_details(
    --So it updates id every time I make a new row
    customerID NUMBER(4) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_email VARCHAR2(200),
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    customer_address VARCHAR2(150)
    );
CREATE TABLE Products_Details(
    product_name VARCHAR2(75) PRIMARY KEY,
    price   NUMBER(5,2) CHECK (price>0),
    store   VARCHAR2(100),
    product_category    VARCHAR2(100)
    );
CREATE TABLE Orders_Details(
--So it updates id every time I make a new row  
    orderid NUMBER(4) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customerID NUMBER(4),
    product_name VARCHAR2(75),
    quantity    NUMBER(3) CHECK (quantity>0),
    order_date DATE,
    CONSTRAINT email_fk
    FOREIGN KEY (customerID)
    REFERENCES Customers_Details(customerID),
    CONSTRAINT product_fk
    FOREIGN KEY (product_name)
    REFERENCES Products_Details(product_name)
    );
CREATE TABLE Product_review(
    orderid    NUMBER(4),
    review      NUMBER(1) CHECK (review>1),
    review_description VARCHAR2(350),
    review_flag NUMBER(3) CHECK(review_flag>=0),
    CONSTRAINT review_order_fk
    FOREIGN KEY (orderid)
    REFERENCES Orders_details(orderid)
    );
CREATE TABLE Warehouse_Inventory(
    product_name    VARCHAR2(75),
    warehouse_name  VARCHAR2(100),
    quantity    NUMBER(6) CHECK (quantity>0),
    CONSTRAINT product_warehouse_fk
    FOREIGN KEY (product_name)
    REFERENCES Products_Details(product_name),
    CONSTRAINT warehouse_name_fk
    FOREIGN KEY (warehouse_name)
    REFERENCES Warehouse_details(warehouse_name)
    );
CREATE TABLE Location(
    Country VARCHAR2(125) PRIMARY KEY,
    City VARCHAR2(100)
    );
COMMIT;
/

CREATE OR REPLACE TYPE productObj IS OBJECT(
        product_name VARCHAR2(75),
        price NUMBER(5,2),
        store  VARCHAR2(100),
        product_category VARCHAR2(100)
        );
/
CREATE OR REPLACE TYPE warehouseObj IS OBJECT(
      warehouse_name VARCHAR2(100),
      warehouse_address VARCHAR2(150)
    );
/
CREATE OR REPLACE TYPE orderObj IS OBJECT(
      orderid NUMBER(4),
      customerID NUMBER(4),
      product_name VARCHAR2(75),
      quantity NUMBER(3),
      order_date DATE
    );

/
CREATE OR REPLACE TYPE productReviewObj IS OBJECT (
        orderid NUMBER(4),
        review VARCHAR2(30),
        review_description VARCHAR2(350),
        review_flag NUMBER(3)
    );
/
CREATE OR REPLACE TYPE customerObj IS OBJECT(
      customerID NUMBER(4),
      customer_email VARCHAR2(200),
      first_name VARCHAR2(100),
      last_name VARCHAR2(100),
      customer_address VARCHAR2(150)
    );  
/
CREATE OR REPLACE TYPE warehouseInventoryObj IS OBJECT (
        product_name VARCHAR2(75),
        warehouse_name VARCHAR2(100),
        quantity NUMBER(6)
    );
/