<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xử Lý Đơn Hàng - Green Mart</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --pine: #0f4a3c;
            --pine2: #176a55;
            --mint: #d8efe3;
            --amber: #e9892b;
            --paper: #f4f7f5;
        }
        body { font-family: 'Be Vietnam Pro', sans-serif; background-color: var(--paper); color: #16251e; }
        
        /* Header nhân viên */
        .staff-nav { background: var(--pine); }
        .staff-avatar {
            width: 38px; height: 38px;
            background: var(--amber); color: #fff;
            border-radius: 50%;
            display: grid; place-items: center;
            font-weight: 700;
        }

        /* Thẻ thống kê */
        .stat-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 4px 14px rgba(15,74,60,.06);
            transition: .25s;
        }
        .stat-card:hover { transform: translateY(-3px); }

        /* Khung đơn hàng */
        .order-card {
            border: 1px solid #dce5df;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,.03);
            overflow: hidden;
            transition: .2s;
        }
        .order-card:hover { border-color: var(--pine2); box-shadow: 0 6px 18px rgba(0,0,0,.06); }
        .order-header { background: #fbfdfc; border-bottom: 1px solid #edf2ee; }
        .table-items th { font-size: 0.8rem; text-transform: uppercase; letter-spacing: .5px; color: #62756b; }
        
        /* Pills Tab */
        .nav-pills .nav-link {
            border-radius: 50px;
            color: #55685e;
            font-weight: 600;
            padding: 7px 18px;
        }
        .nav-pills .nav-link.active {
            background-color: var(--pine);
            color: #fff;
        }
    </style>
</head>
<body>

<!-- Header nhân viên -->
<header class="staff-nav py-2 text-white sticky-top shadow-sm">
    <div class="container-fluid px-4 d-flex align-items-center justify-content-between">
        <div class="d-flex align-items-center gap-3">
            <span class="fs-4 fw-bold">🥬 Green <b class="text-warning">Mart</b></span>
            <span class="badge bg-white text-dark rounded-pill px-3 py-1 d-none d-md-inline-block">Bàn Làm Việc Nhân Viên</span>
        </div>

        <div class="d-flex align-items-center gap-3">
            <a href="${ctx}/trang-chu" class="btn btn-outline-light btn-sm rounded-pill px-3">
                <i class="bi bi-shop me-1"></i>Xem cửa hàng
            </a>
            <div class="d-flex align-items-center gap-2 border-start ps-3 border-secondary">
                <div class="text-end d-none d-sm-block lh-1">
                    <span class="fw-bold">${sessionScope.currentUser.fullname}</span>
                    <small class="d-block text-white-50" style="font-size: .75rem;">Nhân viên vận hành</small>
                </div>
                <div class="staff-avatar">
                    ${fn:toUpperCase(fn:substring(sessionScope.currentUser.fullname, 0, 1))}
                </div>
                <a href="${ctx}/dang-xuat" class="btn btn-sm btn-outline-warning rounded-pill ms-2" title="Đăng xuất">
                    <i class="bi bi-box-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>
</header>

<div class="container-fluid px-4 py-4">

    <!-- Flash message thông báo kết quả xử lý -->
    <c:if test="${not empty flashMsg}">
        <div class="alert ${flashOk ? 'alert-success' : 'alert-danger'} alert-dismissible fade show rounded-4 border-0 shadow-sm" role="alert">
            <i class="bi ${flashOk ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill'} me-2"></i>
            <c:out value="${flashMsg}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Thống kê ca làm việc & doanh số cá nhân -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="card stat-card h-100 p-3">
                <small class="text-muted fw-semibold">Đơn đang chờ xử lý</small>
                <div class="fs-2 fw-bold text-warning mt-1">${dem['cho']}</div>
                <span class="small text-muted">Cần xác nhận ngay</span>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card stat-card h-100 p-3">
                <small class="text-muted fw-semibold">Đơn bạn đã xử lý (${nam})</small>
                <div class="fs-2 fw-bold text-primary mt-1">${myTongDon}</div>
                <span class="small text-muted">Đơn hoàn tất</span>
            </div>
        </div>
        <div class="col-12 col-md-6">
            <div class="card stat-card h-100 p-3 text-white" style="background: linear-gradient(135deg, #0f4a3c, #176a55);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <small class="text-white-50 fw-semibold">Tổng sản phẩm bạn đã bán (${nam})</small>
                        <div class="display-6 fw-bold mt-1">
                            <fmt:formatNumber value="${myTongSp}" pattern="#,###"/> <span class="fs-5 fw-normal text-white-50">sản phẩm</span>
                        </div>
                        <span class="badge bg-warning text-dark mt-2">Đóng góp doanh số kho</span>
                    </div>
                    <i class="bi bi-trophy-fill text-warning" style="font-size: 3.5rem; opacity: .85;"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Hàng nội dung chính: Danh sách đơn hàng & Bảng xếp hạng thi đua -->
    <div class="row g-4">
        
        <!-- Cột trái: Quản lý danh sách đơn hàng -->
        <div class="col-xl-9">
            <!-- Tab lọc trạng thái đơn -->
            <ul class="nav nav-pills mb-3 gap-2 bg-white p-2 rounded-pill shadow-sm border" style="width: fit-content;">
                <li class="nav-item">
                    <a class="nav-link ${tab == 'cho' ? 'active' : ''}" href="?tab=cho">
                        <i class="bi bi-hourglass-split me-1"></i>Chờ xử lý 
                        <span class="badge bg-danger ms-1">${dem['cho']}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${tab == 'xuly' ? 'active' : ''}" href="?tab=xuly">
                        <i class="bi bi-check-circle me-1"></i>Đã xử lý 
                        <span class="badge bg-secondary ms-1">${dem['xuly']}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${tab == 'huy' ? 'active' : ''}" href="?tab=huy">
                        <i class="bi bi-x-circle me-1"></i>Đã hủy 
                        <span class="badge bg-secondary ms-1">${dem['huy']}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${tab == 'all' ? 'active' : ''}" href="?tab=all">Tất cả đơn</a>
                </li>
            </ul>

            <!-- Khi danh sách trống -->
            <c:if test="${empty listDonHang}">
                <div class="card border-0 shadow-sm rounded-4 p-5 text-center text-muted">
                    <i class="bi bi-inbox fs-1 mb-2"></i>
                    <h5>Không có đơn hàng nào trong mục này</h5>
                </div>
            </c:if>

            <!-- Vòng lặp từng đơn hàng -->
            <c:forEach var="dh" items="${listDonHang}">
                <div class="order-card mb-3">
                    <!-- Đầu thẻ đơn hàng -->
                    <div class="order-header p-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div class="d-flex align-items-center gap-2">
                            <span class="fs-5 fw-bold text-success">#<c:out value="${dh.maDon}"/></span>
                            <span class="text-muted small">
                                <i class="bi bi-calendar3 me-1"></i><fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${dh.trangThai == 'Chờ xử lý'}">
                                    <span class="badge rounded-pill bg-warning text-dark px-3 py-2"><i class="bi bi-clock me-1"></i>Chờ xử lý</span>
                                </c:when>
                                <c:when test="${dh.trangThai == 'Đã xử lý'}">
                                    <span class="badge rounded-pill bg-success px-3 py-2"><i class="bi bi-check2-all me-1"></i>Đã xử lý / Đang giao</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge rounded-pill bg-danger px-3 py-2"><i class="bi bi-x me-1"></i>Đã hủy</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Thân thẻ: Thông tin khách & Bảng chi tiết sản phẩm -->
                    <div class="p-3">
                        <div class="row g-3">
                            <!-- Cột thông tin khách hàng -->
                            <div class="col-lg-5 border-end-lg">
                                <div class="fw-bold fs-6"><i class="bi bi-person-fill text-success me-1"></i><c:out value="${dh.tenNguoiNhan}"/></div>
                                <div class="text-muted small mt-1"><i class="bi bi-telephone-fill me-1"></i><c:out value="${dh.sdt}"/></div>
                                <div class="text-muted small mt-1"><i class="bi bi-geo-alt-fill me-1"></i><c:out value="${dh.diaChi}"/></div>
                                
                                <c:if test="${not empty dh.ghiChu}">
                                    <div class="alert alert-light border small mt-2 py-1 px-2 mb-0">
                                        <i class="bi bi-chat-quote-fill me-1 text-warning"></i><c:out value="${dh.ghiChu}"/>
                                    </div>
                                </c:if>
                                
                                <div class="mt-2">
                                    <span class="badge bg-light text-dark border">
                                        <i class="bi bi-credit-card me-1"></i><c:out value="${dh.phuongThucTt}"/>
                                    </span>
                                </div>
                            </div>

                            <!-- Cột chi tiết bảng món -->
                            <div class="col-lg-7">
                                <table class="table table-sm align-middle mb-0 table-items">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th class="text-end">Đơn giá</th>
                                            <th class="text-center">SL</th>
                                            <th class="text-end">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="ct" items="${dh.chiTiet}">
                                            <tr>
                                                <td class="fw-semibold"><c:out value="${ct.tenSanPham}"/></td>
                                                <td class="text-end text-muted"><fmt:formatNumber value="${ct.donGia}" pattern="#,###"/>đ</td>
                                                <td class="text-center fw-bold">${ct.soLuong}</td>
                                                <!-- Nhân trực tiếp để tránh lỗi getter -->
                                                <td class="text-end fw-bold text-dark"><fmt:formatNumber value="${ct.donGia * ct.soLuong}" pattern="#,###"/>đ</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Chân thẻ: Tổng tiền & Nút thao tác -->
                    <div class="p-3 bg-light border-top d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div>
                            <span class="text-muted small">Tổng (${dh.tongSp} món):</span>
                            <strong class="text-danger fs-5 ms-1"><fmt:formatNumber value="${dh.tongTien}" pattern="#,###"/>đ</strong>
                            <c:if test="${not empty dh.tenNhanVien}">
                                <div class="small text-muted mt-1">
                                    <i class="bi bi-person-check-fill text-success me-1"></i>Xử lý bởi: <b><c:out value="${dh.tenNhanVien}"/></b>
                                    <c:if test="${not empty dh.ngayXuLy}"> lúc <fmt:formatDate value="${dh.ngayXuLy}" pattern="dd/MM/yyyy HH:mm"/></c:if>
                                </div>
                            </c:if>
                        </div>

                        <!-- Chỉ hiển thị nút Duyệt / Hủy với đơn Chờ xử lý -->
                        <c:if test="${dh.trangThai == 'Chờ xử lý'}">
                            <div class="d-flex gap-2">
                                <form action="${ctx}/nhan-vien/don-hang" method="post" onsubmit="return confirm('Bạn có chắc muốn hủy đơn #${dh.maDon}?');">
                                    <input type="hidden" name="action" value="huy">
                                    <input type="hidden" name="id" value="${dh.id}">
                                    <button class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                        <i class="bi bi-x-circle me-1"></i>Hủy đơn
                                    </button>
                                </form>
                                <form action="${ctx}/nhan-vien/don-hang" method="post" onsubmit="return confirm('Xác nhận nhận và xử lý đơn #${dh.maDon}? Kho sẽ tự trừ tồn kho và ghi nhận doanh số cho bạn.');">
                                    <input type="hidden" name="action" value="xuly">
                                    <input type="hidden" name="id" value="${dh.id}">
                                    <button class="btn btn-success btn-sm rounded-pill px-4 fw-bold">
                                        <i class="bi bi-check2-circle me-1"></i>Xử lý đơn
                                    </button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Cột phải: Bảng thành tích nhân viên -->
        <div class="col-xl-3">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-header bg-white py-3 border-bottom">
                    <h6 class="mb-0 fw-bold text-success">
                        <i class="bi bi-bar-chart-fill me-2"></i>Thành tích nhân viên ${nam}
                    </h6>
                </div>
                <ul class="list-group list-group-flush">
                    <c:forEach var="r" items="${bangXepHang}" varStatus="st">
                        <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge ${st.index == 0 ? 'bg-warning text-dark' : 'bg-light text-muted border'} rounded-circle p-2" style="width: 28px; height: 28px; display: grid; place-items: center;">
                                    ${st.index + 1}
                                </span>
                                <div>
                                    <div class="fw-semibold text-dark"><c:out value="${r[0]}"/></div>
                                    <small class="text-muted">${r[1]} đơn thành công</small>
                                </div>
                            </div>
                            <strong class="text-success fs-6">${r[2]} SP</strong>
                        </li>
                    </c:forEach>
                    <c:if test="${empty bangXepHang}">
                        <li class="list-group-item text-muted text-center py-4">Chưa có dữ liệu thành tích</li>
                    </c:if>
                </ul>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>