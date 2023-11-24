package s2_g8;
import java.sql.*;
import java.util.Map;

public class CustomerDetails implements SQLData {
    private int customerID;
    private String customerEmail;
    private String firstName;
    private String lastName;
    private int addressID;

    public CustomerDetails(String customerEmail, String firstName, String lastName, int addressID) {
        this.customerEmail = customerEmail;
        this.firstName = firstName;
        this.lastName = lastName;
        this.addressID = addressID;
    }

    // Getters
    public int getCustomerID() {
        return this.customerID;
    }

    public String getCustomerEmail() {
        return this.customerEmail;
    }

    public String getFirstName() {
        return this.firstName;
    }

    public String getLastName() {
        return this.lastName;
    }

    public int getAddressID() {
        return this.addressID;
    }

    // Setters
    public void setCustomerID(int customerID){
        this.customerID=customerID;
    }
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setAddressID(int addressID) {
        this.addressID = addressID;
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(getCustomerID());
        stream.writeString(getCustomerEmail());
        stream.writeString(getFirstName());
        stream.writeString(getLastName());
        stream.writeInt(getAddressID());
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        setCustomerID(stream.readInt());
        setCustomerEmail(stream.readString());
        setFirstName(stream.readString());
        setLastName(stream.readString());
        setAddressID(stream.readInt());
    }

    @Override
    public String getSQLTypeName() {
        return "CUSTOMERDETAILSTYPE";
    }

    public void addToDatabase(Connection conn) throws SQLException {
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put("CUSTOMEROBJ",
             Class.forName("s2_g8.CustomerDetails"));
            CustomerDetails customer = new CustomerDetails(this.customerEmail, this.firstName, this.lastName, this.addressID);
            String sql = "{call SuperStorePackage.addCustomer(?, ?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)){
                conn.setAutoCommit(false);
                stmt.setObject(1, customer);
                stmt.registerOutParameter(2, Types.INTEGER);
                stmt.execute();
                setCustomerID((int) stmt.getInt(2));
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