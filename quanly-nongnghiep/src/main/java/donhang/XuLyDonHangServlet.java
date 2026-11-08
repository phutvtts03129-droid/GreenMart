package donhang;


import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import login.User;

@WebServlet("/nhan-vien/don-hang")
public class XuLyDonHangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // !!! Đổi cho khớp tên attribute mà servlet đăng nhập của bạn đang lưu vào session
 // Đổi "user" thành "currentUser" cho đồng bộ với AuthServlet
    private static final String SESSION_USER = "currentUser";

    private final DonHangDAO donHangDAO = new DonHangDAO();

    /** Chỉ cho EMPLOYEE hoặc ADMIN vào. Trả về null (và redirect) nếu không hợp lệ. */
    private User currentStaff(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Object o = session == null ? null : session.getAttribute(SESSION_USER);
        if (o instanceof User) {
            User u = (User) o;
            String role = u.getRole() == null ? "" : u.getRole().trim();
            if ("EMPLOYEE".equalsIgnoreCase(role) || "ADMIN".equalsIgnoreCase(role)) {
                return u;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/dang-nhap");
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User staff = currentStaff(request, response);
        if (staff == null) return;

        String tab = request.getParameter("tab");
        String trangThai;
        if ("xuly".equals(tab))      trangThai = DonHang.DA_XU_LY;
        else if ("huy".equals(tab))  trangThai = DonHang.DA_HUY;
        else if ("all".equals(tab))  trangThai = null;
        else { tab = "cho";          trangThai = DonHang.CHO_XU_LY; }

        int nam = LocalDate.now().getYear();
        List<DonHang> list = donHangDAO.getDonHang(trangThai);
        Map<String, Integer> dem = donHangDAO.demTheoTrangThai();
        int[] tk = donHangDAO.thongKeNhanVien(staff.getId(), nam);

        request.setAttribute("listDonHang", list);
        request.setAttribute("tab", tab);
        request.setAttribute("dem", dem);
        request.setAttribute("nam", nam);
        request.setAttribute("myTongDon", tk[0]);
        request.setAttribute("myTongSp", tk[1]);
        request.setAttribute("bangXepHang", donHangDAO.bangXepHang(nam));

        // Thông báo 1 lần (flash) sau khi xử lý
        HttpSession session = request.getSession();
        request.setAttribute("flashMsg", session.getAttribute("flashMsg"));
        request.setAttribute("flashOk", session.getAttribute("flashOk"));
        session.removeAttribute("flashMsg");
        session.removeAttribute("flashOk");

        request.getRequestDispatcher("/donhang/xuly-donhang.jsp").forward(request, response);
    }

    /** Thao tác thay đổi dữ liệu chỉ nhận POST (tránh bị kích hoạt bằng link / prefetch). */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User staff = currentStaff(request, response);
        if (staff == null) return;

        String action = request.getParameter("action");
        String msg;
        boolean ok = false;

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if ("xuly".equals(action)) {
                String err = donHangDAO.xuLyDonHang(id, staff.getId());
                ok = (err == null);
                msg = ok ? "Đã xử lý đơn hàng thành công. Doanh số đã được ghi cho bạn." : err;
            } else if ("huy".equals(action)) {
                ok = donHangDAO.huyDonHang(id, staff.getId());
                msg = ok ? "Đã hủy đơn hàng." : "Không thể hủy: đơn không còn ở trạng thái chờ xử lý.";
            } else {
                msg = "Thao tác không hợp lệ.";
            }
        } catch (NumberFormatException e) {
            msg = "Mã đơn hàng không hợp lệ.";
        }

        HttpSession session = request.getSession();
        session.setAttribute("flashMsg", msg);
        session.setAttribute("flashOk", ok);
        response.sendRedirect(request.getContextPath() + "/nhan-vien/don-hang?tab=cho");
    }
    
}