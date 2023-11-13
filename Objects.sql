CREATE OR REPLACE TYPE locationObj IS OBJECT(
    AddressID NUMBER(4),
    Country VARCHAR2(125),
    City VARCHAR2(100)
    );
/
CREATE OR REPLACE TYPE productObj IS OBJECT(
        product_name VARCHAR2(75),
        price NUMBER(5,2),
        store  VARCHAR2(100),
        product_category VARCHAR2(100),
        average_review NUMBER(1)
        );
/
CREATE OR REPLACE TYPE warehouseObj IS OBJECT(
      warehouse_name VARCHAR2(100),
      addressID NUMBER(4)
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
        product_name VARCHAR2(75),
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
      AddressID NUMBER(4)
    );  
/
CREATE OR REPLACE TYPE warehouseInventoryObj IS OBJECT (
        product_name VARCHAR2(75),
        warehouse_name VARCHAR2(100),
        quantity NUMBER(6)
    );
/