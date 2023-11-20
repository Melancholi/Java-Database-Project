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
    Country VARCHAR2(125),
    City VARCHAR2(100)
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
    price   NUMBER(8,2) CHECK (price>0),
    store   VARCHAR2(100),
    product_category    VARCHAR2(100)
    );
CREATE TABLE Orders_details(
--So it updates id every time I make a new row  
    orderid NUMBER(4) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customerID NUMBER(4),
    product_name VARCHAR2(75),
    price NUMBER(8,2),
    quantity    NUMBER(3) CONSTRAINT quantityCheck CHECK (quantity>0) CONSTRAINT orderQuantityNotNull NOT NULL,
    order_date DATE ,
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
    review      NUMBER(1) CHECK (review BETWEEN 1 AND 5) CONSTRAINT reviewNotNull NOT NULL,
    review_description VARCHAR2(350),
    review_flag NUMBER(3)  CONSTRAINT revFlagNotNull NOT NULL,
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
--Log tables
DROP TABLE location_log;
CREATE TABLE location_log(
    AddressID NUMBER(4),
    operation_type VARCHAR2(10),
    oldAddress VARCHAR2(200),
    newAddress VARCHAR2(200),
    oldCountry VARCHAR2(125),
    newCountry VARCHAR2(125),
    oldCity VARCHAR2(100),
    newCity VARCHAR2(100)
);
DROP TABLE products_details_log;
CREATE TABLE products_details_log (
    product_name VARCHAR2(75),
    operation_type VARCHAR2(10),
    old_price NUMBER(8,2),
    new_price NUMBER(8,2),
    old_store VARCHAR2(100),
    new_store VARCHAR2(100),
    old_product_category VARCHAR2(100),
    new_product_category VARCHAR2(100)
);
DROP TABLE customers_details_log;
CREATE TABLE customers_details_log (
    customerID NUMBER(4),
    operation_type VARCHAR2(10),
    old_customer_email VARCHAR2(200),
    new_customer_email VARCHAR2(200),
    old_first_name VARCHAR2(100),
    new_first_name VARCHAR2(100),
    old_last_name VARCHAR2(100),
    new_last_name VARCHAR2(100),
    old_AddressID NUMBER(4),
    new_AddressID NUMBER(4)
);
DROP TABLE orders_details_log;
CREATE TABLE orders_details_log (
    orderid NUMBER(4),
    operation_type VARCHAR2(10),
    old_customerID NUMBER(4),
    new_customerID NUMBER(4),
    old_product_name VARCHAR2(75),
    new_product_name VARCHAR2(75),
    old_price NUMBER(8,2),
    new_price NUMBER(8,2),
    old_quantity NUMBER(3),
    new_quantity NUMBER(3),
    old_order_date DATE,
    new_order_date DATE
);
DROP TABLE product_review_log;
CREATE TABLE product_review_log (
    product_name VARCHAR2(75),
    customerID NUMBER(4),
    operation_type VARCHAR2(10),
    old_review NUMBER(1),
    new_review NUMBER(1),
    old_review_description VARCHAR2(350),
    new_review_description VARCHAR2(350),
    old_review_flag NUMBER(3),
    new_review_flag NUMBER(3)
);
DROP TABLE warehouse_inventory_log;
CREATE TABLE warehouse_inventory_log (
    product_name VARCHAR2(75),
    warehouse_name VARCHAR2(100),
    operation_type VARCHAR2(10),
    old_quantity NUMBER(6),
    new_quantity NUMBER(6)
);
DROP TABLE warehouse_details_log;
CREATE TABLE warehouse_details_log(
    warehouseName VARCHAR2(100),
    operation_type VARCHAR(10),
    oldAddressID  NUMBER(4),
    newAddressID  NUMBER(4) 
);
COMMIT;
/
SELECT * FROM Customers_details;
-- add customer details
--Location for warehouse
INSERT INTO Location_details (Address, Country, City)
VALUES ('100 rue William, saint laurent, Quebec, Canada', 'Canada', 'Quebec');

INSERT INTO Location_details (Address, Country, City)
VALUES ('304 Rue Fran�ois-Perrault, Villera Saint-Michel, Montr�al, QC', 'Canada', 'Quebec');

INSERT INTO Location_details (Address, Country, City)
VALUES ('86700 Weston Rd, Toronto, Canada', 'Canada', 'Ontario');

INSERT INTO Location_details (Address, Country, City)
VALUES ('170 Sideroad, Quebec City, Canada', 'Canada', 'Quebec');

INSERT INTO Location_details (Address, Country, City)
VALUES ('1231 Trudea road, Ottawa, Canada', 'Canada', 'Ontario');

INSERT INTO Location_details (Address, Country, City)
VALUES ('16 Whitlock Rd, Alberta, Canada', 'Canada', 'Alberta');
--location for customers
INSERT INTO Location_Details(Address, Country, City)
VALUES ('dawson college, montreal, qeuebe, canada', 'Canada', 'Montreal');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('090 boul saint laurent, montreal, quebec, canada', 'Canada', 'Montreal');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('100 atwater street, toronto, canada', 'Canada', 'Toronto');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('boul saint laurent, montreal, quebec, canada', 'Canada', 'Montreal');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('100 Young street, toronto, canada', 'Canada', 'Toronto');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('100 boul saint laurent, montreal, quebec, canada', 'Canada', 'Montreal');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('Calgary, Alberta, Canada', 'Canada', 'Calgary');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('brossard, quebec, canada', 'Canada', 'Brossard');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('104 gill street, Toronto, Canada', 'Canada', 'Toronto');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('105 Young street, toronto, canada', 'Canada', 'Toronto');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('87 boul saint laurent, montreal, quebec, canada', 'Canada', 'Montreal');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('76 boul decalthon, laval, quebec, canada', 'Canada', 'Laval');
INSERT INTO Location_Details(Address, Country, City) 
VALUES ('22222 happy street, Laval, quebec, canada', 'Canada', 'Laval');

--Customers
INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('mahsa', 'sadeghi', 'msadeghi@dawsoncollege.qc.ca', (SELECT AddressID FROM Location_Details WHERE Address = 'dawson college, montreal, qeuebe, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('alex', 'brown', 'alex@gmail.com', (SELECT AddressID FROM Location_Details WHERE Address = '090 boul saint laurent, montreal, quebec, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('martin', 'alexandre', 'marting@yahoo.com', (SELECT AddressID FROM Location_Details WHERE Address = 'brossard, quebec, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('daneil', 'hanne', 'daneil@yahoo.com', (SELECT AddressID FROM Location_Details WHERE Address = '100 atwater street, toronto, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('alex', 'brown', 'alex@gmail.com', (SELECT AddressID FROM Location_Details WHERE Address = 'boul saint laurent, montreal, quebec, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('John', 'boura', 'bdoura@gmail.com', (SELECT AddressID FROM Location_Details WHERE Address = '100 Young street, toronto, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('Ari', 'brown', 'b.a@gmail.com', NULL);

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('Amanda', 'Harry', 'am.harry@yahioo.com', (SELECT AddressID FROM Location_Details WHERE Address = '100 boul saint laurent, montreal, quebec, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('Jack', 'Jonhson', 'johnson.a@gmail.com', (SELECT AddressID FROM Location_Details WHERE Address = 'Calgary, Alberta, Canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('mahsa', 'sadeghi', 'ms@gmail.com', (SELECT AddressID FROM Location_Details WHERE Address = '104 gill street, Toronto, Canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('John', 'belle', 'abcd@yahoo.com', (SELECT AddressID FROM Location_Details WHERE Address = '105 Young street, toronto, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('martin', 'Li', 'm.li@gmail.com', (SELECT AddressID FROM Location_Details WHERE Address = '87 boul saint laurent, montreal, quebec, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('olivia', 'smith', 'smith@hotmail.com', (SELECT AddressID FROM Location_Details WHERE Address = '76 boul decalthon, laval, quebec, canada'));

INSERT INTO Customers_Details(First_Name, Last_Name, customer_Email, AddressID)
VALUES ('Noah', 'Garcia', 'g.noah@yahoo.com', (SELECT AddressID FROM Location_Details WHERE Address = '22222 happy street, Laval, quebec, canada'));

--Products THINK ABOUT WHEN Price changes between stores
INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('laptop ASUS 104S', 970, 'marche adonis', 'electronics');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('apple', 10, 'marche atwater', 'Grocery');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('SIMS CD', 50, 'dawson store', 'Video Games');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('orange', 2, 'store magic', 'grocery');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('Barbie Movie', 30, 'movie store', 'DVD');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('LOreal Normal Hair', 10, 'super rue champlain', 'Health');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('BMW iX Lego', 40, 'toy r us', 'Toys');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('BMW i6', 50000, 'Dealer one', 'Cars');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('Truck 500c', 856600, 'dealer montreal', 'Vehicle');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('paper towel', 50, 'movie start', 'Beauty');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('plum', 10, 'marche atwater', 'grocery');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('Lamborghini Lego', 40, 'toy r us', 'Toys');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('chicken', 9.5, 'marche adonis', 'grocery');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('pasta', 13.5, 'marche atwater', 'Grocery');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('PS5', 200, 'star store', 'electronics');

INSERT INTO Products_Details (product_name, price, store, product_category)
VALUES ('Train X745', NULL, 'store magic', 'Toys');

INSERT INTO Products_details (product_name, price, store, product_category)
VALUES('tomato',NULL,'marche adonis','Grocery');
--Warehouse_details
INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse A', (SELECT AddressID FROM Location_details WHERE Address = '100 rue William, saint laurent, Quebec, Canada'));

INSERT INTO Warehouse_details (warehouse_name, addressID)
VALUES ('Warehouse B', (SELECT AddressID FROM Location_details WHERE Address = '304 Rue Fran�ois-Perrault, Villera Saint-Michel, Montr�al, QC'));

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
VALUES ('LOreal Normal Hair', 'Warehouse F', 450);

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

--Orders details
INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 'laptop ASUS 104S', 970, 1, TO_DATE('21/04/2023', 'DD/MM/YYYY'));
INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 'apple', 10, 2, TO_DATE('23/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'marting@yahoo.com'), 'SIMS CD', 50, 3, TO_DATE('01/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'daneil@yahoo.com'), 'orange', 2, 1, TO_DATE('23/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 'Barbie Movie', 30, 1, TO_DATE('23/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'marting@yahoo.com'), 'LOreal Normal Hair', 10, 1, TO_DATE('10/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 'BMW iX Lego', 40, 1, TO_DATE('11/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'bdoura@gmail.com'), 'BMW i6', 50000, 1, TO_DATE('10/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email IS NULL), 'Truck 500c', NULL, 1, NULL);
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'am.harry@yahioo.com'), 'paper towel', 3.5, 3, NULL);
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'johnson.a@gmail.com'), 'plum', 10, 6, TO_DATE('06/05/2020', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'marting@yahoo.com'), 'LOreal Normal Hair', 30, 3, TO_DATE('12/09/2019', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 'Lamborghini Lego', 40, 1, TO_DATE('11/10/2010', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 'plum', 10, 7, TO_DATE('06/05/2022', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'ms@gmail.com'), 'Lamborghini Lego', 80, 2, TO_DATE('07/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'bdoura@gmail.com'), 'BMW i6', 50000, 1, TO_DATE('10/08/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 'SIMS CD', 16, 1, TO_DATE('23/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 'Barbie Movie', 45, 1, TO_DATE('02/10/2023', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'm.li@gmail.com'), 'chicken', 9.5, 1, TO_DATE('03/04/2019', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'smith@hotmail.com'), 'pasta', 13.5, 3, TO_DATE('29/12/2021', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'g.noah@yahoo.com'), 'PS5', 200, 1, TO_DATE('20/01/2020', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 'BMW iX Lego', 38, 2, TO_DATE('11/10/2022', 'DD/MM/YYYY'));
  INSERT INTO Orders_details (customerID, product_name, price, quantity, order_date)
VALUES
  ((SELECT customerID FROM Customers_details WHERE customer_email = 'smith@hotmail.com'), 'pasta', 15, 3, TO_DATE('29/12/2021', 'DD/MM/YYYY'));


--Products review
INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('laptop ASUS 104S', (SELECT customerID FROM Customers_Details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 4, 'it was affordable.', 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('apple', (SELECT customerID FROM Customers_Details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 3, 'quality was not good', 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('SIMS CD', (SELECT customerID FROM customers_details where customer_email LIKE 'marting@%'), 2, NULL, 1);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('orange', (SELECT customerID FROM Customers_Details WHERE customer_email = 'daneil@yahoo.com'), 5, 'highly recommend', 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('Barbie Movie', (SELECT customerID FROM Customers_Details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 1, NULL, 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('LOreal Normal Hair', (SELECT customerID FROM customers_details where customer_email LIKE 'marting@%'), 1, 'did not worth the price', 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('BMW iX Lego', (SELECT customerID FROM Customers_Details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 1, 'missing some parts', 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('BMW i6', (SELECT customerID FROM Customers_Details WHERE customer_email = 'bdoura@gmail.com'), 5, 'trash', 1);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('Truck 500c', (SELECT customerID FROM Customers_Details WHERE customer_email = 'b.a@gmail.com'), 2, NULL, 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('paper towel', (SELECT customerID FROM Customers_Details WHERE customer_email = 'am.harry@yahioo.com'), 5, NULL, 3);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('plum', (SELECT customerID FROM Customers_Details WHERE customer_email = 'johnson.a@gmail.com'), 4, NULL, 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('LOreal Normal Hair', (SELECT customerID FROM customers_details where customer_email LIKE 'marting@%'), 3, NULL, 30);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('Lamborghini Lego', (SELECT customerID FROM Customers_Details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 1, 'missing some parts', 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('plum', (SELECT customerID FROM Customers_Details WHERE customer_email = 'msadeghi@dawsoncollege.qc.ca'), 4, NULL, 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('Lamborghini Lego', (SELECT customerID FROM Customers_Details WHERE customer_email = 'ms@gmail.com'), 1, 'great product', 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('BMW i6', (SELECT customerID FROM Customers_Details WHERE customer_email = 'abcd@yahoo.com'), 5, 'bad quality', 1);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('SIMS CD', (SELECT customerID FROM Customers_Details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 1, NULL, 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('Barbie Movie', (SELECT customerID FROM Customers_Details WHERE customer_email = 'alex@gmail.com' FETCH FIRST 1 ROW ONLY), 4, NULL, 0);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('chicken', (SELECT customerID FROM Customers_Details WHERE customer_email = 'm.li@gmail.com'), 4, NULL, 9.5);


INSERT INTO Product_review (product_name, customerID, review, review_description, review_flag)
VALUES ('pasta', (SELECT customerID FROM Customers_Details WHERE customer_email = 'smith@hotmail.com'), 5, NULL, 13.5);

