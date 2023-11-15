--Add link to location from warehouse details
--Add link to location from customer details
-- Make address id

DROP TABLE Warehouse_Inventory;
DROP TABLE Product_Review;
DROP TABLE Warehouse_Details;
DROP TABLE Orders_Details;
DROP TABLE Customers_Details;
DROP TABLE Location_Details;
DROP TABLE Products_Details;

CREATE TABLE Location_details(
    AddressID NUMBER(4) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Country VARCHAR2(125) CONSTRAINT countryNotNull NOT NULL,
    City VARCHAR2(100)
    );
CREATE TABLE Warehouse_details(
    warehouse_name VARCHAR2(100) PRIMARY KEY,
    AddressID NUMBER(4),
    CONSTRAINT adress_warehouse
    FOREIGN KEY (AddressID)
    REFERENCES Location_details(AddressID)
    );
CREATE TABLE Customers_details(
    --So it updates id every time I make a new row
    customerID NUMBER(4) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_email VARCHAR2(200) CONSTRAINT emailNotNull NOT NULL,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    AddressID NUMBER(4),
    CONSTRAINT address_customers
    FOREIGN KEY (AddressID)
    REFERENCES Location_details(AddressID)
    );
CREATE TABLE Products_Details(
    product_name VARCHAR2(75) PRIMARY KEY,
    price   NUMBER(5,2) CHECK (price>0) CONSTRAINT priceNull NOT NULL,
    store   VARCHAR2(100),
    product_category    VARCHAR2(100),
    average_review NUMBER(1) CHECK(average_review IN(5,1))
    );
CREATE TABLE Orders_details(
--So it updates id every time I make a new row  
    orderid NUMBER(4) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customerID NUMBER(4),
    product_name VARCHAR2(75),
    quantity    NUMBER(3) CHECK (quantity>0) CONSTRAINT orderQuantityNotNull NOT NULL,
    order_date DATE CONSTRAINT orderDateNotNull NOT NULL,
    CONSTRAINT custID_fk
    FOREIGN KEY (customerID)
    REFERENCES Customers_Details(customerID),
    CONSTRAINT product_fk
    FOREIGN KEY (product_name)
    REFERENCES Products_Details(product_name)
    );
CREATE TABLE Product_review(
    product_name VARCHAR2(75),
    review      NUMBER(1) CHECK (review>1) CONSTRAINT reviewNotNull NOT NULL,
    review_description VARCHAR2(350),
    review_flag NUMBER(3) CHECK(review_flag>=0) CONSTRAINT revFlagNotNull NOT NULL,
    CONSTRAINT review_product_fk
    FOREIGN KEY (product_name)
    REFERENCES products_details(product_name)
    );
CREATE TABLE Warehouse_inventory(
    product_name    VARCHAR2(75),
    warehouse_name  VARCHAR2(100),
    quantity    NUMBER(6) CHECK (quantity>0) CONSTRAINT inventoryQuantityNotNull NOT NULL,
    CONSTRAINT product_warehouse_fk
    FOREIGN KEY (product_name)
    REFERENCES Products_Details(product_name),
    CONSTRAINT warehouse_name_fk
    FOREIGN KEY (warehouse_name)
    REFERENCES Warehouse_details(warehouse_name)
    );
COMMIT;
/
