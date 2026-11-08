<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>
<c:set var="me" value="${not empty sessionScope.currentUser ? sessionScope.currentUser : sessionScope.user}"/>
<%-- Chưa đăng nhập -> về trang login; không phải ADMIN -> về trang chủ --%>
<c:if test="${empty me}"><c:redirect url="/login"/></c:if>
<c:if test="${fn:toUpperCase(empty me.role ? 'CUSTOMER' : me.role) ne 'ADMIN'}"><c:redirect url="/"/></c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bảng điều khiển - Green Mart</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
:root{
  --bg:#e8ebe6; --card:#ffffff; --ink:#141a14; --mute:#7b857c; --line:#e3e7e1;
  --green:#2e7d32; --green-soft:#dcefdc; --leaf:#8bc34a;
  --carrot:#f2b878; --carrot-soft:#fbe7cf; --warn:#fff1c9; --warn-ink:#8a6200;
  --side:248px;
}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Be Vietnam Pro',Arial,sans-serif;background:var(--bg);color:var(--ink);font-size:14px;min-height:100vh}
a{color:inherit;text-decoration:none}
button{font:inherit;cursor:pointer}
:focus-visible{outline:2px solid var(--green);outline-offset:2px}

/* ===== SIDEBAR TRÁI ===== */
.side{position:fixed;left:0;top:0;bottom:0;width:var(--side);background:var(--card);padding:22px 16px;display:flex;flex-direction:column;z-index:50;border-right:1px solid var(--line);transition:transform .3s}
.brand{display:flex;align-items:center;gap:10px;font-weight:800;font-size:18px;padding:0 8px 22px}
.brand .lg{width:38px;height:38px;border-radius:12px;background:var(--ink);color:#fff;display:grid;place-items:center;font-size:18px}
.brand b{color:var(--green)}
.nav-t{font-size:12px;color:var(--mute);padding:8px 12px 6px;font-weight:600}
.nav a{display:flex;align-items:center;gap:12px;padding:11px 14px;border-radius:50px;font-weight:600;color:#4a554b;margin-bottom:4px;transition:background .2s,color .2s}
.nav a i{font-size:17px}
.nav a:hover{background:#f1f4ef;color:var(--ink)}
.nav a.on{background:var(--ink);color:#fff}
.nav .cnt{margin-left:auto;font-size:11px;font-weight:700;background:var(--carrot);color:var(--ink);padding:2px 8px;border-radius:50px}
.side .grow{flex:1}
.me{display:flex;align-items:center;gap:10px;padding:10px;border-radius:18px;background:#f4f6f2}
.me .av{width:38px;height:38px;border-radius:50%;background:var(--green);color:#fff;display:grid;place-items:center;font-weight:800;flex:none}
.me .t{min-width:0;line-height:1.25}
.me .t b{display:block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.me .t small{color:var(--mute);font-size:11px}
.me a{margin-left:auto;color:#c62828;font-size:18px}

/* ===== KHUNG CHÍNH ===== */
.main{margin-left:var(--side);padding:22px 26px 40px}
.top{display:flex;align-items:center;gap:14px;margin-bottom:22px}
.top h1{font-size:22px;font-weight:800}
.top p{color:var(--mute);font-size:13px;margin-top:2px}
.top .sp{flex:1}
.ibtn{width:42px;height:42px;border-radius:50%;border:0;background:var(--card);display:grid;place-items:center;font-size:17px;position:relative}
.ibtn .dot{position:absolute;top:10px;right:11px;width:8px;height:8px;border-radius:50%;background:#e53935;border:2px solid #fff}
.menu-btn{display:none}
.search{display:flex;align-items:center;gap:8px;background:var(--card);border-radius:50px;padding:0 16px;height:42px;width:250px}
.search input{border:0;outline:0;background:none;font:inherit;width:100%}

.card{background:var(--card);border-radius:24px;padding:20px 22px}
.card h3{font-size:15px;font-weight:700}
.card .hd{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px}
.go{width:30px;height:30px;border-radius:50%;border:0;background:#f1f4ef;display:grid;place-items:center}

/* ===== HÀNG ĐẦU: số liệu + ảnh ===== */
.r1{display:grid;grid-template-columns:1.35fr 1fr;gap:18px;margin-bottom:18px;align-items:stretch}
.kp{display:grid;grid-template-columns:1fr 1fr;gap:20px 30px;align-content:center;padding:6px 6px}
.kp small{color:var(--mute);font-size:13px}
.kp .v{font-size:26px;font-weight:700;margin-top:4px}
.kp .v em{font-style:normal;color:var(--mute);font-weight:500;margin-right:4px}
.bars{grid-column:1/-1;display:flex;height:13px;border-radius:50px;overflow:hidden;background:repeating-linear-gradient(45deg,#dfe3dc 0 6px,#e8ebe6 6px 12px)}
.bars i{display:block;height:100%}
.bars .a{background:var(--ink);width:52%}
.bars .b{background:var(--carrot);width:24%}
.hero{border-radius:24px;overflow:hidden;position:relative;min-height:190px;background:linear-gradient(135deg,#9ccc65,#2e7d32)}
.hero img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}
.hero .tag{position:absolute;left:14px;bottom:14px;background:rgba(255,255,255,.92);border-radius:50px;padding:7px 14px;font-weight:700;font-size:12.5px;display:flex;gap:6px;align-items:center}

/* ===== HÀNG 2 ===== */
.r2{display:grid;grid-template-columns:230px 1fr 1.7fr;gap:18px;margin-bottom:18px}
.stk{display:flex;flex-direction:column;gap:18px}
.big{font-size:27px;font-weight:700;margin:14px 0 2px}
.big em{font-style:normal;color:var(--mute);font-weight:500;margin-right:4px}
.mute{color:var(--mute);font-size:12.5px}
.bc{height:34px;margin-top:8px;background:repeating-linear-gradient(90deg,#b8bfb5 0 2px,transparent 2px 5px,#b8bfb5 5px 8px,transparent 8px 9px);opacity:.55;width:60%;margin-left:auto;border-radius:3px}
.sel{border:1px solid var(--line);background:#fff;border-radius:50px;padding:5px 12px;font-size:12.5px;display:flex;gap:6px;align-items:center}
.hb{margin-top:6px}
.hb .row{display:grid;grid-template-columns:62px 1fr;align-items:center;gap:10px;margin-bottom:11px;font-size:11.5px;color:var(--mute)}
.hb .tr{height:22px;border-radius:50px;background:#f1f4ef;position:relative}
.hb .fl{height:100%;border-radius:50px;background:var(--ink);color:#fff;font-size:10.5px;font-weight:700;display:flex;align-items:center;justify-content:flex-end;padding:0 9px;min-width:46px}
.hb .fl.o{background:var(--carrot);color:var(--ink)}

/* ===== SẢN PHẨM NỔI BẬT ===== */
.pg{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.pc{border-radius:20px;border:1px solid var(--line);overflow:hidden;background:#fff}
.pc .im{height:150px;position:relative;background:var(--green-soft);display:grid;place-items:center;font-size:56px}
.pc .im img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}
.pc .im .hh,.pc .im .ar{position:absolute;top:10px;width:30px;height:30px;border-radius:50%;display:grid;place-items:center;font-size:13px}
.pc .im .hh{right:46px;background:#fff}
.pc .im .ar{right:10px;background:var(--ink);color:#fff}
.pc .bd{padding:11px 12px 12px}
.pc .nm{display:flex;justify-content:space-between;gap:6px;font-weight:700;font-size:13px}
.pc .nm span{white-space:nowrap}
.pc .sb{font-size:11.5px;color:var(--mute);margin:3px 0 8px}
.pc .mt{display:flex;gap:10px;font-size:11px;color:var(--mute)}
.pc .mt i{margin-right:3px}

/* ===== BẢNG + VÙNG TRỒNG ===== */
.r3{display:grid;grid-template-columns:1.9fr 1fr;gap:18px}
.flt{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:12px;align-items:center}
.flt .sel{padding:8px 14px}
.flt .sp{flex:1}
.tw{overflow-x:auto}
table{width:100%;border-collapse:collapse;min-width:560px}
th{font-size:12px;color:var(--mute);font-weight:600;text-align:left;padding:8px 10px}
td{padding:11px 10px;border-top:1px solid var(--line);font-size:13px;vertical-align:middle}
.pn{display:flex;align-items:center;gap:12px}
.pn .th{width:44px;height:44px;border-radius:12px;background:var(--green-soft);display:grid;place-items:center;font-size:22px;overflow:hidden;position:relative;flex:none}
.pn .th img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}
.pn b{display:block;font-size:13px}.pn small{color:var(--mute);font-size:11.5px}
.pill{display:inline-block;padding:5px 14px;border-radius:50px;font-size:12px;font-weight:600}
.pill.ok{background:#d9f2d4;color:#1e6b25}
.pill.low{background:var(--warn);color:var(--warn-ink)}
.pill.out{background:#fde0de;color:#b3261e}
.act{border:0;background:#f1f4ef;width:32px;height:32px;border-radius:50%}
.act:hover{background:var(--ink);color:#fff}

.map{position:relative;height:100%;min-height:250px;border-radius:18px;overflow:hidden;
  background:
   radial-gradient(circle at 70% 70%,rgba(242,184,120,.9) 0 46px,rgba(242,184,120,.35) 47px 78px,transparent 79px),
   radial-gradient(circle at 25% 30%,rgba(139,195,74,.55) 0 30px,transparent 31px),
   repeating-linear-gradient(0deg,transparent 0 38px,#dfe5da 38px 39px),
   repeating-linear-gradient(90deg,transparent 0 38px,#dfe5da 38px 39px),#eef2ea}
.map .pin{position:absolute;background:var(--ink);color:#fff;font-size:11px;font-weight:700;padding:5px 10px;border-radius:50px;white-space:nowrap}
.map .pin.c{background:#fff;color:var(--ink);box-shadow:0 4px 12px rgba(0,0,0,.12)}

/* ===== RESPONSIVE ===== */
@media(max-width:1280px){
  .r2{grid-template-columns:1fr 1fr}.r2 .pobj{grid-column:1/-1}
  .r3{grid-template-columns:1fr}
}
@media(max-width:960px){
  .side{transform:translateX(-100%)}
  body.open .side{transform:none;box-shadow:0 0 60px rgba(0,0,0,.25)}
  .main{margin-left:0;padding:16px}
  .menu-btn{display:grid}
  .search{display:none}
  .r1{grid-template-columns:1fr}
  .pg{grid-template-columns:1fr}
  .r2{grid-template-columns:1fr}
}
@media(prefers-reduced-motion:reduce){*{transition-duration:.01ms!important}}
</style>
</head>
<body>

<!-- ===== MENU BÊN TRÁI ===== -->
<aside class="side" id="side" aria-label="Menu quản trị">
  <div class="brand"><span class="lg">🥬</span><span>Green <b>Mart</b></span></div>

  <div class="nav-t">Quản lý</div>
  <nav class="nav">
    <a class="on" href="${cp}/admin"><i class="bi bi-speedometer2"></i>Bảng điều khiển</a>
    <a href="${cp}/admin/san-pham"><i class="bi bi-basket3"></i>Sản phẩm</a>
    <a href="${cp}/admin/don-hang"><i class="bi bi-receipt"></i>Đơn hàng <span class="cnt">12</span></a>
    <a href="${cp}/admin/nguoi-dung"><i class="bi bi-people"></i>Quản Lý all Tài Khoản</a>
        <a href="${cp}/admin/khach-hang"><i class="bi bi-people"></i>Quản Lý Customer</a>
    <a href="${cp}/admin/nhan-vien"><i class="bi bi-person-badge"></i>Nhân viên &amp; lương</a>
    <a href="${cp}/admin/bao-cao"><i class="bi bi-graph-up-arrow"></i>Báo cáo doanh thu</a>
  </nav>

  <div class="nav-t" style="margin-top:10px">Khác</div>
  <nav class="nav">
    <a href="${cp}/"><i class="bi bi-shop"></i>Xem cửa hàng</a>
    <a href="${cp}/admin/cai-dat"><i class="bi bi-gear"></i>Cài đặt</a>
  </nav>

  <div class="grow"></div>
  <div class="me">
    <span class="av"><c:out value="${fn:toUpperCase(fn:substring(empty me.fullname ? 'A' : me.fullname, 0, 1))}"/></span>
    <span class="t"><b><c:out value="${empty me.fullname ? 'Quản trị viên' : me.fullname}"/></b><small>Quản trị viên</small></span>
    <a href="${cp}/logout" title="Đăng xuất" aria-label="Đăng xuất"><i class="bi bi-box-arrow-right"></i></a>
  </div>
</aside>

<!-- ===== NỘI DUNG ===== -->
<main class="main">

  <header class="top">
    <button class="ibtn menu-btn" id="menuBtn" aria-label="Mở menu"><i class="bi bi-list"></i></button>
    <div>
      <h1>Xin chào, <c:out value="${empty me.fullname ? 'Admin' : me.fullname}"/></h1>
      <p>Tình hình kinh doanh nông sản hôm nay</p>
    </div>
    <span class="sp"></span>
    <label class="search"><i class="bi bi-search"></i><input type="search" placeholder="Tìm sản phẩm, đơn hàng..."></label>
    <button class="ibtn" aria-label="Thông báo"><i class="bi bi-bell"></i><span class="dot"></span></button>
    <a class="ibtn" href="${cp}/admin/cai-dat" aria-label="Cài đặt"><i class="bi bi-gear"></i></a>
  </header>

  <!-- Hàng 1 -->
  <section class="r1">
    <div class="kp">
      <div><small>Nông sản đã bán</small><div class="v"><em>₫</em>276.883.900</div></div>
      <div><small>Đơn đang giao</small><div class="v"><em>₫</em>346.594.300</div></div>
      <div class="bars" role="img" aria-label="Tỷ lệ đã bán và đang giao"><i class="a"></i><i class="b"></i></div>
    </div>
    <div class="hero">
      <img src="https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=900&q=70" alt="Nông trại rau củ" onerror="this.style.display='none'">
      <span class="tag"><i class="bi bi-geo-alt-fill" style="color:var(--green)"></i>Vùng trồng Đà Lạt · 35 nông trại</span>
    </div>
  </section>

  <!-- Hàng 2 -->
  <section class="r2">
    <div class="stk">
      <div class="card">
        <div class="hd"><h3>Tổng doanh thu</h3><button class="go" aria-label="Chi tiết"><i class="bi bi-arrow-up-right"></i></button></div>
        <div class="big"><em>₫</em>873,4 tr</div><div class="mute">Tháng này</div>
        <div class="bc"></div>
      </div>
      <div class="card">
        <div class="hd"><h3>Đơn hoàn thành</h3><button class="go" aria-label="Chi tiết"><i class="bi bi-arrow-up-right"></i></button></div>
        <div class="big">1.269</div><div class="mute">Tháng này</div>
        <div class="bc"></div>
      </div>
    </div>

    <div class="card">
      <div class="hd"><h3>Giá trị đơn trung bình</h3><span class="sel">Theo ngày <i class="bi bi-chevron-down"></i></span></div>
      <div class="big"><em>₫</em>873.420</div>
      <div class="hb">
        <div class="row"><span>Rau lá</span><div class="tr"><div class="fl" style="width:88%">+16%</div></div></div>
        <div class="row"><span>Củ quả</span><div class="tr"><div class="fl o" style="width:62%">+10%</div></div></div>
        <div class="row"><span>Trái cây</span><div class="tr"><div class="fl" style="width:48%">+8%</div></div></div>
        <div class="row"><span>Nấm</span><div class="tr"><div class="fl o" style="width:30%">+5%</div></div></div>
      </div>
    </div>

    <div class="card pobj">
      <div class="hd"><h3>Nông sản bán chạy</h3><button class="go" aria-label="Làm mới"><i class="bi bi-arrow-repeat"></i></button></div>
      <div class="pg">
        <article class="pc">
          <div class="im">🍅<img src="https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=500&q=70" alt="Cà chua cherry" onerror="this.style.display='none'">
            <span class="hh"><i class="bi bi-heart"></i></span><span class="ar"><i class="bi bi-arrow-up-right"></i></span></div>
          <div class="bd"><div class="nm">Cà chua cherry <span>35.000₫</span></div><div class="sb">Đà Lạt · Loại 1 · 1kg</div>
            <div class="mt"><span><i class="bi bi-bag"></i>420 đã bán</span><span><i class="bi bi-box-seam"></i>Còn 86</span></div></div>
        </article>
        <article class="pc">
          <div class="im">🥬<img src="https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=500&q=70" alt="Xà lách thủy canh" onerror="this.style.display='none'">
            <span class="hh"><i class="bi bi-heart"></i></span><span class="ar"><i class="bi bi-arrow-up-right"></i></span></div>
          <div class="bd"><div class="nm">Xà lách thủy canh <span>28.000₫</span></div><div class="sb">Lâm Đồng · Hữu cơ · 500g</div>
            <div class="mt"><span><i class="bi bi-bag"></i>385 đã bán</span><span><i class="bi bi-box-seam"></i>Còn 54</span></div></div>
        </article>
        <article class="pc">
          <div class="im">🥑<img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=500&q=70" alt="Rau củ tươi" onerror="this.style.display='none'">
            <span class="hh"><i class="bi bi-heart"></i></span><span class="ar"><i class="bi bi-arrow-up-right"></i></span></div>
          <div class="bd"><div class="nm">Combo rau củ <span>189.000₫</span></div><div class="sb">Gia đình · 5 loại · 3kg</div>
            <div class="mt"><span><i class="bi bi-bag"></i>312 đã bán</span><span><i class="bi bi-box-seam"></i>Còn 27</span></div></div>
        </article>
      </div>
    </div>
  </section>

  <!-- Hàng 3 -->
  <section class="r3">
    <div class="card">
      <div class="flt">
        <span class="sel"><i class="bi bi-grid"></i>Nhóm hàng <i class="bi bi-chevron-down"></i></span>
        <span class="sel"><i class="bi bi-tag"></i>Loại <i class="bi bi-chevron-down"></i></span>
        <span class="sel"><i class="bi bi-flag"></i>Trạng thái <i class="bi bi-chevron-down"></i></span>
        <span class="sel"><i class="bi bi-cash-coin"></i>Giá <i class="bi bi-chevron-down"></i></span>
        <span class="sp"></span>
        <a class="sel" href="${cp}/admin/san-pham">Xem tất cả <i class="bi bi-arrow-up-right"></i></a>
      </div>
      <div class="tw">
        <table>
          <thead><tr><th>Sản phẩm</th><th>Nhóm</th><th>Nhà cung cấp</th><th>Giá / kg</th><th>Lượt xem</th><th>Kho</th><th></th></tr></thead>
          <tbody>
            <tr>
              <td><div class="pn"><span class="th">🍅<img src="https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=120&q=60" alt="" onerror="this.style.display='none'"></span><div><b>Cà chua cherry</b><small>Đà Lạt, Lâm Đồng</small></div></div></td>
              <td>Củ quả</td><td>HTX Đà Lạt Xanh</td><td>35.000₫</td><td>1.251</td><td><span class="pill ok">Còn hàng</span></td>
              <td><button class="act" aria-label="Tùy chọn"><i class="bi bi-sliders"></i></button></td>
            </tr>
            <tr>
              <td><div class="pn"><span class="th">🥬<img src="https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60" alt="" onerror="this.style.display='none'"></span><div><b>Xà lách thủy canh</b><small>Đơn Dương, Lâm Đồng</small></div></div></td>
              <td>Rau lá</td><td>Nông trại Sạch Việt</td><td>28.000₫</td><td>987</td><td><span class="pill low">Sắp hết</span></td>
              <td><button class="act" aria-label="Tùy chọn"><i class="bi bi-sliders"></i></button></td>
            </tr>
            <tr>
              <td><div class="pn"><span class="th">🥕</span><div><b>Cà rốt Đà Lạt</b><small>Lạc Dương, Lâm Đồng</small></div></div></td>
              <td>Củ quả</td><td>HTX Đà Lạt Xanh</td><td>30.000₫</td><td>742</td><td><span class="pill ok">Còn hàng</span></td>
              <td><button class="act" aria-label="Tùy chọn"><i class="bi bi-sliders"></i></button></td>
            </tr>
            <tr>
              <td><div class="pn"><span class="th">🥑</span><div><b>Bơ sáp 034</b><small>Đắk Lắk</small></div></div></td>
              <td>Trái cây</td><td>Vườn Bơ Tây Nguyên</td><td>62.000₫</td><td>1.530</td><td><span class="pill out">Hết hàng</span></td>
              <td><button class="act" aria-label="Tùy chọn"><i class="bi bi-sliders"></i></button></td>
            </tr>
            <tr>
              <td><div class="pn"><span class="th">🥦</span><div><b>Súp lơ xanh</b><small>Mộc Châu, Sơn La</small></div></div></td>
              <td>Rau lá</td><td>Nông sản Mộc Châu</td><td>35.000₫</td><td>618</td><td><span class="pill ok">Còn hàng</span></td>
              <td><button class="act" aria-label="Tùy chọn"><i class="bi bi-sliders"></i></button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="card">
      <div class="hd"><h3>Vùng trồng</h3><button class="go" aria-label="Mở rộng"><i class="bi bi-arrow-up-right"></i></button></div>
      <div class="map" role="img" aria-label="Bản đồ vùng trồng">
        <span class="pin c" style="left:14%;top:18%">Sơn La · 6</span>
        <span class="pin c" style="left:40%;top:50%">Lâm Đồng · 18</span>
        <span class="pin" style="left:56%;top:74%">Đắk Lắk · 11</span>
      </div>
    </div>
  </section>

</main>

<script>
(function(){
  var b=document.body,btn=document.getElementById('menuBtn'),side=document.getElementById('side');
  btn.addEventListener('click',function(e){e.stopPropagation();b.classList.toggle('open')});
  document.addEventListener('click',function(e){if(b.classList.contains('open')&&!side.contains(e.target))b.classList.remove('open')});
})();
</script>
</body>
</html>
