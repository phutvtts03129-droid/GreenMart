<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row g-4">
        <!-- Cột trái: Thông tin nhận hàng & Phương thức thanh toán -->
        <div class="col-md-7 col-lg-8">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <h4 class="mb-4 text-primary fw-bold">
                        <i class="bi bi-geo-alt-fill me-2"></i>Thông tin nhận hàng
                    </h4>

                    <!-- Thông báo đặt hàng thành công -->
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success border-0 shadow-sm p-4 mb-4 rounded-3 text-center">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 3.2rem;"></i>
                            <h4 class="alert-heading fw-bold mt-2">Đặt Hàng Thành Công!</h4>
                            <p class="mb-2"><c:out value="${successMsg}"/></p>
                            <p class="mb-3">Mã đơn hàng của bạn: <strong class="text-danger fs-5">#<c:out value="${maDon}"/></strong></p>
                            
                            <div class="d-flex justify-content-center gap-2 flex-wrap">
                                <a href="${pageContext.request.contextPath}/don-hang-cua-toi" class="btn btn-success rounded-pill px-4 py-2">
                                    <i class="bi bi-bag-check me-1"></i> Xem đơn hàng của tôi
                                </a>
                                <a href="${pageContext.request.contextPath}/trang-chu" class="btn btn-outline-secondary rounded-pill px-4 py-2">
                                    <i class="bi bi-house me-1"></i> Về trang chủ
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <!-- Thông báo lỗi -->
                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}
                        </div>
                    </c:if>

                    <!-- Maymaysa a pormulario ti panag-order -->
                    <c:if test="${empty isSuccess}">
                        <form action="${pageContext.request.contextPath}/thanh-toan" method="POST" id="formThanhToan">
                            <!-- Dữ liệu ẩn gửi sang Servlet -->
                            <input type="hidden" name="spId" value="${mon.spId}">
                            <input type="hidden" name="comboId" value="${mon.comboId}">
                            <input type="hidden" name="soLuong" value="${soLuong != null ? soLuong : 1}">

                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <label for="tenNhan" class="form-label fw-semibold">Họ và tên người nhận</label>
                                    <input type="text" class="form-control" id="tenNhan" name="tenNhan" 
                                           value="${sessionScope.currentUser != null ? sessionScope.currentUser.fullname : ''}" required>
                                </div>

                                <div class="col-sm-6">
                                    <label for="sdt" class="form-label fw-semibold">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="sdt" name="sdt" 
                                           value="" 
                                           pattern="[0-9]{10}" placeholder="Ví dụ: 0912345678" required>
                                </div>

                                <div class="col-12">
                                    <label for="diaChi" class="form-label fw-semibold">Địa chỉ giao hàng</label>
                                    <input type="text" class="form-control" id="diaChi" name="diaChi" 
                                           placeholder="Số nhà, tên đường, phường/xã, quận/huyện..." required>
                                </div>

                                <div class="col-12">
                                    <label for="ghiChu" class="form-label fw-semibold">Ghi chú đơn hàng (tuỳ chọn)</label>
                                    <textarea class="form-control" id="ghiChu" name="ghiChu" rows="2" 
                                              placeholder="Lời nhắn cho shipper hoặc dặn dò khi giao..."></textarea>
                                </div>
                            </div>

                            <hr class="my-4">

                            <h5 class="mb-3 text-primary fw-bold">
                                <i class="bi bi-credit-card-2-front-fill me-2"></i>Phương thức thanh toán
                            </h5>

                            <div class="my-3">
                                <div class="form-check mb-2">
                                    <input id="cod" name="phuongThuc" type="radio" class="form-check-input" value="COD" checked>
                                    <label class="form-check-label" for="cod">
                                        Thanh toán khi nhận hàng (COD)
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input id="banking" name="phuongThuc" type="radio" class="form-check-input" value="BANKING">
                                    <label class="form-check-label" for="banking">
                                        Chuyển khoản ngân hàng / Quét mã QR
                                    </label>
                                </div>
                            </div>

                            <button class="w-100 btn btn-success btn-lg mt-3 fw-bold shadow-sm" type="submit">
                                <i class="bi bi-check-circle me-1"></i> Đặt hàng ngay
                            </button>
                        </form>
                    </c:if>

                </div>
            </div>
        </div>

        <!-- Cột phải: Tóm tắt đơn hàng -->
        <div class="col-md-5 col-lg-4">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-4">
                    <h4 class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-primary fw-bold">Đơn hàng</span>
                        <span class="badge bg-primary rounded-pill">1 món</span>
                    </h4>

                    <div class="d-flex align-items-center py-3 border-bottom">
                        <c:choose>
                            <c:when test="${not empty mon.hinh}">
                                <img src="${mon.hinh}" alt="${mon.ten}" class="rounded me-3 object-fit-cover" 
                                     style="width: 64px; height: 64px;">
                            </c:when>
                            <c:otherwise>
                                <div class="bg-secondary bg-opacity-25 rounded d-flex align-items-center justify-content-center me-3" 
                                     style="width: 64px; height: 64px; font-size: 1.5rem;">
                                    ${not empty mon.emoji ? mon.emoji : '📦'}
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="flex-grow-1">
                            <h6 class="my-0 text-dark fw-bold">${mon.ten}</h6>
                            <small class="text-muted">
                                Số lượng: ${soLuong != null ? soLuong : 1} 
                                <c:if test="${not empty mon.donVi}"> (${mon.donVi})</c:if>
                            </small>
                            <div class="text-muted small">
                                Đơn giá: <fmt:formatNumber value="${mon.gia}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </div>

                    <ul class="list-group list-group-flush my-3">
                        <li class="list-group-item d-flex justify-content-between px-0 bg-transparent">
                            <span class="text-muted">Tạm tính</span>
                            <span>
                                <fmt:formatNumber value="${mon.gia * (soLuong != null ? soLuong : 1)}" 
                                                  type="currency" currencyCode="VND" maxFractionDigits="0"/>
                            </span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between px-0 bg-transparent">
                            <span class="text-muted">Phí vận chuyển</span>
                            <span class="text-success fw-semibold">Miễn phí</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between px-0 bg-transparent border-top pt-3">
                            <strong class="fs-5">Tổng tiền</strong>
                            <strong class="fs-5 text-danger">
                                <fmt:formatNumber value="${mon.gia * (soLuong != null ? soLuong : 1)}" 
                                                  type="currency" currencyCode="VND" maxFractionDigits="0"/>
                            </strong>
                        </li>
                    </ul>

                    <div class="alert alert-secondary py-2 px-3 small mb-0 rounded-2" role="alert">
                        <i class="bi bi-info-circle me-1"></i> Kho hiện có: 
                        <strong>${mon.tonKho != Integer.MAX_VALUE ? mon.tonKho : 'Sẵn hàng'}</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>