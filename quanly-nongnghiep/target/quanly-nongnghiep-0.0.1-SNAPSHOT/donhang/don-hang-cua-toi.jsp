<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - Nông Sản Xanh</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --g700: #2e7d32;
            --g500: #4caf50;
            --g100: #e8f5e9;
            --orange: #ff7a00;
        }
        body { font-family: 'Be Vietnam Pro', sans-serif; background: #fbfdf6; color: #1f2d24; }
        .order-card {
            background: #fff;
            border-radius: 20px;
            border: 1px solid #e0ecdc;
            box-shadow: 0 4px 16px rgba(20,83,45,.06);
            transition: .25s;
        }
        .order-card:hover { box-shadow: 0 8px 24px rgba(20,83,45,.12); }
        .tag-status {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .status-cho { background: #fdecd6; color: #b45b08; }
        .status-xuly { background: #d8efe3; color: #0f4a3c; }
        .status-huy { background: #fbe1de; color: #c8453a; }
        .item-row { border-bottom: 1px dashed #e5ede7; padding: 12px 0; }
        .item-row:last-child { border-bottom: 0; }
    </style>
</head>
<body>

<!-- Header đơn giản -->
<div class="container py-3 border-bottom bg-white">
    <div class="d-flex align-items-center justify-content-between">
        <a href="${ctx}/trang-chu" class="text-success text-decoration-none fw-bold fs-4">
            <i class="bi bi-flower3"></i> Nông Sản Xanh
        </a>
        <div class="d-flex align-items-center gap-3">
            <span class="text-muted small">Xin chào, <b>${sessionScope.currentUser.fullname}</b></span>
            <a href="${ctx}/trang-chu" class="btn btn-outline-success rounded-pill btn-sm px-3">
                <i class="bi bi-house"></i> Về trang chủ
            </a>
        </div>
    </div>
</div>

<div class="container py-5" style="max-width: 960px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-bag-check-fill text-success me-2"></i>Đơn hàng của tôi</h2>
            <p class="text-muted small mb-0">Theo dõi tiến trình các đơn hàng bạn đã đặt mua</p>
        </div>
        <a href="${ctx}/trang-chu#san-pham" class="btn btn-success rounded-pill px-4 fw-semibold">
            <i class="bi bi-plus-lg me-1"></i> Mua thêm món khác
        </a>
    </div>

    <!-- Thông báo nếu chưa có đơn -->
    <c:if test="${empty listDonHang}">
        <div class="text-center py-5 bg-white rounded-4 border">
            <i class="bi bi-basket2 text-muted" style="font-size: 4rem;"></i>
            <h5 class="mt-3 fw-bold">Bạn chưa có đơn hàng nào</h5>
            <p class="text-muted small">Hãy dạo quanh cửa hàng và chọn những nông sản tươi ngon nhất nhé!</p>
            <a href="${ctx}/trang-chu#san-pham" class="btn btn-success rounded-pill px-4 mt-2">Khám phá ngay</a>
        </div>
    </c:if>

    <!-- Danh sách đơn hàng -->
    <c:forEach var="dh" items="${listDonHang}">
        <div class="order-card p-4 mb-4">
            <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3 flex-wrap gap-2">
                <div>
                    <span class="fw-bold fs-5 text-success me-2">${dh.maDon}</span>
                    <span class="text-muted small">
                        <i class="bi bi-clock me-1"></i><fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>
                    </span>
                    <div class="small text-muted mt-1">
                        <i class="bi bi-geo-alt me-1"></i>Người nhận: <b>${dh.tenNguoiNhan}</b> (${dh.sdt}) - ${dh.diaChi}
                    </div>
                </div>

                <div>
                    <c:choose>
                        <c:when test="${dh.trangThai eq 'Chờ xử lý'}">
                            <span class="tag-status status-cho"><i class="bi bi-hourglass-split"></i> Chờ xử lý</span>
                        </c:when>
                        <c:when test="${dh.trangThai eq 'Đã xử lý'}">
                            <span class="tag-status status-xuly"><i class="bi bi-check-circle-fill"></i> Đã xử lý / Đang giao</span>
                        </c:when>
                        <c:otherwise>
                            <span class="tag-status status-huy"><i class="bi bi-x-circle-fill"></i> Đã hủy</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Danh sách món trong đơn -->
            <div class="mb-3">
                <c:forEach var="ct" items="${dh.chiTiet}">
                    <div class="item-row d-flex justify-content-between align-items-center">
                        <div>
                            <span class="fw-semibold text-dark">${ct.tenSanPham}</span>
                            <span class="text-muted small ms-2">x ${ct.soLuong}</span>
                        </div>
                        <span class="fw-bold text-dark">
                            <fmt:formatNumber value="${ct.donGia * ct.soLuong}" type="number" groupingUsed="true"/>₫
                        </span>
                    </div>
                </c:forEach>
            </div>

            <!-- Tổng kết đơn -->
            <div class="d-flex justify-content-between align-items-center pt-3 border-top flex-wrap gap-2">
                <span class="small text-muted">
                    Phương thức: <b>${dh.phuongThucTt}</b>
                    <c:if test="${not empty dh.ghiChu}"> | Ghi chú: <i>${dh.ghiChu}</i></c:if>
                </span>
                <div>
                    <span class="text-muted small me-2">Tổng thanh toán:</span>
                    <span class="fs-4 fw-bold text-danger">
                        <fmt:formatNumber value="${dh.tongTien}" type="number" groupingUsed="true"/>₫
                    </span>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

</body>
</html>