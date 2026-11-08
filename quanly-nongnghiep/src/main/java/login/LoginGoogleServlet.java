package login;

import java.io.IOException;
import java.math.BigDecimal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login-google")
public class LoginGoogleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String code = request.getParameter("code");

        // Khi người dùng bấm Cancel trên màn hình Google
        if (code == null || code.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?error=cancel");
            return;
        }

        try {
            // Đổi mã code lấy token và thông tin tài khoản
            String accessToken = GoogleUtils.getToken(code);
            GooglePojo googlePojo = GoogleUtils.getUserInfo(accessToken);

            String email = googlePojo.getEmail();
            User user = userDAO.findByEmail(email);

            // Nếu là lần đầu đăng nhập, tự động tạo tài khoản mới
            if (user == null) {
                String username = email.split("@")[0];
                String fullname = googlePojo.getName() != null ? googlePojo.getName() : username;
                String randomPass = "GG_" + System.currentTimeMillis();

                user = new User(fullname, username, email, randomPass, "CUSTOMER", BigDecimal.ZERO);
                userDAO.register(user);

                // Lấy lại thông tin user từ database
                user = userDAO.findByEmail(email);
            }

            // Lưu vào session và về trang chủ
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            response.sendRedirect(request.getContextPath() + "/trang-chu");

        }  catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2 style='color:red;'>Chi tiết lỗi đăng nhập Google:</h2>");
            response.getWriter().println("<pre style='background:#f4f4f4; padding:15px; border:1px solid #ccc; font-size:14px;'>");
            e.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}