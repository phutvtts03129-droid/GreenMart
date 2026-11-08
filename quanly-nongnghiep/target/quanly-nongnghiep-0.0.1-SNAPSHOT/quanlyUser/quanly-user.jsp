<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tài Khoản & Phân Quyền</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <h2 class="mb-4 text-primary fw-bold"><i class="bi bi-people-fill me-2"></i>Quản Lý Tài Khoản & Phân Quyền</h2>

    <div class="row g-4">
        <!-- Form Thêm / Cập nhật -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-person-gear me-1"></i>
                        <c:choose>
                            <c:when test="${not empty userEdit}">Cập Nhật Tài Khoản #${userEdit.id}</c:when>
                            <c:otherwise>Thêm Mới Tài Khoản</c:otherwise>
                        </c:choose>
                    </h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/nguoi-dung" method="post">
                        <input type="hidden" name="action" value="${not empty userEdit ? 'update' : 'insert'}">
                        <c:if test="${not empty userEdit}">
                            <input type="hidden" name="id" value="${userEdit.id}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và tên (*)</label>
                            <input type="text" name="fullname" class="form-control" value="${userEdit.fullname}" required>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tên đăng nhập (*)</label>
                                <input type="text" name="username" class="form-control" value="${userEdit.username}" 
                                       ${not empty userEdit ? 'readonly class="form-control bg-secondary-subtle"' : 'required'}>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email (*)</label>
                                <input type="email" name="email" class="form-control" value="${userEdit.email}" 
                                       ${not empty userEdit ? 'readonly class="form-control bg-secondary-subtle"' : 'required'}>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Mật khẩu <c:if test="${not empty userEdit}"><small class="text-muted fw-normal">(để trống nếu không đổi)</small></c:if>
                            </label>
                            <input type="password" name="password" class="form-control" ${empty userEdit ? 'required' : ''}>
                        </div>

                        <div class="row g-2 mb-3">
                            <!-- Dropdown Phân Quyền -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold text-danger">Vai trò (Role) (*)</label>
                                <select name="role" class="form-select border-primary" required>
                                    <option value="CUSTOMER" ${userEdit.role == 'CUSTOMER' ? 'selected' : ''}>Khách hàng (CUSTOMER)</option>
                                    <option value="EMPLOYEE" ${userEdit.role == 'EMPLOYEE' ? 'selected' : ''}>Nhân viên (EMPLOYEE)</option>
                                    <option value="ADMIN" ${userEdit.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên (ADMIN)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Lương (VNĐ)</label>
                                <input type="number" step="500000" name="salary" class="form-control" value="${userEdit != null ? userEdit.salary : '0'}">
                            </div>
                        </div>

                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="status" id="userStatus"
                                    ${userEdit == null || userEdit.status ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold" for="userStatus">Kích hoạt tài khoản</label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-fill">
                                <i class="bi bi-save me-1"></i> ${not empty userEdit ? 'Lưu thay đổi' : 'Tạo tài khoản'}
                            </button>
                            <c:if test="${not empty userEdit}">
                                <a href="${pageContext.request.contextPath}/admin/nguoi-dung" class="btn btn-secondary">Hủy</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách tài khoản -->
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 fw-bold">Danh Sách Người Dùng</h5>
                    <span class="badge bg-primary fs-6">${listUsers.size()} tài khoản</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên & Tài khoản</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Lương</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${listUsers}">
                                    <tr>
                                        <td><strong>#${u.id}</strong></td>
                                        <td>
                                            <div class="fw-bold">${u.fullname}</div>
                                            <small class="text-muted"><i class="bi bi-person me-1"></i>${u.username}</small>
                                        </td>
                                        <td>${u.email}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role == 'ADMIN'}">
                                                    <span class="badge bg-danger"><i class="bi bi-shield-lock me-1"></i>ADMIN</span>
                                                </c:when>
                                                <c:when test="${u.role == 'EMPLOYEE'}">
                                                    <span class="badge bg-info text-dark"><i class="bi bi-briefcase me-1"></i>EMPLOYEE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-light text-secondary border"><i class="bi bi-person me-1"></i>CUSTOMER</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.salary != null && u.salary > 0}">
                                                    <fmt:formatNumber value="${u.salary}" pattern="#,###"/> đ
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/nguoi-dung?action=toggleStatus&id=${u.id}&status=${u.status}" 
                                               class="text-decoration-none" title="Nhấp để đổi trạng thái">
                                                <c:choose>
                                                    <c:when test="${u.status}">
                                                        <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary"><i class="bi bi-lock me-1"></i>Đã khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/nguoi-dung?action=edit&id=${u.id}"
                                               class="btn btn-sm btn-outline-primary me-1" title="Sửa & Cấp quyền">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/nguoi-dung?action=delete&id=${u.id}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản ${u.username} không?');"
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