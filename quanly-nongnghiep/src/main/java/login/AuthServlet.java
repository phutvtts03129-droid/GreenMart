package login;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(urlPatterns = {"/login", "/register", "/dang-nhap", "/dang-ky", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // 1. Xu ly dang xuat
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate(); // Xoa session
            }
            resp.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }

        // 2. Dieu huong hien thi trang Dang ky
        if ("/register".equals(path) || "/dang-ky".equals(path)) {
            req.getRequestDispatcher("/login/register.jsp").forward(req, resp);
            return;
        }

        // 3. Dieu huong hien thi trang Dang nhap (/login hoac /dang-nhap)
        req.getRequestDispatcher("/login/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/login".equals(path) || "/dang-nhap".equals(path)) {
            handleLogin(req, resp);
        } else if ("/register".equals(path) || "/dang-ky".equals(path)) {
            handleRegister(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String account = req.getParameter("account");
        String pass = req.getParameter("password");

        User user = userDAO.login(account, pass);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("currentUser", user);

            // Phân quyền điều hướng theo Role:
            String role = user.getRole() == null ? "" : user.getRole().trim();
            if ("ADMIN".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin");
            } else if ("EMPLOYEE".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/nhan-vien"); // Khớp hoàn toàn với urlPatterns của EmployeeServlet
            } else {
                resp.sendRedirect(req.getContextPath() + "/trang-chu");
            }
        } else {
            // Dang nhap that bai -> bao loi tai trang login
            req.setAttribute("error", "Tai khoan hoac mat khau khong dung, hoac da bi khoa!");
            req.getRequestDispatcher("/login/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullname = req.getParameter("fullname");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String role = req.getParameter("role");
        String salaryStr = req.getParameter("salary");

        BigDecimal salary = BigDecimal.ZERO;
        try {
            if (salaryStr != null && !salaryStr.trim().isEmpty()) {
                salary = new BigDecimal(salaryStr);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Dinh dang luong khong hop le!");
            req.getRequestDispatcher("/login/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.checkUserExists(username, email)) {
            req.setAttribute("error", "Username hoac Email da duoc su dung!");
            req.getRequestDispatcher("/login/register.jsp").forward(req, resp);
            return;
        }

        if (role == null || role.trim().isEmpty()) {
            role = "CUSTOMER";
        }

        User newUser = new User(fullname, username, email, pass, role, salary);
        boolean success = userDAO.register(newUser);

        if (success) {
            // Dang ky thanh cong -> Chuyen ve trang dang nhap kem thong bao
            resp.sendRedirect(req.getContextPath() + "/dang-nhap?msg=success");
        } else {
            req.setAttribute("error", "Dang ky that bai, vui long thu lai!");
            req.getRequestDispatcher("/login/register.jsp").forward(req, resp);
        }
    }
    
}