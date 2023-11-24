package s2_g8;

import java.sql.*;
import java.util.Map;
import java.util.Scanner;

public class LocationDetails {
    private String typeName;
    private int addressID;
    private String address;
    private String country;
    private String city;

    /**
     * Constructor to assign all fields to their respective values (not ID)
     * @param address The customer's address
     * @param country The country where the customer lives
     * @param city The city where the customer resides
     */
    public LocationDetails(String address, String country, String city) {
        this.address = address;
        this.country = country;
        this.city = city;
    }

    //sets values for each of the object's fields (ID not included)
    public void setAddressID(int id) {
        this.addressID = id;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public void setCountry(String country) {
        this.country = country;
    }
    public void setCity(String city) {
        this.city = city;
    }
    
    //get values for each one of the objects' fields
    public int getAddressID() {
        return this.addressID;
    }
    public String getAddress() {
        return this.address;
    }
    public String getCountry() {
        return this.country;
    }
    public String getCity() {
        return this.city;
    }

    //The compiler threw an exception when I put @Override on this for some reason. Programmer threads online said it's because the compiler might be too old. I was forced to remove it entirely
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(getAddressID());
        stream.writeString(getAddress());
        stream.writeString(getCountry());
        stream.writeString(getCity());
    }
    
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.typeName = typeName;
        setAddressID(stream.readInt());
        setAddress(stream.readString());
        setCountry(stream.readString());
        setCity(stream.readString());
    }

    public String getSQLTypeName() {
        return typeName;
    }

    public void addToDatabase(Connection conn) throws SQLException {
        try {
            Map map = conn.getTypeMap();
            conn.setTypeMap(map);
            map.put("LOCATIONOBJ",
                    Class.forName("s2_g8.LocationDetails"));
            LocationDetails order = new LocationDetails(this.address, this.country, this.city);
            String sql = "{call SuperStorePackage.addLocation(?, ?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {
                conn.setAutoCommit(false);
                stmt.setObject(1, order);
                stmt.registerOutParameter(2, Types.INTEGER);
                stmt.execute();
                setAddressID((int) stmt.getInt(2));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
        } catch (ClassNotFoundException c) {
            c.printStackTrace();
            conn.rollback();
        }
    }

    public void removeFromDatabase(Connection conn) throws SQLException {
        Scanner sc = new Scanner(System.in);

        System.out.println("Enter the ID of the location to delete:");
        int idToDelete = sc.nextInt();


        try {
            String sql = "{call SuperStorePackage.DeleteLocation(?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {
                conn.setAutoCommit(false);
                stmt.setInt(1, idToDelete);
                stmt.execute();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
        }
    }
}
