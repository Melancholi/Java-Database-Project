package s2_g8;

import java.sql.*;
import java.util.Map;

public class WarehouseInventory {
    private String typeName;
    private String productName;
    private String warehouseName;
    private int quantity;


    //Constructor
    public WarehouseInventory(String productName, String warehouseName, int quantity) {
        this.productName = productName;
        this.warehouseName = warehouseName;
        this.quantity = quantity;
    }

    //setter methods
    public void setProductName(String productName) {
        this.productName = productName;
    }
    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    //getter methods
    public String getProductName() {
        return this.productName;
    }
    public String getWarehouseName() {
        return this.warehouseName;
    }
    public int getQuantity() {
        return this.quantity;
    }

    //jdbc methods
    //The compiler threw an exception when I put @Override on this for some reason. Programmer threads online said it's because the compiler might be too old. I was forced to remove it entirely
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeString(getProductName());
        stream.writeString(getWarehouseName());
        stream.writeInt(getQuantity());
    }

    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.typeName = typeName;
        setProductName(stream.readString());
        setWarehouseName(stream.readString());
        setQuantity(stream.readInt());
    }

    public String getSQLTypeName() {
        return typeName;
    }

    public void addToDatabase(Connection conn) throws SQLException {
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put("WAREHOUSEINVENTORYOBJ",
                    Class.forName("s2_g8.LocationDetails"));
            WarehouseInventory inv = new WarehouseInventory(this.productName, this.warehouseName, this.quantity);
            String sql = "{call SuperStorePackage.addWarehouse(?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {
                conn.setAutoCommit(false);
                stmt.setObject(1, inv);
                stmt.execute();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
        } catch (ClassNotFoundException c) {
            c.printStackTrace();
            conn.rollback();
        }
    }
}