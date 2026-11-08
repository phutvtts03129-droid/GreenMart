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
/* Green Mart • visual redesign only. All original routes and data retained. */
:root{--bg:#f2f6f0;--ink:#163b2b;--mute:#687d70;--green:#238455;--line:#dce8dd;--side:260px}
body{background:radial-gradient(ellipse at 85% 0%,#d7ebd5,transparent 46%),radial-gradient(ellipse at 5% 75%,#ffeed8,transparent 40%),var(--bg);overflow-x:hidden}
.side{background:rgba(255,255,255,.95);padding:28px 18px;box-shadow:8px 0 40px #183d2807;overflow-y:auto}
.brand{font-size:22px;letter-spacing:-1px;padding-bottom:30px}.brand .lg{background:linear-gradient(145deg,#287c50,#123c29);box-shadow:0 8px 16px #23543430;transform:rotate(-8deg);border-radius:14px;width:44px;height:44px}
.nav-t{text-transform:uppercase;font-size:10px;letter-spacing:1.8px;margin:8px 0}
.nav a{border-radius:14px;font-size:12px;padding:13px 14px;transition:transform .25s,background .25s,box-shadow .25s}
.nav a:hover{transform:translateX(4px);background:#edf6ed}.nav a.on{background:linear-gradient(120deg,#174931,#2a7850);box-shadow:0 8px 18px #1e69452b}
.me{margin-top:24px;border:1px solid var(--line);border-radius:16px;background:#f4f9f2}.me .av{background:linear-gradient(145deg,#389466,#185034)}
.main{max-width:1920px;padding:30px 32px 36px}.top{margin-bottom:26px}.top h1{font-size:25px;letter-spacing:-.8px}.top p{margin-top:6px}.ibtn,.search{border:1px solid #ffffff;box-shadow:0 6px 18px #24452c08}.search{width:260px}.ibtn:hover{background:#e2f0df}
.welcome{position:relative;isolation:isolate;display:grid;grid-template-columns:1.3fr .7fr;align-items:center;gap:20px;min-height:265px;margin-bottom:24px;padding:34px 38px;border-radius:28px;color:#fff;background:radial-gradient(circle at 85% 20%,#4b9561,transparent 38%),linear-gradient(120deg,#123b2a,#226344);box-shadow:0 20px 35px #164b3024;overflow:hidden}
.welcome:before{content:'';position:absolute;z-index:-1;width:400px;height:400px;border:1px solid #ffffff13;border-radius:50%;right:-80px;top:-180px;box-shadow:0 0 0 45px #ffffff05,0 0 0 95px #ffffff04}
.eyebrow{display:inline-flex;align-items:center;gap:7px;font-size:10px;letter-spacing:1.8px;text-transform:uppercase;font-weight:600;color:#cce6bd}.eyebrow i{color:#c1ea81}
.welcome h2{font-size:clamp(25px,2.7vw,40px);line-height:1.3;letter-spacing:-1.3px;max-width:600px;margin:14px 0}.welcome h2 span{color:#c2ec91}.welcome p{color:#d2e2d7;font-size:12px;line-height:1.9;max-width:490px}
.hero-links{display:flex;gap:10px;flex-wrap:wrap;margin-top:22px}.hero-links a{display:inline-flex;gap:9px;align-items:center;padding:11px 17px;border-radius:11px;background:#d3efa5;color:#20472c;font-size:11px;font-weight:700;box-shadow:0 5px 0 #091e2526;transition:transform .2s}.hero-links a+ a{background:#ffffff12;color:#fff;border:1px solid #ffffff32;box-shadow:none}.hero-links a:hover{transform:translateY(-3px)}
.garden{height:200px;position:relative;perspective:700px;display:grid;place-items:center}.garden-platform{position:absolute;width:205px;height:150px;border-radius:36px;transform:rotateX(56deg) rotateZ(-34deg);background:repeating-linear-gradient(90deg,#98bf76 0 22px,#8db36c 22px 26px);border:6px solid #c5dd9a;box-shadow:-10px 12px 0 #6a8a51,-20px 24px 0 #456c43,0 42px 42px #092b3066;animation:platformFloat 7s ease-in-out infinite}.produce{position:absolute;font-size:67px;filter:drop-shadow(0 16px 9px #092d2660);animation:produceFloat 5s ease-in-out infinite;user-select:none}.produce.p1{left:18%;top:14%;transform:rotate(-14deg)}.produce.p2{left:49%;top:0;animation-delay:-2s;font-size:78px}.produce.p3{left:47%;top:48%;animation-delay:-3s;font-size:62px}.garden-label{position:absolute;bottom:0;right:3%;padding:9px 13px;border:1px solid #ffffff40;border-radius:12px;background:#ffffff16;backdrop-filter:blur(10px);font-size:10px;letter-spacing:.4px}
.section-intro{display:flex;justify-content:space-between;gap:16px;align-items:end;margin:26px 0 16px}.section-intro h2{font-size:18px;letter-spacing:-.5px}.section-intro p{font-size:11px;color:var(--mute);margin-top:5px}.section-intro>span{font-size:10px;color:var(--green);background:#e2edda;padding:7px 11px;border-radius:20px}
.card,.kp{border:1px solid #fff;box-shadow:0 8px 30px #1e48220a,0 1px 0 #d3dfd1;transition:box-shadow .3s,transform .3s;border-radius:22px}.card{padding:22px;background:linear-gradient(150deg,#fff,#fcfdfb)}
.card:hover{box-shadow:0 16px 35px #1e482216}.card h3{font-size:13px}.card .hd{gap:10px}.go{background:#edf4e9;color:#2d6741;flex-shrink:0;transition:transform .25s}.go:hover{transform:rotate(40deg)}
.r1{grid-template-columns:1.2fr 1fr;gap:20px}.kp{background:#fff;padding:26px;gap:24px}.kp>div:not(.bars){padding-left:14px;border-left:3px solid #c5dfab}.kp .v{font-size:clamp(20px,2.1vw,30px);letter-spacing:-1px;margin-top:9px}.kp small{font-size:11px}.bars{height:10px;box-shadow:inset 0 2px 4px #00000008}.bars .a{background:linear-gradient(90deg,#1b5639,#4a9462)}.bars .b{background:#edbd84}
.hero{min-height:200px;box-shadow:0 8px 24px #1e48221a}.hero img{transition:transform 1s;filter:saturate(.85)}.hero:hover img{transform:scale(1.06)}.hero .tag{backdrop-filter:blur(12px);background:#ffffffdf;font-size:11px;box-shadow:0 5px 20px #142d3522}
.r2{grid-template-columns:minmax(180px,.7fr) minmax(220px,.9fr) minmax(380px,1.7fr);gap:20px;margin:22px 0}.stk{gap:20px}.stk .card:first-child{background:linear-gradient(135deg,#edf6df,#fff)}.big{font-size:30px;letter-spacing:-1px}.bc{height:22px;opacity:.3}.hb{margin-top:24px}.hb .row{margin-bottom:18px}.hb .tr{background:#edf2e8;height:19px}.hb .fl{background:linear-gradient(90deg,#1e573b,#57996b);box-shadow:0 3px 7px #225a3920;transform-origin:left;animation:barReveal 1.2s ease both}.hb .fl.o{background:linear-gradient(90deg,#e8ac71,#f1cd99)}.sel{font-size:11px;background:#f9fcf6;border-color:#e2ebde}
.pg{gap:12px}.pc{border-color:#e3ecde;border-radius:16px;transition:transform .35s,box-shadow .35s;transform-style:preserve-3d}.pc:hover{transform:perspective(700px) translateY(-7px) rotateX(3deg);box-shadow:0 14px 24px #184d2920}.pc .im{height:160px;overflow:hidden}.pc .im img{transition:transform .7s}.pc:hover .im img{transform:scale(1.1)}.pc .bd{padding:13px 10px}.pc .nm{flex-direction:column;gap:5px;font-size:12px}.pc .nm span{color:#277345;font-size:13px}.pc .sb{font-size:10px;margin:7px 0 10px}.pc .mt{flex-wrap:wrap;font-size:10px;gap:5px}.pc .im .hh,.pc .im .ar{box-shadow:0 4px 12px #15332115}
.r3{gap:20px;grid-template-columns:minmax(0,2fr) minmax(240px,.8fr)}.r3>.card{min-width:0}.flt{gap:7px}.flt .sel{padding:8px 10px}table{min-width:680px}th{background:#f5f8f0;padding:12px 10px;font-size:10px}td{padding:15px 10px;font-size:11px}tbody tr{transition:background .2s}tbody tr:hover{background:#f5faef}.pn b{font-size:11px}.pn small{font-size:10px}.pill{font-size:10px;padding:5px 10px}.map{height:280px;min-height:0;border:1px solid #e1e9dc;box-shadow:inset 0 0 45px #5d854115}.map .pin{box-shadow:0 7px 12px #143c2926;animation:pinFloat 6s ease-in-out infinite}.map .pin:nth-child(2){animation-delay:-2s}.map .pin:nth-child(3){animation-delay:-4s}
.workspace-notes{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;margin-top:24px}.workspace-note{display:flex;gap:13px;padding:20px;border-radius:18px;background:#ffffffab;border:1px solid #fff}.workspace-note>i{display:grid;place-items:center;width:39px;height:39px;border-radius:12px;background:#e5f0da;color:#347449;font-size:18px;flex-shrink:0}.workspace-note h3{font-size:12px;margin:2px 0 7px}.workspace-note p{font-size:11px;line-height:1.8;color:var(--mute)}.dashboard-footer{display:flex;justify-content:space-between;gap:12px;margin-top:28px;padding-top:18px;border-top:1px solid #d9e5d6;color:var(--mute);font-size:10px}.dashboard-footer strong{color:#3c6947}
@keyframes platformFloat{50%{transform:translateY(-8px) rotateX(56deg) rotateZ(-30deg)}}
@keyframes produceFloat{50%{translate:0 -13px;rotate:5deg}}
@keyframes pinFloat{50%{transform:translateY(-5px)}}
@keyframes barReveal{from{transform:scaleX(.1)}to{transform:scaleX(1)}}
@media(min-width:961px){.card[data-visual-tilt]{transform:perspective(1100px) rotateX(var(--tilt-x,0deg)) rotateY(var(--tilt-y,0deg));will-change:auto}}
@media(max-width:1400px){.r2{grid-template-columns:1fr 1fr}.r2 .pobj{grid-column:1/-1}.pc .nm{flex-direction:row;flex-wrap:wrap}.pg{grid-template-columns:repeat(3,1fr)}}
@media(max-width:1280px){.r3{grid-template-columns:1fr}.map{height:230px}.top h1{font-size:21px}.search{width:210px}}
@media(max-width:960px){.main{padding:20px 18px}.side{width:260px}.welcome{padding:28px;grid-template-columns:1.3fr .7fr}.garden{transform:scale(.85)}.r1{grid-template-columns:1fr}.workspace-notes{grid-template-columns:1fr}.r2{grid-template-columns:1fr 1fr}.r2 .pobj{grid-column:1/-1}.pg{grid-template-columns:repeat(3,1fr)}.search{display:none}}
@media(max-width:600px){.main{padding:18px 12px}.top{gap:9px;flex-wrap:wrap}.top h1{font-size:17px}.top p{font-size:10px}.ibtn{width:35px;height:35px;flex-shrink:0}.top .sp{display:none}.top>div{flex:1}.welcome{padding:24px;grid-template-columns:1fr;gap:8px}.welcome h2{font-size:29px}.welcome p{font-size:11px}.garden{height:185px;max-width:280px;width:100%;justify-self:center;transform:scale(.9)}.r2{grid-template-columns:1fr}.r2 .pobj{grid-column:auto}.pg{grid-template-columns:1fr}.pc{display:grid;grid-template-columns:115px 1fr}.pc .im{height:100%;min-height:150px}.pc .nm{flex-direction:column}.pc .bd{padding:18px 12px}.pc .im .hh{display:none}.kp{padding:20px;gap:20px 12px}.kp .v{font-size:18px}.kp small{font-size:10px}.card{padding:18px}.section-intro>span{display:none}.dashboard-footer{flex-direction:column}.hero-links a{padding:10px 12px}}
@media(prefers-reduced-motion:reduce){*,*:before,*:after{animation:none!important;transition:none!important;scroll-behavior:auto!important}.card[data-visual-tilt]{transform:none!important}}
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

  <!-- Bổ sung nội dung trình bày; không thêm dữ liệu kinh doanh giả hoặc endpoint mới. -->
  <section class="welcome" aria-labelledby="welcome-title">
    <div>
      <span class="eyebrow"><i class="bi bi-flower1" aria-hidden="true"></i>Green Mart • Không gian quản trị</span>
      <h2 id="welcome-title">Chăm từng mầm xanh.<br><span>Vững từng bước phát triển.</span></h2>
      <p>Một góc nhìn tổng quan cho cửa hàng nông sản. Theo dõi sản phẩm, kết nối đội ngũ và quản lý công việc hằng ngày trong cùng một không gian.</p>
      <div class="hero-links">
        <a href="${cp}/admin/san-pham">Quản lý sản phẩm <i class="bi bi-arrow-up-right" aria-hidden="true"></i></a>
        <a href="${cp}/admin/bao-cao">Xem báo cáo <i class="bi bi-graph-up-arrow" aria-hidden="true"></i></a>
      </div>
    </div>
    <div class="garden" aria-hidden="true">
      <div class="garden-platform"></div>
      <span class="produce p1">🥬</span><span class="produce p2">🥑</span><span class="produce p3">🍅</span>
      <span class="garden-label">Từ nông trại đến bàn ăn</span>
    </div>
  </section>
  <div class="section-intro"><div><h2>Tổng quan cửa hàng</h2><p>Doanh thu, sản phẩm và hoạt động kinh doanh</p></div><span>GREEN MART / DASHBOARD</span></div>

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

  <section class="workspace-notes" aria-label="Góc quản trị">
    <article class="workspace-note"><i class="bi bi-basket3" aria-hidden="true"></i><div><h3>Danh mục gọn gàng</h3><p>Quản lý thông tin nông sản, nhóm hàng và cách sản phẩm được giới thiệu tới khách hàng.</p></div></article>
    <article class="workspace-note"><i class="bi bi-people" aria-hidden="true"></i><div><h3>Kết nối đội ngũ</h3><p>Truy cập các mục tài khoản, khách hàng và nhân viên từ thanh điều hướng bên trái.</p></div></article>
    <article class="workspace-note"><i class="bi bi-bar-chart-line" aria-hidden="true"></i><div><h3>Góc nhìn kinh doanh</h3><p>Theo dõi tổng quan tại bảng điều khiển và truy cập báo cáo doanh thu để xem thêm.</p></div></article>
  </section>
  <footer class="dashboard-footer"><span><strong>Green Mart</strong> · Không gian quản trị nông sản</span><span>Chăm chút hôm nay, vun trồng ngày mai.</span></footer>
</main>

<script>
(function(){
  var b=document.body,btn=document.getElementById('menuBtn'),side=document.getElementById('side');
  btn.addEventListener('click',function(e){e.stopPropagation();b.classList.toggle('open')});
  document.addEventListener('click',function(e){if(b.classList.contains('open')&&!side.contains(e.target))b.classList.remove('open')});
})();
</script>
<!-- Chỉ tạo hiệu ứng thị giác; không can thiệp click, form hoặc dữ liệu. -->
<script>
(function(){
  'use strict';
  if(!window.matchMedia || !window.matchMedia('(hover: hover) and (pointer: fine)').matches || window.matchMedia('(prefers-reduced-motion: reduce)').matches){return;}
  var cards=document.querySelectorAll('.stk .card, .r2 > .card:not(.pobj)');
  for(var i=0;i<cards.length;i++){
    (function(card){
      var frame=0;
      card.setAttribute('data-visual-tilt','');
      card.addEventListener('pointermove',function(event){
        if(frame){window.cancelAnimationFrame(frame);}
        var x=event.clientX,y=event.clientY;
        frame=window.requestAnimationFrame(function(){
          var rect=card.getBoundingClientRect();
          if(!rect.width || !rect.height){frame=0;return;}
          card.style.setProperty('--tilt-x',((.5-(y-rect.top)/rect.height)*5).toFixed(2)+'deg');
          card.style.setProperty('--tilt-y',(((x-rect.left)/rect.width-.5)*5).toFixed(2)+'deg');
          frame=0;
        });
      });
      card.addEventListener('pointerleave',function(){
        if(frame){window.cancelAnimationFrame(frame);frame=0;}
        card.style.setProperty('--tilt-x','0deg');
        card.style.setProperty('--tilt-y','0deg');
      });
    })(cards[i]);
  }
})();
</script>
</body>
</html>
