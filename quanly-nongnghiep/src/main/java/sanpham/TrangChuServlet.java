package sanpham;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TrangChuServlet", urlPatterns = {"/trang-chu", ""})
public class TrangChuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Khởi tạo các DAO
        SanPhamDAO spDao = new SanPhamDAO();
        SlideDAO slideDao = new SlideDAO();
        DanhMucDAO dmDao = new DanhMucDAO();

        req.setAttribute("danhSachSlide", slideDao.getAllSlide());

        
        req.setAttribute("danhSachDanhMuc", dmDao.getAllDanhMuc());
        req.setAttribute("soLuongTheoDM", dmDao.demSanPhamTheoDanhMuc());   // <-- DÒNG MỚI
  
        // 4. Sản phẩm Nổi Bật
        List<SanPham> dsNoiBat = spDao.getSanPhamNoiBat();
        req.setAttribute("danhSachNoiBat", dsNoiBat);

        // 5. Danh sách Sản Phẩm chính (lọc theo ?danhMucId=...)
        String dmIdParam = req.getParameter("danhMucId");
        List<SanPham> danhSach;

        if (dmIdParam != null && !dmIdParam.trim().isEmpty()) {
            try {
                int danhMucId = Integer.parseInt(dmIdParam);
                danhSach = spDao.getSanPhamByDanhMuc(danhMucId);
                req.setAttribute("selectedDanhMucId", danhMucId);
            } catch (NumberFormatException e) {
                danhSach = spDao.getAllSanPham();
            }
        } else {
        	danhSach = spDao.getAllSanPham();
        }

        req.setAttribute("danhSachSanPham", danhSach);

        // 6. Điều hướng về JSP
        req.getRequestDispatcher("/home/index.jsp").forward(req, resp);
    }
}