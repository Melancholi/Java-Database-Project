package s2_g8;
import java.sql.*;
import java.util.Map;

public class OrderDetails implements SQLData {
    private String typeName;
    private int orderID;
    private int customerID;
    private String productName;
    private double price;
    private int quantity;
    private Date orderDate;

    public OrderDetails(int customerID, String productName, double price, int quantity, Date orderDate) {
        this.customerID = customerID;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.orderDate = orderDate;
    }

    // Getters
    public int getOrderID() {
        return this.orderID;
    }

    public int getCustomerID() {
        return this.customerID;
    }

    public String getProductName() {
        return this.productName;
    }

    public double getPrice() {
        return this.price;
    }

    public int getQuantity() {
        return this.quantity;
    }

    public Date getOrderDate() {
        return this.orderDate;
    }

    // Setters
    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(getOrderID());
        stream.writeInt(getCustomerID());
        stream.writeString(getProductName());
        stream.writeDouble(getPrice());
        stream.writeInt(getQuantity());
        stream.writeDate(getOrderDate());
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.typeName = typeName;
        setOrderID(stream.readInt());
        setCustomerID(stream.readInt());
        setProductName(stream.readString());
        setPrice(stream.readDouble());
        setQuantity(stream.readInt());
        setOrderDate(stream.readDate());
    }

    @Override
    public String getSQLTypeName() {
        return typeName;
    }

    public void addToDatabase(Connection conn) throws SQLException {
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put("ORDEROBJ",
                    Class.forName("OrdersDetails"));
            OrderDetails order = new OrderDetails(this.customerID, this.productName, this.price, this.quantity, this.orderDate);
            String sql = "{call SuperStorePackage.addOrder(?, ?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {
                conn.setAutoCommit(false);
                stmt.setObject(1, order);
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