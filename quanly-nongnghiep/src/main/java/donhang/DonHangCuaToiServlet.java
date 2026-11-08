package donhang;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import login.User;

@WebServlet("/don-hang-cua-toi")
public class DonHangCuaToiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DonHangDAO donHangDAO;

    @Override
    public void init() throws ServletException {
        donHangDAO = new DonHangDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Nếu chưa đăng nhập thì bắt buộc chuyển sang trang đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap?redirect=/don-hang-cua-toi");
            return;
        }

        // Lấy danh sách đơn hàng của khách hàng hiện tại
        List<DonHang> list = donHangDAO.getDonHangByKhachHang(currentUser.getId());
        request.setAttribute("listDonHang", list);

        // Chuyển hướng tới giao diện JSP
        request.getRequestDispatcher("/donhang/don-hang-cua-toi.jsp").forward(request, response);
    }
}
