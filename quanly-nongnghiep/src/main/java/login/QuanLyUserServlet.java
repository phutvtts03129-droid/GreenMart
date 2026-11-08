package login;


import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/nguoi-dung")
public class QuanLyUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

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
                deleteUser(request, response);
                break;
            case "toggleStatus":
                toggleStatus(request, response);
                break;
            default:
                listUsers(request, response);
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
                updateUser(request, response);
                break;
            case "insert":
            default:
                insertUser(request, response);
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> list = userDAO.getAllUsers();
        request.setAttribute("listUsers", list);
        request.getRequestDispatcher("/quanlyUser/quanly-user.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(id);
            request.setAttribute("userEdit", user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        listUsers(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String fullname = request.getParameter("fullname");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String salaryStr = request.getParameter("salary");
            BigDecimal salary = (salaryStr != null && !salaryStr.trim().isEmpty())
                                ? new BigDecimal(salaryStr) : BigDecimal.ZERO;

            if (!userDAO.checkUserExists(username, email)) {
                User u = new User(fullname, username, email, password, role, salary);
                u.setStatus(request.getParameter("status") != null);
                userDAO.register(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/nguoi-dung");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullname = request.getParameter("fullname");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String salaryStr = request.getParameter("salary");
            BigDecimal salary = (salaryStr != null && !salaryStr.trim().isEmpty())
                                ? new BigDecimal(salaryStr) : BigDecimal.ZERO;
            boolean status = request.getParameter("status") != null;

            User u = new User();
            u.setId(id);
            u.setFullname(fullname);
            u.setPassword(password);
            u.setRole(role);
            u.setSalary(salary);
            u.setStatus(status);

            userDAO.updateUser(u);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/nguoi-dung");
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean currentStatus = Boolean.parseBoolean(request.getParameter("status"));
            userDAO.toggleStatus(id, currentStatus);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/nguoi-dung");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/nguoi-dung");
    }
}