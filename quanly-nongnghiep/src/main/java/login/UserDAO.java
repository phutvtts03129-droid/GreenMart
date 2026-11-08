package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnect.DBConnectf;

public class UserDAO {

    // Kiem tra ton tai username hoac email
    public boolean checkUserExists(String username, String email) {
        String sql = "SELECT id FROM Users WHERE username = ? OR email = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Dang ky tai khoan moi
    public boolean register(User user) {
        String sql = "INSERT INTO Users (fullname, username, email, password, role, salary, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getRole() != null ? user.getRole() : "CUSTOMER");
            ps.setBigDecimal(6, user.getSalary());
            ps.setBoolean(7, true);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Dang nhap (kiem tra username/email, mat khau va trang thai hoat dong)
    public User login(String account, String password) {
        String sql = "SELECT * FROM Users WHERE (username = ? OR email = ?) AND password = ? AND status = 1";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account);
            ps.setString(2, account);
            ps.setString(3, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setFullname(rs.getString("fullname"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setSalary(rs.getBigDecimal("salary"));
                    u.setStatus(rs.getBoolean("status"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tim user theo Email (Phuc vu tinh nang Dang nhap bang Google)
    public User findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ? AND status = 1";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setFullname(rs.getString("fullname"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setRole(rs.getString("role"));
                    u.setSalary(rs.getBigDecimal("salary"));
                    u.setStatus(rs.getBoolean("status"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
 // Map ResultSet sang User Model
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullname(rs.getString("fullname"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setSalary(rs.getBigDecimal("salary"));
        u.setStatus(rs.getBoolean("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }

    // Lay toan bo danh sach nguoi dung
    public java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY id DESC";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay thong tin user theo ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE id = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cap nhat thong tin nguoi dung & phan quyen (ADMIN, EMPLOYEE, CUSTOMER)
    public boolean updateUser(User user) {
        // Neu password truyen vao rong thi giu nguyen password cu
        boolean updatePass = user.getPassword() != null && !user.getPassword().trim().isEmpty();
        String sql = updatePass
            ? "UPDATE Users SET fullname = ?, role = ?, salary = ?, status = ?, password = ? WHERE id = ?"
            : "UPDATE Users SET fullname = ?, role = ?, salary = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getRole());
            ps.setBigDecimal(3, user.getSalary());
            ps.setBoolean(4, user.isStatus());
            if (updatePass) {
                ps.setString(5, user.getPassword());
                ps.setInt(6, user.getId());
            } else {
                ps.setInt(5, user.getId());
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Chuyen doi nhanh trang thai hoat dong (Khoa / Mo khoa tai khoan)
    public boolean toggleStatus(int id, boolean currentStatus) {
        String sql = "UPDATE Users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoa user theo ID
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM Users WHERE id = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
 // 1. Lay danh sach tat ca Nhan vien (role = 'EMPLOYEE')
    public List<User> getEmployeesOnly() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'EMPLOYEE' ORDER BY id DESC";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lay danh sach tat ca Khach hang (role = 'CUSTOMER')
    public List<User> getCustomersOnly() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'CUSTOMER' ORDER BY id DESC";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Dem so luong san pham nhan vien da ban duoc trong nam chi dinh
    public int getTongSanPhamBanTheoNam(int employeeId, int nam) {
        String sql = "SELECT ISNULL(SUM(ct.so_luong), 0) AS tong "
                   + "FROM DonHang dh "
                   + "JOIN ChiTietDonHang ct ON dh.id = ct.don_hang_id "
                   + "WHERE dh.nhan_vien_id = ? AND YEAR(dh.ngay_dat) = ? AND dh.trang_thai = N'Hoàn thành'";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, nam);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("tong");
            }
        } catch (SQLException e) {
            // Neu chua co bang DonHang thi tra ve 0 tranh loi
            return 0;
        }
        return 0;
    }
}