package donhang;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import DBConnect.DBConnectf;

public class DonHangDAO {

    private DonHang map(ResultSet rs) throws SQLException {
        DonHang d = new DonHang();
        d.setId(rs.getInt("id"));
        d.setMaDon(rs.getString("ma_don"));
        int kh = rs.getInt("khach_hang_id");
        d.setKhachHangId(rs.wasNull() ? null : kh);
        int nv = rs.getInt("nhan_vien_id");
        d.setNhanVienId(rs.wasNull() ? null : nv);
        d.setTenNguoiNhan(rs.getString("ten_nguoi_nhan"));
        d.setSdt(rs.getString("sdt"));
        d.setDiaChi(rs.getString("dia_chi"));
        d.setGhiChu(rs.getString("ghi_chu"));
        d.setPhuongThucTt(rs.getString("phuong_thuc_tt"));
        d.setTongTien(rs.getBigDecimal("tong_tien"));
        d.setTrangThai(rs.getString("trang_thai"));
        d.setNgayDat(rs.getTimestamp("ngay_dat"));
        d.setNgayXuLy(rs.getTimestamp("ngay_xu_ly"));
        d.setTenKhachHang(rs.getString("ten_kh"));
        d.setTenNhanVien(rs.getString("ten_nv"));
        d.setTongSp(rs.getInt("tong_sp"));
        return d;
    }

    /** Lấy danh sách đơn (kèm chi tiết). trangThai = null => tất cả. */
    public List<DonHang> getDonHang(String trangThai) {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT dh.*, kh.fullname AS ten_kh, nv.fullname AS ten_nv, "
                   + "(SELECT ISNULL(SUM(so_luong),0) FROM ChiTietDonHang WHERE don_hang_id = dh.id) AS tong_sp "
                   + "FROM DonHang dh "
                   + "LEFT JOIN Users kh ON dh.khach_hang_id = kh.id "
                   + "LEFT JOIN Users nv ON dh.nhan_vien_id = nv.id "
                   + (trangThai != null ? "WHERE dh.trang_thai = ? " : "")
                   // đơn chờ xử lý: cũ nhất lên trước; các tab khác: mới nhất lên trước
                   + (DonHang.CHO_XU_LY.equals(trangThai) ? "ORDER BY dh.ngay_dat ASC" : "ORDER BY dh.ngay_dat DESC");
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (trangThai != null) ps.setString(1, trangThai);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            for (DonHang d : list) d.setChiTiet(getChiTiet(conn, d.getId()));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<ChiTietDonHang> getChiTiet(Connection conn, int donHangId) throws SQLException {
        List<ChiTietDonHang> list = new ArrayList<>();
        String sql = "SELECT id, don_hang_id, san_pham_id, ten_san_pham, don_gia, so_luong "
                   + "FROM ChiTietDonHang WHERE don_hang_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donHangId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChiTietDonHang c = new ChiTietDonHang();
                    c.setId(rs.getInt("id"));
                    c.setDonHangId(rs.getInt("don_hang_id"));
                    int sp = rs.getInt("san_pham_id");
                    c.setSanPhamId(rs.wasNull() ? null : sp);
                    c.setTenSanPham(rs.getString("ten_san_pham"));
                    c.setDonGia(rs.getBigDecimal("don_gia"));
                    c.setSoLuong(rs.getInt("so_luong"));
                    list.add(c);
                }
            }
        }
        return list;
    }

    /** Đếm số đơn theo từng trạng thái: key = cho / xuly / huy. */
    public Map<String, Integer> demTheoTrangThai() {
        Map<String, Integer> m = new HashMap<>();
        m.put("cho", 0); m.put("xuly", 0); m.put("huy", 0);
        String sql = "SELECT trang_thai, COUNT(*) AS n FROM DonHang GROUP BY trang_thai";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String tt = rs.getString("trang_thai");
                int n = rs.getInt("n");
                if (DonHang.CHO_XU_LY.equals(tt)) m.put("cho", n);
                else if (DonHang.DA_XU_LY.equals(tt)) m.put("xuly", n);
                else if (DonHang.DA_HUY.equals(tt)) m.put("huy", n);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return m;
    }

    /**
     * Nhân viên bấm "Xử lý đơn".
     * Trong 1 transaction:
     *  1) Giành đơn (chỉ thành công nếu đơn còn "Chờ xử lý" -> 2 nhân viên bấm cùng lúc chỉ 1 người được)
     *  2) Gán nhan_vien_id + ngay_xu_ly + trạng thái "Đã xử lý"  => nhân viên này được tính doanh số
     *  3) Trừ tồn kho (so_luong) và cộng da_ban cho từng sản phẩm; thiếu hàng thì rollback toàn bộ
     * @return null nếu thành công, ngược lại là thông báo lỗi
     */
    public String xuLyDonHang(int donHangId, int nhanVienId) {
        try (Connection conn = DBConnectf.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE DonHang SET trang_thai = ?, nhan_vien_id = ?, ngay_xu_ly = GETDATE() "
                      + "WHERE id = ? AND trang_thai = ?")) {
                    ps.setString(1, DonHang.DA_XU_LY);
                    ps.setInt(2, nhanVienId);
                    ps.setInt(3, donHangId);
                    ps.setString(4, DonHang.CHO_XU_LY);
                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return "Đơn hàng không còn ở trạng thái chờ xử lý (có thể đã được người khác xử lý).";
                    }
                }

                for (ChiTietDonHang c : getChiTiet(conn, donHangId)) {
                    if (c.getSanPhamId() == null) continue;   // sản phẩm đã bị xóa khỏi hệ thống
                    try (PreparedStatement ps = conn.prepareStatement(
                            "UPDATE SanPham SET so_luong = so_luong - ?, da_ban = da_ban + ? "
                          + "WHERE id = ? AND so_luong >= ?")) {
                        ps.setInt(1, c.getSoLuong());
                        ps.setInt(2, c.getSoLuong());
                        ps.setInt(3, c.getSanPhamId());
                        ps.setInt(4, c.getSoLuong());
                        if (ps.executeUpdate() == 0) {
                            conn.rollback();
                            return "Không đủ tồn kho cho sản phẩm: " + c.getTenSanPham();
                        }
                    }
                }
                conn.commit();
                return null;
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Lỗi hệ thống khi xử lý đơn hàng.";
        }
    }

    /** Hủy đơn đang chờ xử lý (không trừ kho, không tính doanh số). */
    public boolean huyDonHang(int donHangId, int nhanVienId) {
        String sql = "UPDATE DonHang SET trang_thai = ?, nhan_vien_id = ?, ngay_xu_ly = GETDATE() "
                   + "WHERE id = ? AND trang_thai = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, DonHang.DA_HUY);
            ps.setInt(2, nhanVienId);
            ps.setInt(3, donHangId);
            ps.setString(4, DonHang.CHO_XU_LY);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** {tổng số đơn đã xử lý, tổng số sản phẩm đã bán} của 1 nhân viên trong năm. */
    public int[] thongKeNhanVien(int nhanVienId, int nam) {
        String sql = "SELECT COUNT(DISTINCT dh.id) AS so_don, ISNULL(SUM(ct.so_luong),0) AS tong_sp "
                   + "FROM DonHang dh LEFT JOIN ChiTietDonHang ct ON ct.don_hang_id = dh.id "
                   + "WHERE dh.nhan_vien_id = ? AND dh.trang_thai = ? AND YEAR(dh.ngay_xu_ly) = ?";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nhanVienId);
            ps.setString(2, DonHang.DA_XU_LY);
            ps.setInt(3, nam);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new int[]{rs.getInt("so_don"), rs.getInt("tong_sp")};
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new int[]{0, 0};
    }

    /** Bảng xếp hạng: mỗi dòng {họ tên, số đơn đã xử lý, tổng sản phẩm đã bán} trong năm. */
    public List<Object[]> bangXepHang(int nam) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT u.fullname, COUNT(DISTINCT dh.id) AS so_don, ISNULL(SUM(ct.so_luong),0) AS tong_sp "
                   + "FROM Users u "
                   + "LEFT JOIN DonHang dh ON dh.nhan_vien_id = u.id AND dh.trang_thai = ? AND YEAR(dh.ngay_xu_ly) = ? "
                   + "LEFT JOIN ChiTietDonHang ct ON ct.don_hang_id = dh.id "
                   + "WHERE u.role = 'EMPLOYEE' AND u.status = 1 "
                   + "GROUP BY u.id, u.fullname ORDER BY tong_sp DESC, u.fullname";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, DonHang.DA_XU_LY);
            ps.setInt(2, nam);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Object[]{rs.getString("fullname"), rs.getInt("so_don"), rs.getInt("tong_sp")});
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /** Lấy danh sách đơn hàng của riêng 1 khách hàng (kèm chi tiết các món). */
    public List<DonHang> getDonHangByKhachHang(int khachHangId) {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT dh.*, kh.fullname AS ten_kh, nv.fullname AS ten_nv, "
                   + "(SELECT ISNULL(SUM(so_luong),0) FROM ChiTietDonHang WHERE don_hang_id = dh.id) AS tong_sp "
                   + "FROM DonHang dh "
                   + "LEFT JOIN Users kh ON dh.khach_hang_id = kh.id "
                   + "LEFT JOIN Users nv ON dh.nhan_vien_id = nv.id "
                   + "WHERE dh.khach_hang_id = ? "
                   + "ORDER BY dh.ngay_dat DESC";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, khachHangId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
            // Load chi tiết từng món cho từng đơn hàng
            for (DonHang d : list) {
                d.setChiTiet(getChiTiet(conn, d.getId()));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}