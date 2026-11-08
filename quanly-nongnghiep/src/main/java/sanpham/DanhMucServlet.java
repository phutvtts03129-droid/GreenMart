package sanpham;



import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Trang danh mục:
 *   /danh-muc                      -> tất cả sản phẩm
 *   /danh-muc?ma=rau-cu-huu-co     -> sản phẩm của 1 danh mục
 *   &sort=gia-tang|gia-giam|ten|moi   (sắp xếp)
 *   &q=ca chua                        (tìm trong danh mục)
 */
@WebServlet(name = "DanhMucServlet", urlPatterns = {"/danh-muc"})
public class DanhMucServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        DanhMucDAO dmDao = new DanhMucDAO();
        SanPhamDAO spDao = new SanPhamDAO();

        String ma = req.getParameter("ma");
        String sort = req.getParameter("sort");
        String q = req.getParameter("q");

        if (ma != null) ma = ma.trim();
        if (q != null) q = q.trim();
        if (sort == null || sort.isEmpty()) sort = "moi";

        // 1. Danh sách danh mục (thanh bên) + số sản phẩm từng danh mục
        List<DanhMuc> dsDanhMuc = dmDao.getAllDanhMuc();
        Map<Integer, Integer> dem = dmDao.demSanPhamTheoDanhMuc();
        int tongTatCa = 0;
        for (int n : dem.values()) tongTatCa += n;

        // 2. Lấy sản phẩm theo danh mục (hoặc tất cả)
        DanhMuc hienTai = null;
        List<SanPham> ds;

        if (ma != null && !ma.isEmpty()) {
            hienTai = dmDao.getDanhMucByMa(ma);
            if (hienTai == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy danh mục");
                return;
            }
            ds = spDao.getSanPhamByDanhMuc(hienTai.getId());
        } else {
            ds = spDao.getAllSanPham();
        }

        // 3. Lọc theo từ khóa
        if (q != null && !q.isEmpty()) {
            String kw = q.toLowerCase();
            List<SanPham> loc = new ArrayList<>();
            for (SanPham sp : ds) {
                String ten = sp.getTen() == null ? "" : sp.getTen().toLowerCase();
                String xx = sp.getXuatXu() == null ? "" : sp.getXuatXu().toLowerCase();
                if (ten.contains(kw) || xx.contains(kw)) loc.add(sp);
            }
            ds = loc;
        }

        // 4. Sắp xếp (mặc định "moi" = id giảm dần, đã sắp từ SQL)
        switch (sort) {
            case "gia-tang":
                ds.sort(Comparator.comparingDouble(SanPham::getGia));
                break;
            case "gia-giam":
                ds.sort(Comparator.comparingDouble(SanPham::getGia).reversed());
                break;
            case "ten":
                ds.sort(Comparator.comparing(SanPham::getTen, String.CASE_INSENSITIVE_ORDER));
                break;
            default:
                sort = "moi";
        }

        req.setAttribute("danhSachDanhMuc", dsDanhMuc);
        req.setAttribute("soLuongTheoDM", dem);
        req.setAttribute("tongTatCa", tongTatCa);
        req.setAttribute("danhMucHienTai", hienTai);
        req.setAttribute("danhSachSanPham", ds);
        req.setAttribute("ma", ma == null ? "" : ma);
        req.setAttribute("sort", sort);
        req.setAttribute("q", q == null ? "" : q);

        req.getRequestDispatcher("/home/danh-muc.jsp").forward(req, resp);
    }
}