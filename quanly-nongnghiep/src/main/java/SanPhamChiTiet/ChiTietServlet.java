package SanPhamChiTiet;


import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sanpham.SanPham;
import sanpham.SanPhamDAO;

@WebServlet("/chi-tiet")
public class ChiTietServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SanPhamDAO sanPhamDAO;

    @Override
    public void init() throws ServletException {
        sanPhamDAO = new SanPhamDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/trang-chu");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            SanPham sp = sanPhamDAO.getSanPhamById(id);

            if (sp == null) {
                response.sendRedirect(request.getContextPath() + "/trang-chu");
                return;
            }

            // Lay them danh sach san pham de xuat cung loai/noi bat
            List<SanPham> dsLienQuan = sanPhamDAO.getSanPhamNoiBat();

            request.setAttribute("sp", sp);
            request.setAttribute("dsLienQuan", dsLienQuan);

            // Chuyen huong toi file jsp trong thu muc home
            request.getRequestDispatcher("/home/chi-tiet.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/trang-chu");
        }
    }
}