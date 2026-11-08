package DBConnect;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConnectf {
    public static final String HOSTNAME = "localhost";
    public static final String PORT = "1433";
    public static final String DBNAME = "Nha"; // Tên database trong SQL Server
    public static final String USERNAME = "sa";
    public static final String PASSWORD = "123456"; // Mật khẩu của bạn

    public static Connection getConnection() {
        // Chuỗi kết nối chuẩn cho SQL Server
        String connectionURL = "jdbc:sqlserver://" + HOSTNAME + ":" + PORT + ";"
                + "databaseName=" + DBNAME + ";"
                + "encrypt=true;trustServerCertificate=true;";
        
        try {
            // Bước 1: Nạp Driver (Cần file .jar trong Build Path)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Bước 2: Thực hiện kết nối
            return DriverManager.getConnection(connectionURL, USERNAME, PASSWORD);
            
        } catch (ClassNotFoundException e) {
            System.err.println("LỖI: Thiếu thư viện Driver (File .jar)! Hãy kiểm tra Build Path.");
        } catch (SQLException e) {
            System.err.println("LỖI: Không thể kết nối SQL Server!");
            System.err.println("Kiểm tra: Mật khẩu sa, Database '" + DBNAME + "' đã có chưa, hoặc cổng 1433 đã mở chưa.");
            e.printStackTrace(); // In chi tiết lỗi SQL
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Hàm main để chạy test độc lập
    public static void main(String[] args) {
        System.out.println("--- Đang kiểm tra kết nối... ---");
        Connection conn = getConnection();
        
        
        if (conn != null) {
            System.out.println("THÀNH CÔNG: Đã kết nối tới SQL Server!");
            System.out.println("Thông tin kết nối: " + conn.toString());
        } else {
            System.out.println("THẤT BẠI: Kết nối trả về NULL.");
        }
    }
}
