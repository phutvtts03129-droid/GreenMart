<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>
<c:set var="tab" value="${empty tab ? 'tong-quan' : tab}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Khu làm việc - Green Mart</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;800&display=swap" rel="stylesheet">
<style>
:root{
  --ink:#16251e; --muted:#62756b; --line:#d9e2dc; --paper:#f1f5f2; --card:#ffffff;
  --pine:#0f4a3c; --pine2:#176a55; --mint:#d8efe3;
  --amber:#e9892b; --amber-bg:#fdecd6; --red:#c8453a; --red-bg:#fbe1de; --blue:#2f6fb0; --blue-bg:#dfeaf7;
}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Be Vietnam Pro',Arial,sans-serif;background:var(--paper);color:var(--ink);font-size:14px;line-height:1.5}
a{color:inherit;text-decoration:none}
button{font:inherit;cursor:pointer}
:focus-visible{outline:3px solid var(--amber);outline-offset:2px}

/* ===== Thanh trên: điều hướng ngang ===== */
.top{background:var(--pine);color:#fff;position:sticky;top:0;z-index:20}
.top-in{max-width:1240px;margin:0 auto;padding:0 24px;display:flex;align-items:center;gap:28px;height:64px}
.logo{font-weight:800;font-size:18px;white-space:nowrap}
.logo b{color:#8fe0b4}
.nav{display:flex;gap:4px;flex:1;overflow-x:auto}
.nav a{padding:8px 16px;border-radius:10px;color:rgba(255,255,255,.78);font-weight:500;white-space:nowrap}
.nav a:hover{background:rgba(255,255,255,.1);color:#fff}
.nav a.on{background:#fff;color:var(--pine);font-weight:600}
.who{display:flex;align-items:center;gap:10px}
.who .av{width:36px;height:36px;border-radius:50%;background:var(--amber);display:grid;place-items:center;font-weight:800}
.who .nm{line-height:1.2;text-align:right}
.who small{display:block;color:rgba(255,255,255,.65);font-size:12px}
.out{border:1px solid rgba(255,255,255,.35);border-radius:10px;padding:6px 12px;color:#fff;font-size:13px}
.out:hover{background:rgba(255,255,255,.12)}

.wrap{max-width:1240px;margin:0 auto;padding:26px 24px 60px}
h1{font-size:26px;font-weight:800;letter-spacing:-.01em}
h2{font-size:16px;font-weight:700}
.lead{color:var(--muted);margin-top:2px}

/* ===== Bảng ca (phần nổi bật) ===== */
.shift{margin-top:20px;background:var(--pine);color:#fff;border-radius:24px;padding:26px 30px;display:grid;grid-template-columns:1.2fr 1fr;gap:30px;align-items:center;
  background-image:repeating-linear-gradient(135deg,rgba(255,255,255,.035) 0 2px,transparent 2px 14px)}
.clock{font-size:64px;font-weight:800;line-height:1;letter-spacing:-.03em;font-variant-numeric:tabular-nums}
.date{margin-top:8px;color:rgba(255,255,255,.7)}
.clock-row{display:flex;gap:12px;margin-top:18px;flex-wrap:wrap}
.btn{border:0;border-radius:12px;padding:11px 20px;font-weight:700}
.btn-go{background:var(--amber);color:#fff}
.btn-go.out-state{background:#fff;color:var(--pine)}
.btn-ghost{background:rgba(255,255,255,.12);color:#fff}
.shift-stat{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.ss{background:rgba(255,255,255,.1);border-radius:16px;padding:14px 16px}
.ss b{display:block;font-size:30px;font-weight:800;line-height:1.1}
.ss span{font-size:12px;color:rgba(255,255,255,.72)}
.track{grid-column:1/-1;margin-top:2px}
.track .lbl{display:flex;justify-content:space-between;font-size:12px;color:rgba(255,255,255,.75);margin-bottom:6px}
.bar{height:10px;border-radius:99px;background:rgba(255,255,255,.18);overflow:hidden}
.bar i{display:block;height:100%;width:64%;background:#8fe0b4;border-radius:99px}

/* ===== Bảng công việc 3 cột ===== */
.board{margin-top:26px;display:grid;grid-template-columns:repeat(3,1fr);gap:18px;align-items:start}
.col{background:#e6ede8;border-radius:20px;padding:14px}
.col-h{display:flex;align-items:center;justify-content:space-between;padding:4px 6px 12px}
.col-h .cnt{background:#fff;border-radius:99px;padding:1px 10px;font-weight:700;font-size:12px}
.col.todo{border-top:5px solid var(--amber)}
.col.doing{border-top:5px solid var(--blue)}
.col.done{border-top:5px solid var(--pine2)}
.order{background:var(--card);border-radius:14px;padding:13px 14px;margin-bottom:10px;border:1px solid var(--line)}
.order .r1{display:flex;justify-content:space-between;font-weight:700}
.order .r2{color:var(--muted);font-size:13px;margin:2px 0 10px}
.order .r3{display:flex;justify-content:space-between;align-items:center;gap:8px}
.tag{display:inline-block;padding:2px 10px;border-radius:99px;font-size:12px;font-weight:600}
.tag.a{background:var(--amber-bg);color:#9a5410}
.tag.b{background:var(--blue-bg);color:var(--blue)}
.tag.g{background:var(--mint);color:var(--pine)}
.tag.r{background:var(--red-bg);color:var(--red)}
.mv{border:1px solid var(--pine2);background:#fff;color:var(--pine2);border-radius:9px;padding:4px 11px;font-weight:600;font-size:12px}
.mv:hover{background:var(--pine2);color:#fff}

/* ===== Khối dưới ===== */
.two{margin-top:26px;display:grid;grid-template-columns:1.4fr 1fr;gap:18px}
.panel{background:var(--card);border:1px solid var(--line);border-radius:20px;padding:20px 22px}
.panel h2{margin-bottom:12px}
table{width:100%;border-collapse:collapse}
th{text-align:left;font-size:12px;color:var(--muted);font-weight:600;padding:8px 8px;border-bottom:1px solid var(--line)}
td{padding:11px 8px;border-bottom:1px solid #edf1ee;vertical-align:middle}
tr:last-child td{border-bottom:0}
td.num,th.num{text-align:right;font-variant-numeric:tabular-nums}
.stock{display:flex;align-items:center;gap:10px}
.stock .meter{flex:1;height:8px;border-radius:99px;background:#e4ebe6;overflow:hidden;min-width:70px}
.stock .meter i{display:block;height:100%;border-radius:99px}
.todo-list{list-style:none}
.todo-list li{display:flex;gap:10px;align-items:flex-start;padding:10px 0;border-bottom:1px dashed var(--line)}
.todo-list li:last-child{border-bottom:0}
.todo-list input{margin-top:4px;accent-color:var(--pine2);width:16px;height:16px}
.todo-list input:checked+span{text-decoration:line-through;color:var(--muted)}

.pay{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin:20px 0}
.pay .box{background:var(--card);border:1px solid var(--line);border-radius:18px;padding:16px 18px}
.pay .box span{color:var(--muted);font-size:13px}
.pay .box b{display:block;font-size:24px;font-weight:800;margin-top:4px}
.pay .net{background:var(--pine);color:#fff;border-color:var(--pine)}
.pay .net span{color:rgba(255,255,255,.72)}

.toast{position:fixed;bottom:22px;left:50%;transform:translate(-50%,30px);background:var(--ink);color:#fff;padding:10px 18px;border-radius:12px;opacity:0;pointer-events:none;transition:.3s;z-index:50}
.toast.show{opacity:1;transform:translate(-50%,0)}

@media(max-width:980px){
  .shift{grid-template-columns:1fr}
  .board,.two,.pay{grid-template-columns:1fr 1fr}
  .two{grid-template-columns:1fr}
}
@media(max-width:640px){
  .top-in{flex-wrap:wrap;height:auto;padding:10px 16px;gap:10px}
  .nav{order:3;width:100%;flex:none}
  .who .nm{display:none}
  .board,.pay{grid-template-columns:1fr}
  .clock{font-size:48px}
  .shift{padding:22px 20px}
}
@media(prefers-reduced-motion:reduce){*{transition:none!important}}
</style>
</head>
<body>

<header class="top">
  <div class="top-in">
    <a class="logo" href="${cp}/nhan-vien">🥬 Green <b>Mart</b></a>
    <nav class="nav" aria-label="Điều hướng nhân viên">
      <a href="${cp}/nhan-vien" class="${tab eq 'tong-quan' ? 'on' : ''}">Ca làm việc</a>
      <a href="${cp}/nhan-vien/don-hang" class="${tab eq 'don-hang' ? 'on' : ''}">Xử lý đơn hàng</a>
      <a href="${cp}/nhan-vien/kho" class="${tab eq 'kho' ? 'on' : ''}">Quản lý kho</a>
      <a href="${cp}/nhan-vien/luong" class="${tab eq 'luong' ? 'on' : ''}">Bảng lương của tôi</a>
      <a href="${cp}/trang-chu">Xem cửa hàng</a>
    </nav>
    <div class="who">
      <div class="nm"><c:out value="${me.fullname}"/><small>Nhân viên</small></div>
      <div class="av">${fn:toUpperCase(fn:substring(me.fullname, 0, 1))}</div>
      <a class="out" href="${cp}/logout">Đăng xuất</a>
    </div>
  </div>
</header>

<main class="wrap">

<c:choose>

<%-- ================= TỔNG QUAN / CA LÀM ================= --%>
<c:when test="${tab eq 'tong-quan'}">
  <h1>Chào <c:out value="${me.fullname}"/>, hôm nay bạn có 9 việc cần xử lý</h1>
  <p class="lead">Bắt đầu ca, rồi xử lý đơn từ trái sang phải.</p>

  <section class="shift" aria-label="Ca làm việc">
    <div>
      <div class="clock" id="clock">--:--:--</div>
      <div class="date" id="date"></div>
      <div class="clock-row">
        <button class="btn btn-go" id="btnShift" type="button">Bắt đầu ca</button>
        <a class="btn btn-ghost" href="${cp}/nhan-vien/don-hang">Mở danh sách đơn</a>
      </div>
      <p class="date" id="shiftNote" style="margin-top:10px">Ca sáng · 07:00 - 15:00</p>
    </div>
    <div class="shift-stat">
      <div class="ss"><b>5</b><span>Đơn chờ xử lý</span></div>
      <div class="ss"><b>3</b><span>Đang đóng gói</span></div>
      <div class="ss"><b>14</b><span>Đã giao hôm nay</span></div>
      <div class="track">
        <div class="lbl"><span>Tiến độ ca</span><span>14 / 22 đơn</span></div>
        <div class="bar"><i></i></div>
      </div>
    </div>
  </section>

  <section class="board" aria-label="Bảng đơn hàng">
    <div class="col todo">
      <div class="col-h"><h2>Chờ xử lý</h2><span class="cnt">3</span></div>
      <div class="order"><div class="r1"><span>#GM-2041</span><span>218.000₫</span></div>
        <div class="r2">Chị Hà · Cà chua cherry, Xà lách</div>
        <div class="r3"><span class="tag r">Giao trước 10:00</span><button class="mv" type="button">Nhận đơn</button></div></div>
      <div class="order"><div class="r1"><span>#GM-2042</span><span>189.000₫</span></div>
        <div class="r2">Anh Quân · Combo rau củ gia đình</div>
        <div class="r3"><span class="tag a">Giao trước 12:00</span><button class="mv" type="button">Nhận đơn</button></div></div>
      <div class="order"><div class="r1"><span>#GM-2043</span><span>124.000₫</span></div>
        <div class="r2">Cô Lan · Bơ sáp 034</div>
        <div class="r3"><span class="tag a">Giao trước 14:00</span><button class="mv" type="button">Nhận đơn</button></div></div>
    </div>
    <div class="col doing">
      <div class="col-h"><h2>Đang đóng gói</h2><span class="cnt">2</span></div>
      <div class="order"><div class="r1"><span>#GM-2038</span><span>312.000₫</span></div>
        <div class="r2">Bạn Mai · Combo eat-clean, Súp lơ</div>
        <div class="r3"><span class="tag b">Đã soạn 4/6 món</span><button class="mv" type="button">Xong, giao đi</button></div></div>
      <div class="order"><div class="r1"><span>#GM-2039</span><span>96.000₫</span></div>
        <div class="r2">Chú Tám · Cà rốt Đà Lạt</div>
        <div class="r3"><span class="tag b">Đã soạn 1/2 món</span><button class="mv" type="button">Xong, giao đi</button></div></div>
    </div>
    <div class="col done">
      <div class="col-h"><h2>Đã giao</h2><span class="cnt">2</span></div>
      <div class="order"><div class="r1"><span>#GM-2035</span><span>150.000₫</span></div>
        <div class="r2">Chị Thu · Xà lách thủy canh</div>
        <div class="r3"><span class="tag g">Giao lúc 08:42</span></div></div>
      <div class="order"><div class="r1"><span>#GM-2036</span><span>275.000₫</span></div>
        <div class="r2">Anh Phúc · Combo gia đình</div>
        <div class="r3"><span class="tag g">Giao lúc 09:15</span></div></div>
    </div>
  </section>

  <section class="two">
    <div class="panel">
      <h2>Sắp hết hàng, cần báo kho</h2>
      <table>
        <tr><th>Sản phẩm</th><th>Tồn kho</th><th class="num">Còn</th></tr>
        <tr><td>Xà lách thủy canh</td><td><div class="stock"><div class="meter"><i style="width:18%;background:var(--amber)"></i></div></div></td><td class="num">54 kg</td></tr>
        <tr><td>Bơ sáp 034</td><td><div class="stock"><div class="meter"><i style="width:4%;background:var(--red)"></i></div></div></td><td class="num">0 kg</td></tr>
        <tr><td>Súp lơ xanh</td><td><div class="stock"><div class="meter"><i style="width:40%;background:var(--pine2)"></i></div></div></td><td class="num">120 kg</td></tr>
      </table>
    </div>
    <div class="panel">
      <h2>Việc cuối ca</h2>
      <ul class="todo-list">
        <li><input type="checkbox" id="t1"><span>Kiểm tra nhiệt độ kho lạnh</span></li>
        <li><input type="checkbox" id="t2"><span>Đối chiếu số lượng hàng nhập sáng nay</span></li>
        <li><input type="checkbox" id="t3"><span>Bàn giao đơn chưa giao cho ca chiều</span></li>
      </ul>
    </div>
  </section>
</c:when>

<%-- ================= XỬ LÝ ĐƠN HÀNG ================= --%>
<c:when test="${tab eq 'don-hang'}">
  <h1>Xử lý đơn hàng</h1>
  <p class="lead">Đơn gấp được xếp lên đầu.</p>
  <section class="panel" style="margin-top:20px">
    <table>
      <tr><th>Mã đơn</th><th>Khách hàng</th><th>Sản phẩm</th><th>Hạn giao</th><th>Trạng thái</th><th class="num">Tổng tiền</th><th></th></tr>
      <tr><td>#GM-2041</td><td>Chị Hà</td><td>Cà chua cherry, Xà lách</td><td>10:00</td><td><span class="tag r">Chờ xử lý</span></td><td class="num">218.000₫</td><td><button class="mv" type="button">Nhận đơn</button></td></tr>
      <tr><td>#GM-2042</td><td>Anh Quân</td><td>Combo rau củ gia đình</td><td>12:00</td><td><span class="tag a">Chờ xử lý</span></td><td class="num">189.000₫</td><td><button class="mv" type="button">Nhận đơn</button></td></tr>
      <tr><td>#GM-2038</td><td>Bạn Mai</td><td>Combo eat-clean, Súp lơ</td><td>11:00</td><td><span class="tag b">Đang đóng gói</span></td><td class="num">312.000₫</td><td><button class="mv" type="button">Xong, giao đi</button></td></tr>
      <tr><td>#GM-2035</td><td>Chị Thu</td><td>Xà lách thủy canh</td><td>09:00</td><td><span class="tag g">Đã giao</span></td><td class="num">150.000₫</td><td></td></tr>
    </table>
  </section>
</c:when>

<%-- ================= QUẢN LÝ KHO ================= --%>
<c:when test="${tab eq 'kho'}">
  <h1>Quản lý kho</h1>
  <p class="lead">Ghi nhận nhập, xuất và theo dõi hạn dùng.</p>
  <section class="panel" style="margin-top:20px">
    <table>
      <tr><th>Sản phẩm</th><th>Nhà cung cấp</th><th>Mức tồn</th><th class="num">Còn lại</th><th>Hạn dùng</th><th></th></tr>
      <tr><td>Cà chua cherry</td><td>HTX Đà Lạt Xanh</td><td><div class="stock"><div class="meter"><i style="width:80%;background:var(--pine2)"></i></div></div></td><td class="num">420 kg</td><td>08/11</td><td><button class="mv" type="button">Nhập / xuất</button></td></tr>
      <tr><td>Xà lách thủy canh</td><td>Nông trại Sạch Việt</td><td><div class="stock"><div class="meter"><i style="width:18%;background:var(--amber)"></i></div></div></td><td class="num">54 kg</td><td>07/11</td><td><button class="mv" type="button">Nhập / xuất</button></td></tr>
      <tr><td>Bơ sáp 034</td><td>Vườn Bơ Tây Nguyên</td><td><div class="stock"><div class="meter"><i style="width:4%;background:var(--red)"></i></div></div></td><td class="num">0 kg</td><td>—</td><td><button class="mv" type="button">Nhập / xuất</button></td></tr>
      <tr><td>Súp lơ xanh</td><td>Nông sản Mộc Châu</td><td><div class="stock"><div class="meter"><i style="width:40%;background:var(--pine2)"></i></div></div></td><td class="num">120 kg</td><td>10/11</td><td><button class="mv" type="button">Nhập / xuất</button></td></tr>
    </table>
  </section>
</c:when>

<%-- ================= BẢNG LƯƠNG ================= --%>
<c:otherwise>
  <h1>Bảng lương của tôi</h1>
  <p class="lead">Tháng 11/2026, cập nhật đến hôm nay.</p>
  <div class="pay">
    <div class="box"><span>Lương cơ bản</span><b>
      <c:choose><c:when test="${not empty me.salary}"><fmt:formatNumber value="${me.salary}" pattern="#,##0"/>₫</c:when><c:otherwise>0₫</c:otherwise></c:choose></b></div>
    <div class="box"><span>Số ca đã làm</span><b>9 ca</b></div>
    <div class="box"><span>Thưởng và phụ cấp</span><b>+ 600.000₫</b></div>
    <div class="box net"><span>Tạm tính nhận về</span><b>Xem chi tiết bên dưới</b></div>
  </div>
  <section class="panel">
    <h2>Chi tiết các khoản</h2>
    <table>
      <tr><th>Khoản</th><th>Ghi chú</th><th class="num">Số tiền</th></tr>
      <tr><td>Lương cơ bản</td><td>Theo hợp đồng</td><td class="num">Theo mức lương của bạn</td></tr>
      <tr><td>Thưởng đủ ca</td><td>Không nghỉ ca nào trong tuần</td><td class="num">+ 400.000₫</td></tr>
      <tr><td>Phụ cấp ăn trưa</td><td>9 ca × 22.000₫</td><td class="num">+ 198.000₫</td></tr>
    </table>
  </section>
</c:otherwise>

</c:choose>
</main>

<div class="toast" id="toast" role="status" aria-live="polite"></div>

<script>
(function(){
  var clock=document.getElementById('clock'),dateEl=document.getElementById('date');
  var days=['Chủ nhật','Thứ hai','Thứ ba','Thứ tư','Thứ năm','Thứ sáu','Thứ bảy'];
  function p(n){return n<10?'0'+n:n}
  function tick(){
    var d=new Date();
    if(clock)clock.textContent=p(d.getHours())+':'+p(d.getMinutes())+':'+p(d.getSeconds());
    if(dateEl)dateEl.textContent=days[d.getDay()]+', '+p(d.getDate())+'/'+p(d.getMonth()+1)+'/'+d.getFullYear();
  }
  tick();setInterval(tick,1000);

  var toast=document.getElementById('toast'),tt;
  function say(m){toast.textContent=m;toast.classList.add('show');clearTimeout(tt);tt=setTimeout(function(){toast.classList.remove('show')},2200)}

  var btn=document.getElementById('btnShift'),note=document.getElementById('shiftNote'),on=false;
  if(btn)btn.addEventListener('click',function(){
    on=!on;
    var d=new Date(),t=p(d.getHours())+':'+p(d.getMinutes());
    btn.textContent=on?'Kết thúc ca':'Bắt đầu ca';
    btn.classList.toggle('out-state',on);
    note.textContent=on?('Đã vào ca lúc '+t):'Ca sáng · 07:00 - 15:00';
    say(on?'Đã vào ca lúc '+t:'Đã kết thúc ca lúc '+t);
  });

  document.querySelectorAll('.mv').forEach(function(b){
    b.addEventListener('click',function(){say('Đã ghi nhận: '+b.textContent.trim())});
  });
})();
</script>
</body>
</html>
