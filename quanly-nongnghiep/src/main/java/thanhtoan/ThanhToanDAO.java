package thanhtoan;


import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import DBConnect.DBConnectf;
import donhang.DonHang;

public class ThanhToanDAO {

    /** Món hàng khách đang thanh toán: 1 sản phẩm trong DB hoặc 1 combo. */
    public static class Mon {
        public Integer spId;        // null nếu là combo
        public int comboId;         // 0 nếu là sản phẩm
        public String ten;
        public BigDecimal gia;
        public String hinh;
        public String emoji;
        public String donVi;
        public int tonKho = Integer.MAX_VALUE;

        public Integer getSpId() { return spId; }
        public int getComboId() { return comboId; }
        public String getTen() { return ten; }
        public BigDecimal getGia() { return gia; }
        public String getHinh() { return hinh; }
        public String getEmoji() { return emoji; }
        public String getDonVi() { return donVi; }
        public int getTonKho() { return tonKho; }
    }

    /** Lấy sản phẩm đang bán theo id (giá luôn lấy từ DB, không tin dữ liệu từ trình duyệt). */
    public Mon findSanPham(int id) {
        String sql = "SELECT id, ten, gia, hinh_anh, don_vi_tinh, so_luong "
                   + "FROM SanPham WHERE id = ? AND trang_thai = 1";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Mon m = new Mon();
                    m.spId = rs.getInt("id");
                    m.ten = rs.getString("ten");
                    m.gia = rs.getBigDecimal("gia");
                    m.hinh = rs.getString("hinh_anh");
                    m.donVi = rs.getString("don_vi_tinh");
                    m.tonKho = rs.getInt("so_luong");
                    return m;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lưu đơn hàng ở trạng thái "Chờ xử lý" (trong 1 transaction).
     * Chưa trừ kho: kho chỉ bị trừ khi nhân viên bấm "Xử lý" (DonHangDAO.xuLyDonHang).
     * @return mã đơn, ví dụ DH20261105-0004
     */
    public String taoDonHang(int khachId, String tenNhan, String sdt, String diaChi,
                             String ghiChu, String phuongThuc, Mon mon, int soLuong) throws SQLException {
        BigDecimal tong = mon.gia.multiply(BigDecimal.valueOf(soLuong));
        String tam = "TMP" + UUID.randomUUID().toString().replace("-", "").substring(0, 20);

        try (Connection conn = DBConnectf.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int donId;
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO DonHang (ma_don, khach_hang_id, ten_nguoi_nhan, sdt, dia_chi, ghi_chu, "
                      + "phuong_thuc_tt, tong_tien, trang_thai) VALUES (?,?,?,?,?,?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, tam);
                    ps.setInt(2, khachId);
                    ps.setString(3, tenNhan);
                    ps.setString(4, sdt);
                    ps.setString(5, diaChi);
                    if (ghiChu == null || ghiChu.isEmpty()) ps.setNull(6, java.sql.Types.NVARCHAR);
                    else ps.setString(6, ghiChu);
                    ps.setString(7, phuongThuc);
                    ps.setBigDecimal(8, tong);
                    ps.setString(9, DonHang.CHO_XU_LY);
                    ps.executeUpdate();
                    try (ResultSet k = ps.getGeneratedKeys()) {
                        k.next();
                        donId = k.getInt(1);
                    }
                }

                String maDon = "DH" + LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE)
                             + "-" + String.format("%04d", donId);
                try (PreparedStatement ps = conn.prepareStatement("UPDATE DonHang SET ma_don = ? WHERE id = ?")) {
                    ps.setString(1, maDon);
                    ps.setInt(2, donId);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO ChiTietDonHang (don_hang_id, san_pham_id, ten_san_pham, don_gia, so_luong) "
                      + "VALUES (?,?,?,?,?)")) {
                    ps.setInt(1, donId);
                    if (mon.spId == null) ps.setNull(2, java.sql.Types.INTEGER);
                    else ps.setInt(2, mon.spId);
                    ps.setString(3, mon.ten);
                    ps.setBigDecimal(4, mon.gia);
                    ps.setInt(5, soLuong);
                    ps.executeUpdate();
                }

                conn.commit();
                return maDon;
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}