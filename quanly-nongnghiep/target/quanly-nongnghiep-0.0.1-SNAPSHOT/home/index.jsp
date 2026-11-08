<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nông Sản Xanh - Tươi ngon từ thiên nhiên</title>

<!-- Áp dụng chế độ sáng/tối ngay khi tải để không bị nháy -->
<script>
(function(){try{var t=localStorage.getItem('theme');if(t){document.documentElement.setAttribute('data-theme',t);document.documentElement.setAttribute('data-bs-theme',t);}}catch(e){}})();
</script>
<%@ include file="home-extras.jspf" %>
<%@ include file="chat-ai.jspf" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&family=Dancing+Script:wght@600;700&display=swap" rel="stylesheet">

<style>
:root{
  --g900:#14532d; --g800:#1b6b34; --g700:#2e7d32; --g500:#4caf50; --g100:#e8f5e9; --g50:#f4faf0;
  --orange:#ff7a00; --bg:#fbfdf6; --bg2:#f0f7ec; --card:#ffffff; --text:#1f2d24; --muted:#66756b;
  --line:#e0ecdc; --head:#14532d; --shadow:rgba(20,83,45,.13); --pm:#eaf6e5; --pm2:#d7efcf;
}
[data-theme="dark"]{
  --bg:#040b18;--bg2:#071428;--card:rgba(11,25,48,.74);--text:#e8f1ff;--muted:#9db3cf;--line:rgba(110,170,255,.2);
  --head:#9fe0ff;--g700:#35c9a0;--g100:rgba(53,201,160,.14);--g50:#0f1c16;--shadow:rgba(0,0,0,.55);--pm:#16314f;--pm2:#0c1e36;
}
*{scroll-behavior:smooth}
body{font-family:'Be Vietnam Pro',sans-serif;color:var(--text);background:var(--bg);overflow-x:hidden;transition:background .4s,color .4s}
.script{font-family:'Dancing Script',cursive;font-weight:700}
.text-green{color:var(--g700)!important}
.text-muted{color:var(--muted)!important}
a{text-decoration:none}

/* ===== TOP BAR + HEADER ===== */
.topbar{background:var(--g800);color:#fff;font-size:.85rem;padding:7px 0}
.topbar a{color:#fff}
.topbar .tb{display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap}
.site-header{background:var(--card);position:sticky;top:0;z-index:1030;box-shadow:0 2px 16px var(--shadow);transition:background .4s}
.site-header .container,
.topbar .container {
  max-width: 1400px;
  padding-left: clamp(20px, 3.5vw, 48px) !important;
  padding-right: clamp(20px, 3.5vw, 48px) !important;
}

.site-header{background:var(--card);position:sticky;top:0;z-index:1030;box-shadow:0 2px 16px var(--shadow);transition:background .4s}
.brand{display:flex;align-items:center;gap:12px;color:var(--g700);flex-shrink:0}
.brand i{font-size:2.3rem}
.brand b{display:block;font-size:1.5rem;line-height:1;font-weight:800}
.brand small{color:var(--muted);font-size:.78rem}
.search-box{display:flex;border:2px solid var(--g700);border-radius:50px;overflow:hidden;background:var(--bg2);max-width:440px;margin:0 12px}
.search-box input{border:0;background:transparent;color:var(--text);padding:8px 18px;flex:1;outline:0;min-width:0}
.search-box button{background:var(--g700);color:#fff;border:0;padding:0 20px}
.nav-row{border-top:1px solid var(--line)}
/* Giãn khoảng cách giữa các chữ Trang chủ, Danh mục... */
.main-nav{display:flex;justify-content:center;align-items:center;gap:20px;flex-wrap:nowrap;padding:10px 0}
.main-nav a{color:var(--text);font-weight:600;font-size:.95rem;padding:8px 20px;border-radius:50px;white-space:nowrap;transition:.25s}
.main-nav a:hover,.main-nav a.active{background:var(--g700);color:#fff}
.icon-btn{position:relative;background:var(--g100);color:var(--g700);border:0;width:44px;height:44px;border-radius:50%;font-size:1.2rem;transition:.25s}
.icon-btn:hover{background:var(--g700);color:#fff}
.icon-btn .badge{position:absolute;top:-4px;right:-4px;font-size:.65rem}
.btn-auth{align-items:center;gap:6px;border:2px solid var(--g700);color:var(--g700);border-radius:50px;padding:8px 18px;font-weight:600;font-size:.9rem;white-space:nowrap;transition:.25s}
.btn-auth:hover{background:var(--g700);color:#fff}
.btn-auth.solid{background:var(--g700);color:#fff}
.btn-auth.solid:hover{background:var(--orange);border-color:var(--orange)}
.burger{background:var(--g700);color:#fff;border:0;width:44px;height:44px;border-radius:12px;font-size:1.6rem}

/* ===== HERO (thoáng) ===== */
.hero{position:relative;min-height:clamp(540px,76vh,720px);overflow:hidden;color:#fff;display:flex;align-items:center;padding:90px 0 170px}
.hero video{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
.hero::after{content:"";position:absolute;inset:0;background:linear-gradient(100deg,rgba(6,38,20,.78) 0%,rgba(6,38,20,.35) 60%,rgba(0,0,0,.05) 100%);z-index:1}
.hero .container{position:relative;z-index:2}
.hero h1{font-size:clamp(2rem,3.6vw,3rem);line-height:1.08;text-shadow:0 4px 18px rgba(0,0,0,.45)}
.btn-orange{background:var(--orange);color:#fff;border-radius:50px;padding:13px 32px;font-weight:700;border:0;box-shadow:0 8px 20px rgba(255,122,0,.4);transition:.3s}
.btn-orange:hover{background:#e56d00;color:#fff;transform:translateY(-3px)}
.btn-ghost{border:2px solid #fff;color:#fff;border-radius:50px;padding:11px 28px;font-weight:600;transition:.3s}
.btn-ghost:hover{background:#fff;color:var(--g700)}
@keyframes floaty{0%,100%{transform:translateY(0) rotate(-2deg)}50%{transform:translateY(-22px) rotate(3deg)}}
.scroll-down{position:absolute;bottom:70px;left:50%;transform:translateX(-50%);z-index:3;color:#fff;font-size:1.8rem;animation:bounce 1.6s infinite}
@keyframes bounce{50%{transform:translate(-50%,10px)}}
.video-toggle{position:absolute;right:20px;bottom:64px;z-index:3;background:rgba(255,255,255,.2);border:0;color:#fff;width:42px;height:42px;border-radius:50%;backdrop-filter:blur(6px)}

/* Đồng hồ trong banner */
.hero-clock{position:absolute;top:26px;right:26px;z-index:5;min-width:210px;padding:14px 20px;border-radius:22px;color:#fff;text-align:center;background:rgba(255,255,255,.12);backdrop-filter:blur(14px);border:1px solid rgba(255,255,255,.28);box-shadow:0 14px 34px rgba(0,0,0,.28)}
.hero-clock .t{font-weight:800;font-size:2.2rem;line-height:1;letter-spacing:.04em;font-variant-numeric:tabular-nums}
.hero-clock .t i{font-style:normal;font-size:1.2rem;color:#ffd54f;margin-left:4px}
.hero-clock .d{font-size:.8rem;opacity:.85;margin-top:6px}
.hero-clock .s{margin-top:8px;font-size:.76rem;font-weight:700;display:inline-flex;gap:6px;align-items:center;padding:3px 12px;border-radius:50px;background:rgba(0,0,0,.25)}
.hero-clock .s::before{content:"";width:8px;height:8px;border-radius:50%;background:#58e46b;box-shadow:0 0 8px #58e46b}
.hero-clock.closed .s::before{background:#ff6b6b;box-shadow:0 0 8px #ff6b6b}

/* ===== FEATURE STRIP ===== */
.feature-strip{margin-top:-62px;position:relative;z-index:5}
.feature-box{background:var(--card);border-radius:22px;box-shadow:0 16px 44px var(--shadow);padding:24px 10px}
.feature-item{display:flex;align-items:center;gap:14px;padding:6px 18px;border-right:1px dashed var(--line)}
.col-lg-3:last-child .feature-item{border:0}
.feature-item i{font-size:2.3rem;color:var(--g700);transition:.5s}
.feature-item:hover i{transform:rotateY(360deg)}
.feature-item b{display:block;font-size:.95rem}
.feature-item small{color:var(--muted)}

/* ===== SECTION ===== */
.section{padding:84px 0;position:relative}
.sec-title{text-align:center;margin-bottom:48px}
.sec-title .script{font-size:1.9rem;color:var(--orange);display:block}
.sec-title h2{font-weight:800;color:var(--head);font-size:clamp(1.8rem,3.5vw,2.6rem)}
.sec-title .line{width:96px;height:5px;background:linear-gradient(90deg,var(--g700),var(--orange));margin:12px auto 0;border-radius:5px}
.sec-alt{background:var(--bg2)}
.wave{display:block;width:100%;height:60px;margin-bottom:-1px}
.wave path{fill:var(--bg2)}
.wave.flip{transform:rotate(180deg);margin:-1px 0 0}

/* ===== CATEGORIES ===== */
.cat-card{border-radius:26px;padding:28px 10px 22px;text-align:center;height:100%;display:block;color:#fff;position:relative;overflow:hidden;transition:.4s;box-shadow:0 10px 24px var(--shadow)}
.cat-card::after{content:"";position:absolute;width:120px;height:120px;border-radius:50%;background:rgba(255,255,255,.18);right:-40px;bottom:-40px;transition:.5s}
.cat-card:hover{transform:translateY(-10px) rotate(-1.5deg);color:#fff}
.cat-card:hover::after{transform:scale(2.4)}
.cat-card .ico{font-size:3.4rem;line-height:1;margin-bottom:10px;display:inline-block;filter:drop-shadow(0 8px 8px rgba(0,0,0,.25));animation:floaty 4.5s ease-in-out infinite}
.cat-card b{display:block;font-size:1rem;position:relative;z-index:1}
.cat-card small{opacity:.85;position:relative;z-index:1}
.c1{background:linear-gradient(135deg,#43a047,#1b5e20)}.c2{background:linear-gradient(135deg,#ef5350,#b71c1c)}
.c3{background:linear-gradient(135deg,#ffa726,#e65100)}.c4{background:linear-gradient(135deg,#8d6e63,#4e342e)}
.c5{background:linear-gradient(135deg,#ec407a,#ad1457)}.c6{background:linear-gradient(135deg,#d4a017,#8a6100)}

/* ===== SẢN PHẨM NỔI BẬT (nhiều khung) ===== */
.sec-deco span{position:absolute;font-size:3.2rem;opacity:.2;animation:floaty 7s ease-in-out infinite;pointer-events:none}
.p-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:26px}
.p-item.big{grid-column:span 2;grid-row:span 2}
.p-card{background:var(--card);border-radius:28px;overflow:hidden;box-shadow:0 10px 28px var(--shadow);transition:.4s;position:relative;height:100%;display:flex;flex-direction:column;border:1px solid var(--line)}
.p-card:hover{transform:translateY(-10px);box-shadow:0 22px 44px var(--shadow);border-color:var(--g500)}
.p-media{position:relative;height:300px;display:grid;place-items:center;padding:22px;background:radial-gradient(circle at 25% 15%,rgba(255,255,255,.7),transparent 55%),linear-gradient(160deg,var(--pm),var(--pm2));overflow:hidden}
.p-item.big .p-media{height:440px}
@keyframes spin{to{transform:rotate(360deg)}}
.frame{position:relative;width:min(70%,210px);aspect-ratio:1;z-index:1;transition:.5s}
.big .frame{width:min(68%,330px)}
.frame::before{content:"";position:absolute;inset:0;border-radius:inherit;transform:translate(14px,14px) rotate(4deg);background:linear-gradient(135deg,var(--g500),var(--orange));opacity:.85;z-index:-1;transition:.5s}
.frame::after{content:"";position:absolute;inset:-14px;border-radius:inherit;border:2px dashed rgba(46,125,50,.5);transform:rotate(-3deg);z-index:-1}
.p-media .frame img{width:100%;height:100%;object-fit:cover;border-radius:inherit;border:5px solid #fff;box-shadow:0 18px 30px rgba(0,0,0,.28);transition:.5s}
.f0{border-radius:999px 999px 28px 28px}.f1{border-radius:50%}.f2{border-radius:34px}.f3{border-radius:46% 54% 42% 58%/52% 44% 56% 48%}
.p-card:hover .frame{transform:translateY(-6px) scale(1.05)}
.p-card:hover .frame::before{transform:translate(20px,20px) rotate(8deg)}
.chip{position:absolute;z-index:4;background:#fff;color:#1f2d24;font-size:.74rem;font-weight:700;padding:6px 12px;border-radius:50px;box-shadow:0 10px 20px rgba(0,0,0,.2);animation:floaty 4.5s ease-in-out infinite;white-space:nowrap}
.chip.ca{left:12px;bottom:64px}.chip.cz{right:12px;bottom:24px;animation-delay:1.4s}
.p-tag{position:absolute;top:16px;left:16px;z-index:3;background:linear-gradient(90deg,#ff5252,#ff7a00);color:#fff;font-size:.75rem;font-weight:700;padding:5px 14px;border-radius:50px;box-shadow:0 6px 14px rgba(255,82,82,.4)}
.heart{position:absolute;top:14px;right:14px;width:42px;height:42px;border-radius:50%;border:0;background:#fff;color:#b5bdb7;font-size:1.15rem;box-shadow:0 6px 14px rgba(0,0,0,.18);transition:.3s;z-index:3}
.heart:hover{transform:scale(1.15)}
.heart.on{color:#e53935;animation:beat .45s}
@keyframes beat{40%{transform:scale(1.45)}}
.p-body{padding:18px 20px 22px;display:flex;flex-direction:column;flex:1}
.p-body h5{font-weight:700;font-size:1.12rem;margin:6px 0 4px;color:var(--text)}
.p-desc{color:var(--muted);font-size:.86rem;flex:1;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:10px}
.big .p-desc{-webkit-line-clamp:4;font-size:.95rem}.big h5{font-size:1.5rem}.big .p-price{font-size:2rem}
.p-foot{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px}
.p-price{font-size:1.45rem;font-weight:800;color:#e53935;line-height:1}
.p-stock{font-size:.75rem;color:var(--g700);font-weight:600}
.p-actions{display:grid;grid-template-columns:1fr 1fr;gap:8px}
.btn-detail{border:2px solid var(--g700);color:var(--g700);border-radius:50px;font-weight:600;font-size:.85rem;padding:9px 4px;transition:.25s;text-align:center;white-space:nowrap}
.btn-detail:hover{background:var(--g700);color:#fff}
.btn-pay{background:linear-gradient(90deg,var(--g700),var(--g500));color:#fff;border-radius:50px;font-weight:700;font-size:.85rem;padding:10px 4px;transition:.3s;text-align:center;white-space:nowrap;border:2px solid transparent}
.btn-pay:hover{color:#fff;transform:translateY(-2px);box-shadow:0 10px 20px rgba(46,125,50,.4)}
.btn-cart{width:44px;height:44px;border-radius:50%;border:0;background:var(--g100);color:var(--g700);font-size:1.2rem;transition:.3s;flex-shrink:0}
.btn-cart:hover{background:var(--orange);color:#fff;transform:rotate(-12deg) scale(1.1)}

/* ===== PROMO ===== */
.promo{border-radius:26px;overflow:hidden;position:relative;min-height:240px;display:flex;align-items:center;padding:30px;color:#fff;transition:.5s;background-size:cover;background-position:center;box-shadow:0 12px 28px var(--shadow)}
.promo:hover{transform:scale(1.03) rotate(-.5deg)}
.promo h4{font-weight:800}

/* ===== ABOUT ===== */
.about-img{position:relative;text-align:center}
.about-img .blob{position:absolute;inset:6% 4%;background:linear-gradient(135deg,var(--g100),var(--pm2));border-radius:42% 58% 63% 37%/41% 44% 56% 59%;animation:morph 9s ease-in-out infinite}
@keyframes morph{50%{border-radius:60% 40% 35% 65%/55% 60% 40% 45%}}
.about-img img{position:relative;width:88%;filter:drop-shadow(0 25px 25px rgba(0,0,0,.3));animation:floaty 6s ease-in-out infinite}
.about-badge{position:absolute;left:2%;bottom:8%;background:var(--card);border-radius:18px;padding:12px 18px;box-shadow:0 12px 28px var(--shadow);text-align:left;animation:floaty 5s ease-in-out infinite;z-index:3}
.about-badge b{font-size:1.5rem;color:var(--g700);display:block;line-height:1}
.check-list li{margin-bottom:14px;display:flex;gap:12px}
.check-list i{color:var(--g700);font-size:1.25rem}

/* ===== COUNTERS ===== */
.counter-sec{background:linear-gradient(rgba(20,83,45,.92),rgba(20,83,45,.92)),url('https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=1600') center/cover fixed;color:#fff;padding:76px 0}
.counter-sec .num{font-size:3.1rem;font-weight:800;color:#ffd54f}
.counter-sec i{font-size:2.5rem;color:#8bf08f}

/* ===== WHY ===== */
.why-card{background:var(--card);border-radius:26px;padding:34px 24px;text-align:center;height:100%;box-shadow:0 8px 24px var(--shadow);transition:.4s;border:1px solid var(--line);position:relative;overflow:hidden}
.why-card::before{content:"";position:absolute;left:0;top:0;height:5px;width:100%;background:linear-gradient(90deg,var(--g700),var(--orange));transform:scaleX(0);transform-origin:left;transition:.5s}
.why-card:hover::before{transform:scaleX(1)}
.why-card:hover{transform:translateY(-10px)}
.why-card .ico{width:80px;height:80px;border-radius:26px;background:linear-gradient(135deg,var(--g700),var(--g500));color:#fff;font-size:2.1rem;display:grid;place-items:center;margin:0 auto 18px;transform:rotate(-8deg);transition:.4s;box-shadow:0 12px 22px rgba(46,125,50,.35)}
.why-card:hover .ico{transform:rotate(8deg) scale(1.1);background:linear-gradient(135deg,var(--orange),#ffb300)}

/* ===== COMBO (nhiều khung) ===== */
.combo-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:26px}
.cb-card{position:relative;background:var(--card);border:2px solid var(--line);border-radius:30px;overflow:hidden;transition:.4s;display:flex;flex-direction:column;box-shadow:0 10px 28px var(--shadow)}
.cb-card:hover{transform:translateY(-8px);border-color:var(--g500)}
.cb-card.hot{border-color:var(--orange);box-shadow:0 18px 40px rgba(255,122,0,.3)}
.cb-top{position:relative;padding:26px 22px 54px;color:#fff;background:var(--bgc)}
.cb-top::after{content:"";position:absolute;left:0;right:0;bottom:-1px;height:34px;background:var(--card);border-radius:50% 50% 0 0/100% 100% 0 0}
.cb-emo{display:flex;gap:6px;font-size:2.2rem;filter:drop-shadow(0 6px 6px rgba(0,0,0,.3))}
.cb-top h4{margin:10px 0 2px;font-weight:800;font-size:1.25rem}.cb-top small{opacity:.92}
.cb-save{position:absolute;top:18px;right:18px;background:#fff;color:#d32f2f;font-weight:800;font-size:.78rem;padding:5px 12px;border-radius:50px;box-shadow:0 6px 14px rgba(0,0,0,.2)}
.cb-flag{position:absolute;top:14px;left:-34px;background:var(--orange);color:#fff;font-size:.72rem;font-weight:700;padding:4px 40px;transform:rotate(-40deg);z-index:2}
.cb-body{padding:4px 24px 24px;flex:1;display:flex;flex-direction:column}
.cb-price{display:flex;align-items:baseline;gap:10px}.cb-price b{font-size:1.9rem;color:#e53935;font-weight:800}.cb-price s{color:var(--muted)}
.cb-body ul{list-style:none;padding:0;margin:12px 0 16px;flex:1}
.cb-body li{padding:6px 0;font-size:.9rem;border-bottom:1px dashed var(--line)}.cb-body li i{color:var(--g500);margin-right:8px}
.cb-gift{background:var(--g100);color:var(--g700);padding:8px 12px;border:1px dashed var(--g500);border-radius:14px;font-size:.82rem;font-weight:600;margin-bottom:14px}

/* ===== FLASH ===== */
.flash{background:linear-gradient(120deg,#ff7a00,#ff4d00);border-radius:32px;color:#fff;position:relative;overflow:hidden;padding:50px 44px;box-shadow:0 18px 40px rgba(255,100,0,.35)}
.flash::before{content:"";position:absolute;width:400px;height:400px;border-radius:50%;background:rgba(255,255,255,.12);right:-90px;top:-120px}
.time-box{display:inline-block;background:#fff;color:#e65100;border-radius:16px;width:78px;padding:10px 0;margin-right:8px;text-align:center;box-shadow:0 8px 16px rgba(0,0,0,.2)}
.time-box b{display:block;font-size:1.9rem;line-height:1}
.time-box small{font-size:.7rem}
.flash img{filter:drop-shadow(0 20px 20px rgba(0,0,0,.4));animation:floaty 5s ease-in-out infinite;max-width:100%}

/* ===== PROCESS ===== */
.step{text-align:center;position:relative}
.step .circle{width:104px;height:104px;margin:0 auto 16px;border-radius:50%;background:var(--card);border:3px dashed var(--g500);display:grid;place-items:center;font-size:2.5rem;color:var(--g700);transition:.4s;box-shadow:0 10px 22px var(--shadow)}
.step:hover .circle{background:var(--g700);color:#fff;border-style:solid;transform:scale(1.1) rotate(8deg)}
@media(min-width:992px){.step:not(:last-child)::after{content:"\F138";font-family:bootstrap-icons;position:absolute;top:32px;right:-14px;font-size:1.9rem;color:var(--orange)}}

/* ===== TESTIMONIAL ===== */
.testi{background:var(--card);border-radius:26px;padding:32px;box-shadow:0 10px 26px var(--shadow);height:100%;position:relative;border:1px solid var(--line);transition:.4s}
.testi:hover{transform:translateY(-8px)}
.testi::before{content:"\201C";font-family:serif;font-size:7rem;color:var(--g100);position:absolute;top:-6px;right:24px;line-height:1}
.testi img{width:60px;height:60px;border-radius:50%;object-fit:cover;border:3px solid var(--g500)}
.stars{color:#ffb300}

/* ===== BLOG ===== */
.blog-card{background:var(--card);border-radius:26px;overflow:hidden;box-shadow:0 10px 26px var(--shadow);transition:.4s;height:100%;border:1px solid var(--line)}
.blog-card:hover{transform:translateY(-10px)}
.blog-card .thumb{height:210px;overflow:hidden;position:relative}
.blog-card .thumb img{width:100%;height:100%;object-fit:cover;transition:.7s}
.blog-card:hover .thumb img{transform:scale(1.14)}
.blog-card .date{position:absolute;left:14px;top:14px;background:var(--orange);color:#fff;font-size:.75rem;font-weight:700;padding:5px 12px;border-radius:50px}
.blog-card a.more{color:var(--g700);font-weight:700}
.blog-card h5{color:var(--text)}

/* ===== FAQ ===== */
.accordion-item{border:1px solid var(--line)!important;margin-bottom:12px;border-radius:18px!important;overflow:hidden;box-shadow:0 4px 14px var(--shadow);background:var(--card);color:var(--text)}
.accordion-button{background:var(--card);color:var(--text);font-weight:600}
.accordion-button:not(.collapsed){background:var(--g100);color:var(--g700);box-shadow:none}

/* ===== MARQUEE ===== */
.marquee{position:relative;overflow:hidden;white-space:nowrap;background:var(--card);padding:24px 0;border-block:1px solid var(--line)}
.marquee-track{display:inline-flex;gap:64px;animation:scrollx 28s linear infinite}
.marquee span{font-weight:700;color:var(--muted);font-size:1.15rem}
.marquee i{color:var(--g500);margin-right:8px}
@keyframes scrollx{to{transform:translateX(-50%)}}

/* ===== NEWSLETTER / FOOTER ===== */
.news-box{background:linear-gradient(120deg,var(--g800),var(--g500));border-radius:32px;color:#fff;padding:50px 42px;box-shadow:0 16px 36px var(--shadow)}
.news-box input{border-radius:50px;border:0;padding:13px 22px}
footer{position:relative;background:#0f3d20;color:#cfe3d2;padding-top:64px}
[data-theme="dark"] footer{background:#06100a}
footer h6{color:#fff;font-weight:700;margin-bottom:16px}
footer a{color:#cfe3d2;display:block;margin-bottom:8px;transition:.25s}
footer a:hover{color:#ffd54f;padding-left:6px}
.social a{display:inline-grid;place-items:center;width:42px;height:42px;border-radius:50%;background:rgba(255,255,255,.12);margin-right:8px;color:#fff}
.social a:hover{background:var(--orange);padding:0}
.copy{border-top:1px solid rgba(255,255,255,.12);margin-top:36px;padding:16px 0;font-size:.85rem}

/* ===== MISC ===== */
#toTop{position:fixed;right:22px;bottom:22px;width:48px;height:48px;border-radius:50%;border:0;background:var(--g700);color:#fff;font-size:1.3rem;box-shadow:0 8px 20px rgba(0,0,0,.3);opacity:0;pointer-events:none;transition:.3s;z-index:1040}
#toTop.show{opacity:1;pointer-events:auto}
.toast-mini{position:fixed;left:50%;bottom:30px;transform:translate(-50%,120px);background:var(--g900);color:#fff;padding:12px 24px;border-radius:50px;z-index:2200;transition:.4s;box-shadow:0 10px 30px rgba(0,0,0,.3)}
.toast-mini.show{transform:translate(-50%,0)}
.offcanvas{background:#0f3d20;color:#fff}
.offcanvas a.m-link{color:#fff;display:block;padding:13px 6px;border-bottom:1px solid rgba(255,255,255,.12);font-weight:600}
.offcanvas a.m-link:hover{color:#ffd54f;padding-left:14px;transition:.25s}

/* ===== SÁNG / TỐI + HIỆU ỨNG ĐÊM ===== */
#fx{position:fixed;inset:0;width:100%;height:100%;pointer-events:none;z-index:1050}
#plexus{position:fixed;inset:0;width:100%;height:100%;z-index:0;pointer-events:none;display:none}
[data-theme="dark"] #plexus{display:block}
.fx-dock{position:fixed;left:18px;bottom:18px;z-index:2100;display:flex;flex-direction:column;align-items:flex-start;gap:10px}
.theme-btn{width:54px;height:54px;border-radius:50%;border:0;background:var(--card);color:var(--g700);box-shadow:0 8px 24px rgba(0,0,0,.3);font-size:1.5rem;transition:.3s}
.theme-btn:hover{transform:rotate(25deg) scale(1.08)}
.fx-panel{display:none;background:var(--card);border:1px solid var(--line);border-radius:20px;padding:12px;box-shadow:0 12px 30px rgba(0,0,0,.45);width:270px;flex-wrap:wrap;gap:6px;backdrop-filter:blur(12px)}
.fx-panel.open{display:flex}
.fx-panel .ttl{width:100%;font-size:.78rem;font-weight:700;color:var(--muted);margin-bottom:2px}
.fx-panel button{border:1px solid var(--line);background:transparent;color:var(--text);border-radius:50px;padding:6px 12px;font-size:.82rem;transition:.2s}
.fx-panel button:hover{border-color:var(--g500)}
.fx-panel button.on{background:var(--g700);color:#fff;border-color:var(--g700)}

/* ===== DARK MODE: nền mạng lưới, thẻ kính mờ ===== */
[data-theme="dark"] body{background:radial-gradient(1200px 700px at 85% -10%,#0d2a52 0,transparent 60%),radial-gradient(900px 600px at 0 40%,#2a0f1c 0,transparent 55%),#040b18}
[data-theme="dark"] .section,[data-theme="dark"] .sec-alt,[data-theme="dark"] .marquee{background:transparent}
[data-theme="dark"] .wave path{fill:rgba(7,20,40,.55)}
[data-theme="dark"] .topbar{background:#061a33}
[data-theme="dark"] .site-header,[data-theme="dark"] .p-card,[data-theme="dark"] .cb-card,[data-theme="dark"] .why-card,[data-theme="dark"] .testi,[data-theme="dark"] .blog-card,[data-theme="dark"] .feature-box,[data-theme="dark"] .accordion-item{backdrop-filter:blur(12px)}
[data-theme="dark"] .p-card,[data-theme="dark"] .cb-card,[data-theme="dark"] .why-card,[data-theme="dark"] .testi,[data-theme="dark"] .blog-card{border-color:var(--line);box-shadow:0 0 0 1px rgba(90,160,255,.08),0 18px 40px rgba(0,0,0,.5)}
[data-theme="dark"] .p-card:hover,[data-theme="dark"] .cb-card:hover{box-shadow:0 0 28px rgba(60,170,255,.35);border-color:#3aa8ff}
[data-theme="dark"] .chip{background:#0c1e36;color:#bfe6ff}
[data-theme="dark"] .p-media .frame img{border-color:#0c1e36}
[data-theme="dark"] .frame::after{border-color:rgba(100,190,255,.5)}
[data-theme="dark"] .frame::before{background:linear-gradient(135deg,#2bb5ff,#ff5a3c)}
[data-theme="dark"] .cb-top::after{background:rgba(11,25,48,.95)}
[data-theme="dark"] .why-card .ico{color:#fff}
[data-theme="dark"] .hero::after{background:linear-gradient(100deg,rgba(2,10,28,.86),rgba(2,10,28,.5) 60%,rgba(2,10,28,.2))}
[data-theme="dark"] .hero::before{content:"";position:absolute;z-index:1;top:64px;left:46%;width:84px;height:84px;border-radius:50%;background:radial-gradient(circle at 35% 35%,#fffbe6,#f2e7b6 55%,#cfc28a);box-shadow:0 0 40px 14px rgba(255,250,210,.4),0 0 120px 50px rgba(120,170,255,.25)}

/* ===== RESPONSIVE ===== */
@media(max-width:1199px){.p-grid{grid-template-columns:repeat(2,1fr)}.p-item.big{grid-row:auto}}
@media(max-width:991px){
  .feature-item{border:0;padding:10px}.hero{padding:70px 0 150px}.flash{padding:30px 22px}
  .combo-grid{grid-template-columns:repeat(2,1fr)}
  [data-theme="dark"] .hero::before{left:auto;right:8%}
}
@media(max-width:767px){.hero-clock{display:none}}
@media(max-width:575px){.p-grid,.combo-grid{grid-template-columns:1fr}.p-item.big{grid-column:auto}}
@media(prefers-reduced-motion:reduce){.hero *,.marquee-track{animation:none!important}}

/* ===== HERO SLIDER ===== */
.hero .slides{position:relative;z-index:2;width:100%;display:grid}
.hs{grid-area:1/1;position:relative;opacity:0;visibility:hidden;transition:opacity .8s,visibility .8s}
.hs.active{opacity:1;visibility:visible}
.hs-inner{display:flex}
.hs-text{max-width:620px}
.hs.pos-left .hs-inner{justify-content:flex-start;text-align:left}
.hs.pos-right .hs-inner{justify-content:flex-end;text-align:right}
.hs.pos-center .hs-inner{justify-content:center;text-align:center}
.hs-sub{font-size:.55em;display:block;opacity:.95;margin-top:8px}
.hs .fs-5{font-size:1.05rem!important;line-height:1.7;margin-top:16px!important;max-width:540px}
.hs.pos-right .fs-5{margin-left:auto}.hs.pos-center .fs-5{margin-inline:auto}
.hero-list{display:flex;flex-wrap:wrap;gap:10px;margin-top:22px!important}
.hero-list li{display:flex;align-items:center;margin:0;font-size:.92rem;background:rgba(255,255,255,.14);backdrop-filter:blur(8px);border:1px solid rgba(255,255,255,.22);padding:7px 16px;border-radius:50px}
.hero-list i{color:#8bf08f;margin-right:8px}
.hero-list li>i:first-child{display:none}
.hs.pos-right .hero-list,.hs.pos-right .hs-btns{justify-content:flex-end}
.hs.pos-center .hero-list,.hs.pos-center .hs-btns{justify-content:center}
.hs-btns{margin-top:30px!important}
.hs .anim{opacity:0;transform:translateY(26px)}
.hs.active .anim{animation:slideUp .8s forwards}
.hs.active .a2{animation-delay:.15s}.hs.active .a3{animation-delay:.3s}
.hs.active .a4{animation-delay:.45s}.hs.active .a5{animation-delay:.6s}
@keyframes slideUp{to{opacity:1;transform:none}}

.emoji-layer{position:absolute;inset:0;pointer-events:none;z-index:1}
.emoji-layer span{position:absolute;font-size:clamp(1.9rem,3.4vw,3.1rem);opacity:.92;filter:drop-shadow(0 14px 14px rgba(0,0,0,.45));animation:floaty 5s ease-in-out infinite}
.emoji-layer span:nth-child(2n){animation-delay:1.1s}
.emoji-layer span:nth-child(3n){animation-delay:2.2s}

.hs-arrow{position:absolute;top:50%;transform:translateY(-50%);z-index:4;width:46px;height:46px;border-radius:50%;border:0;background:rgba(255,255,255,.2);color:#fff;font-size:1.3rem;backdrop-filter:blur(6px);transition:.25s}
.hs-arrow:hover{background:var(--orange)}
.hs-arrow.prev{left:14px}.hs-arrow.next{right:14px}
.hs-dots{position:absolute;left:50%;bottom:112px;transform:translateX(-50%);z-index:4;display:flex;gap:8px}
.hs-dots button{width:11px;height:11px;border-radius:50px;border:0;background:rgba(255,255,255,.5);padding:0;transition:.35s}
.hs-dots button.on{width:34px;background:var(--orange)}
@media(max-width:991px){.emoji-layer{display:none}.hs-arrow{display:none}.hs.pos-right .hs-inner,.hs.pos-left .hs-inner{text-align:center;justify-content:center}.hs.pos-right .hero-list,.hs.pos-left .hero-list,.hs.pos-right .hs-btns,.hs.pos-left .hs-btns{justify-content:center}.hs.pos-right .fs-5,.hs.pos-left .fs-5{margin-inline:auto}}
@media(prefers-reduced-motion:reduce){.hs .anim{opacity:1;transform:none;animation:none!important}}
</style>
</head>
<body>

<canvas id="fx"></canvas>
<canvas id="plexus"></canvas>

<!-- ================= TOP BAR ================= -->
<div class="topbar">
  <div class="container tb">
    <span><i class="bi bi-truck me-1"></i>Miễn phí giao hàng đơn từ 199.000₫</span>
    <span class="d-none d-md-inline"><i class="bi bi-gift me-1"></i>Mã NONGSAN10 giảm 10% đơn đầu tiên</span>
    <a href="tel:0987654321"><i class="bi bi-telephone me-1"></i>0987 654 321</a>
  </div>
</div>

<!-- ================= HEADER ================= -->
<header class="site-header">
  <div class="container py-2">
    <div class="d-flex align-items-center justify-content-between gap-3">
      <button class="burger" data-bs-toggle="offcanvas" data-bs-target="#menuMobile" aria-label="Menu"><i class="bi bi-list"></i></button>

      <a href="${ctx}/trang-chu" class="brand">
        <i class="bi bi-flower3"></i>
        <span><b>Nông Sản Xanh</b><small>Tươi ngon từ thiên nhiên</small></span>
      </a>

      <form class="search-box flex-grow-1 d-none d-lg-flex" style="max-width:560px" action="${ctx}/tim-kiem" method="get">
        <input type="text" name="q" placeholder="Tìm kiếm rau củ, quả...">
        <button type="submit"><i class="bi bi-search"></i></button>
      </form>

      <div class="d-flex align-items-center gap-2">
        <div class="d-none d-xxl-flex align-items-center me-2 text-green">
          <i class="bi bi-telephone-fill fs-3 me-2"></i>
          <div class="lh-1"><small class="text-muted">Hotline</small><br><b class="fs-5">0987 654 321</b></div>
        </div>
        <a href="${ctx}/dang-nhap" class="btn-auth d-none d-md-inline-flex"><i class="bi bi-person"></i> Đăng nhập</a>
        <a href="${ctx}/dang-ky" class="btn-auth solid d-none d-md-inline-flex">Đăng ký</a>
        <button class="icon-btn" title="Yêu thích"><i class="bi bi-heart"></i><span class="badge rounded-pill bg-danger" id="favCount">0</span></button>
        <button class="icon-btn" title="Giỏ hàng"><i class="bi bi-cart3"></i><span class="badge rounded-pill bg-danger" id="cartCount">0</span></button>
      </div>
    </div>
  </div>
  <div class="nav-row d-none d-lg-block">
    <div class="container">
      <nav class="main-nav">
        <a href="#top" class="active"><i class="bi bi-house-fill me-1"></i>Trang chủ</a>
        <a href="danh-muc">Danh mục</a>
        <a href="#san-pham">Sản phẩm</a>
        <a href="#khuyen-mai">Khuyến mãi</a>
        <a href="#combo">Combo</a>
        <a href="#tin-tuc">Tin tức</a>
        <a href="#gioi-thieu">Giới thiệu</a>
        <a href="#lien-he">Liên hệ</a>
      </nav>
    </div>
  </div>
</header>

<!-- ================= MENU 3 GẠCH ================= -->
<div class="offcanvas offcanvas-start" tabindex="-1" id="menuMobile">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title script fs-2"><i class="bi bi-flower3 text-success"></i> Nông Sản Xanh</h5>
    <button class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
  </div>
  <div class="offcanvas-body">
    <form class="search-box mb-3" style="background:#fff" action="${ctx}/tim-kiem">
      <input type="text" name="q" placeholder="Tìm sản phẩm..." style="color:#222"><button><i class="bi bi-search"></i></button>
    </form>
    <a class="m-link" href="#top"><i class="bi bi-house me-2"></i>Trang chủ</a>
    <a class="m-link" href="#danh-muc"><i class="bi bi-grid me-2"></i>Danh mục sản phẩm</a>
    <a class="m-link" href="#san-pham"><i class="bi bi-basket me-2"></i>Sản phẩm nổi bật</a>
    <a class="m-link" href="#khuyen-mai"><i class="bi bi-lightning-charge me-2"></i>Khuyến mãi</a>
    <a class="m-link" href="#combo"><i class="bi bi-box2-heart me-2"></i>Combo tiết kiệm</a>
    <a class="m-link" href="#tin-tuc"><i class="bi bi-newspaper me-2"></i>Tin tức</a>
    <a class="m-link" href="#gioi-thieu"><i class="bi bi-info-circle me-2"></i>Giới thiệu</a>
    <a class="m-link" href="#lien-he"><i class="bi bi-telephone me-2"></i>Liên hệ</a>
    <div class="d-flex gap-2 mt-4">
      <a href="${ctx}/dang-nhap" class="btn btn-outline-light rounded-pill flex-fill">Đăng nhập</a>
      <a href="${ctx}/dang-ky" class="btn btn-warning rounded-pill flex-fill fw-bold">Đăng ký</a>
    </div>
    <div class="mt-4 small text-white-50"><i class="bi bi-telephone-fill"></i> Hotline: 0987 654 321</div>
  </div>
</div>

<!-- ================= PHẦN 1: HERO VIDEO ================= -->
<section class="hero" id="top">
  <video id="heroVideo" autoplay muted loop playsinline
         poster="https://images.unsplash.com/photo-1542838132-92c53300491e?w=1600">
    <source src="https://assets.mixkit.co/videos/48128/48128-720.mp4" type="video/mp4">
    <source src="${ctx}/videos/banner.mp4" type="video/mp4">
  </video>

  <div class="slides" id="heroSlides">
    <c:forEach var="sl" items="${danhSachSlide}" varStatus="st">
      <div class="hs pos-${sl.viTri} ${st.first ? 'active' : ''}">

        <%-- Emoji bay lơ lửng, vị trí tính theo viTri --%>
        <div class="emoji-layer">
          <c:forEach var="ic" items="${sl.iconList}" varStatus="e">
            <c:choose>
              <c:when test="${sl.viTri == 'right'}">
                <c:set var="x" value="${4 + (e.index % 3) * 14}"/>
              </c:when>
              <c:when test="${sl.viTri == 'center'}">
                <c:set var="x" value="${e.index % 2 == 0 ? 3 + (e.index % 3) * 5 : 82 + (e.index % 3) * 4}"/>
              </c:when>
              <c:otherwise>
                <c:set var="x" value="${60 + (e.index % 3) * 13}"/>
              </c:otherwise>
            </c:choose>
            <c:set var="y" value="${sl.viTri == 'center' ? 10 + (e.index div 2) * 26 : 10 + (e.index div 3) * 40 + (e.index % 3) * 6}"/>
            <span style="left:${x}%;top:${y}%"><c:out value="${ic}"/></span>
          </c:forEach>
        </div>

        <div class="container position-relative" style="z-index:2">
          <div class="hs-inner">
            <div class="hs-text">
              <c:if test="${not empty sl.badge}">
                <span class="badge bg-warning text-dark rounded-pill px-3 py-2 mb-3 anim"><c:out value="${sl.badge}"/></span>
              </c:if>

              <h1 class="script anim a2">
                <span class="d-block"><c:out value="${sl.tieuDe}"/></span>
                <c:if test="${not empty sl.tieuDePhu}">
                  <span class="d-block hs-sub"><c:out value="${sl.tieuDePhu}"/></span>
                </c:if>
              </h1>

              <c:if test="${not empty sl.moTa}">
                <p class="fs-5 mt-2 mb-0 anim a3"><c:out value="${sl.moTa}"/></p>
              </c:if>

              <ul class="list-unstyled hero-list mt-3 anim a4">
                <c:forEach var="d" items="${sl.dacDiemList}">
                  <li><i class="bi bi-check-circle-fill"></i>
                      <i class="bi <c:out value='${d[0]}'/> me-2"></i><c:out value="${d[1]}"/></li>
                </c:forEach>
              </ul>

              <div class="d-flex flex-wrap gap-3 mt-3 hs-btns anim a5">
                <c:if test="${not empty sl.nutChu}">
                  <a href="<c:out value='${sl.nutLink}'/>" class="btn-orange"><c:out value="${sl.nutChu}"/> <i class="bi bi-arrow-right"></i></a>
                </c:if>
                <a href="#gioi-thieu" class="btn-ghost">Tìm hiểu thêm</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>

  <button class="hs-arrow prev" id="hsPrev" aria-label="Slide trước"><i class="bi bi-chevron-left"></i></button>
  <button class="hs-arrow next" id="hsNext" aria-label="Slide sau"><i class="bi bi-chevron-right"></i></button>
  <div class="hs-dots" id="hsDots"></div>

  <!-- Đồng hồ -->
  <div class="hero-clock" id="heroClock">
    <div class="t">00:00<i>00</i></div>
    <div class="d"></div>
    <div class="s"></div>
  </div>

  <button class="video-toggle" id="videoToggle" title="Phát / tạm dừng"><i class="bi bi-pause-fill"></i></button>
  <a href="#danh-muc" class="scroll-down"><i class="bi bi-chevron-double-down"></i></a>
</section>

<!-- ================= FEATURE STRIP ================= -->
<section class="feature-strip">
  <div class="container">
    <div class="feature-box row g-0" data-aos="fade-up">
      <div class="col-6 col-lg-3"><div class="feature-item"><i class="bi bi-shield-check"></i><div><b>100% Nông sản sạch</b><small>An toàn cho sức khỏe</small></div></div></div>
      <div class="col-6 col-lg-3"><div class="feature-item"><i class="bi bi-truck"></i><div><b>Giao hàng nhanh</b><small>Toàn quốc</small></div></div></div>
      <div class="col-6 col-lg-3"><div class="feature-item"><i class="bi bi-arrow-repeat"></i><div><b>Đổi trả linh hoạt</b><small>Trong 7 ngày</small></div></div></div>
      <div class="col-6 col-lg-3"><div class="feature-item"><i class="bi bi-headset"></i><div><b>Tư vấn miễn phí</b><small>24/7</small></div></div></div>
    </div>
  </div>
</section>

<!-- ================= DANH MỤC ================= -->
<section class="section" id="danh-muc">
  <div class="container">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Khám phá</span><h2>Danh mục sản phẩm</h2><div class="line"></div>
    </div>
    <div class="row g-3 g-lg-4 row-cols-2 row-cols-md-3 row-cols-lg-6">
      <c:forEach var="d" items="${danhSachDanhMuc}" varStatus="st">
        <div class="col" data-aos="zoom-in" data-aos-delay="${st.index * 80}">
          <a href="${ctx}/danh-muc?ma=${d.maDanhMuc}" class="cat-card c${(st.index % 6) + 1}">
            <span class="ico"><i class="${d.icon}"></i></span>
            <b><c:out value="${d.tenDanhMuc}"/></b>
            <small><c:out value="${empty soLuongTheoDM[d.id] ? 0 : soLuongTheoDM[d.id]}"/> sản phẩm</small>
          </a>
        </div>
      </c:forEach>
    </div>

    <c:if test="${empty danhSachDanhMuc}">
      <div class="text-center text-muted py-4">Chưa có danh mục nào.</div>
    </c:if>
  </div>
</section>

<!-- ================= SẢN PHẨM NỔI BẬT ================= -->
<svg class="wave" viewBox="0 0 1440 60" preserveAspectRatio="none"><path d="M0,30 C240,70 480,0 720,30 C960,60 1200,10 1440,30 L1440,60 L0,60 Z"/></svg>
<section class="section sec-alt" id="san-pham" style="padding-top:40px;overflow:hidden">
  <div class="sec-deco">
    <span style="left:3%;top:12%">🥕</span><span style="right:4%;top:18%;animation-delay:1s">🍅</span>
    <span style="left:6%;bottom:8%;animation-delay:2s">🥬</span><span style="right:6%;bottom:10%;animation-delay:3s">🍋</span>
  </div>
  <div class="container position-relative">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Được yêu thích nhất</span><h2>Sản phẩm nổi bật</h2><div class="line"></div>
    </div>

    <div class="p-grid">
      <c:forEach var="sp" items="${danhSachNoiBat}" varStatus="st">
        <div class="p-item ${st.first ? 'big' : ''}" data-aos="fade-up" data-aos-delay="${(st.index % 4) * 80}">
          <div class="p-card">
            <div class="p-media">
              <span class="p-tag"><i class="bi bi-stars"></i> ${st.first ? 'Sản phẩm của ngày' : 'Mới'}</span>
              <button class="heart" type="button" data-id="${sp.id}" title="Yêu thích"><i class="bi bi-heart-fill"></i></button>
              <div class="frame f${st.index % 4}">
                <img src="${sp.hinhAnh}" alt="${sp.ten}" onerror="this.src='https://placehold.co/400x400/e8f5e9/2e7d32?text=No+Image'">
              </div>
              <span class="chip ca"><i class="bi bi-patch-check-fill text-success"></i> Hữu cơ</span>
              <span class="chip cz"><i class="bi bi-star-fill text-warning"></i> 4.8</span>
            </div>
            <div class="p-body">
              <h5 class="text-truncate">${sp.ten}</h5>
          <p class="p-desc"><c:out value="${sp.motaNgan}"/></p>
              <div class="p-foot">
                <div>
                  <div class="p-price"><fmt:formatNumber value="${sp.gia}" type="number" groupingUsed="true"/>₫</div>
                  <span class="p-stock"><i class="bi bi-check2-circle"></i> Còn hàng</span>
                </div>
                <button class="btn-cart add-cart" type="button" title="Thêm vào giỏ"><i class="bi bi-cart-plus"></i></button>
              </div>
              <div class="p-actions">
                <a class="btn-detail" href="${ctx}/chi-tiet?id=${sp.id}"><i class="bi bi-eye"></i> Xem chi tiết</a>
 <a class="btn-pay" href="${ctx}/thanh-toan?id=${sp.id}&soLuong=1"><i class="bi bi-credit-card"></i> Thanh toán</a>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>

   <c:if test="${empty danhSachNoiBat}">
      <div class="text-center text-muted py-5">
        <i class="bi bi-inbox fs-1"></i><p class="mt-2">Chưa có sản phẩm nào trong cơ sở dữ liệu.</p>
      </div>
    </c:if>
  </div>
</section>
<svg class="wave flip" viewBox="0 0 1440 60" preserveAspectRatio="none"><path d="M0,30 C240,70 480,0 720,30 C960,60 1200,10 1440,30 L1440,60 L0,60 Z"/></svg>

<!-- ================= KHUYẾN MÃI ================= -->
<section class="pb-5 pt-4" id="khuyen-mai">
  <div class="container">
    <div class="row g-4">
      <div class="col-lg-4" data-aos="fade-right">
        <div class="promo h-100" style="background-image:linear-gradient(90deg,rgba(255,122,0,.92),rgba(255,122,0,.25)),url('https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800')">
          <div><small>Khuyến mãi đặc biệt</small><h4 class="script fs-1">Giảm đến 30%</h4><a href="#san-pham" class="btn btn-light rounded-pill btn-sm fw-bold px-3">Mua ngay</a></div>
        </div>
      </div>
      <div class="col-lg-4" data-aos="fade-up">
        <div class="promo h-100" style="background-image:linear-gradient(90deg,rgba(20,83,45,.92),rgba(20,83,45,.25)),url('https://images.unsplash.com/photo-1566385101042-1a0aa0c1268c?w=800')">
          <div><small>Giao hàng nhanh chóng</small><h4 class="script fs-1">Trong 2h nội thành</h4><a href="#" class="btn btn-light rounded-pill btn-sm fw-bold px-3">Đặt hàng</a></div>
        </div>
      </div>
      <div class="col-lg-4" data-aos="fade-left">
        <div class="promo h-100" style="background-image:linear-gradient(90deg,rgba(0,100,60,.92),rgba(0,100,60,.25)),url('https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800')">
          <div><small>Nông sản sạch</small><h4 class="script fs-1">Cho gia đình Việt</h4><a href="#gioi-thieu" class="btn btn-light rounded-pill btn-sm fw-bold px-3">Khám phá</a></div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ================= COMBO (6 khung, dữ liệu trong JS cuối file) ================= -->
<section class="section sec-alt" id="combo">
  <div class="container">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Tiết kiệm hơn</span><h2>Combo nông sản theo nhu cầu</h2><div class="line"></div>
    </div>
    <div class="combo-grid" id="comboGrid" data-ctx="${ctx}"></div>
  </div>
</section>

<!-- ================= PHẦN 2: GIỚI THIỆU ================= -->
<section class="section" id="gioi-thieu">
  <div class="container">
    <div class="row align-items-center g-5">
      <div class="col-lg-6" data-aos="fade-right">
        <div class="about-img">
          <div class="blob"></div>
          <img src="${ctx}/images/cutout/gioi-thieu.png" alt="Nông sản sạch"
               onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1540420773420-3366772f4999?w=700';this.style.borderRadius='50%';this.style.aspectRatio='1';this.style.objectFit='cover'">
          <div class="about-badge"><b>10+ năm</b><small class="text-muted">đồng hành cùng nhà vườn</small></div>
        </div>
      </div>
      <div class="col-lg-6" data-aos="fade-left">
        <span class="script fs-3 text-warning">Về chúng tôi</span>
        <h2 class="fw-bold display-6 mb-3" style="color:var(--head)">Mang vườn xanh đến tận bàn ăn của bạn</h2>
        <p class="text-muted">Nông Sản Xanh liên kết trực tiếp với hơn 120 nhà vườn đạt chuẩn VietGAP và GlobalGAP trên khắp cả nước. Mỗi sản phẩm đều được thu hoạch trong ngày, kiểm định chất lượng và đóng gói cẩn thận trước khi đến tay bạn.</p>
        <ul class="list-unstyled check-list my-4">
          <li><i class="bi bi-check-circle-fill"></i><span>Truy xuất nguồn gốc rõ ràng bằng mã QR trên từng bao bì.</span></li>
          <li><i class="bi bi-check-circle-fill"></i><span>Không sử dụng thuốc trừ sâu hóa học, không chất bảo quản.</span></li>
          <li><i class="bi bi-check-circle-fill"></i><span>Giá trực tiếp từ vườn, hỗ trợ bà con nông dân bán được giá tốt.</span></li>
          <li><i class="bi bi-check-circle-fill"></i><span>Đóng gói thân thiện môi trường, giữ độ tươi đến 48 giờ.</span></li>
        </ul>
        <a href="#" class="btn-orange d-inline-block">Xem câu chuyện của chúng tôi</a>
      </div>
    </div>
  </div>
</section>

<!-- ================= SỐ LIỆU ================= -->
<section class="counter-sec">
  <div class="container">
    <div class="row text-center g-4">
      <div class="col-6 col-md-3" data-aos="zoom-in"><i class="bi bi-people-fill"></i><div class="num"><span class="count" data-to="25000">0</span>+</div>Khách hàng tin dùng</div>
      <div class="col-6 col-md-3" data-aos="zoom-in" data-aos-delay="100"><i class="bi bi-basket3-fill"></i><div class="num"><span class="count" data-to="350">0</span>+</div>Loại nông sản</div>
      <div class="col-6 col-md-3" data-aos="zoom-in" data-aos-delay="200"><i class="bi bi-tree-fill"></i><div class="num"><span class="count" data-to="120">0</span></div>Nhà vườn liên kết</div>
      <div class="col-6 col-md-3" data-aos="zoom-in" data-aos-delay="300"><i class="bi bi-geo-alt-fill"></i><div class="num"><span class="count" data-to="63">0</span></div>Tỉnh thành giao tới</div>
    </div>
  </div>
</section>

<!-- ================= VÌ SAO CHỌN ================= -->
<section class="section">
  <div class="container">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Cam kết của chúng tôi</span><h2>Vì sao chọn Nông Sản Xanh?</h2><div class="line"></div>
    </div>
    <div class="row g-4">
      <div class="col-md-6 col-lg-3" data-aos="flip-left"><div class="why-card"><div class="ico"><i class="bi bi-patch-check-fill"></i></div><h5 class="fw-bold">Chuẩn VietGAP</h5><p class="text-muted small mb-0">Mọi sản phẩm đều đạt tiêu chuẩn an toàn thực phẩm, có giấy chứng nhận rõ ràng.</p></div></div>
      <div class="col-md-6 col-lg-3" data-aos="flip-left" data-aos-delay="100"><div class="why-card"><div class="ico"><i class="bi bi-snow2"></i></div><h5 class="fw-bold">Bảo quản lạnh</h5><p class="text-muted small mb-0">Vận chuyển bằng xe lạnh chuyên dụng, giữ trọn độ tươi và dinh dưỡng.</p></div></div>
      <div class="col-md-6 col-lg-3" data-aos="flip-left" data-aos-delay="200"><div class="why-card"><div class="ico"><i class="bi bi-cash-coin"></i></div><h5 class="fw-bold">Giá tốt từ vườn</h5><p class="text-muted small mb-0">Không qua trung gian nên giá luôn hợp lý, nhiều ưu đãi mỗi tuần.</p></div></div>
      <div class="col-md-6 col-lg-3" data-aos="flip-left" data-aos-delay="300"><div class="why-card"><div class="ico"><i class="bi bi-heart-pulse-fill"></i></div><h5 class="fw-bold">Tốt cho sức khỏe</h5><p class="text-muted small mb-0">Thực đơn lành mạnh cho cả gia đình, đầy đủ vitamin và chất xơ.</p></div></div>
    </div>
  </div>
</section>

<!-- ================= FLASH SALE ================= -->
<section class="pb-5">
  <div class="container">
    <div class="flash" data-aos="zoom-in">
      <div class="row align-items-center g-4">
        <div class="col-lg-7 position-relative">
          <span class="script fs-3">Ưu đãi trong ngày</span>
          <h2 class="fw-bold display-6">Combo rau củ gia đình – Giảm 25%</h2>
          <p>Gồm 8 loại rau củ tươi theo mùa, đủ cho gia đình 4 người dùng trong 3 ngày.</p>
          <div class="mb-4">
            <div class="time-box"><b id="cdH">00</b><small>Giờ</small></div>
            <div class="time-box"><b id="cdM">00</b><small>Phút</small></div>
            <div class="time-box"><b id="cdS">00</b><small>Giây</small></div>
          </div>
          <a href="#combo" class="btn btn-light rounded-pill fw-bold px-4 py-2 text-danger">Đặt combo ngay</a>
        </div>
        <div class="col-lg-5 text-center"><img src="${ctx}/images/cutout/combo.png" alt="" onerror="this.style.display='none'"></div>
      </div>
    </div>
  </div>
</section>

<!-- ================= QUY TRÌNH ================= -->
<section class="section sec-alt">
  <div class="container">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Từ nông trại đến bàn ăn</span><h2>Quy trình 4 bước</h2><div class="line"></div>
    </div>
    <div class="row g-4">
      <div class="col-6 col-lg-3 step" data-aos="fade-up"><div class="circle"><i class="bi bi-flower2"></i></div><h6 class="fw-bold">Gieo trồng</h6><p class="small text-muted">Canh tác hữu cơ tại các nhà vườn đạt chuẩn.</p></div>
      <div class="col-6 col-lg-3 step" data-aos="fade-up" data-aos-delay="100"><div class="circle"><i class="bi bi-scissors"></i></div><h6 class="fw-bold">Thu hoạch</h6><p class="small text-muted">Hái trực tiếp trong ngày để giữ độ tươi.</p></div>
      <div class="col-6 col-lg-3 step" data-aos="fade-up" data-aos-delay="200"><div class="circle"><i class="bi bi-box-seam"></i></div><h6 class="fw-bold">Kiểm định &amp; đóng gói</h6><p class="small text-muted">Kiểm tra kỹ lưỡng, đóng gói sạch sẽ.</p></div>
      <div class="col-6 col-lg-3 step" data-aos="fade-up" data-aos-delay="300"><div class="circle"><i class="bi bi-bicycle"></i></div><h6 class="fw-bold">Giao tận nhà</h6><p class="small text-muted">Giao nhanh trong 2 giờ tại nội thành.</p></div>
    </div>
  </div>
</section>

<!-- ================= ĐÁNH GIÁ ================= -->
<section class="section">
  <div class="container">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Khách hàng nói gì</span><h2>Phản hồi từ khách hàng</h2><div class="line"></div>
    </div>
    <div class="row g-4">
      <div class="col-lg-4" data-aos="fade-up"><div class="testi"><div class="stars mb-2"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
        <p class="text-muted">Rau rất tươi, lá không bị dập, giao đến còn mát lạnh. Gia đình mình đặt hàng mỗi tuần và con nhỏ rất thích ăn rau.</p>
        <div class="d-flex align-items-center gap-3"><img src="https://i.pravatar.cc/120?img=47" alt=""><div><b>Chị Thu Hà</b><br><small class="text-muted">Quận 3, TP.HCM</small></div></div></div></div>
      <div class="col-lg-4" data-aos="fade-up" data-aos-delay="120"><div class="testi"><div class="stars mb-2"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
        <p class="text-muted">Giá hợp lý hơn siêu thị mà chất lượng tốt hơn hẳn. Nhân viên tư vấn nhiệt tình, giao hàng đúng giờ.</p>
        <div class="d-flex align-items-center gap-3"><img src="https://i.pravatar.cc/120?img=12" alt=""><div><b>Anh Minh Quân</b><br><small class="text-muted">Thủ Đức, TP.HCM</small></div></div></div></div>
      <div class="col-lg-4" data-aos="fade-up" data-aos-delay="240"><div class="testi"><div class="stars mb-2"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-half"></i></div>
        <p class="text-muted">Mình hay mua trái cây cho quán, cam và cà chua luôn ngọt và đồng đều. Sẽ tiếp tục ủng hộ lâu dài.</p>
        <div class="d-flex align-items-center gap-3"><img src="https://i.pravatar.cc/120?img=32" alt=""><div><b>Cô Lan Anh</b><br><small class="text-muted">Bình Thạnh, TP.HCM</small></div></div></div></div>
    </div>
  </div>
</section>

<!-- ================= ĐỐI TÁC ================= -->
<div class="marquee">
  <div class="marquee-track">
    <span><i class="bi bi-patch-check"></i>VietGAP</span><span><i class="bi bi-globe-asia-australia"></i>GlobalGAP</span><span><i class="bi bi-tree"></i>Đà Lạt Farm</span><span><i class="bi bi-flower1"></i>Organic Việt</span><span><i class="bi bi-droplet"></i>Mộc Châu Fresh</span><span><i class="bi bi-sun"></i>Miền Tây Garden</span>
    <span><i class="bi bi-patch-check"></i>VietGAP</span><span><i class="bi bi-globe-asia-australia"></i>GlobalGAP</span><span><i class="bi bi-tree"></i>Đà Lạt Farm</span><span><i class="bi bi-flower1"></i>Organic Việt</span><span><i class="bi bi-droplet"></i>Mộc Châu Fresh</span><span><i class="bi bi-sun"></i>Miền Tây Garden</span>
  </div>
</div>

<!-- ================= TIN TỨC ================= -->
<section class="section" id="tin-tuc">
  <div class="container">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Góc chia sẻ</span><h2>Tin tức &amp; mẹo hay</h2><div class="line"></div>
    </div>
    <div class="row g-4">
      <div class="col-md-6 col-lg-4" data-aos="fade-up"><div class="blog-card"><div class="thumb"><img src="https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=700" alt=""><span class="date">28/10/2026</span></div><div class="p-4"><h5 class="fw-bold">5 cách bảo quản rau xanh tươi lâu trong tủ lạnh</h5><p class="small text-muted">Những mẹo đơn giản giúp rau giữ độ giòn và màu xanh đến cả tuần.</p><a class="more" href="#">Đọc tiếp <i class="bi bi-arrow-right"></i></a></div></div></div>
      <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="120"><div class="blog-card"><div class="thumb"><img src="https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=700" alt=""><span class="date">22/10/2026</span></div><div class="p-4"><h5 class="fw-bold">Thực đơn eat-clean 7 ngày với nông sản theo mùa</h5><p class="small text-muted">Gợi ý bữa ăn cân bằng, dễ nấu, phù hợp cho dân văn phòng bận rộn.</p><a class="more" href="#">Đọc tiếp <i class="bi bi-arrow-right"></i></a></div></div></div>
      <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="240"><div class="blog-card"><div class="thumb"><img src="https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=700" alt=""><span class="date">15/10/2026</span></div><div class="p-4"><h5 class="fw-bold">Phân biệt rau sạch và rau thường: 4 dấu hiệu dễ nhận biết</h5><p class="small text-muted">Cách chọn mua thực phẩm an toàn mà không cần dụng cụ chuyên dụng.</p><a class="more" href="#">Đọc tiếp <i class="bi bi-arrow-right"></i></a></div></div></div>
    </div>
  </div>
</section>

<!-- ================= FAQ ================= -->
<section class="section sec-alt">
  <div class="container" style="max-width:860px">
    <div class="sec-title" data-aos="fade-up">
      <span class="script">Giải đáp</span><h2>Câu hỏi thường gặp</h2><div class="line"></div>
    </div>
    <div class="accordion" id="faq" data-aos="fade-up">
      <div class="accordion-item"><h2 class="accordion-header"><button class="accordion-button" data-bs-toggle="collapse" data-bs-target="#f1">Thời gian giao hàng là bao lâu?</button></h2><div id="f1" class="accordion-collapse collapse show" data-bs-parent="#faq"><div class="accordion-body">Nội thành giao trong 2 giờ, các tỉnh khác từ 1–3 ngày tùy khu vực.</div></div></div>
      <div class="accordion-item"><h2 class="accordion-header"><button class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#f2">Nếu rau củ bị hư hỏng thì sao?</button></h2><div id="f2" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="accordion-body">Bạn được đổi trả miễn phí trong 24 giờ nếu sản phẩm bị dập hoặc hỏng.</div></div></div>
      <div class="accordion-item"><h2 class="accordion-header"><button class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#f3">Có những hình thức thanh toán nào?</button></h2><div id="f3" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="accordion-body">Thanh toán khi nhận hàng (COD), chuyển khoản ngân hàng hoặc ví điện tử.</div></div></div>
    </div>
  </div>
</section>

<!-- ================= NHẬN TIN ================= -->
<section class="py-5" id="lien-he">
  <div class="container">
    <div class="news-box" data-aos="zoom-in">
      <div class="row align-items-center g-3">
        <div class="col-lg-6"><h3 class="fw-bold mb-1">Đăng ký nhận ưu đãi</h3><p class="mb-0">Nhận mã giảm giá 10% cho đơn hàng đầu tiên và mẹo nấu ăn mỗi tuần.</p></div>
        <div class="col-lg-6"><form class="d-flex gap-2" onsubmit="event.preventDefault();toast('Đăng ký thành công. Cảm ơn bạn!');this.reset()"><input type="email" class="form-control" placeholder="Nhập email của bạn..." required><button class="btn-orange flex-shrink-0">Đăng ký</button></form></div>
      </div>
    </div>
  </div>
</section>

<!-- ================= PHẦN 3: FOOTER ================= -->
<footer>
  <div class="container">
    <div class="row g-4">
      <div class="col-lg-4">
        <a href="#top" class="brand text-white mb-3"><i class="bi bi-flower3"></i><span><b>Nông Sản Xanh</b><small class="text-white-50">Tươi ngon từ thiên nhiên</small></span></a>
        <p class="small">Hệ thống cung cấp thực phẩm sạch, liên kết trực tiếp với các nhà vườn đạt chuẩn VietGAP và GlobalGAP.</p>
        <div class="social"><a href="#"><i class="bi bi-facebook"></i></a><a href="#"><i class="bi bi-youtube"></i></a><a href="#"><i class="bi bi-tiktok"></i></a><a href="#"><i class="bi bi-instagram"></i></a></div>
      </div>
      <div class="col-6 col-lg-2"><h6>Hỗ trợ khách hàng</h6><a href="#">Chính sách mua hàng</a><a href="#">Chính sách đổi trả</a><a href="#">Phương thức thanh toán</a><a href="#">FAQ</a></div>
      <div class="col-6 col-lg-2"><h6>Về chúng tôi</h6><a href="#gioi-thieu">Giới thiệu</a><a href="#tin-tuc">Tin tức</a><a href="#lien-he">Liên hệ</a><a href="#">Tuyển dụng</a></div>
      <div class="col-lg-4"><h6>Liên hệ</h6>
        <p class="small mb-2"><i class="bi bi-geo-alt me-2"></i>123 Đường Nông Nghiệp, Quận 1, TP. HCM</p>
        <p class="small mb-2"><i class="bi bi-telephone me-2"></i>Hotline: 0987 654 321</p>
        <p class="small mb-2"><i class="bi bi-envelope me-2"></i>lienhe@nongsanxanh.vn</p>
        <p class="small"><i class="bi bi-clock me-2"></i>Mở cửa: 6:00 – 21:00 mỗi ngày</p></div>
    </div>
    <div class="copy text-center">&copy; 2026 Nông Sản Xanh. Tất cả quyền được bảo lưu.</div>
  </div>
</footer>

<!-- ================= NÚT SÁNG/TỐI + HIỆU ỨNG ĐÊM ================= -->
<div class="fx-dock">
  <div class="fx-panel" id="fxPanel">
    <div class="ttl"><i class="bi bi-moon-stars"></i> Hiệu ứng ban đêm</div>
    <button data-fx="stars">✨ Sao</button>
    <button data-fx="snow">❄️ Tuyết</button>
    <button data-fx="bats">🦇 Dơi</button>
    <button data-fx="rain">🌧️ Mưa</button>
    <button data-fx="color">🎨 Màu sắc</button>
    <button data-fx="none">🚫 Tắt</button>
  </div>
  <button class="theme-btn" id="themeBtn" title="Chuyển sáng / tối"><i class="bi bi-moon-stars-fill"></i></button>
</div>

<button id="toTop" aria-label="Lên đầu trang"><i class="bi bi-arrow-up"></i></button>
<div class="toast-mini" id="toast"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
<script>
AOS.init({duration:800, once:true, offset:60});

function toast(msg){
  var t=document.getElementById('toast'); t.textContent=msg; t.classList.add('show');
  clearTimeout(window._tt); window._tt=setTimeout(function(){t.classList.remove('show')},2200);
}

/* Giỏ hàng (demo) */
var cart=0;
document.querySelectorAll('.add-cart').forEach(function(b){
  b.addEventListener('click',function(){ cart++; document.getElementById('cartCount').textContent=cart; toast('Đã thêm sản phẩm vào giỏ hàng'); });
});

/* Yêu thích */
var favs=[];
try{ favs=JSON.parse(localStorage.getItem('favs')||'[]'); }catch(e){}
function renderFav(){
  document.getElementById('favCount').textContent=favs.length;
  document.querySelectorAll('.heart').forEach(function(h){ h.classList.toggle('on', favs.indexOf(h.dataset.id)>-1); });
}
document.querySelectorAll('.heart').forEach(function(h){
  h.addEventListener('click',function(){
    var id=h.dataset.id, i=favs.indexOf(id);
    if(i>-1){favs.splice(i,1);toast('Đã bỏ khỏi yêu thích');} else{favs.push(id);toast('Đã thêm vào yêu thích');}
    try{localStorage.setItem('favs',JSON.stringify(favs));}catch(e){}
    renderFav();
  });
});
renderFav();

/* Video */
var v=document.getElementById('heroVideo'), vt=document.getElementById('videoToggle');
vt.addEventListener('click',function(){
  if(v.paused){v.play();vt.innerHTML='<i class="bi bi-pause-fill"></i>';} else{v.pause();vt.innerHTML='<i class="bi bi-play-fill"></i>';}
});

/* Đếm số */
var counted=false;
function runCounters(){
  document.querySelectorAll('.count').forEach(function(el){
    var to=+el.dataset.to, cur=0, step=Math.max(1,Math.ceil(to/80));
    var iv=setInterval(function(){cur+=step; if(cur>=to){cur=to;clearInterval(iv);} el.textContent=cur.toLocaleString('vi-VN');},25);
  });
}
new IntersectionObserver(function(es,ob){
  es.forEach(function(e){ if(e.isIntersecting&&!counted){counted=true;runCounters();ob.disconnect();} });
},{threshold:.4}).observe(document.querySelector('.counter-sec'));

/* Đồng hồ đếm ngược flash sale */
function tick(){
  var n=new Date(), end=new Date(n); end.setHours(23,59,59,999);
  var d=Math.max(0,end-n), p=function(x){return String(x).padStart(2,'0')};
  document.getElementById('cdH').textContent=p(Math.floor(d/3600000));
  document.getElementById('cdM').textContent=p(Math.floor(d%3600000/60000));
  document.getElementById('cdS').textContent=p(Math.floor(d%60000/1000));
}
tick(); setInterval(tick,1000);

/* Lên đầu trang */
var tt=document.getElementById('toTop');
window.addEventListener('scroll',function(){tt.classList.toggle('show',window.scrollY>500);});
tt.addEventListener('click',function(){window.scrollTo({top:0,behavior:'smooth'});});

/* Đóng menu 3 gạch khi bấm link */
document.querySelectorAll('.offcanvas a.m-link').forEach(function(a){
  a.addEventListener('click',function(){
    var oc=bootstrap.Offcanvas.getInstance(document.getElementById('menuMobile')); if(oc) oc.hide();
  });
});

/* =============== SÁNG / TỐI =============== */
var root=document.documentElement, themeBtn=document.getElementById('themeBtn'), panel=document.getElementById('fxPanel');
var fxMode='stars';
try{ fxMode=localStorage.getItem('fx')||'stars'; }catch(e){}

function setTheme(t){
  root.setAttribute('data-theme',t); root.setAttribute('data-bs-theme',t);
  try{localStorage.setItem('theme',t);}catch(e){}
  themeBtn.innerHTML = t==='dark' ? '<i class="bi bi-sun-fill"></i>' : '<i class="bi bi-moon-stars-fill"></i>';
  panel.classList.toggle('open', t==='dark');
  runFx();
}
themeBtn.addEventListener('click',function(){
  var next = root.getAttribute('data-theme')==='dark' ? 'light' : 'dark';
  setTheme(next);
  toast(next==='dark' ? 'Chế độ ban đêm – chọn hiệu ứng bên dưới' : 'Chế độ ban ngày');
});
panel.querySelectorAll('button').forEach(function(b){
  b.addEventListener('click',function(){
    fxMode=b.dataset.fx;
    try{localStorage.setItem('fx',fxMode);}catch(e){}
    runFx();
  });
});

/* =============== HIỆU ỨNG BAN ĐÊM CŨ (canvas #fx) =============== */
var cv=document.getElementById('fx'), cx=cv.getContext('2d'), W=0, H=0, P=[], raf=0, active='none', shoot=null;
function resize(){ W=cv.width=window.innerWidth; H=cv.height=window.innerHeight; }
window.addEventListener('resize',resize); resize();

function spawn(m,first){
  var R=Math.random;
  if(m==='snow')  return {x:R()*W,y:first?R()*H:-8,r:1+R()*3,s:.5+R()*1.4,d:R()*6.28};
  if(m==='rain')  return {x:R()*W,y:first?R()*H:-20,l:12+R()*16,s:9+R()*8};
  if(m==='stars') return {x:R()*W,y:R()*H,r:.4+R()*1.7,p:R()*6.28,sp:.02+R()*.04};
  if(m==='bats')  return {x:first?R()*W:-70,y:70+R()*H*.55,s:.7+R()*.9,v:1+R()*1.6,ph:R()*6.28,amp:18+R()*34};
  if(m==='color') return {x:R()*W,y:first?R()*H:H+70,r:14+R()*40,s:.25+R()*.6,h:R()*360,dx:(R()-.5)*.5};
}
function drawBat(x,y,s,f){
  cx.save(); cx.translate(x,y); cx.scale(s,s);
  cx.beginPath(); cx.moveTo(0,0);
  cx.quadraticCurveTo(-12,-10*f-6,-28,-5*f); cx.quadraticCurveTo(-20,2,-15,7);
  cx.quadraticCurveTo(-9,2,-4,9); cx.quadraticCurveTo(-2,4,0,7);
  cx.quadraticCurveTo(2,4,4,9); cx.quadraticCurveTo(9,2,15,7);
  cx.quadraticCurveTo(20,2,28,-5*f); cx.quadraticCurveTo(12,-10*f-6,0,0);
  cx.fill(); cx.stroke();
  cx.beginPath(); cx.moveTo(-3,-1); cx.lineTo(-4.5,-8); cx.lineTo(0,-3); cx.lineTo(4.5,-8); cx.lineTo(3,-1); cx.fill();
  cx.restore();
}
function frame(){
  cx.clearRect(0,0,W,H);
  var i,p;
  if(active==='snow'){
    cx.fillStyle='rgba(255,255,255,.92)';
    for(i=0;i<P.length;i++){p=P[i]; p.d+=.015; p.x+=Math.sin(p.d)*.7; p.y+=p.s;
      if(p.y>H+6){p.y=-6;p.x=Math.random()*W;}
      cx.beginPath(); cx.arc(p.x,p.y,p.r,0,6.283); cx.fill();}
  } else if(active==='rain'){
    cx.strokeStyle='rgba(170,210,255,.55)'; cx.lineWidth=1.2;
    for(i=0;i<P.length;i++){p=P[i]; p.y+=p.s; p.x-=2;
      if(p.y>H){p.y=-20;p.x=Math.random()*(W+100);}
      cx.beginPath(); cx.moveTo(p.x,p.y); cx.lineTo(p.x-p.l*.2,p.y+p.l); cx.stroke();}
  } else if(active==='stars'){
    for(i=0;i<P.length;i++){p=P[i]; p.p+=p.sp;
      cx.fillStyle='rgba(255,255,225,'+(.45+.55*Math.sin(p.p)*Math.sin(p.p))+')';
      cx.beginPath(); cx.arc(p.x,p.y,p.r,0,6.283); cx.fill();}
    if(!shoot && Math.random()<.006){ shoot={x:W*(.3+Math.random()*.7),y:Math.random()*H*.35,a:1}; }
    if(shoot){
      var g=cx.createLinearGradient(shoot.x,shoot.y,shoot.x+120,shoot.y-50);
      g.addColorStop(0,'rgba(255,255,255,'+shoot.a+')'); g.addColorStop(1,'rgba(255,255,255,0)');
      cx.strokeStyle=g; cx.lineWidth=2; cx.beginPath(); cx.moveTo(shoot.x,shoot.y); cx.lineTo(shoot.x+120,shoot.y-50); cx.stroke();
      shoot.x-=16; shoot.y+=7; shoot.a-=.02; if(shoot.a<=0) shoot=null;
    }
  } else if(active==='bats'){
    cx.fillStyle='#1a1030'; cx.strokeStyle='rgba(190,140,255,.85)'; cx.lineWidth=1.3;
    for(i=0;i<P.length;i++){p=P[i]; p.x+=p.v; p.ph+=.14;
      if(p.x>W+70){p.x=-70;p.y=70+Math.random()*H*.55;}
      drawBat(p.x,p.y+Math.sin(p.ph*.5)*p.amp,p.s,Math.sin(p.ph*2.2));}
  } else if(active==='color'){
    for(i=0;i<P.length;i++){p=P[i]; p.y-=p.s; p.x+=p.dx; p.h+=.3;
      if(p.y<-80){p.y=H+70;p.x=Math.random()*W;}
      var gr=cx.createRadialGradient(p.x,p.y,0,p.x,p.y,p.r);
      gr.addColorStop(0,'hsla('+p.h+',90%,65%,.45)'); gr.addColorStop(1,'hsla('+p.h+',90%,60%,0)');
      cx.fillStyle=gr; cx.beginPath(); cx.arc(p.x,p.y,p.r,0,6.283); cx.fill();}
  }
  raf=requestAnimationFrame(frame);
}
function runFx(){
  cancelAnimationFrame(raf); cx.clearRect(0,0,W,H); shoot=null;
  var dark=root.getAttribute('data-theme')==='dark';
  panel.querySelectorAll('button').forEach(function(b){ b.classList.toggle('on', b.dataset.fx===fxMode); });
  active = dark ? fxMode : 'none';
  if(active==='none') return;
  var n={snow:120,rain:170,stars:150,bats:9,color:36}[active];
  P=[]; for(var i=0;i<n;i++) P.push(spawn(active,true));
  frame();
}
setTheme(root.getAttribute('data-theme')==='dark' ? 'dark' : 'light');

/* ===== VIDEO NỀN: chạy lần lượt nhiều clip ===== */
var playlist=[
  'https://assets.mixkit.co/videos/48128/48128-720.mp4',
  'https://assets.mixkit.co/videos/48129/48129-720.mp4',
  'https://assets.mixkit.co/videos/4653/4653-720.mp4',
  'https://assets.mixkit.co/videos/10421/10421-720.mp4'
];
var vi=0;
v.removeAttribute('loop');
function nextClip(){
  vi=(vi+1)%playlist.length;
  v.src=playlist[vi];
  var pr=v.play(); if(pr&&pr.catch) pr.catch(function(){});
}
v.addEventListener('ended',nextClip);
v.addEventListener('error',function(){ if(playlist.length>1) nextClip(); });

/* ===== HERO SLIDER (nội dung lấy từ bảng Slide) ===== */
(function(){
  var slides=document.querySelectorAll('#heroSlides .hs');
  var dotsBox=document.getElementById('hsDots');
  var hero=document.getElementById('top');
  var prev=document.getElementById('hsPrev'), next=document.getElementById('hsNext');
  var cur=0, timer=null, DELAY=6000;

  if(slides.length<2){
    prev.style.display='none'; next.style.display='none';
    return;
  }

  slides.forEach(function(_,i){
    var b=document.createElement('button');
    b.type='button';
    b.setAttribute('aria-label','Slide '+(i+1));
    b.addEventListener('click',function(){go(i);start();});
    dotsBox.appendChild(b);
  });
  var dots=dotsBox.querySelectorAll('button');
  dots[0].classList.add('on');

  function go(n){
    slides[cur].classList.remove('active'); dots[cur].classList.remove('on');
    cur=(n+slides.length)%slides.length;
    slides[cur].classList.add('active'); dots[cur].classList.add('on');
  }
  function stop(){ if(timer){clearInterval(timer);timer=null;} }
  function start(){ stop(); timer=setInterval(function(){go(cur+1);},DELAY); }

  prev.addEventListener('click',function(){go(cur-1);start();});
  next.addEventListener('click',function(){go(cur+1);start();});
  hero.addEventListener('mouseenter',stop);
  hero.addEventListener('mouseleave',start);

  var sx=0;
  hero.addEventListener('touchstart',function(e){sx=e.touches[0].clientX;},{passive:true});
  hero.addEventListener('touchend',function(e){
    var dx=e.changedTouches[0].clientX-sx;
    if(Math.abs(dx)>50){go(dx<0?cur+1:cur-1);start();}
  });

  start();
})();
</script>

<!-- ================= THIẾT KẾ MỚI: đồng hồ banner, combo, hiệu ứng mạng lưới ================= -->
<script>
(function(){
var $=function(s,c){return (c||document).querySelector(s)};

/* ---- Đồng hồ banner ---- */
var clk=$('#heroClock');
if(clk){
  var T=$('.t',clk),D=$('.d',clk),S=$('.s',clk);
  var days=['Chủ nhật','Thứ hai','Thứ ba','Thứ tư','Thứ năm','Thứ sáu','Thứ bảy'];
  (function tk(){
    var n=new Date(),p=function(x){return String(x).padStart(2,'0')};
    T.innerHTML=p(n.getHours())+':'+p(n.getMinutes())+'<i>'+p(n.getSeconds())+'</i>';
    D.textContent=days[n.getDay()]+', '+p(n.getDate())+'/'+p(n.getMonth()+1)+'/'+n.getFullYear();
    var h=n.getHours(),open=h>=6&&h<21;
    S.textContent=open?'Đang mở cửa - giao trong 2 giờ':'Đã đóng - nhận đơn từ 6:00';
    clk.classList.toggle('closed',!open);
    setTimeout(tk,1000);
  })();
}

/* ---- Combo 6 khung ---- */
var cb=$('#comboGrid');
if(cb){
  var ctx=cb.dataset.ctx||'';
  var L=[
   ['🥗 🥑 🍅','Combo Eat-clean','1–2 người / 3 ngày',149000,199000,'#2e9e4f,#16642f','Xà lách, rau mầm, cà chua bi|Dưa leo, bơ, ớt chuông|Giao lạnh trong 2 giờ','Tặng sốt mè rang',0],
   ['🧺 🥕 🍊','Combo Gia đình','4 người / 3 ngày',229000,305000,'#ff8a00,#e65100','8 loại rau củ tươi theo mùa|Thêm 1kg trái cây tặng kèm|Miễn phí giao hàng','Tặng túi vải thân thiện',1],
   ['🎁 🍇 🍎','Combo Quà biếu','Hộp quà cao cấp',399000,499000,'#8e24aa,#4a148c','Trái cây cao cấp nhập khẩu|Giỏ mây + thiệp tặng|Giao tận nơi đúng hẹn','Thiệp viết tay miễn phí',0],
   ['👶 🥦 🍌','Combo Mẹ và Bé','Ăn dặm / 5 ngày',189000,239000,'#26a69a,#00695c','Bông cải, bí đỏ, khoai lang|Chuối, bơ, táo hữu cơ|Sơ chế sẵn, đóng gói riêng','Tặng sổ thực đơn ăn dặm',0],
   ['🍓 🍍 🍉','Combo Trái cây tươi','Cả nhà / 1 tuần',259000,329000,'#ec407a,#ad1457','Dâu, thơm, dưa hấu, cam|Hái chín cây, mọng nước|Đổi trả trong 24 giờ','Tặng hộp bảo quản',0],
   ['🍲 🍄 🌶️','Combo Nấu lẩu','4–6 người / 1 bữa',179000,229000,'#ef6c00,#bf360c','Nấm các loại, rau ăn lẩu|Cà chua, hành, ớt tươi|Rửa sạch, cắt sẵn','Tặng gói gia vị lẩu',0]
  ];
  var f=function(n){return n.toLocaleString('vi-VN')+'₫'};
  cb.innerHTML=L.map(function(c,i){
    var g=c[5].split(','),pc=Math.round((1-c[3]/c[4])*100);
    return '<div class="cb-card'+(c[8]?' hot':'')+'" data-aos="fade-up" data-aos-delay="'+(i%3)*100+'">'+
      (c[8]?'<span class="cb-flag">Bán chạy</span>':'')+
      '<div class="cb-top" style="--bgc:linear-gradient(135deg,'+g[0]+','+g[1]+')"><span class="cb-save">-'+pc+'%</span>'+
      '<div class="cb-emo">'+c[0].split(' ').map(function(e){return '<span>'+e+'</span>'}).join('')+'</div>'+
      '<h4>'+c[1]+'</h4><small>'+c[2]+'</small></div>'+
      '<div class="cb-body"><div class="cb-price"><b>'+f(c[3])+'</b><s>'+f(c[4])+'</s></div>'+
      '<ul>'+c[6].split('|').map(function(x){return '<li><i class="bi bi-check2-circle"></i>'+x+'</li>'}).join('')+'</ul>'+
      '<div class="cb-gift"><i class="bi bi-gift me-1"></i>'+c[7]+'</div>'+
      '<a href="'+ctx+'/thanh-toan?comboId='+(i+1)+'&soLuong=1" class="btn-pay d-block py-2"><i class="bi bi-credit-card me-1"></i>Thanh toán combo</a></div></div>';
  }).join('');
}

/* ---- Hiệu ứng ban đêm: mạng lưới / cực quang / đom đóm (canvas #plexus) ---- */
var pc=$('#plexus'); if(!pc) return;
var px=pc.getContext('2d'),PW=0,PH=0,PT=[],orbs=[],mode='off',praf=0,mx=-999,my=-999,t=0;
function rs(){PW=pc.width=innerWidth;PH=pc.height=innerHeight}
function init(){
  PT=[];orbs=[];var i,n=mode==='net'?Math.min(110,Math.floor(PW*PH/14000)):mode==='fireflies'?45:0;
  for(i=0;i<n;i++)PT.push({x:Math.random()*PW,y:Math.random()*PH,vx:(Math.random()-.5)*.5,vy:(Math.random()-.5)*.5,r:1+Math.random()*2,p:Math.random()*6.28});
  if(mode==='net')for(i=0;i<9;i++)orbs.push({x:Math.random()*PW,y:Math.random()*PH,r:30+Math.random()*70,vx:(Math.random()-.5)*.25,vy:(Math.random()-.5)*.25,c:i%3?'255,90,50':'60,160,255'});
}
rs();
addEventListener('resize',function(){rs();init()});
addEventListener('mousemove',function(e){mx=e.clientX;my=e.clientY});

function net(){
  orbs.forEach(function(o){
    o.x+=o.vx;o.y+=o.vy;if(o.x<-50||o.x>PW+50)o.vx*=-1;if(o.y<-50||o.y>PH+50)o.vy*=-1;
    var g=px.createRadialGradient(o.x,o.y,0,o.x,o.y,o.r);
    g.addColorStop(0,'rgba('+o.c+',.35)');g.addColorStop(1,'rgba('+o.c+',0)');
    px.fillStyle=g;px.beginPath();px.arc(o.x,o.y,o.r,0,6.283);px.fill();
  });
  PT.forEach(function(a,i){
    a.x+=a.vx;a.y+=a.vy;a.p+=.03;
    if(a.x<0||a.x>PW)a.vx*=-1;if(a.y<0||a.y>PH)a.vy*=-1;
    for(var j=i+1;j<PT.length;j++){
      var b=PT[j],dx=a.x-b.x,dy=a.y-b.y,d=dx*dx+dy*dy;
      if(d<19600){px.strokeStyle='rgba(90,200,255,'+(.5*(1-d/19600))+')';px.lineWidth=1;px.beginPath();px.moveTo(a.x,a.y);px.lineTo(b.x,b.y);px.stroke();}
    }
    var dm=(a.x-mx)*(a.x-mx)+(a.y-my)*(a.y-my);
    if(dm<32400){px.strokeStyle='rgba(255,170,90,'+(.7*(1-dm/32400))+')';px.beginPath();px.moveTo(a.x,a.y);px.lineTo(mx,my);px.stroke();}
    px.fillStyle='rgba(150,225,255,'+(.6+.4*Math.sin(a.p))+')';px.beginPath();px.arc(a.x,a.y,a.r,0,6.283);px.fill();
  });
}
function aurora(){
  t+=.01;
  [['80,255,170',0],['60,170,255',1.7],['190,110,255',3.2]].forEach(function(c,k){
    for(var x=0;x<PW;x+=8){
      var y=PH*.2+Math.sin(x*.004+t+c[1])*70+Math.sin(x*.011-t*1.3)*28+k*40,h=150+Math.sin(x*.006+t*.8+c[1])*60;
      var g=px.createLinearGradient(0,y,0,y+h);
      g.addColorStop(0,'rgba('+c[0]+',.28)');g.addColorStop(1,'rgba('+c[0]+',0)');
      px.fillStyle=g;px.fillRect(x,y,8,h);
    }
  });
}
function fire(){
  PT.forEach(function(a){
    a.p+=.04;a.x+=a.vx+Math.sin(a.p)*.3;a.y+=a.vy+Math.cos(a.p*.8)*.3;
    if(a.x<-20)a.x=PW+20;if(a.x>PW+20)a.x=-20;if(a.y<-20)a.y=PH+20;if(a.y>PH+20)a.y=-20;
    var r=(a.r*3+Math.sin(a.p)*2)*2,g=px.createRadialGradient(a.x,a.y,0,a.x,a.y,r*2);
    g.addColorStop(0,'rgba(230,255,140,.9)');g.addColorStop(.3,'rgba(160,255,90,.35)');g.addColorStop(1,'rgba(160,255,90,0)');
    px.fillStyle=g;px.beginPath();px.arc(a.x,a.y,r*2,0,6.283);px.fill();
  });
}
function loop(){
  px.clearRect(0,0,PW,PH);
  if(mode==='net')net();else if(mode==='aurora')aurora();else if(mode==='fireflies')fire();
  praf=requestAnimationFrame(loop);
}
function stopFx(){cancelAnimationFrame(praf);px.clearRect(0,0,PW,PH)}
function mark(m){document.querySelectorAll('[data-fx2]').forEach(function(b){b.classList.toggle('on',b.dataset.fx2===m)})}
function setMode(m){
  stopFx();mode=m;
  try{localStorage.setItem('fx2',m)}catch(e){}
  window.fxMode='none';runFx();   /* tắt hiệu ứng cũ để không chồng nhau */
  mark(m);init();loop();
}
function sync(){
  if(root.getAttribute('data-theme')!=='dark'){stopFx();return;}
  var m='net';try{m=localStorage.getItem('fx2')||'net'}catch(e){}
  if(m==='off'){stopFx();mode='off';return;}
  setMode(m);
}

if(panel){
  [['fireflies','✨ Đom đóm'],['aurora','🌌 Cực quang'],['net','🕸️ Mạng lưới']].forEach(function(x){
    var b=document.createElement('button');b.type='button';b.dataset.fx2=x[0];b.textContent=x[1];
    b.addEventListener('click',function(){setMode(x[0])});
    panel.insertBefore(b,panel.children[1]);
  });
  panel.querySelectorAll('[data-fx]').forEach(function(b){   /* chọn hiệu ứng cũ thì tắt hiệu ứng mới */
    b.addEventListener('click',function(){
      mode='off';stopFx();mark('');
      try{localStorage.setItem('fx2','off')}catch(e){}
    });
  });
}
new MutationObserver(sync).observe(root,{attributes:true,attributeFilter:['data-theme']});
sync();
})();
</script>
</body>
</html>
