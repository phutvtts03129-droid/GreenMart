<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${sp.ten} - Nông Sản Xanh</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --g700: #2e7d32;
            --g500: #4caf50;
            --g100: #e8f5e9;
            --orange: #ff7a00;
            --text: #1f2d24;
        }
        body { font-family: 'Be Vietnam Pro', sans-serif; background: #fbfdf6; color: var(--text); }
        .product-img {
            width: 100%;
            height: 440px;
            object-fit: cover;
            border-radius: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .price-box {
            background: #f4faf0;
            border-radius: 16px;
            padding: 16px 20px;
        }
        .price-current {
            font-size: 2.2rem;
            font-weight: 800;
            color: #e53935;
        }
        .qty-btn {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            border: 1px solid #ced4da;
            background: #fff;
            font-weight: bold;
            font-size: 1.2rem;
        }
        .qty-input {
            width: 70px;
            height: 42px;
            text-align: center;
            border: 1px solid #ced4da;
            border-radius: 10px;
            font-weight: 700;
        }
        .btn-buy {
            background: linear-gradient(90deg, var(--g700), var(--g500));
            color: #fff;
            border-radius: 50px;
            font-weight: 700;
            padding: 14px 30px;
            border: none;
            transition: .3s;
        }
        .btn-buy:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(46,125,50,0.3);
            color: #fff;
        }
        .stars { color: #ffb300; }
        .tag-pill {
            background: var(--g100);
            color: var(--g700);
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.85rem;
        }
    </style>
</head>
<body>

<!-- Navbar rút gọn -->
<div class="container py-3 border-bottom">
    <div class="d-flex align-items-center justify-content-between">
        <a href="${ctx}/trang-chu" class="text-success text-decoration-none fw-bold fs-4">
            <i class="bi bi-flower3"></i> Nông Sản Xanh
        </a>
        <a href="${ctx}/trang-chu#san-pham" class="btn btn-outline-success rounded-pill btn-sm px-3">
            <i class="bi bi-arrow-left"></i> Về danh sách sản phẩm
        </a>
    </div>
</div>

<div class="container py-5">
    <div class="row g-5">
        <!-- Ảnh sản phẩm -->
        <div class="col-lg-6">
            <div class="position-relative">
                <img src="${sp.hinhAnh}" alt="${sp.ten}" class="product-img" 
                     onerror="this.src='https://placehold.co/500x500/e8f5e9/2e7d32?text=No+Image'">
                <c:if test="${sp.khuyenMai > 0}">
                    <span class="position-absolute top-0 start-0 m-3 badge bg-danger fs-6 px-3 py-2 rounded-pill">
                        Giảm ${sp.khuyenMai}%
                    </span>
                </c:if>
            </div>
        </div>

        <!-- Thông tin chi tiết & Đặt mua -->
        <div class="col-lg-6">
            <span class="tag-pill"><i class="bi bi-patch-check-fill"></i> Nông sản sạch VietGAP</span>
            <h1 class="fw-bold mt-2 mb-2">${sp.ten}</h1>

            <!-- Đánh giá sao -->
            <div class="d-flex align-items-center gap-2 mb-3">
                <div class="stars">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-half"></i>
                </div>
                <span class="fw-bold text-dark">4.8</span>
                <span class="text-muted small">| Đã bán: <b>${sp.daBan > 0 ? sp.daBan : 120}</b></span>
                <span class="text-muted small">| Xuất xứ: <b>${sp.xuatXu != null ? sp.xuatXu : 'Đà Lạt'}</b></span>
            </div>

            <!-- Khung giá & Thành tiền realtime -->
            <div class="price-box mb-4">
                <div class="text-muted small">Đơn giá niêm yết:</div>
                <div class="d-flex align-items-baseline gap-3">
                    <span class="price-current" id="unitPriceDisplay">
                        <fmt:formatNumber value="${sp.gia}" type="number" groupingUsed="true"/>₫
                    </span>
                    <span class="text-muted">/ 1 ${not empty sp.donViTinh ? sp.donViTinh : 'Kg'}</span>
                    
                    <c:if test="${sp.giaGoc != null && sp.giaGoc > sp.gia}">
                        <s class="text-muted fs-5"><fmt:formatNumber value="${sp.giaGoc}" type="number"/>₫</s>
                    </c:if>
                </div>
            </div>

            <p class="text-muted">${not empty sp.motaNgan ? sp.motaNgan : 'Sản phẩm được trồng theo quy trình hữu cơ, thu hoạch tươi mỗi ngày.'}</p>

            <form action="${ctx}/thanh-toan" method="GET" class="mt-4">
                <input type="hidden" name="id" value="${sp.id}">

                <!-- Bộ chọn số lượng / Kg -->
                <div class="mb-4">
                    <label class="form-label fw-bold">Chọn số lượng (${not empty sp.donViTinh ? sp.donViTinh : 'Kg'}):</label>
                    <div class="d-flex align-items-center gap-2">
                        <button type="button" class="qty-btn" onclick="changeQty(-1)">-</button>
                        <input type="number" id="soLuong" name="soLuong" class="qty-input" value="1" min="1" max="${sp.soLuong > 0 ? sp.soLuong : 99}" onchange="calculateTotal()" oninput="calculateTotal()">
                        <button type="button" class="qty-btn" onclick="changeQty(1)">+</button>
                        <span class="text-muted small ms-2">
                            (Còn <b>${sp.soLuong}</b> ${not empty sp.donViTinh ? sp.donViTinh : 'Kg'} trong kho)
                        </span>
                    </div>
                </div>

                <!-- Tổng tiền tạm tính -->
                <div class="d-flex align-items-center justify-content-between p-3 bg-light rounded-3 mb-4 border">
                    <span class="fw-semibold">Tổng tiền thanh toán:</span>
                    <span class="fs-4 fw-bold text-danger" id="totalPriceDisplay">
                        <fmt:formatNumber value="${sp.gia}" type="number" groupingUsed="true"/>₫
                    </span>
                </div>

                <!-- Nút bấm -->
                <div class="d-flex gap-3">
                    <button type="submit" class="btn btn-buy flex-grow-1 fs-5">
                        <i class="bi bi-credit-card me-2"></i> Mua ngay
                    </button>
                    <a href="${ctx}/trang-chu#san-pham" class="btn btn-outline-secondary rounded-pill px-4 d-flex align-items-center">
                        Tiếp tục xem
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Mô tả chi tiết -->
    <div class="mt-5 pt-4 border-top">
        <h4 class="fw-bold text-success mb-3"><i class="bi bi-card-text me-2"></i>Mô tả chi tiết sản phẩm</h4>
        <div class="p-4 bg-white rounded-4 border shadow-sm">
            <c:choose>
                <c:when test="${not empty sp.motaChiTiet}">
                    <p style="white-space: pre-line; line-height: 1.8;">${sp.motaChiTiet}</p>
                </c:when>
                <c:otherwise>
                    <p class="text-muted mb-0">Nông sản sạch thu hoạch trực tiếp tại vườn, đạt chuẩn an toàn thực phẩm VietGAP, không sử dụng hóa chất kích thích sinh trưởng và thuốc bảo vệ thực vật độc hại.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    // Đơn giá lấy từ server
    var unitPrice = ${sp.gia};
    var maxStock = ${sp.soLuong > 0 ? sp.soLuong : 999};

    function changeQty(delta) {
        var input = document.getElementById('soLuong');
        var cur = parseInt(input.value) || 1;
        var next = cur + delta;
        if (next >= 1 && next <= maxStock) {
            input.value = next;
            calculateTotal();
        }
    }

    function calculateTotal() {
        var input = document.getElementById('soLuong');
        var qty = parseInt(input.value) || 1;
        if (qty < 1) qty = 1;
        if (qty > maxStock) qty = maxStock;
        input.value = qty;

        var total = qty * unitPrice;
        // Format hiển thị tiền tệ VNĐ
        document.getElementById('totalPriceDisplay').innerText = total.toLocaleString('vi-VN') + '₫';
    }
</script>

</body>
</html>