<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // ====== VIDEO NỀN (file .mp4 trực tiếp, KHÔNG phải link trang iStock) ======
    // Bước 1: mua/tải video iStock (ID 1191450079) rồi đổi tên thành nen.mp4
    // Bước 2: đặt vào webapp/assets/video/nen.mp4
    // Hoặc thay bằng link mp4 trực tiếp khác: "https://ten-mien.com/video/nen.mp4"
    String videoUrl  = request.getContextPath() + "/assets/video/nen.mp4";
    // Ảnh hiện tạm khi video chưa có / đang tải
    String posterUrl = "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=1600&q=70";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng nhập - Green Mart</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
<noscript><style>.login,.overview{opacity:1!important;visibility:visible!important;max-height:none!important}.bg,.veil{opacity:1!important}</style></noscript>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{font-family:'Be Vietnam Pro',Arial,sans-serif;background:#000;color:#fff;min-height:100vh;overflow-x:hidden}

/* ===== NỀN: tắt đèn = đen, bật đèn = video ===== */
.bg{position:fixed;inset:0;z-index:0;background:#000 url('<%= posterUrl %>') center/cover;opacity:0;transition:opacity 1.6s}
.bg video{width:100%;height:100%;object-fit:cover;display:block}
.veil{position:fixed;inset:0;z-index:1;opacity:0;transition:opacity 1.6s;
  background:linear-gradient(180deg,rgba(4,10,7,.5),rgba(4,10,7,.8))}
body.lit .bg,body.lit .veil{opacity:1}
#fx{position:fixed;inset:0;width:100%;height:100%;z-index:2;pointer-events:none}
.halo{position:fixed;z-index:2;left:0;top:0;width:1000px;height:1000px;margin:-500px 0 0 -500px;border-radius:50%;pointer-events:none;
  background:radial-gradient(circle,rgba(255,206,100,.5),rgba(255,190,70,.14) 40%,transparent 68%);opacity:0;transition:opacity 1.2s}
body.lit .halo{opacity:1}

/* ===== BỐ CỤC ===== */
.scene{position:relative;z-index:3;min-height:100vh;max-width:1100px;margin:0 auto;padding:28px 20px;display:flex;flex-direction:column;justify-content:center}

/* NỘI DUNG TỔNG QUAN Ở TRÊN */
.overview{max-height:0;overflow:hidden;opacity:0;visibility:hidden;transform:translateY(-18px);
  transition:max-height 1s ease,opacity .6s,transform .8s,visibility 0s 1s}
body.lit .overview{max-height:620px;opacity:1;visibility:visible;transform:none;
  transition:max-height 1s ease .2s,opacity .9s .5s,transform .9s .5s,visibility 0s}
.ov-in{padding:4px 0 26px}
.ov-head{display:flex;justify-content:space-between;align-items:flex-end;gap:20px;flex-wrap:wrap;margin-bottom:16px}
.ov-head h2{font-size:30px;font-weight:800;text-shadow:0 2px 14px rgba(0,0,0,.5)}
.ov-head p{font-size:14px;color:rgba(255,255,255,.78);margin-top:4px}
.stats{display:flex;gap:10px;flex-wrap:wrap}
.stat{padding:8px 16px;border-radius:14px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.2);backdrop-filter:blur(10px);text-align:center}
.stat b{display:block;font-size:19px;color:#ffd36b}
.stat span{font-size:11px;color:rgba(255,255,255,.75)}
.feats{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.feat{display:flex;gap:12px;align-items:center;padding:10px;border-radius:16px;background:rgba(255,255,255,.1);
  border:1px solid rgba(255,255,255,.2);backdrop-filter:blur(10px)}
.feat img{width:72px;height:72px;object-fit:cover;border-radius:12px;flex:none;background:#1b3a25}
.feat h3{font-size:14px;margin-bottom:3px}
.feat p{font-size:12px;line-height:1.5;color:rgba(255,255,255,.78)}

.row{display:flex;align-items:center;justify-content:center;gap:30px}

/* ===== ĐÈN BÀN ===== */
.lamp-col{width:260px;flex:none;display:flex;flex-direction:column;align-items:center;transition:transform 1.3s cubic-bezier(.6,0,.2,1)}
@media(min-width:861px){body:not(.lit) .lamp-col{transform:translateX(235px)}}
.lamp{width:260px;height:380px;overflow:visible;touch-action:none;user-select:none}
.top-in{fill:#8f8b82;transition:fill 1s}
.rim{fill:none;stroke:rgba(0,0,0,.35);stroke-width:1.5;transition:stroke 1s}
.shade-on{opacity:0;transition:opacity 1s}
.wp{color:#5f574d;opacity:.5;transition:color 1s,opacity 1s}
.shade-wrap{cursor:pointer;transition:filter 1s}
.pool{opacity:0;transition:opacity 1.2s}
body.lit .top-in{fill:#fff8de}
body.lit .rim{stroke:rgba(255,190,70,.8)}
body.lit .shade-on{opacity:1}
body.lit .wp{color:#a06d28;opacity:.9}
body.lit .shade-wrap{filter:drop-shadow(0 0 16px rgba(255,200,90,.85)) drop-shadow(0 0 50px rgba(255,170,40,.55))}
body.lit .pool{opacity:1}
.chain{stroke:#d9c9a3;stroke-width:2.6;stroke-dasharray:1 5;stroke-linecap:round}
.handle{cursor:grab}.handle:active{cursor:grabbing}
.handle:focus{outline:none}.handle:focus-visible .bead{stroke:#fff;stroke-width:2}
.swing{transform-origin:199px 218px;transform-box:view-box}
.lamp-tip{margin-top:4px;text-align:center;font-size:13px;line-height:1.6;color:rgba(255,255,255,.5)}
.lamp-tip b{color:#ffd36b}

/* ===== ĐĂNG NHẬP ===== */
.login{width:440px;max-width:100%;padding:36px 34px 26px;border-radius:26px;color:#1f2d1f;
  background:rgba(255,252,243,.95);border:1px solid rgba(255,196,60,.7);
  box-shadow:0 0 0 1px rgba(255,200,70,.5),0 0 60px rgba(255,200,70,.5),0 0 150px rgba(255,200,70,.3);
  opacity:0;visibility:hidden;transform:translateY(26px) scale(.97);transition:opacity .7s,transform .7s,visibility 0s .7s}
body.lit .login{opacity:1;visibility:visible;transform:none;transition:opacity .9s .6s,transform .9s .6s,visibility 0s}
.brand{font-weight:800;font-size:19px;margin-bottom:18px}
.brand b{color:#2e7d32}
.login h1{font-size:27px;font-weight:800;line-height:1.25;margin-bottom:6px}
.sub{color:#5a7260;font-size:14px;line-height:1.6;margin-bottom:20px}
.group{margin-bottom:15px}
label{display:block;font-size:13px;font-weight:700;margin-bottom:6px}
.box{position:relative}
.box span{position:absolute;left:14px;top:50%;transform:translateY(-50%);font-size:16px}
input{width:100%;padding:13px 15px 13px 44px;border:1px solid #ddd8c4;border-radius:12px;background:#f8f6ec;color:#1f2d1f;font:inherit;font-size:14px;outline:none;transition:.25s}
input:focus{border-color:#43a047;box-shadow:0 0 0 4px rgba(67,160,71,.18);background:#fff}
.btn{width:100%;padding:14px;border:0;border-radius:12px;font:inherit;font-weight:800;font-size:15px;color:#fff;cursor:pointer;
  background:linear-gradient(135deg,#2e7d32,#5fbf66);box-shadow:0 8px 22px rgba(46,125,50,.35);transition:.25s}
.btn:hover{transform:translateY(-2px)}
.sep{display:flex;align-items:center;gap:12px;margin:16px 0;color:#8a9a8c;font-size:12px}
.sep::before,.sep::after{content:'';flex:1;border-bottom:1px solid #e2ddc9}
.google{display:flex;align-items:center;justify-content:center;gap:10px;padding:12px;border:1px solid #ddd8c4;border-radius:12px;text-decoration:none;color:#2b3a2d;background:#fff;font-weight:700;font-size:14px;transition:.25s}
.google:hover{transform:translateY(-2px);border-color:#43a047}
.google img{width:18px;height:18px}
.error{color:#b71c1c;background:#ffebee;padding:10px 14px;border-radius:8px;font-size:13px;margin-bottom:14px}
.success{color:#1b5e20;background:#e3f4e4;padding:10px 14px;border-radius:8px;font-size:13px;margin-bottom:14px}
.reg{text-align:center;margin-top:16px;font-size:13px;color:#5a7260}
.reg a{color:#2e7d32;font-weight:800;text-decoration:none}
.reg a:hover{text-decoration:underline}
.copy{text-align:center;margin-top:14px;font-size:11px;color:#9aa89c}

/* ===== CON CHIM ===== */
#bird{position:fixed;left:0;top:0;width:70px;height:56px;z-index:8;pointer-events:none;opacity:0;will-change:transform}
#bird .wing-fly{transform-box:view-box;transform-origin:34px 28px;animation:flap .2s ease-in-out infinite alternate}
#bird .wing-fly.far{animation-delay:-.07s}
#bird .wing-rest,#bird .legs{display:none}
#bird.perched .wing-fly{display:none}
#bird.perched .wing-rest,#bird.perched .legs{display:block}
#bird .headg{transform-box:view-box;transform-origin:46px 30px}
#bird.perched .headg{animation:peck 4.5s ease-in-out infinite}
@keyframes flap{from{transform:scaleY(1) rotate(0)}to{transform:scaleY(-.75) rotate(-6deg)}}
@keyframes peck{0%,62%,100%{transform:rotate(0)}68%{transform:rotate(16deg)}74%{transform:rotate(0)}80%{transform:rotate(14deg)}86%{transform:rotate(-4deg)}}

@media(max-width:860px){
  .row{flex-direction:column;gap:6px}
  .lamp-col{width:100%}
  .login{margin-bottom:30px;padding:30px 22px 22px;display:none}
  body.lit .login{display:block;animation:rise .9s .5s both}
  .feats{grid-template-columns:1fr}
  body.lit .overview{max-height:1100px}
}
@keyframes rise{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:none}}
@media(prefers-reduced-motion:reduce){*{animation-duration:.01ms!important;transition-duration:.01ms!important}}
</style>
</head>
<body>

<div class="bg">
  <video id="bgv" muted loop playsinline preload="auto" poster="<%= posterUrl %>">
    <source src="<%= videoUrl %>" type="video/mp4">
  </video>
</div>
<div class="veil"></div>
<canvas id="fx"></canvas>
<div class="halo" id="halo"></div>

<main class="scene">

  <!-- NỘI DUNG TỔNG QUAN (hiện khi bật đèn) -->
  <section class="overview" aria-label="Tổng quan về hệ thống">
    <div class="ov-in">
      <div class="ov-head">
        <div>
          <h2>Tổng quan về hệ thống</h2>
          <p>Quản lý nông sản trọn vòng đời: từ vườn, kho, đơn hàng đến bàn ăn.</p>
        </div>
        <div class="stats">
          <div class="stat"><b>120+</b><span>Loại nông sản</span></div>
          <div class="stat"><b>35</b><span>Vùng trồng</span></div>
          <div class="stat"><b>24/7</b><span>Theo dõi đơn</span></div>
          <div class="stat"><b>100%</b><span>Truy xuất nguồn gốc</span></div>
        </div>
      </div>
      <div class="feats">
        <div class="feat">
          <img src="https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=300&q=70" alt="Nông trại" onerror="this.style.visibility='hidden'">
          <div><h3>Quản lý nông trại</h3><p>Theo dõi vùng trồng, mùa vụ và sản lượng theo thời gian thực.</p></div>
        </div>
        <div class="feat">
          <img src="https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=300&q=70" alt="Kho hàng" onerror="this.style.visibility='hidden'">
          <div><h3>Kho &amp; sản phẩm</h3><p>Nhập xuất kho, hạn dùng và giá bán luôn được cập nhật.</p></div>
        </div>
        <div class="feat">
          <img src="https://images.unsplash.com/photo-1573246123716-6b1782bfc499?auto=format&fit=crop&w=300&q=70" alt="Đơn hàng" onerror="this.style.visibility='hidden'">
          <div><h3>Đơn hàng &amp; giao nhận</h3><p>Từ giỏ hàng đến tận nhà, mọi bước đều có trạng thái rõ ràng.</p></div>
        </div>
      </div>
    </div>
  </section>

  <div class="row">

    <!-- ĐÈN BÀN (luôn hiện) -->
    <div class="lamp-col">
      <svg class="lamp" id="lamp" viewBox="0 0 260 380" aria-label="Đèn bàn: kéo dây để bật hoặc tắt">
        <defs>
          <linearGradient id="gOff" x1="0" x2="1">
            <stop offset="0" stop-color="#85817a"/><stop offset=".2" stop-color="#bbb6ab"/><stop offset=".5" stop-color="#d8d4c9"/><stop offset=".8" stop-color="#b1ada2"/><stop offset="1" stop-color="#7d7972"/>
          </linearGradient>
          <linearGradient id="gOn" x1="0" x2="1">
            <stop offset="0" stop-color="#f1c056"/><stop offset=".2" stop-color="#ffe5a0"/><stop offset=".5" stop-color="#fff7de"/><stop offset=".8" stop-color="#ffe19a"/><stop offset="1" stop-color="#eeb94f"/>
          </linearGradient>
          <linearGradient id="gSide" x1="0" x2="1">
            <stop offset="0" stop-color="#000" stop-opacity=".35"/><stop offset=".28" stop-color="#000" stop-opacity="0"/><stop offset=".72" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".35"/>
          </linearGradient>
          <linearGradient id="gChrome" x1="0" x2="1">
            <stop offset="0" stop-color="#6f7b83"/><stop offset=".35" stop-color="#f2f5f6"/><stop offset=".65" stop-color="#a9b3b9"/><stop offset="1" stop-color="#58646b"/>
          </linearGradient>
          <linearGradient id="gWood" x1="0" x2="1">
            <stop offset="0" stop-color="#1b110c"/><stop offset=".4" stop-color="#3a251a"/><stop offset="1" stop-color="#150d09"/>
          </linearGradient>
          <radialGradient id="gPool"><stop offset="0" stop-color="#ffd067" stop-opacity=".6"/><stop offset="1" stop-color="#ffd067" stop-opacity="0"/></radialGradient>
          <clipPath id="shadeClip">
            <path d="M60 44 L60 214 A70 12 0 0 0 200 214 L200 44 A70 12 0 0 0 60 44Z"/>
          </clipPath>
          <!-- một bông lúa -->
          <g id="wheat">
            <path d="M0 0 C2 -30 -2 -62 3 -94" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
            <path d="M1 -16 C-10 -24 -16 -33 -18 -44 C-8 -40 -1 -30 1 -16Z" fill="currentColor"/>
            <path d="M2 -30 C12 -36 18 -44 20 -54 C10 -50 3 -42 2 -30Z" fill="currentColor"/>
            <ellipse cx="-3.4" cy="-58" rx="2.6" ry="6" transform="rotate(-28 -3.4 -58)" fill="currentColor"/>
            <ellipse cx="6.6" cy="-60" rx="2.6" ry="6" transform="rotate(28 6.6 -60)" fill="currentColor"/>
            <ellipse cx="-2.8" cy="-68" rx="2.6" ry="6" transform="rotate(-28 -2.8 -68)" fill="currentColor"/>
            <ellipse cx="7.4" cy="-70" rx="2.6" ry="6" transform="rotate(28 7.4 -70)" fill="currentColor"/>
            <ellipse cx="-1.8" cy="-78" rx="2.5" ry="5.8" transform="rotate(-28 -1.8 -78)" fill="currentColor"/>
            <ellipse cx="7.8" cy="-80" rx="2.5" ry="5.8" transform="rotate(28 7.8 -80)" fill="currentColor"/>
            <ellipse cx="-.6" cy="-88" rx="2.3" ry="5.4" transform="rotate(-26 -.6 -88)" fill="currentColor"/>
            <ellipse cx="6.2" cy="-90" rx="2.3" ry="5.4" transform="rotate(26 6.2 -90)" fill="currentColor"/>
            <ellipse cx="3.4" cy="-101" rx="2.3" ry="6" fill="currentColor"/>
          </g>
        </defs>

        <!-- vệt sáng trên mặt bàn -->
        <ellipse class="pool" cx="130" cy="296" rx="125" ry="22" fill="url(#gPool)"/>

        <!-- dây điện -->
        <path d="M72 290 C46 298 34 322 8 334" fill="none" stroke="#0d0d0d" stroke-width="3.2" stroke-linecap="round"/>

        <!-- đế gỗ tròn -->
        <ellipse cx="130" cy="292" rx="60" ry="11" fill="#0f0906"/>
        <rect x="70" y="276" width="120" height="16" fill="url(#gWood)"/>
        <ellipse cx="130" cy="276" rx="60" ry="11" fill="#2f1d14"/>
        <ellipse cx="130" cy="276" rx="60" ry="11" fill="none" stroke="#6b4630" stroke-width="1.2"/>

        <!-- cổ inox -->
        <rect x="124" y="214" width="12" height="64" fill="url(#gChrome)"/>
        <rect x="119" y="262" width="22" height="6" rx="3" fill="url(#gChrome)"/>

        <!-- chao đèn trụ tròn vải trắng in lúa -->
        <g class="shade-wrap" id="shadeBody">
          <path d="M60 44 L60 214 A70 12 0 0 0 200 214 L200 44 A70 12 0 0 0 60 44Z" fill="url(#gOff)"/>
          <path class="shade-on" d="M60 44 L60 214 A70 12 0 0 0 200 214 L200 44 A70 12 0 0 0 60 44Z" fill="url(#gOn)"/>
          <g clip-path="url(#shadeClip)">
            <use href="#wheat" class="wp" transform="translate(84 228) scale(1.35) rotate(-6)"/>
            <use href="#wheat" class="wp" transform="translate(100 230) scale(1.6) rotate(-3)"/>
            <use href="#wheat" class="wp" transform="translate(114 230) scale(1.2) rotate(2)"/>
            <use href="#wheat" class="wp" transform="translate(133 232) scale(1.05) rotate(4)"/>
            <use href="#wheat" class="wp" transform="translate(151 230) scale(1.3) rotate(8)"/>
            <use href="#wheat" class="wp" transform="translate(167 230) scale(.95) rotate(10)"/>
            <use href="#wheat" class="wp" transform="translate(181 230) scale(.8) rotate(14)"/>
            <rect x="60" y="30" width="140" height="200" fill="url(#gSide)"/>
          </g>
          <ellipse class="top-in" cx="130" cy="44" rx="70" ry="12"/>
          <ellipse class="rim" cx="130" cy="44" rx="70" ry="12"/>
          <path class="rim" d="M60 214 A70 12 0 0 0 200 214"/>
        </g>

        <!-- dây kéo -->
        <g class="swing" id="swing">
          <line class="chain" id="chain" x1="199" y1="218" x2="199" y2="300"/>
          <g class="handle" id="pull" tabindex="0" role="button" aria-label="Kéo dây đèn">
            <g id="tassel">
              <circle class="bead" cx="199" cy="304" r="4.5" fill="#d8b36e"/>
              <path class="bead" d="M194 308 L204 308 L202 330 Q199 334 196 330Z" fill="#c9a050"/>
            </g>
            <rect x="184" y="290" width="30" height="60" fill="transparent"/>
          </g>
        </g>
      </svg>
      <p class="lamp-tip" id="tip"><b>Kéo dây</b> để thắp sáng</p>
    </div>

    <!-- ĐĂNG NHẬP (hiện khi bật đèn) -->
    <div class="login" id="login">
      <div class="brand">🥬 Green <b>Mart</b></div>
      <h1>Chào mừng trở lại!</h1>
      <p class="sub">Đăng nhập để khám phá những sản phẩm tươi ngon tại Green Mart.</p>

      <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
      <% } %>
      <% if ("success".equals(request.getParameter("msg"))) { %>
        <div class="success">✓ Đăng ký thành công! Vui lòng đăng nhập.</div>
      <% } %>

      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="group">
          <label for="account">Username hoặc Email</label>
          <div class="box"><span>👤</span>
            <input id="account" type="text" name="account" placeholder="Nhập username hoặc email" autocomplete="username" required>
          </div>
        </div>
        <div class="group">
          <label for="password">Mật khẩu</label>
          <div class="box"><span>🔒</span>
            <input id="password" type="password" name="password" placeholder="Nhập mật khẩu" autocomplete="current-password" required>
          </div>
        </div>
        <button type="submit" class="btn">Đăng nhập</button>
      </form>

      <div class="sep">HOẶC</div>

      <a class="google" href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/quanly-nongnghiep/login-google&response_type=code&client_id=707003451628-6ro7hd1h6knnti6v2fgbgiptfrbo1miu.apps.googleusercontent.com&approval_prompt=force">
        <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google">
        Đăng nhập bằng Google
      </a>

      <div class="reg">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></div>
      <div class="copy">© 2026 Green Mart. Fresh food, happy life.</div>
    </div>
  </div>
</main>

<!-- CON CHIM -->
<svg id="bird" viewBox="0 0 70 56" aria-hidden="true">
  <path class="wing-fly far" d="M34 28 C28 8 14 2 4 4 C14 12 20 22 26 30Z" fill="#4e342e"/>
  <path d="M14 30 L0 22 L3 31 L0 40 L16 35Z" fill="#5d4037"/>
  <ellipse cx="32" cy="32" rx="20" ry="11" fill="#8d6e63"/>
  <path d="M15 36 C24 47 44 47 51 36 C44 41 24 41 15 36Z" fill="#f3e5ce"/>
  <g class="legs" stroke="#5d4037" stroke-width="2" stroke-linecap="round" fill="none">
    <path d="M30 42 L30 52 M26 52 L34 52"/><path d="M38 42 L38 52 M34 52 L42 52"/>
  </g>
  <path class="wing-rest" d="M18 30 C28 23 44 27 47 34 C36 39 25 39 18 30Z" fill="#6d4c41"/>
  <g class="headg">
    <circle cx="52" cy="25" r="9" fill="#a1806f"/>
    <path d="M60 24 L69 27 L60 29Z" fill="#ffb300"/>
    <circle cx="55" cy="23" r="1.9" fill="#111"/><circle cx="55.6" cy="22.4" r=".6" fill="#fff"/>
  </g>
  <path class="wing-fly" d="M34 28 C28 8 14 2 4 4 C14 12 20 22 26 30Z" fill="#6d4c41"/>
</svg>

<script>
(function(){
  var body=document.body,tip=document.getElementById('tip'),v=document.getElementById('bgv');
  var reduce=window.matchMedia&&matchMedia('(prefers-reduced-motion: reduce)').matches;
  v.addEventListener('error',function(){v.style.display='none'},true);

  /* ---- Hiệu ứng nền đêm: sao, sao băng, tuyết | đèn sáng: hạt sáng ---- */
  var cv=document.getElementById('fx'),ctx=cv.getContext('2d'),W,H,stars=[],snow=[],dust=[],shooters=[],i;
  function init(){
    W=cv.width=innerWidth;H=cv.height=innerHeight;stars=[];snow=[];dust=[];
    for(i=0;i<Math.min(130,W/9);i++)stars.push({x:Math.random()*W,y:Math.random()*H,r:Math.random()*1.3+.3,p:Math.random()*6});
    for(i=0;i<70;i++)snow.push({x:Math.random()*W,y:Math.random()*H,r:Math.random()*2.3+.8,s:Math.random()+.4,d:Math.random()*6});
    for(i=0;i<40;i++)dust.push({x:Math.random()*W,y:Math.random()*H,r:Math.random()*2.5+1,s:Math.random()*.4+.1,d:Math.random()*6});
  }
  setInterval(function(){if(!body.classList.contains('lit')&&Math.random()<.75)
    shooters.push({x:Math.random()*W*.7+W*.3,y:Math.random()*H*.35,l:0,max:55+Math.random()*30,v:9+Math.random()*5})},1700);

  /* ---- Quầng sáng bám theo đèn ---- */
  var halo=document.getElementById('halo'),shade=document.getElementById('shadeBody');
  function placeHalo(){var r=shade.getBoundingClientRect();halo.style.left=(r.left+r.width/2)+'px';halo.style.top=(r.top+r.height*.45)+'px'}

  /* ---- Con chim ---- */
  var bird=document.getElementById('bird'),loginEl=document.getElementById('login');
  var B={state:'hidden',t0:0,dur:1,from:{x:0,y:0},x:0,y:0,ang:0};
  function perch(){var r=loginEl.getBoundingClientRect();return{x:r.left+r.width*.7-35,y:r.top-49}}
  function bez(a,b,c,d,t){var u=1-t;return u*u*u*a+3*u*u*t*b+3*u*t*t*c+t*t*t*d}
  function clamp(n,a,b){return Math.max(a,Math.min(b,n))}
  function startArrive(){
    var from=(B.state==='leaving')?{x:B.x,y:B.y}:{x:-120,y:innerHeight*.2};
    B.state='arriving';B.t0=performance.now();B.dur=3800;B.from=from;
    bird.classList.remove('perched');bird.style.opacity=1;
    if(reduce){B.state='perched';bird.classList.add('perched')}
  }
  function startLeave(){
    if(B.state==='hidden')return;
    B.state='leaving';B.t0=performance.now();B.dur=2400;B.from={x:B.x,y:B.y};bird.classList.remove('perched');
  }
  function birdFrame(now){
    if(B.state==='hidden')return;
    var tg=perch(),x=B.x,y=B.y,tAng=0,t,e,f=B.from;
    if(B.state==='arriving'){
      t=Math.min(1,(now-B.t0)/B.dur);e=1-Math.pow(1-t,2.2);
      x=bez(f.x,innerWidth*.18,tg.x-260,tg.x,e);y=bez(f.y,-30,tg.y-190,tg.y,e);
      tAng=clamp(Math.atan2(y-B.y,x-B.x)*57.3,-30,30)*(1-t);
      if(t>=1){B.state='perched';bird.classList.add('perched')}
    }else if(B.state==='perched'){
      x=tg.x;y=tg.y;tAng=0;
    }else if(B.state==='leaving'){
      t=Math.min(1,(now-B.t0)/B.dur);e=t*t;
      x=bez(f.x,f.x+80,innerWidth*.6,innerWidth+160,e);y=bez(f.y,f.y-150,-90,-130,e);
      tAng=clamp(Math.atan2(y-B.y,x-B.x)*57.3,-35,35);
      if(t>=1){B.state='hidden';bird.style.opacity=0;return}
    }
    B.ang+=(tAng-B.ang)*.18;B.x=x;B.y=y;
    bird.style.transform='translate('+x.toFixed(1)+'px,'+y.toFixed(1)+'px) rotate('+B.ang.toFixed(1)+'deg)';
  }

  /* ---- Vòng lặp ---- */
  var t=0;
  function loop(now){
    t+=.016;ctx.clearRect(0,0,W,H);var lit=body.classList.contains('lit'),o;
    if(!lit){
      for(i=0;i<stars.length;i++){o=stars[i];ctx.globalAlpha=.3+.6*Math.abs(Math.sin(t*1.4+o.p));ctx.fillStyle='#fff';ctx.beginPath();ctx.arc(o.x,o.y,o.r,0,6.3);ctx.fill()}
      ctx.globalAlpha=.8;ctx.fillStyle='#fff';
      for(i=0;i<snow.length;i++){o=snow[i];o.y+=o.s;o.x+=Math.sin(t+o.d)*.5;if(o.y>H){o.y=-5;o.x=Math.random()*W}ctx.beginPath();ctx.arc(o.x,o.y,o.r,0,6.3);ctx.fill()}
      for(i=shooters.length-1;i>=0;i--){o=shooters[i];o.l++;o.x-=o.v;o.y+=o.v*.55;
        var g=ctx.createLinearGradient(o.x,o.y,o.x+100,o.y-55);g.addColorStop(0,'rgba(255,255,255,1)');g.addColorStop(1,'rgba(255,255,255,0)');
        ctx.globalAlpha=1;ctx.strokeStyle=g;ctx.lineWidth=2;ctx.beginPath();ctx.moveTo(o.x,o.y);ctx.lineTo(o.x+100,o.y-55);ctx.stroke();
        if(o.l>o.max||o.x<-110)shooters.splice(i,1)}
    }else{
      ctx.fillStyle='#ffc93c';
      for(i=0;i<dust.length;i++){o=dust[i];o.y-=o.s;o.x+=Math.sin(t+o.d)*.4;if(o.y<-10){o.y=H+10;o.x=Math.random()*W}
        ctx.globalAlpha=.2+.35*Math.abs(Math.sin(t*2+o.d));ctx.beginPath();ctx.arc(o.x,o.y,o.r,0,6.3);ctx.fill()}
    }
    ctx.globalAlpha=1;placeHalo();birdFrame(now||performance.now());requestAnimationFrame(loop)
  }
  addEventListener('resize',init);init();requestAnimationFrame(loop);

  /* ---- Bật / tắt đèn ---- */
  var pull=document.getElementById('pull'),chain=document.getElementById('chain'),tassel=document.getElementById('tassel'),
      swing=document.getElementById('swing'),dragging=false,startY=0,dy=0;
  function setPull(d){chain.setAttribute('y2',300+d);tassel.setAttribute('transform','translate(0,'+d+')')}
  function toggle(){
    var on=body.classList.toggle('lit');
    if(on){var p=v.play();if(p&&p.catch)p.catch(function(){});startArrive();tip.innerHTML='<b>Kéo dây</b> lần nữa để tắt đèn'}
    else{startLeave();setTimeout(function(){if(!body.classList.contains('lit'))v.pause()},1700);tip.innerHTML='<b>Kéo dây</b> để thắp sáng'}
  }
  function release(){if(!dragging)return;dragging=false;var ok=dy>26;setPull(0);dy=0;if(ok)toggle()}
  pull.addEventListener('pointerdown',function(e){dragging=true;startY=e.clientY;pull.setPointerCapture(e.pointerId);e.preventDefault()});
  pull.addEventListener('pointermove',function(e){if(!dragging)return;dy=clamp(e.clientY-startY,0,48);setPull(dy)});
  pull.addEventListener('pointerup',release);
  pull.addEventListener('pointercancel',release);
  pull.addEventListener('keydown',function(e){if(e.key==='Enter'||e.key===' '){e.preventDefault();toggle()}});
  shade.addEventListener('click',toggle);
})();
</script>
</body>
</html>
