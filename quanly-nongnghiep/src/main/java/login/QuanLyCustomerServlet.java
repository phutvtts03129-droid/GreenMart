package login;


import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/khach-hang")
public class QuanLyCustomerServlet extends HttpServlet {
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
                deleteCustomer(request, response);
                break;
            case "toggleStatus":
                toggleStatus(request, response);
                break;
            default:
                listCustomers(request, response);
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
                updateCustomer(request, response);
                break;
            case "insert":
            default:
                insertCustomer(request, response);
                break;
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách tài khoản chỉ có role = 'CUSTOMER'
        List<User> list = userDAO.getCustomersOnly();
        request.setAttribute("listCustomers", list);
        request.getRequestDispatcher("/quanlyUser/quanly-customer.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(id);
            request.setAttribute("customerEdit", user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        listCustomers(request, response);
    }

    private void insertCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String fullname = request.getParameter("fullname");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (!userDAO.checkUserExists(username, email)) {
                // Khách hàng không có lương (gán 0) và cố định role là CUSTOMER
                User u = new User(fullname, username, email, password, "CUSTOMER", java.math.BigDecimal.ZERO);
                u.setStatus(request.getParameter("status") != null);
                userDAO.register(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/khach-hang");
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullname = request.getParameter("fullname");
            String password = request.getParameter("password");
            boolean status = request.getParameter("status") != null;

            User u = new User();
            u.setId(id);
            u.setFullname(fullname);
            u.setPassword(password);
            u.setRole("CUSTOMER");
            u.setSalary(java.math.BigDecimal.ZERO);
            u.setStatus(status);

            userDAO.updateUser(u);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/khach-hang");
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
        response.sendRedirect(request.getContextPath() + "/admin/khach-hang");
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/khach-hang");
    }
}