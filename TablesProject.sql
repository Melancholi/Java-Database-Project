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
    Address VARCHAR2(200),
    Country VARCHAR2(125) CONSTRAINT countryNotNull NOT NULL,
    City VARCHAR2(100)CONSTRAINT cityNotNull NOT NULL
    );
CREATE TABLE Warehouse_details(
    warehouse_name VARCHAR2(100) PRIMARY KEY,
    AddressID NUMBER(4),
    CONSTRAINT address_warehouse
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
    price   NUMBER(8,2) CHECK (price>0) CONSTRAINT priceNull NOT NULL,
    store   VARCHAR2(100),
    product_category    VARCHAR2(100),
    average_review NUMBER(1) CHECK(average_review IN(5,1))
    );
CREATE TABLE Orders_details(
--So it updates id every time I make a new row  
    orderid NUMBER(4) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customerID NUMBER(4),
    product_name VARCHAR2(75),
    price NUMBER(8,2),
    quantity    NUMBER(3) CHECK (quantity>0) CONSTRAINT orderQuantityNotNull NOT NULL,
    order_date DATE CONSTRAINT orderDateNotNull NOT NULL,
    CONSTRAINT custOrder_fk
    FOREIGN KEY (customerID)
    REFERENCES Customers_Details(customerID),
    CONSTRAINT product_fk
    FOREIGN KEY (product_name)
    REFERENCES Products_Details(product_name)
    );
CREATE TABLE Product_review(
    product_name VARCHAR2(75),
    customerID NUMBER(4),
    review      NUMBER(1) CHECK (review>1) CONSTRAINT reviewNotNull NOT NULL,
    review_description VARCHAR2(350),
    review_flag NUMBER(3) CHECK(review_flag>=0) CONSTRAINT revFlagNotNull NOT NULL,
    CONSTRAINT review_product_fk
    FOREIGN KEY (product_name)
    REFERENCES products_details(product_name),
    CONSTRAINT custReview_fk
    FOREIGN KEY (customerID)
    REFERENCES Customers_Details(customerID)
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
--Location
INSERT INTO Location_details (Address, Country, City)
VALUES ('100 rue William, saint laurent, Quebec, Canada', 'Canada', 'Quebec');

INSERT INTO Location_details (Address, Country, City)
VALUES ('304 Rue François-Perrault, Villera Saint-Michel, Montréal, QC', 'Canada', 'Quebec');

INSERT INTO Location_details (Address, Country, City)
VALUES ('86700 Weston Rd, Toronto, Canada', 'Canada', 'Ontario');

INSERT INTO Location_details (Address, Country, City)
VALUES ('170 Sideroad, Quebec City, Canada', 'Canada', 'Quebec');

INSERT INTO Location_details (Address, Country, City)
VALUES ('1231 Trudea road, Ottawa, Canada', 'Canada', 'Ontario');

INSERT INTO Location_details (Address, Country, City)
VALUES ('16 Whitlock Rd, Alberta, Canada', 'Canada', 'Alberta');

--Products THINK ABOUT WHEN Price changes between stores
INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('laptop ASUS 104S', 970, 'marche adonis', 'electronics', 4);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('apple', 10, 'marche atwater', 'Grocery', 3);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('SIMS CD', 50, 'dawson store', 'Video Games', 2);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('orange', 2, 'store magic', 'grocery', 5);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('Barbie Movie', 30, 'movie store', 'DVD', 1);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('L''Oreal Normal Hair', 10, 'super rue champlain', 'Health', 1);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('BMW iX Lego', 40, 'toy r us', 'Toys', 1);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('BMW i6', 50000, 'Dealer one', 'Cars', 5);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('Truck 500c', 856600, 'dealer montreal', 'Vehicle', 2);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('paper towel', 50, 'movie start', 'Beauty', 5);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('plum', 10, 'marche atwater', 'grocery', 4);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('Lamborghini Lego', 40, 'toy r us', 'Toys', 1);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('chicken', 9.5, 'marche adonis', 'grocery', 4);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('pasta', 13.5, 'marche atwater', 'Grocery', 5);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('PS5', 200, 'star store', 'electronics', NULL);

INSERT INTO Products_Details (product_name, price, store, product_category, average_review)
VALUES ('Train X745', NULL, 'store magic', 'Toys', NULL);

--Warehouse_details
INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse A', (SELECT AddressID FROM Location_details WHERE Address = '100 rue William, saint laurent, Quebec, Canada'));

INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse B', (SELECT AddressID FROM Location_details WHERE Address = '304 Rue François-Perrault, Villera Saint-Michel, Montréal, QC'));

INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse C', (SELECT AddressID FROM Location_details WHERE Address = '86700 Weston Rd, Toronto, Canada'));

INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse D', (SELECT AddressID FROM Location_details WHERE Address = '170  Sideroad, Quebec City, Canada'));

INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse E', (SELECT AddressID FROM Location_details WHERE Address = '1231 Trudea road, Ottawa, Canada'));

INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse F', (SELECT AddressID FROM Location_details WHERE Address = '16  Whitlock Rd, Alberta, Canada'));

--Warehouse inventor
INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('laptop ASUS 104S', 'Warehouse A', 1000);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('apple', 'Warehouse B', 24980);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('SIMS CD', 'Warehouse C', 103);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('orange', 'Warehouse D', 35405);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('Barbie Movie', 'Warehouse E', 40);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('L''Oreal Normal Hair', 'Warehouse F', 450);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('BMW iX Lego', 'Warehouse A', 10);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('BMW i6', 'Warehouse A', 6);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('Truck 500c', 'Warehouse E', 1000);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('paper towel', 'Warehouse F', 3532);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('plum', 'Warehouse C', 43242);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('paper towel', 'Warehouse B', 39484);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('plum', 'Warehouse D', 6579);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('Lamborghini Lego', 'Warehouse E', 98765);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('chicken', 'Warehouse F', 43523);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('pasta', 'Warehouse A', 2132);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('PS5', 'Warehouse D', 123);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('tomato', 'Warehouse A', 352222);

INSERT INTO Warehouse_inventory (product_name, warehouse_name, quantity)
VALUES ('Train X745', 'Warehouse E', 4543);