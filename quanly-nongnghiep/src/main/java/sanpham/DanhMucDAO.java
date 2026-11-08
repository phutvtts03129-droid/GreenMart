package sanpham;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import DBConnect.DBConnectf;

public class DanhMucDAO {

    private DanhMuc map(ResultSet rs) throws Exception {
        DanhMuc dm = new DanhMuc();
        dm.setId(rs.getInt("id"));
        dm.setMaDanhMuc(rs.getString("ma_danhmuc"));
        dm.setTenDanhMuc(rs.getString("ten_danhmuc"));
        dm.setIcon(rs.getString("icon"));
        dm.setHinhAnh(rs.getString("hinh_anh"));
        dm.setMota(rs.getString("mota"));
        dm.setThuTu(rs.getInt("thu_tu"));
        dm.setTrangThai(rs.getBoolean("trang_thai"));
        dm.setNgayTao(rs.getTimestamp("ngay_tao"));
        return dm;
    }

    // Lấy tất cả danh mục đang hiển thị
    public List<DanhMuc> getAllDanhMuc() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT * FROM DanhMuc WHERE trang_thai = 1 ORDER BY thu_tu ASC";

        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // MỚI: tìm danh mục theo mã (slug), ví dụ "rau-cu-huu-co"
    public DanhMuc getDanhMucByMa(String ma) {
        String sql = "SELECT * FROM DanhMuc WHERE ma_danhmuc = ? AND trang_thai = 1";
        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ma);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // MỚI: đếm số sản phẩm đang bán theo từng danh mục -> Map<idDanhMuc, soLuong>
    public Map<Integer, Integer> demSanPhamTheoDanhMuc() {
        Map<Integer, Integer> m = new HashMap<>();
        String sql = "SELECT danh_muc_id, COUNT(*) AS so FROM SanPham "
                   + "WHERE trang_thai = 1 AND danh_muc_id IS NOT NULL GROUP BY danh_muc_id";

        try (Connection conn = DBConnectf.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                m.put(rs.getInt("danh_muc_id"), rs.getInt("so"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }
}