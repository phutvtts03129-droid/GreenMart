package thanhtoan;


import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import login.User;

@WebServlet("/thanh-toan")
public class ThanhToanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ThanhToanDAO thanhToanDAO;

    @Override
    public void init() throws ServletException {
        thanhToanDAO = new ThanhToanDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Bat buoc dang nhap truoc khi thanh toan
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap?redirect=/thanh-toan");
            return;
        }

        String spIdParam = request.getParameter("id");
        String soLuongParam = request.getParameter("soLuong");

        if (spIdParam == null || spIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/trang-chu");
            return;
        }

        try {
            int spId = Integer.parseInt(spIdParam);
            int soLuong = (soLuongParam != null && !soLuongParam.trim().isEmpty())
                    ? Math.max(1, Integer.parseInt(soLuongParam))
                    : 1;

            ThanhToanDAO.Mon mon = thanhToanDAO.findSanPham(spId);

            if (mon == null) {
                request.setAttribute("errorMsg", "San pham khong ton tai hoac da ngung kinh doanh!");
                response.sendRedirect(request.getContextPath() + "/trang-chu");
                return;
            }

            request.setAttribute("mon", mon);
            request.setAttribute("soLuong", soLuong);
            request.getRequestDispatcher("/ThanhToan/thanh-toan.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/trang-chu");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String spIdParam = request.getParameter("spId");
        String soLuongParam = request.getParameter("soLuong");
        String tenNhan = request.getParameter("tenNhan");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");
        String ghiChu = request.getParameter("ghiChu");
        String phuongThuc = request.getParameter("phuongThuc");

        int spId = 0;
        int soLuong = 1;
        try {
            spId = Integer.parseInt(spIdParam);
            soLuong = Integer.parseInt(soLuongParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/trang-chu");
            return;
        }

        ThanhToanDAO.Mon mon = thanhToanDAO.findSanPham(spId);
        if (mon == null) {
            request.setAttribute("errorMsg", "San pham khong con hop le tren he thong.");
            response.sendRedirect(request.getContextPath() + "/trang-chu");
            return;
        }

        // Kiem tra ton kho co ban truoc khi ghi nhan don
        if (soLuong > mon.tonKho) {
            request.setAttribute("errorMsg", "So luong dat vuot qua so luong con trong kho (" + mon.tonKho + ").");
            request.setAttribute("mon", mon);
            request.setAttribute("soLuong", mon.tonKho);
            request.getRequestDispatcher("/ThanhToan/thanh-toan.jsp").forward(request, response);
            return;
        }

        try {
            // Tao don hang qua Transaction trong ThanhToanDAO
            String maDon = thanhToanDAO.taoDonHang(
                    currentUser.getId(),
                    tenNhan,
                    sdt,
                    diaChi,
                    ghiChu,
                    phuongThuc,
                    mon,
                    soLuong
            );

            // Gui thong bao thanh cong cung ma don va forward thang ve lai trang thanh-toan.jsp
            request.setAttribute("successMsg", "Đặt hàng thành công! Đơn hàng của bạn đang được xử lý.");
            request.setAttribute("maDon", maDon);
            request.setAttribute("isSuccess", true);
            request.getRequestDispatcher("/ThanhToan/thanh-toan.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Loi he thong khi tao don hang: " + e.getMessage());
            request.setAttribute("mon", mon);
            request.setAttribute("soLuong", soLuong);
            request.getRequestDispatcher("/ThanhToan/thanh-toan.jsp").forward(request, response);
        }
    }
}