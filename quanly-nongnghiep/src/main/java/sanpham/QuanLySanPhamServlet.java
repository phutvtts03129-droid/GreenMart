package sanpham;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/san-pham")
public class QuanLySanPhamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSanPham(request, response);
                break;
            default:
                listSanPham(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "insert";

        switch (action) {
            case "update":
                updateSanPham(request, response);
                break;
            case "insert":
            default:
                insertSanPham(request, response);
                break;
        }
    }

    private void listSanPham(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SanPham> list = sanPhamDAO.getAllForAdmin();
        request.setAttribute("listSanPham", list);
        request.getRequestDispatcher("/Quanlysp/quanly-sanpham.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            SanPham existingSanPham = sanPhamDAO.getSanPhamById(id);
            request.setAttribute("spEdit", existingSanPham);
        } catch (Exception e) {
            e.printStackTrace();
        }
        listSanPham(request, response);
    }

    private void insertSanPham(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            SanPham sp = extractSanPhamFromRequest(request);
            sanPhamDAO.insert(sp);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/san-pham");
    }

    private void updateSanPham(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            SanPham sp = extractSanPhamFromRequest(request);
            sp.setId(Integer.parseInt(request.getParameter("id")));
            sanPhamDAO.update(sp);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/san-pham");
    }

    private void deleteSanPham(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            sanPhamDAO.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/san-pham");
    }

    private SanPham extractSanPhamFromRequest(HttpServletRequest request) {
        SanPham sp = new SanPham();
        sp.setTen(request.getParameter("ten"));

        // Xử lý giá bán (thay dấu phẩy thành dấu chấm nếu có)
        String strGia = request.getParameter("gia");
        if (strGia != null && !strGia.trim().isEmpty()) {
            sp.setGia(Double.parseDouble(strGia.trim().replace(",", ".")));
        }

        // Xử lý giá gốc
        String strGiaGoc = request.getParameter("giaGoc");
        if (strGiaGoc != null && !strGiaGoc.trim().isEmpty()) {
            sp.setGiaGoc(Double.parseDouble(strGiaGoc.trim().replace(",", ".")));
        }

        sp.setSoLuong(Integer.parseInt(request.getParameter("soLuong")));
        sp.setDonViTinh(request.getParameter("donViTinh"));
        sp.setHinhAnh(request.getParameter("hinhAnh"));
        sp.setMotaNgan(request.getParameter("motaNgan"));
        sp.setMotaChiTiet(request.getParameter("motaChiTiet"));
        sp.setXuatXu(request.getParameter("xuatXu"));

        sp.setTrangThai(request.getParameter("trangThai") != null);
        sp.setNoiBat(request.getParameter("noiBat") != null);

        String strDmId = request.getParameter("danhMucId");
        if (strDmId != null && !strDmId.trim().isEmpty()) {
            sp.setDanhMucId(Integer.parseInt(strDmId.trim()));
        }

        // Lấy Khuyến Mãi (%) từ form
        String strKhuyenMai = request.getParameter("khuyenMai");
        if (strKhuyenMai != null && !strKhuyenMai.trim().isEmpty()) {
            sp.setKhuyenMai(Integer.parseInt(strKhuyenMai.trim()));
        } else {
            sp.setKhuyenMai(0);
        }

        // Lấy Đã Bán từ form
        String strDaBan = request.getParameter("daBan");
        if (strDaBan != null && !strDaBan.trim().isEmpty()) {
            sp.setDaBan(Integer.parseInt(strDaBan.trim()));
        } else {
            sp.setDaBan(0);
        }

        return sp;
    }
}