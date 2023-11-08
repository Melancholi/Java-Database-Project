DROP PACKAGE ProductsPackage;
CREATE OR REPLACE PACKAGE ProductsPackage AS
    PROCEDURE AddProduct(productName VARCHAR2,price NUMBER,store VARCHAR2,productCategory VARCHAR2);
--    PROCEDURE addWareHouseProduct(productName VARCHAR2, warehouseName VARCHAR2,quantity NUMBER);
--AS
--BEGIN
--    INSERT INTO Warehouse_Product
--    VALUES(productName,warehouseName,quantity);
--END;
    FUNCTION getProduct(productName)
    --RETURN PRODUCT OBJECT;
    PROCEDURE updateProcuct(productName VARCHAR2,price NUMBER,store VARCHAR2,category VARCHAR2);
    
    
END ProductsPackage;

