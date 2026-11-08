package login;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

@WebFilter(urlPatterns = {"/admin", "/admin/*", "/nhan-vien", "/nhan-vien/*"})
public class RoleFilter implements Filter {

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}

    @Override
    public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) rq;
        HttpServletResponse res = (HttpServletResponse) rs;

        HttpSession s = req.getSession(false);
        User u = (s == null) ? null : (User) s.getAttribute("currentUser");
        if (u == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (u.getRole() == null) ? "CUSTOMER" : u.getRole().trim().toUpperCase();
        boolean ok = req.getServletPath().startsWith("/admin")
                ? role.equals("ADMIN")
                : (role.equals("ADMIN") || role.equals("EMPLOYEE"));

        if (!ok) {
            // Không đủ quyền -> đưa về trang người dùng
            res.sendRedirect(req.getContextPath() + "/trang-chu");
            return;
        }
        chain.doFilter(rq, rs);
    }
}