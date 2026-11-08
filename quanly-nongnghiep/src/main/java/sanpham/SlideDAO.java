package sanpham;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnect.DBConnectf;

public class SlideDAO {

    /** Lấy slide từ SQL Server. Nếu lỗi hoặc bảng trống thì dùng slide mặc định. */
    public List<Slide> getAllSlide() {
        List<Slide> ds = new ArrayList<>();
        String sql = "SELECT Id, TieuDe, TieuDePhu, Badge, MoTa, DacDiem, IconNoi, ViTri, NutChu, NutLink, ThuTu "
                   + "FROM Slide WHERE HienThi = 1 ORDER BY ThuTu, Id";

        try (Connection conn = DBConnectf.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Slide s = new Slide();
                        s.setId(rs.getInt("Id"));
                        s.setTieuDe(rs.getString("TieuDe"));
                        s.setTieuDePhu(rs.getString("TieuDePhu"));
                        s.setBadge(rs.getString("Badge"));
                        s.setMoTa(rs.getString("MoTa"));
                        s.setDacDiem(rs.getString("DacDiem"));
                        s.setIconNoi(rs.getString("IconNoi"));
                        s.setViTri(rs.getString("ViTri"));
                        s.setNutChu(rs.getString("NutChu"));
                        s.setNutLink(rs.getString("NutLink"));
                        s.setThuTu(rs.getInt("ThuTu"));
                        ds.add(s);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đọc bảng Slide (đã chạy file slide.sql chưa?): " + e.getMessage());
        }

        return ds.isEmpty() ? macDinh() : ds;
    }

    /** Slide dự phòng, trang vẫn đẹp khi chưa có bảng Slide */
    public List<Slide> macDinh() {
        List<Slide> ds = new ArrayList<>();
        ds.add(new Slide("Rau Củ Quả Tươi Sạch", "Cho cuộc sống khỏe mạnh hơn!", "100% TƯƠI MỚI MỖI NGÀY",
                "Thu hoạch trực tiếp tại vườn, giao tận tay bạn ngay trong ngày.",
                "bi-shield-check|100% nông sản sạch;bi-truck|Giao hàng nhanh chóng;bi-cash-coin|Giá cả hợp lý",
                "🥬,🍅,🥕,🌽,🥦,🌶️", "left", "Mua ngay", "#san-pham"));
        ds.add(new Slide("Trái Cây Chín Mọng", "Ngọt thanh từ vườn nhà", "MÙA TRÁI CÂY MỚI",
                "Cam, táo, nho, dâu tây hái chín cây, mọng nước và giàu vitamin.",
                "bi-sun|Hái chín tự nhiên;bi-droplet-half|Mọng nước;bi-heart-pulse|Giàu vitamin C",
                "🍊,🍎,🍇,🍓,🍍,🍋", "right", "Xem trái cây", "#san-pham"));
        ds.add(new Slide("Siêu Ưu Đãi Hôm Nay", "Giảm đến 30% toàn bộ rau củ", "FLASH SALE TRONG NGÀY",
                "Đặt hàng ngay hôm nay để nhận mã giảm giá và quà tặng kèm hấp dẫn.",
                "bi-lightning-charge|Flash sale mỗi ngày;bi-gift|Quà tặng kèm;bi-ticket-perforated|Mã giảm 10%",
                "🎉,🏷️,💥,🛒,🎁,⭐", "center", "Săn ưu đãi", "#khuyen-mai"));
        ds.add(new Slide("Giao Hàng Hỏa Tốc", "Nhận rau tươi chỉ trong 2 giờ", "GIAO NHANH NỘI THÀNH",
                "Đặt trước 17h, rau củ tươi được giao đến cửa nhà bạn trong chưa đầy 2 giờ.",
                "bi-stopwatch|Giao trong 2 giờ;bi-geo-alt|Toàn thành phố;bi-box-seam|Đóng gói giữ lạnh",
                "🛵,📦,⏱️,🏠,🚚,📍", "left", "Đặt hàng", "#san-pham"));
        ds.add(new Slide("Từ Nông Trại Đến Bàn Ăn", "Minh bạch nguồn gốc chuẩn VietGAP", "AN TOÀN TỪ GỐC",
                "Mỗi sản phẩm đều có mã QR truy xuất nguồn gốc, bạn biết rõ rau được trồng ở đâu.",
                "bi-patch-check|Chuẩn VietGAP;bi-qr-code|Truy xuất bằng QR;bi-people|120 nhà vườn liên kết",
                "🚜,🌾,🌱,🐝,🌻,🍃", "right", "Tìm hiểu thêm", "#gioi-thieu"));
        ds.add(new Slide("Combo Gia Đình Tiết Kiệm", "Chỉ từ 149.000₫ mỗi combo", "COMBO BÁN CHẠY",
                "Rau củ theo mùa được chọn sẵn, đủ cho cả nhà dùng 3 ngày, miễn phí giao hàng.",
                "bi-basket3|8 loại rau củ;bi-truck|Miễn phí giao;bi-piggy-bank|Tiết kiệm đến 25%",
                "🧺,🥗,🍲,🥒,🍆,🍃", "center", "Xem combo", "#combo"));
        return ds;
    }
}