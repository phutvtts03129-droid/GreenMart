<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khách Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="text-success fw-bold mb-0">
                <i class="bi bi-people me-2"></i>Quản Lý Khách Hàng (Customer)
            </h2>
            <small class="text-muted">Danh sách tài khoản người dùng mua hàng trên hệ thống Nông Sản Xanh</small>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/nhan-vien" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-person-badge me-1"></i>Trang Quản lý Nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/admin/san-pham" class="btn btn-outline-success btn-sm">
                <i class="bi bi-box-seam me-1"></i>Trang Quản lý Sản phẩm
            </a>
        </div>
    </div>

    <div class="row g-4">
        <!-- Form Thêm / Cập nhật Khách Hàng -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-person-gear me-1"></i>
                        <c:choose>
                            <c:when test="${not empty customerEdit}">Cập Nhật Khách Hàng #${customerEdit.id}</c:when>
                            <c:otherwise>Thêm Mới Khách Hàng</c:otherwise>
                        </c:choose>
                    </h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/khach-hang" method="post">
                        <input type="hidden" name="action" value="${not empty customerEdit ? 'update' : 'insert'}">
                        <c:if test="${not empty customerEdit}">
                            <input type="hidden" name="id" value="${customerEdit.id}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và tên (*)</label>
                            <input type="text" name="fullname" class="form-control" value="${customerEdit.fullname}" placeholder="Lê Văn B" required>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tài khoản (*)</label>
                                <input type="text" name="username" class="form-control" value="${customerEdit.username}" 
                                       ${not empty customerEdit ? 'readonly class="form-control bg-secondary-subtle"' : 'required'}>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email (*)</label>
                                <input type="email" name="email" class="form-control" value="${customerEdit.email}" 
                                       ${not empty customerEdit ? 'readonly class="form-control bg-secondary-subtle"' : 'required'}>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Mật khẩu <c:if test="${not empty customerEdit}"><small class="text-muted fw-normal">(để trống nếu giữ nguyên)</small></c:if>
                            </label>
                            <input type="password" name="password" class="form-control" ${empty customerEdit ? 'required' : ''}>
                        </div>

                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="status" id="custStatus"
                                    ${customerEdit == null || customerEdit.status ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold" for="custStatus">Tài khoản hoạt động</label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success flex-fill">
                                <i class="bi bi-save me-1"></i> ${not empty customerEdit ? 'Lưu thay đổi' : 'Thêm khách hàng'}
                            </button>
                            <c:if test="${not empty customerEdit}">
                                <a href="${pageContext.request.contextPath}/admin/khach-hang" class="btn btn-secondary">Hủy</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách Khách Hàng -->
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 fw-bold">Danh Sách Tài Khoản Khách Hàng</h5>
                    <span class="badge bg-success fs-6">${listCustomers.size()} người dùng</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã KH</th>
                                    <th>Họ tên & Username</th>
                                    <th>Email</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày đăng ký</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cust" items="${listCustomers}">
                                    <tr>
                                        <td><strong>#KH${cust.id}</strong></td>
                                        <td>
                                            <div class="fw-bold">${cust.fullname}</div>
                                            <small class="text-muted"><i class="bi bi-person me-1"></i>${cust.username}</small>
                                        </td>
                                        <td>${cust.email}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/khach-hang?action=toggleStatus&id=${cust.id}&status=${cust.status}" 
                                               class="text-decoration-none" title="Nhấp để khóa hoặc mở tài khoản">
                                                <c:choose>
                                                    <c:when test="${cust.status}">
                                                        <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary"><i class="bi bi-lock me-1"></i>Đã khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${cust.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/khach-hang?action=edit&id=${cust.id}"
                                               class="btn btn-sm btn-outline-primary me-1" title="Sửa thông tin">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/khach-hang?action=delete&id=${cust.id}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản khách hàng ${cust.fullname} không?');"
                                               title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>