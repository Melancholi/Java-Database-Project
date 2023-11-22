package s2_g8;

import java.sql.*;
import java.util.Scanner;

public class StoreServices {
    private Connection conn;

    /**
     * Initialize the connection
     */
    public StoreServices() {
        Scanner sc = new Scanner(System.in);

        System.out.println("Enter your user:\n");
        String user = sc.next();
        System.out.println("Enter your password:\n");
        String pwd = sc.next();
        sc.close();
        try {
            this.conn = DriverManager.getConnection("jdbc:oracle:thin:@198.168.52.211:1521/pdbora19c.dawsoncollege.qc.ca", user, pwd);
        }
        catch(SQLException sqlError) {

        }
    }

    /**
     * Retrieve the connection for the DB
     * @return connection
     */
    public Connection getConection() {
        return this.conn;
    }

    public void addProduct(String name, double price, String store, String category) throws SQLException {
        ProductDetails product = new ProductDetails(name, price, store, category, 0);
        product.addToDatabase(conn);
    }

    public void addProductReview(String name, int customerID, int reviewScore, String reviewDesc, int reviewFlag) throws SQLException {
        ProductReview review = new ProductReview(name, customerID, reviewScore, reviewDesc, reviewFlag);
        review.addToDatabase(this.conn);
    }
}
