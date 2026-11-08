package login;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Khu làm việc của nhân viên.
 *   /nhan-vien            -> tổng quan ca làm
 *   /nhan-vien/don-hang   -> xử lý đơn hàng
 *   /nhan-vien/kho        -> quản lý kho
 *   /nhan-vien/luong      -> bảng lương của tôi
 */
@WebServlet(urlPatterns = {"/nhan-vien", "/nhan-vien/*"})
public class EmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("currentUser");

        // Chưa đăng nhập -> về trang đăng nhập
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Chỉ EMPLOYEE (và ADMIN) được vào
        String role = user.getRole() == null ? "" : user.getRole().trim();
        if (!"EMPLOYEE".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        String info = req.getPathInfo(); // null, "/", "/don-hang", ...
        String tab = "tong-quan";
        if (info != null) {
            switch (info) {
                case "/don-hang": tab = "don-hang"; break;
                case "/kho":      tab = "kho";      break;
                case "/luong":    tab = "luong";    break;
                default:          tab = "tong-quan";
            }
        }

        req.setAttribute("tab", tab);
        req.setAttribute("me", user);
        req.getRequestDispatcher("/quanlyUser/employee.jsp").forward(req, resp);
    }
}