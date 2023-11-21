package s2_g8;
import java.sql.*;
import java.util.Map;

public class ProductReview implements SQLData {
    private String productName;
    private int customerID;
    private int review;
    private String reviewDescription;
    private int reviewFlag;

    public ProductReview(String productName, int customerID, int review, String reviewDescription, int reviewFlag) {
        this.productName = productName;
        this.customerID = customerID;
        this.review = review;
        this.reviewDescription = reviewDescription;
        this.reviewFlag = reviewFlag;
    }

    // Getters
    public String getProductName() {
        return this.productName;
    }

    public int getCustomerID() {
        return this.customerID;
    }

    public int getReview() {
        return this.review;
    }

    public String getReviewDescription() {
        return this.reviewDescription;
    }

    public int getReviewFlag() {
        return this.reviewFlag;
    }

    // Setters
    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public void setReview(int review) {
        this.review = review;
    }

    public void setReviewDescription(String reviewDescription) {
        this.reviewDescription = reviewDescription;
    }

    public void setReviewFlag(int reviewFlag) {
        this.reviewFlag = reviewFlag;
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeString(getProductName());
        stream.writeInt(getCustomerID());
        stream.writeInt(getReview());
        stream.writeString(getReviewDescription());
        stream.writeInt(getReviewFlag());
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        setProductName(stream.readString());
        setCustomerID(stream.readInt());
        setReview(stream.readInt());
        setReviewDescription(stream.readString());
        setReviewFlag(stream.readInt());
    }

    @Override
    public String getSQLTypeName() {
        return "PRODUCTREVIEWTYPE";
    }

    public void addToDatabase(Connection conn) throws SQLException {
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put("PRODUCTREVIEWTYPE",
                    Class.forName("ProductReview"));
            ProductReview review = new ProductReview(this.productName, this.customerID, this.review, this.reviewDescription, this.reviewFlag);
            String sql = "{call addProductReview(?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {
                conn.setAutoCommit(false);
                stmt.setObject(1, review);
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