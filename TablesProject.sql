DROP TABLE Warehouse_Products;
DROP TABLE Order_Review;
DROP TABLE Warehouse_Details;
DROP TABLE Orders_Details;
DROP TABLE Customers_Details;
DROP TABLE Products_Details;


CREATE TABLE Warehouse_details(
    warehouse_name VARCHAR2(100) PRIMARY KEY,
    warehouse_address VARCHAR2(150)
    );
CREATE TABLE Customers_details(
    customer_emails VARCHAR2(200) PRIMARY KEY,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    customer_address VARCHAR2(150)
    );
CREATE TABLE Products_Details(
    product_name VARCHAR2(75) PRIMARY KEY,
    price   NUMBER(5,2),
    store   VARCHAR2(100),
    product_category    VARCHAR2(100)
    );
CREATE TABLE Orders_Details(
    orderid NUMBER(4) PRIMARY KEY,
    customers_email  VARCHAR2(200),
    product_name VARCHAR2(75),
    quantity    NUMBER(3),
    order_date DATE,
    CONSTRAINT email_fk
    FOREIGN KEY (customers_email)
    REFERENCES Customers_Details(customers_email),
    CONSTRAINT product_fk
    FOREIGN KEY (product_name)
    REFERENCES Products_Details(product_name)
    );
CREATE TABLE Order_review(
    orderid    NUMBER(4),
    review      VARCHAR2(30),
    review_description VARCHAR2(350),
    review_flag VARCHAR2(100),
    CONSTRAINT review_order_fk
    FOREIGN KEY (orderid)
    REFERENCES Orders_details(orderid)
    );

CREATE TABLE Warehouse_Product (
    product_name    VARCHAR2(75),
    warehouse_name  VARCHAR2(100),
    quantity    NUMBER(4),
    CONSTRAINT product_warehouse_fk
    FOREIGN KEY (product_name)
    REFERENCES Products_Details(product_name),
    CONSTRAINT warehouse_name_fk
    FOREIGN KEY (warehouse_name)
    REFERENCES Warehouse_details(warehouse_name)
    );