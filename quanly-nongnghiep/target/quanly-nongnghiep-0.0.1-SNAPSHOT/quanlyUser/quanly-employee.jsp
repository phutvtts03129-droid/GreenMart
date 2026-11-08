<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hệ Thống Quản Lý Nhân Sự (Employee)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="text-primary fw-bold mb-0">
                <i class="bi bi-person-badge-fill me-2"></i>Quản Lý Nhân Viên (Employee)
            </h2>
            <small class="text-muted">Chỉ hiển thị và quản lý các tài khoản có vai trò Nhân viên trong hệ thống</small>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/nguoi-dung" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-people me-1"></i>Xem tất cả tài khoản
            </a>
        </div>
    </div>

    <div class="row g-4">
        <!-- Form Thêm / Cập nhật Nhân viên -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-person-plus-fill me-1"></i>
                        <c:choose>
                            <c:when test="${not empty empEdit}">Cập Nhật Nhân Viên #${empEdit.id}</c:when>
                            <c:otherwise>Thêm Mới Nhân Viên</c:otherwise>
                        </c:choose>
                    </h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/nhan-vien" method="post">
                        <input type="hidden" name="action" value="${not empty empEdit ? 'update' : 'insert'}">
                        <c:if test="${not empty empEdit}">
                            <input type="hidden" name="id" value="${empEdit.id}">
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và tên (*)</label>
                            <input type="text" name="fullname" class="form-control" value="${empEdit.fullname}" placeholder="Nguyễn Văn A" required>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tài khoản (*)</label>
                                <input type="text" name="username" class="form-control" value="${empEdit.username}" 
                                       ${not empty empEdit ? 'readonly class="form-control bg-secondary-subtle"' : 'required'}>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email (*)</label>
                                <input type="email" name="email" class="form-control" value="${empEdit.email}" 
                                       ${not empty empEdit ? 'readonly class="form-control bg-secondary-subtle"' : 'required'}>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Mật khẩu <c:if test="${not empty empEdit}"><small class="text-muted fw-normal">(để trống nếu giữ nguyên)</small></c:if>
                            </label>
                            <input type="password" name="password" class="form-control" ${empty empEdit ? 'required' : ''}>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-success">Mức Lương Cơ Bản (VNĐ) (*)</label>
                            <input type="number" step="500000" name="salary" class="form-control border-success" 
                                   value="${empEdit != null ? empEdit.salary : '7000000'}" required>
                        </div>

                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="status" id="empStatus"
                                    ${empEdit == null || empEdit.status ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold" for="empStatus">Cho phép đăng nhập & làm việc</label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-fill">
                                <i class="bi bi-save me-1"></i> ${not empty empEdit ? 'Lưu thay đổi' : 'Tạo nhân viên'}
                            </button>
                            <c:if test="${not empty empEdit}">
                                <a href="${pageContext.request.contextPath}/admin/nhan-vien" class="btn btn-secondary">Hủy</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách Nhân viên -->
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 fw-bold">Danh Sách Đội Ngũ Nhân Sự</h5>
                    <span class="badge bg-primary fs-6">${listEmployees.size()} nhân viên</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã NV</th>
                                    <th>Họ tên & Tài khoản</th>
                                    <th>Email</th>
                                    <th>Lương tháng</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày vào làm</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="emp" items="${listEmployees}">
                                    <tr>
                                        <td><strong>#NV${emp.id}</strong></td>
                                        <td>
                                            <div class="fw-bold">${emp.fullname}</div>
                                            <small class="text-muted"><i class="bi bi-person me-1"></i>${emp.username}</small>
                                        </td>
                                        <td>${emp.email}</td>
                                        <td>
                                            <span class="text-success fw-bold">
                                                <fmt:formatNumber value="${emp.salary}" pattern="#,###"/> đ
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/nhan-vien?action=toggleStatus&id=${emp.id}&status=${emp.status}" 
                                               class="text-decoration-none">
                                                <c:choose>
                                                    <c:when test="${emp.status}">
                                                        <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Đang làm</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger"><i class="bi bi-slash-circle me-1"></i>Đã khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${emp.createdAt}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/nhan-vien?action=edit&id=${emp.id}"
                                               class="btn btn-sm btn-outline-primary me-1" title="Sửa thông tin">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/nhan-vien?action=delete&id=${emp.id}"
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa nhân viên ${emp.fullname} không?');"
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