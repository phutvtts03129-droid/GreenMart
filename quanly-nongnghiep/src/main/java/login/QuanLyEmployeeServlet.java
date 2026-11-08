package login;


import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/nhan-vien")
public class QuanLyEmployeeServlet extends HttpServlet {
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
                deleteEmployee(request, response);
                break;
            case "toggleStatus":
                toggleStatus(request, response);
                break;
            default:
                listEmployees(request, response);
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
                updateEmployee(request, response);
                break;
            case "insert":
            default:
                insertEmployee(request, response);
                break;
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ lấy những tài khoản có role là EMPLOYEE
        List<User> list = userDAO.getEmployeesOnly();
        request.setAttribute("listEmployees", list);
        request.getRequestDispatcher("/quanlyUser/quanly-employee.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(id);
            request.setAttribute("empEdit", user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        listEmployees(request, response);
    }

    private void insertEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String fullname = request.getParameter("fullname");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            String salaryStr = request.getParameter("salary");
            BigDecimal salary = (salaryStr != null && !salaryStr.trim().isEmpty())
                                ? new BigDecimal(salaryStr.trim()) : BigDecimal.ZERO;

            if (!userDAO.checkUserExists(username, email)) {
                // Ép cứng role là EMPLOYEE khi tạo ở trang này
                User u = new User(fullname, username, email, password, "EMPLOYEE", salary);
                u.setStatus(request.getParameter("status") != null);
                userDAO.register(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/nhan-vien");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullname = request.getParameter("fullname");
            String password = request.getParameter("password");
            String salaryStr = request.getParameter("salary");
            BigDecimal salary = (salaryStr != null && !salaryStr.trim().isEmpty())
                                ? new BigDecimal(salaryStr.trim()) : BigDecimal.ZERO;
            boolean status = request.getParameter("status") != null;

            User u = new User();
            u.setId(id);
            u.setFullname(fullname);
            u.setPassword(password);
            u.setRole("EMPLOYEE");
            u.setSalary(salary);
            u.setStatus(status);

            userDAO.updateUser(u);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/nhan-vien");
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
        response.sendRedirect(request.getContextPath() + "/admin/nhan-vien");
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/nhan-vien");
    }
}