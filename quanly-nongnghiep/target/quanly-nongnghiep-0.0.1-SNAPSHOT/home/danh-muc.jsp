<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Nếu dùng JSTL 3.0 (Tomcat 10.1+), đổi uri thành: jakarta.tags.core / jakarta.tags.fmt --%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="dm" value="${danhMucHienTai}" />
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty dm ? 'Tất cả sản phẩm' : dm.tenDanhMuc}"/> - Nông Sản Xanh</title>

<script>
(function(){try{var t=localStorage.getItem('theme');if(t){document.documentElement.setAttribute('data-theme',t);document.documentElement.setAttribute('data-bs-theme',t);}}catch(e){}})();
</script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
:root{
  --g800:#1b6b34; --g700:#2e7d32; --g500:#4caf50; --g100:#e8f5e9;
  --orange:#ff7a00; --bg:#fbfdf6; --bg2:#f0f7ec; --card:#ffffff; --text:#1f2d24; --muted:#66756b;
  --line:#e0ecdc; --head:#14532d; --shadow:rgba(20,83,45,.12); --price:#e53935;
}
[data-theme="dark"]{
  --bg:#081428; --bg2:#0c1b36; --card:#10203c; --text:#e8f1ff; --muted:#9db3cf; --line:rgba(110,170,255,.2);
  --head:#9fe0ff; --g700:#35c9a0; --g100:rgba(53,201,160,.14); --shadow:rgba(0,0,0,.5); --price:#ff7a6b;
}
body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);transition:background .3s,color .3s}
a{text-decoration:none}
.text-muted{color:var(--muted)!important}

/* ---- Header gọn ---- */
.bar{background:var(--card);border-bottom:1px solid var(--line);position:sticky;top:0;z-index:50}
.bar .in{display:flex;align-items:center;gap:16px;padding:12px 0}
.brand{display:flex;align-items:center;gap:8px;color:var(--g700);font-weight:800;font-size:1.25rem}
.brand i{font-size:1.8rem}
.bar .back{margin-left:auto;color:var(--g700);font-weight:600;font-size:.92rem}
.bar .back:hover{color:var(--orange)}
.crumb{font-size:.88rem;color:var(--muted);padding:16px 0 12px}
.crumb a{color:var(--g700)}
.crumb span{margin:0 6px}

/* ---- Banner danh mục ---- */
.cat-hero{position:relative;border-radius:22px;overflow:hidden;color:#fff;padding:44px 36px;margin-bottom:26px;
  background:linear-gradient(135deg,#1b6b34,#14532d) center/cover;box-shadow:0 12px 30px var(--shadow)}
.cat-hero::before{content:"";position:absolute;inset:0;background:linear-gradient(95deg,rgba(6,38,20,.88),rgba(6,38,20,.45) 70%,rgba(6,38,20,.2))}
.cat-hero > *{position:relative}
.cat-hero .ic{width:60px;height:60px;border-radius:16px;background:rgba(255,255,255,.18);display:grid;place-items:center;font-size:1.7rem;margin-bottom:14px;backdrop-filter:blur(6px)}
.cat-hero h1{font-weight:800;font-size:clamp(1.6rem,3vw,2.3rem);margin:0 0 6px}
.cat-hero p{margin:0;opacity:.92;max-width:520px}
.cat-hero .cnt{display:inline-block;margin-top:14px;background:var(--orange);padding:5px 14px;border-radius:50px;font-size:.82rem;font-weight:700}

/* ---- Thanh bên ---- */
.side{position:sticky;top:78px;background:var(--card);border:1px solid var(--line);border-radius:18px;padding:10px}
.side h6{font-weight:800;color:var(--head);padding:8px 12px 6px;margin:0;font-size:.95rem}
.side a{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:12px;color:var(--text);font-weight:500;font-size:.92rem}
.side a i{width:20px;text-align:center;color:var(--g700)}
.side a .n{margin-left:auto;font-size:.76rem;color:var(--muted);background:var(--bg2);padding:2px 9px;border-radius:50px}
.side a:hover{background:var(--g100)}
.side a.on{background:var(--g700);color:#fff}
.side a.on i{color:#fff}
.side a.on .n{background:rgba(255,255,255,.22);color:#fff}

/* ---- Thanh công cụ ---- */
.tool{display:flex;flex-wrap:wrap;gap:10px;align-items:center;justify-content:space-between;margin-bottom:18px}
.tool .res{font-size:.92rem;color:var(--muted)}
.tool .res b{color:var(--text)}
.tool form{display:flex;gap:8px;flex-wrap:wrap}
.tool .s{display:flex;border:2px solid var(--g700);border-radius:50px;overflow:hidden;background:var(--card)}
.tool .s input{border:0;background:transparent;color:var(--text);padding:7px 14px;outline:0;width:190px}
.tool .s button{border:0;background:var(--g700);color:#fff;padding:0 16px}
.tool select{border:2px solid var(--line);background:var(--card);color:var(--text);border-radius:50px;padding:7px 14px;font-size:.9rem}

/* ---- Lưới sản phẩm ---- */
.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}
.pc{background:var(--card);border:1px solid var(--line);border-radius:18px;overflow:hidden;display:flex;flex-direction:column;transition:transform .25s,box-shadow .25s,border-color .25s}
.pc:hover{transform:translateY(-4px);box-shadow:0 14px 30px var(--shadow);border-color:var(--g500)}
.pc .img{position:relative;aspect-ratio:1/1;background:var(--bg2);overflow:hidden}
.pc .img img{width:100%;height:100%;object-fit:cover}
.pc .off{position:absolute;top:10px;left:10px;background:var(--orange);color:#fff;font-weight:700;font-size:.76rem;padding:4px 10px;border-radius:50px}
.pc .hot{position:absolute;top:10px;right:10px;background:#fff;color:#e53935;font-size:.74rem;font-weight:700;padding:4px 10px;border-radius:50px}
.pc .out{position:absolute;inset:0;background:rgba(0,0,0,.55);color:#fff;display:grid;place-items:center;font-weight:700}
.pc .bd{padding:14px 16px 16px;display:flex;flex-direction:column;flex:1}
.pc .org{font-size:.76rem;color:var(--muted);margin-bottom:4px}
.pc h5{font-size:1rem;font-weight:700;color:var(--text);margin:0 0 6px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;min-height:2.6em}
.pc .ds{font-size:.82rem;color:var(--muted);flex:1;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:10px}
.pc .pr{display:flex;align-items:baseline;gap:8px;flex-wrap:wrap;margin-bottom:12px}
.pc .pr b{font-size:1.25rem;color:var(--price);font-weight:800}
.pc .pr s{font-size:.82rem;color:var(--muted)}
.pc .pr small{font-size:.76rem;color:var(--muted)}
.pc .ac{display:grid;grid-template-columns:1fr 1fr;gap:8px}
.b1,.b2{text-align:center;border-radius:50px;padding:8px 4px;font-size:.84rem;font-weight:600;white-space:nowrap;border:2px solid var(--g700)}
.b1{color:var(--g700)}
.b1:hover{background:var(--g700);color:#fff}
.b2{background:var(--g700);color:#fff}
.b2:hover{background:var(--orange);border-color:var(--orange);color:#fff}
.b2.dis{opacity:.45;pointer-events:none}

.empty{text-align:center;padding:60px 20px;color:var(--muted);background:var(--card);border:1px dashed var(--line);border-radius:18px}
.empty i{font-size:2.6rem}
.empty a{display:inline-block;margin-top:12px;color:#fff;background:var(--g700);padding:8px 22px;border-radius:50px;font-weight:600}

/* ---- Responsive ---- */
@media(max-width:1199px){.grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:991px){
  .side{position:static;display:flex;gap:6px;overflow-x:auto;padding:8px;margin-bottom:18px}
  .side h6{display:none}
  .side a{white-space:nowrap;flex-shrink:0;border:1px solid var(--line)}
}
@media(max-width:575px){
  .grid{grid-template-columns:repeat(2,1fr);gap:12px}
  .cat-hero{padding:28px 20px}
  .tool .s input{width:130px}
  .pc .ac{grid-template-columns:1fr}
}
.toast-mini{position:fixed;left:50%;bottom:30px;transform:translate(-50%,120px);background:#14532d;color:#fff;padding:12px 24px;border-radius:50px;z-index:2200;transition:.4s}
.toast-mini.show{transform:translate(-50%,0)}
</style>
</head>
<body>

<div class="bar">
  <div class="container in">
    <a href="${ctx}/trang-chu" class="brand"><i class="bi bi-flower3"></i>Nông Sản Xanh</a>
    <a href="${ctx}/trang-chu" class="back"><i class="bi bi-arrow-left"></i> Về trang chủ</a>
  </div>
</div>

<div class="container">

  <!-- Đường dẫn -->
  <div class="crumb">
    <a href="${ctx}/trang-chu">Trang chủ</a><span>/</span>
    <a href="${ctx}/danh-muc">Danh mục</a>
    <c:if test="${not empty dm}"><span>/</span><c:out value="${dm.tenDanhMuc}"/></c:if>
  </div>

  <!-- Banner -->
  <c:choose>
    <c:when test="${not empty dm}">
      <div class="cat-hero" style="background-image:url('<c:out value="${dm.hinhAnh}"/>')">
        <div class="ic"><i class="<c:out value='${empty dm.icon ? "fa-solid fa-leaf" : dm.icon}'/>"></i></div>
        <h1><c:out value="${dm.tenDanhMuc}"/></h1>
        <p><c:out value="${dm.mota}"/></p>
        <span class="cnt"><c:out value="${empty soLuongTheoDM[dm.id] ? 0 : soLuongTheoDM[dm.id]}"/> sản phẩm</span>
      </div>
    </c:when>
    <c:otherwise>
      <div class="cat-hero">
        <div class="ic"><i class="fa-solid fa-basket-shopping"></i></div>
        <h1>Tất cả sản phẩm</h1>
        <p>Rau củ, trái cây, nấm và nông sản chế biến từ các nhà vườn liên kết.</p>
        <span class="cnt">${tongTatCa} sản phẩm</span>
      </div>
    </c:otherwise>
  </c:choose>

  <div class="row g-4">

    <!-- Thanh bên danh mục -->
    <div class="col-lg-3">
      <nav class="side" aria-label="Danh mục">
        <h6>Danh mục</h6>
        <a href="${ctx}/danh-muc" class="${empty ma ? 'on' : ''}">
          <i class="fa-solid fa-border-all"></i>Tất cả<span class="n">${tongTatCa}</span>
        </a>
        <c:forEach var="d" items="${danhSachDanhMuc}">
          <a href="${ctx}/danh-muc?ma=<c:out value='${d.maDanhMuc}'/>" class="${ma eq d.maDanhMuc ? 'on' : ''}">
            <i class="<c:out value='${empty d.icon ? "fa-solid fa-leaf" : d.icon}'/>"></i>
            <c:out value="${d.tenDanhMuc}"/>
            <span class="n"><c:out value="${empty soLuongTheoDM[d.id] ? 0 : soLuongTheoDM[d.id]}"/></span>
          </a>
        </c:forEach>
      </nav>
    </div>

    <!-- Nội dung -->
    <div class="col-lg-9">

      <div class="tool">
        <div class="res">Hiển thị <b>${danhSachSanPham.size()}</b> sản phẩm
          <c:if test="${not empty q}"> cho "<b><c:out value="${q}"/></b>"</c:if></div>
        <form method="get" action="${ctx}/danh-muc">
          <input type="hidden" name="ma" value="<c:out value='${ma}'/>">
          <div class="s">
            <input type="text" name="q" value="<c:out value='${q}'/>" placeholder="Tìm trong danh mục...">
            <button type="submit" aria-label="Tìm"><i class="bi bi-search"></i></button>
          </div>
          <select name="sort" onchange="this.form.submit()" aria-label="Sắp xếp">
            <option value="moi"      ${sort eq 'moi'      ? 'selected' : ''}>Mới nhất</option>
            <option value="gia-tang" ${sort eq 'gia-tang' ? 'selected' : ''}>Giá thấp đến cao</option>
            <option value="gia-giam" ${sort eq 'gia-giam' ? 'selected' : ''}>Giá cao đến thấp</option>
            <option value="ten"      ${sort eq 'ten'      ? 'selected' : ''}>Tên A - Z</option>
          </select>
        </form>
      </div>

      <c:choose>
        <c:when test="${empty danhSachSanPham}">
          <div class="empty">
            <i class="bi bi-inbox"></i>
            <p class="mt-2 mb-0">Không có sản phẩm nào phù hợp.</p>
            <a href="${ctx}/danh-muc?ma=<c:out value='${ma}'/>">Xóa bộ lọc</a>
          </div>
        </c:when>
        <c:otherwise>
          <div class="grid">
            <c:forEach var="sp" items="${danhSachSanPham}">
              <c:set var="giam" value="${not empty sp.giaGoc and sp.giaGoc gt sp.gia}" />
              <article class="pc">
                <div class="img">
                  <img src="<c:out value='${sp.hinhAnh}'/>" alt="<c:out value='${sp.ten}'/>" loading="lazy"
                       onerror="this.onerror=null;this.src='https://placehold.co/400x400/e8f5e9/2e7d32?text=No+Image'">
                  <c:if test="${giam}">
                    <span class="off">-<fmt:formatNumber value="${(1 - sp.gia / sp.giaGoc) * 100}" maxFractionDigits="0"/>%</span>
                  </c:if>
                  <c:if test="${sp.noiBat}"><span class="hot"><i class="bi bi-fire"></i> Nổi bật</span></c:if>
                  <c:if test="${sp.soLuong le 0}"><div class="out">Hết hàng</div></c:if>
                </div>
                <div class="bd">
                  <div class="org"><i class="bi bi-geo-alt"></i> <c:out value="${sp.xuatXu}"/></div>
                  <h5><c:out value="${sp.ten}"/></h5>
                  <p class="ds"><c:out value="${sp.motaNgan}"/></p>
                  <div class="pr">
                    <b><fmt:formatNumber value="${sp.gia}" type="number" groupingUsed="true"/>₫</b>
                    <c:if test="${giam}"><s><fmt:formatNumber value="${sp.giaGoc}" type="number" groupingUsed="true"/>₫</s></c:if>
                    <small>/ <c:out value="${sp.donViTinh}"/></small>
                  </div>
                  <div class="ac">
                    <a class="b1" href="${ctx}/chi-tiet?id=${sp.id}">Xem chi tiết</a>
                    <a class="b2 ${sp.soLuong le 0 ? 'dis' : ''}" href="${ctx}/thanh-toan?id=${sp.id}">Thanh toán</a>
                  </div>
                </div>
              </article>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </div>
</div>

<div style="height:60px"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
