<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <h2 class="mb-4 text-success fw-bold"><i class="bi bi-box-seam me-2"></i>Quản Lý Sản Phẩm</h2>

    <div class="row g-4">
        <!-- Form Thêm / Cập nhật -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="card-title mb-0">
                        <i class="bi bi-pencil-square me-1"></i>
                        <c:choose>
                            <c:when test="${not empty spEdit}">Cập Nhật Sản Phẩm #${spEdit.id}</c:when>
                            <c:otherwise>Thêm Mới Sản Phẩm</c:otherwise>
                        </c:choose>
                    </h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/san-pham" method="post">
                        <input type="hidden" name="action" value="${not empty spEdit ? 'update' : 'insert'}">
                        <c:if test="${not empty spEdit}">
                            <input type="hidden" name="id" value="${spEdit.id}">
                        </c:if>

                        <div class="mb-2">
                            <label class="form-label fw-bold">Tên sản phẩm (*)</label>
                            <input type="text" name="ten" class="form-control" value="${spEdit.ten}" required>
                        </div>

                        <div class="row g-2 mb-2">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Giá bán (*)</label>
                                <input type="number" step="1000" name="gia" class="form-control" value="${spEdit.gia}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Giá gốc</label>
                                <input type="number" step="1000" name="giaGoc" class="form-control" value="${spEdit.giaGoc}">
                            </div>
                        </div>
<div class="row g-2 mb-2">
                            <div class="col-md-6">
                                <label class="form-label">Khuyến mãi (%)</label>
                                <input type="number" min="0" max="100" name="khuyenMai" class="form-control" placeholder="VD: 10" value="${spEdit != null ? spEdit.khuyenMai : 0}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Đã bán</label>
                                <input type="number" min="0" name="daBan" class="form-control" value="${spEdit != null ? spEdit.daBan : 0}">
                            </div>
                        </div>
                        <div class="row g-2 mb-2">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Số lượng (*)</label>
                                <input type="number" name="soLuong" class="form-control" value="${spEdit != null ? spEdit.soLuong : 10}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Đơn vị tính (*)</label>
                                <input type="text" name="donViTinh" class="form-control" placeholder="Kg, Hộp, Túi..." value="${spEdit.donViTinh}" required>
                            </div>
                        </div>

                        <div class="row g-2 mb-2">
                            <div class="col-md-6">
                                <label class="form-label">Danh mục ID</label>
                                <input type="number" name="danhMucId" class="form-control" value="${spEdit.danhMucId}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Xuất xứ</label>
                                <input type="text" name="xuatXu" class="form-control" value="${spEdit.xuatXu}">
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">URL Hình ảnh</label>
                            <input type="text" name="hinhAnh" class="form-control" value="${spEdit.hinhAnh}">
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Mô tả ngắn</label>
                            <textarea name="motaNgan" class="form-control" rows="2">${spEdit.motaNgan}</textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả chi tiết</label>
                            <textarea name="motaChiTiet" class="form-control" rows="3">${spEdit.motaChiTiet}</textarea>
                        </div>

                        <div class="mb-3 d-flex gap-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="trangThai" id="trangThai"
                                    ${spEdit == null || spEdit.trangThai ? 'checked' : ''}>
                                <label class="form-check-label" for="trangThai">Đang bán</label>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="noiBat" id="noiBat"
                                    ${spEdit.noiBat ? 'checked' : ''}>
                                <label class="form-check-label" for="noiBat">Nổi bật</label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success flex-fill">
                                <i class="bi bi-save me-1"></i> ${not empty spEdit ? 'Lưu thay đổi' : 'Thêm mới'}
                            </button>
                            <c:if test="${not empty spEdit}">
                                <a href="${pageContext.request.contextPath}/admin/san-pham" class="btn btn-secondary">Hủy</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách sản phẩm -->
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 fw-bold">Danh Sách Sản Phẩm</h5>
                    <span class="badge bg-primary fs-6">${listSanPham.size()} mặt hàng</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                         <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Giá bán</th>
                                    <th>KM (%)</th>
                                    <th>Kho / Đã bán</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${listSanPham}">
    <tr>
        <!-- 1. ID -->
        <td><strong>#${item.id}</strong></td>

        <!-- 2. Ảnh -->
        <td>
            <img src="${empty item.hinhAnh ? 'https://via.placeholder.com/60' : item.hinhAnh}"
                 alt="${item.ten}" class="rounded border" style="width: 50px; height: 50px; object-fit: cover;">
        </td>

        <!-- 3. Tên sản phẩm -->
        <td>
            <div class="fw-bold">${item.ten}</div>
            <small class="text-muted">${item.donViTinh} | ĐM: ${item.danhMucId}</small>
        </td>

        <!-- 4. Giá bán -->
        <td>
            <span class="text-danger fw-bold">
                <fmt:formatNumber value="${item.gia}" pattern="#,###"/> đ
            </span>
            <c:if test="${not empty item.giaGoc}">
                <br><small class="text-decoration-line-through text-muted">
                    <fmt:formatNumber value="${item.giaGoc}" pattern="#,###"/> đ
                </small>
            </c:if>
        </td>

        <!-- 5. KM (%) -->
        <td>
            <c:choose>
                <c:when test="${item.khuyenMai > 0}">
                    <span class="badge bg-danger">-${item.khuyenMai}%</span>
                </c:when>
                <c:otherwise>
                    <span class="text-muted">0%</span>
                </c:otherwise>
            </c:choose>
        </td>

        <!-- 6. Kho / Đã bán -->
        <td>
            <div>Kho: <strong>${item.soLuong}</strong></div>
            <small class="text-muted">Đã bán: ${item.daBan}</small>
        </td>

        <!-- 7. Trạng thái -->
        <td>
            <c:choose>
                <c:when test="${item.trangThai}">
                    <span class="badge bg-success">Đang bán</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-secondary">Tạm ẩn</span>
                </c:otherwise>
            </c:choose>
            <c:if test="${item.noiBat}">
                <span class="badge bg-warning text-dark">Hot</span>
            </c:if>
        </td>

        <!-- 8. Thao tác -->
        <td class="text-center">
            <a href="${pageContext.request.contextPath}/admin/san-pham?action=edit&id=${item.id}"
               class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                <i class="bi bi-pencil"></i>
            </a>
            <a href="${pageContext.request.contextPath}/admin/san-pham?action=delete&id=${item.id}"
               class="btn btn-sm btn-outline-danger"
               onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm #${item.id} không?');"
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