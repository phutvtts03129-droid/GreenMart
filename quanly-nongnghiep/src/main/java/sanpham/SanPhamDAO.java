package sanpham;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnect.DBConnectf;

public class SanPhamDAO {

    // Helper map dữ liệu từ ResultSet sang SanPham Model
    private SanPham mapResultSetToSanPham(ResultSet rs) throws SQLException {
        SanPham sp = new SanPham();
        sp.setId(rs.getInt("id"));
        sp.setTen(rs.getString("ten"));
        sp.setGia(rs.getDouble("gia"));
        
        double giaGoc = rs.getDouble("gia_goc");
        sp.setGiaGoc(rs.wasNull() ? null : giaGoc);
        
        sp.setSoLuong(rs.getInt("so_luong"));
        sp.setDonViTinh(rs.getString("don_vi_tinh"));
        sp.setHinhAnh(rs.getString("hinh_anh"));
        sp.setMotaNgan(rs.getString("mota_ngan"));
        sp.setMotaChiTiet(rs.getString("mota_chitiet"));
        sp.setXuatXu(rs.getString("xuat_xu"));
        sp.setTrangThai(rs.getBoolean("trang_thai"));
        sp.setNoiBat(rs.getBoolean("noi_bat"));
        
        int dmId = rs.getInt("danh_muc_id");
        sp.setDanhMucId(rs.wasNull() ? null : dmId);
        
        sp.setNgayTao(rs.getTimestamp("ngay_tao"));
        sp.setDaBan(rs.getInt("da_ban"));
        sp.setKhuyenMai(rs.getInt("khuyen_mai"));
        return sp;
    }

    // 1. Lấy tất cả sản phẩm đang mở bán (trang_thai = 1)
    public List<SanPham> getAllSanPham() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE trang_thai = 1 ORDER BY id DESC";

        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy danh sách sản phẩm nổi bật hiển thị ở trang chủ
    public List<SanPham> getSanPhamNoiBat() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE trang_thai = 1 AND noi_bat = 1 ORDER BY id DESC";

        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Lọc sản phẩm theo ID danh mục
    public List<SanPham> getSanPhamByDanhMuc(int danhMucId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE trang_thai = 1 AND danh_muc_id = ? ORDER BY id DESC";

        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, danhMucId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSanPham(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Lấy chi tiết một sản phẩm theo ID
    public SanPham getSanPhamById(int id) {
        String sql = "SELECT * FROM SanPham WHERE id = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSanPham(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. Lấy tất cả sản phẩm cho trang quản trị (Admin xem cả hàng ẩn/hiện)
    public List<SanPham> getAllForAdmin() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham ORDER BY id DESC";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToSanPham(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 6. Thêm mới sản phẩm
    public boolean insert(SanPham sp) {
        String sql = "INSERT INTO SanPham (ten, gia, gia_goc, so_luong, don_vi_tinh, hinh_anh, "
                   + "mota_ngan, mota_chitiet, xuat_xu, trang_thai, noi_bat, danh_muc_id, da_ban, khuyen_mai) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sp.getTen());
            ps.setDouble(2, sp.getGia());
            if (sp.getGiaGoc() != null) {
                ps.setDouble(3, sp.getGiaGoc());
            } else {
                ps.setNull(3, java.sql.Types.DOUBLE);
            }
            ps.setInt(4, sp.getSoLuong());
            ps.setString(5, sp.getDonViTinh());
            ps.setString(6, sp.getHinhAnh());
            ps.setString(7, sp.getMotaNgan());
            ps.setString(8, sp.getMotaChiTiet());
            ps.setString(9, sp.getXuatXu());
            ps.setBoolean(10, sp.isTrangThai());
            ps.setBoolean(11, sp.isNoiBat());
            if (sp.getDanhMucId() != null) {
                ps.setInt(12, sp.getDanhMucId());
            } else {
                ps.setNull(12, java.sql.Types.INTEGER);
            }
            ps.setInt(13, sp.getDaBan());
            ps.setInt(14, sp.getKhuyenMai());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Cập nhật thông tin sản phẩm
    public boolean update(SanPham sp) {
        String sql = "UPDATE SanPham SET ten = ?, gia = ?, gia_goc = ?, so_luong = ?, don_vi_tinh = ?, "
                   + "hinh_anh = ?, mota_ngan = ?, mota_chitiet = ?, xuat_xu = ?, trang_thai = ?, "
                   + "noi_bat = ?, danh_muc_id = ?, da_ban = ?, khuyen_mai = ? WHERE id = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sp.getTen());
            ps.setDouble(2, sp.getGia());
            if (sp.getGiaGoc() != null) {
                ps.setDouble(3, sp.getGiaGoc());
            } else {
                ps.setNull(3, java.sql.Types.DOUBLE);
            }
            ps.setInt(4, sp.getSoLuong());
            ps.setString(5, sp.getDonViTinh());
            ps.setString(6, sp.getHinhAnh());
            ps.setString(7, sp.getMotaNgan());
            ps.setString(8, sp.getMotaChiTiet());
            ps.setString(9, sp.getXuatXu());
            ps.setBoolean(10, sp.isTrangThai());
            ps.setBoolean(11, sp.isNoiBat());
            if (sp.getDanhMucId() != null) {
                ps.setInt(12, sp.getDanhMucId());
            } else {
                ps.setNull(12, java.sql.Types.INTEGER);
            }
            ps.setInt(13, sp.getDaBan());
            ps.setInt(14, sp.getKhuyenMai());
            ps.setInt(15, sp.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 8. Cập nhật riêng số lượng đã bán (dùng khi khách đặt hàng thành công)
    public boolean updateDaBan(int id, int soLuongMua) {
        String sql = "UPDATE SanPham SET da_ban = da_ban + ?, so_luong = so_luong - ? WHERE id = ? AND so_luong >= ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, soLuongMua);
            ps.setInt(2, soLuongMua);
            ps.setInt(3, id);
            ps.setInt(4, soLuongMua);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 9. Xoá sản phẩm theo ID
    public boolean delete(int id) {
        String sql = "DELETE FROM SanPham WHERE id = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}