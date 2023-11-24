package s2_g8;
import java.sql.*;
import java.util.Map;

public class ProductDetails implements SQLData {
    private String typeName;
    private String productName;
    private double price;
    private String store;
    private String productCategory;
    private int averageReview;

    public ProductDetails(String productName, double price, String store, String productCategory, int averageReview) {
        this.productName = productName;
        this.price = price;
        this.store = store;
        this.productCategory = productCategory;
        this.averageReview = averageReview;
    }

    // Getters
    public String getProductName() {
        return this.productName;
    }

    public double getPrice() {
        return this.price;
    }

    public String getStore() {
        return this.store;
    }

    public String getProductCategory() {
        return this.productCategory;
    }

    public int getAverageReview() {
        return this.averageReview;
    }

    // Setters
    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setStore(String store) {
        this.store = store;
    }

    public void setProductCategory(String productCategory) {
        this.productCategory = productCategory;
    }

    public void setAverageReview(int averageReview) {
        this.averageReview = averageReview;
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeString(getProductName());
        stream.writeDouble(getPrice());
        stream.writeString(getStore());
        stream.writeString(getProductCategory());
        stream.writeInt(getAverageReview());
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.typeName = typeName;
        setProductName(stream.readString());
        setPrice(stream.readDouble());
        setStore(stream.readString());
        setProductCategory(stream.readString());
        setAverageReview(stream.readInt());
    }

    @Override
    public String getSQLTypeName() {
        return typeName;
    }

    public void addToDatabase(Connection conn) throws SQLException {
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put("PRODUCTOBJ",
                    Class.forName("ProductDetails"));
            ProductDetails product = new ProductDetails(this.productName, this.price, this.store, this.productCategory, this.averageReview);
            String sql = "{call SuperStorePackage.addProduct(?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {
                conn.setAutoCommit(false);
                stmt.setObject(1, product);
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