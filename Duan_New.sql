
DROP TABLE IF EXISTS DanhMuc;

CREATE TABLE DanhMuc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma_danhmuc VARCHAR(50) UNIQUE NOT NULL,     -- Dùng làm URL slug (vd: rau-cu-tuoi, trai-cay-nhiet-doi)
    ten_danhmuc NVARCHAR(100) NOT NULL,        -- Tên hiển thị
    icon NVARCHAR(100),                         -- Icon FontAwesome hoặc Bootstrap Icons (vd: fa-carrot, fa-apple-whole)
    hinh_anh NVARCHAR(500),                     -- Ảnh banner hoặc ảnh đại diện danh mục
    mota NVARCHAR(500),                         -- Mô tả ngắn
    thu_tu INT DEFAULT 0,                       -- Thứ tự hiển thị trên menu/trang chủ
    trang_thai BIT DEFAULT 1,                   -- 1: Hiển thị, 0: Tạm ẩn
    ngay_tao DATETIME DEFAULT GETDATE()
);

CREATE TABLE SanPham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten NVARCHAR(255) NOT NULL,
    gia DECIMAL(18,0) NOT NULL,                   -- Giá bán hiện tại
    gia_goc DECIMAL(18,0) NULL,                   -- Giá gốc (nếu có giảm giá/khuyến mãi)
    so_luong INT NOT NULL DEFAULT 0,              -- Tồn kho
    don_vi_tinh NVARCHAR(50) DEFAULT N'Kg',       -- Đơn vị: Kg, Hộp, Túi, Bó...
    hinh_anh NVARCHAR(500),                       -- Link ảnh chính
    mota_ngan NVARCHAR(500),                      -- Đoạn mô tả ngắn hiển thị ở card sản phẩm
    mota_chitiet NVARCHAR(MAX),                   -- Mô tả chi tiết cho trang xem chi tiết sản phẩm
    xuat_xu NVARCHAR(150) DEFAULT N'Việt Nam',    -- Đà Lạt, Tây Nguyên, Miền Tây...
    trang_thai BIT DEFAULT 1,                     -- 1: Đang bán, 0: Ngừng kinh doanh/Ẩn
    noi_bat BIT DEFAULT 0,                        -- 1: Hiện ở mục Sản phẩm nổi bật trang chủ
    danh_muc_id INT NULL,                         -- Khóa ngoại liên kết danh mục
    ngay_tao DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_SanPham_DanhMuc FOREIGN KEY (danh_muc_id) 
        REFERENCES DanhMuc(id) ON DELETE SET NULL
);
-- 1. Thêm cột da_ban: số lượng đã bán thành công (mặc định là 0)
ALTER TABLE SanPham 
ADD da_ban INT NOT NULL DEFAULT 0;

-- 2. Thêm cột khuyen_mai: phần trăm giảm giá (VD: 10 = giảm 10%, mặc định 0) 
-- Hoặc nếu bạn muốn đánh dấu cờ Khuyến mãi true/false thì dùng kiểu BIT.
-- Thông thường nên dùng INT để lưu % giảm (0 đến 100):
ALTER TABLE SanPham 
ADD khuyen_mai INT DEFAULT 0;

UPDATE SanPham
SET 
    da_ban = CASE id
        WHEN 1 THEN 85   -- Cà Chua Cherry Đỏ Đà Lạt
        WHEN 2 THEN 40   -- Súp Lơ Xanh Hữu Cơ
        WHEN 3 THEN 62   -- Cà Rốt Baby Đà Lạt
        WHEN 4 THEN 38   -- Ớt Chuông Đà Lạt Ba Màu
        WHEN 5 THEN 95   -- Bơ Sáp 034 Tây Nguyên
        WHEN 6 THEN 120  -- Dâu Tây New Zealand Đà Lạt
        WHEN 7 THEN 75   -- Xoài Cát Hòa Lộc Tiền Giang
        WHEN 8 THEN 53   -- Nấm Đùi Gà Tươi Hữu Cơ
        WHEN 9 THEN 31   -- Nấm Hương Khô Rừng Tây Bắc
        WHEN 10 THEN 110 -- Hạt Điều Rang Muối Vỏ Lụa
        WHEN 11 THEN 140 -- Gạo Lứt Huyết Rồng Hữu Cơ
        WHEN 12 THEN 45  -- Mật Ong Rừng Hoa Cà Phê
        WHEN 13 THEN 88  -- Xoài Sấy Dẻo Tự Nhiên
        WHEN 14 THEN 60  -- Tiêu Đen Phú Quốc
        ELSE da_ban
    END,
    khuyen_mai = CASE id
        WHEN 1 THEN 10   -- Giảm 10%
        WHEN 2 THEN 10   -- Giảm 10%
        WHEN 3 THEN 11   -- Giảm 11%
        WHEN 4 THEN 8    -- Giảm 8%
        WHEN 5 THEN 11   -- Giảm 11%
        WHEN 6 THEN 14   -- Giảm 14%
        WHEN 7 THEN 14   -- Giảm 14%
        WHEN 8 THEN 13   -- Giảm 13%
        WHEN 9 THEN 12   -- Giảm 12%
        WHEN 10 THEN 10  -- Giảm 10%
        WHEN 11 THEN 13  -- Giảm 13%
        WHEN 12 THEN 15  -- Giảm 15%
        WHEN 13 THEN 12  -- Giảm 12%
        WHEN 14 THEN 9   -- Giảm 9%
        ELSE khuyen_mai
    END
WHERE id BETWEEN 1 AND 14;

UPDATE SanPham
SET 
    -- Tự động tính % giảm giá nếu gia_goc > gia
    khuyen_mai = CASE 
        WHEN gia_goc IS NOT NULL AND gia_goc > gia 
        THEN ROUND(((gia_goc - gia) * 100.0 / gia_goc), 0)
        ELSE 0 
    END,
    -- Giả lập số lượng đã bán dựa vào ID (chạy ngẫu nhiên từ 30 đến 120 đơn)
    da_ban = (id * 7 + 25) 
WHERE id BETWEEN 1 AND 14;



SELECT id, ten, gia, gia_goc, khuyen_mai, da_ban, so_luong 
FROM SanPham 
ORDER BY id ASC;
-- 1. Xóa dữ liệu cũ và reset IDENTITY về 1
DELETE FROM SanPham;
DELETE FROM DanhMuc;

DBCC CHECKIDENT ('DanhMuc', RESEED, 0);
DBCC CHECKIDENT ('SanPham', RESEED, 0);
GO
USE nha;
GO

-- 1. Thêm danh mục (nếu mã nào đã có thì bỏ qua, chưa có thì thêm)
IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE ma_danhmuc = 'rau-cu-huu-co')
    INSERT INTO DanhMuc (ma_danhmuc, ten_danhmuc, icon, hinh_anh, mota, thu_tu, trang_thai) 
    VALUES ('rau-cu-huu-co', N'Rau Củ Hữu Cơ', 'fa-solid fa-carrot', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500', N'Rau củ sạch chuẩn VietGAP', 1, 1);

IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE ma_danhmuc = 'trai-cay-dac-san')
    INSERT INTO DanhMuc (ma_danhmuc, ten_danhmuc, icon, hinh_anh, mota, thu_tu, trang_thai) 
    VALUES ('trai-cay-dac-san', N'Trái Cây Đặc Sản', 'fa-solid fa-apple-whole', 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=500', N'Trái cây tươi đặc sản theo mùa', 2, 1);

IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE ma_danhmuc = 'nam-tuoi-cac-loai')
    INSERT INTO DanhMuc (ma_danhmuc, ten_danhmuc, icon, hinh_anh, mota, thu_tu, trang_thai) 
    VALUES ('nam-tuoi-cac-loai', N'Nấm Tươi & Nấm Khô', 'fa-solid fa-leaf', 'https://images.unsplash.com/photo-1504544750208-dc0358e63f7f?w=500', N'Nấm tươi thu hoạch trong ngày', 3, 1);

IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE ma_danhmuc = 'ngu-coc-hat-dinh-duong')
    INSERT INTO DanhMuc (ma_danhmuc, ten_danhmuc, icon, hinh_anh, mota, thu_tu, trang_thai) 
    VALUES ('ngu-coc-hat-dinh-duong', N'Ngũ Cốc & Hạt', 'fa-solid fa-wheat-awn', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500', N'Gạo lứt và hạt dinh dưỡng', 4, 1);

IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE ma_danhmuc = 'nong-san-say-kho')
    INSERT INTO DanhMuc (ma_danhmuc, ten_danhmuc, icon, hinh_anh, mota, thu_tu, trang_thai) 
    VALUES ('nong-san-say-kho', N'Nông Sản Chế Biến', 'fa-solid fa-box-open', 'https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=500', N'Mật ong, trái cây sấy dẻo', 5, 1);

IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE ma_danhmuc = 'gia-vi-nong-nghiep')
    INSERT INTO DanhMuc (ma_danhmuc, ten_danhmuc, icon, hinh_anh, mota, thu_tu, trang_thai) 
    VALUES ('gia-vi-nong-nghiep', N'Gia Vị Tự Nhiên', 'fa-solid fa-pepper-hot', 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=500', N'Tiêu, ớt, tỏi tự nhiên', 6, 1);
GO

-- 2. Xóa sạch sản phẩm cũ để tránh trùng lặp


-- 3. Chèn sản phẩm bằng SELECT (tự động mapping ID thực tế của từng danh mục)
INSERT INTO SanPham (ten, gia, gia_goc, so_luong, don_vi_tinh, hinh_anh, mota_ngan, mota_chitiet, xuat_xu, trang_thai, noi_bat, danh_muc_id)
-- 1. Nhóm Rau Củ
SELECT N'Cà Chua Cherry Đỏ Đà Lạt', 45000, 50000, 120, N'Hộp 500g', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600', N'Cà chua cherry ngọt thanh, giòn mọng nước, chuẩn VietGAP.', N'Cà chua cherry đỏ được canh tác trong nhà kính tại Đà Lạt theo tiêu chuẩn VietGAP.', N'Đà Lạt, Lâm Đồng', 1, 1, id FROM DanhMuc WHERE ma_danhmuc = 'rau-cu-huu-co'
UNION ALL
SELECT N'Súp Lơ Xanh Hữu Cơ (Broccoli)', 38000, 42000, 75, N'Bông (500g)', 'https://images.unsplash.com/photo-1584270354949-c26b0d5b4a0c?w=600', N'Bông cải xanh tươi mới hái trong ngày, giàu chất chống oxy hóa.', N'Súp lơ xanh thu hoạch mỗi sáng sớm, đọt chắc, búp xanh mướt không thuốc trừ sâu.', N'Đà Lạt, Lâm Đồng', 1, 1, id FROM DanhMuc WHERE ma_danhmuc = 'rau-cu-huu-co'
UNION ALL
SELECT N'Cà Rốt Baby Đà Lạt', 32000, 36000, 90, N'Túi 500g', 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=600', N'Cà rốt nhỏ mềm ngọt, củ giòn không xơ, thích hợp làm salad.', N'Cà rốt non thu hoạch khi đạt kích thước chuẩn baby, thịt củ ngọt đậm tự nhiên.', N'Đà Lạt, Lâm Đồng', 1, 0, id FROM DanhMuc WHERE ma_danhmuc = 'rau-cu-huu-co'
UNION ALL
SELECT N'Ớt Chuông Đà Lạt Ba Màu', 55000, 60000, 65, N'Kg', 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=600', N'Ớt chuông đỏ, vàng, xanh giòn ngọt, vỏ bóng dày dặn.', N'Ớt chuông nhà kính công nghệ cao, vị ngọt giòn không cay nồng.', N'Đà Lạt, Lâm Đồng', 1, 0, id FROM DanhMuc WHERE ma_danhmuc = 'rau-cu-huu-co'

-- 2. Nhóm Trái Cây
UNION ALL
SELECT N'Bơ Sáp 034 Tây Nguyên Hạng 1', 85000, 95000, 50, N'Kg', 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=600', N'Bơ quả dài, cơm vàng dẻo quánh, hạt lép béo ngậy.', N'Bơ giống 034 đầu dòng tại Bảo Lộc, Lâm Đồng.', N'Bảo Lộc, Lâm Đồng', 1, 1, id FROM DanhMuc WHERE ma_danhmuc = 'trai-cay-dac-san'
UNION ALL
SELECT N'Dâu Tây New Zealand Đà Lạt', 160000, 185000, 40, N'Hộp 500g', 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=600', N'Dâu tây hái tại vườn, trái đỏ đều, vị ngọt thanh thơm lừng.', N'Dâu tây giống New Zealand canh tác thủy canh bán tự nhiên trên giàn.', N'Đà Lạt, Lâm Đồng', 1, 1, id FROM DanhMuc WHERE ma_danhmuc = 'trai-cay-dac-san'
UNION ALL
SELECT N'Xoài Cát Hòa Lộc Tiền Giang', 90000, 105000, 60, N'Kg', 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=600', N'Xoài cát da vàng óng, thịt chắc mịn, ngọt lịm đặc trưng.', N'Đặc sản nức tiếng Tiền Giang chuẩn mã xuất khẩu.', N'Tiền Giang', 1, 0, id FROM DanhMuc WHERE ma_danhmuc = 'trai-cay-dac-san'

-- 3. Nhóm Nấm
UNION ALL
SELECT N'Nấm Đùi Gà Tươi Hữu Cơ', 42000, 48000, 80, N'Túi 500g', 'https://images.unsplash.com/photo-1504544750208-dc0358e63f7f?w=600', N'Thân nấm dày giòn ngọt, giàu đạm thực vật và khoáng chất.', N'Nấm đùi gà tươi sạch được nuôi trồng trong phòng lạnh khử trùng.', N'Đồng Nai', 1, 0, id FROM DanhMuc WHERE ma_danhmuc = 'nam-tuoi-cac-loai'
UNION ALL
SELECT N'Nấm Hương Khô Rừng Tây Bắc', 115000, 130000, 50, N'Túi 250g', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600', N'Cánh nấm dày, mùi thơm đậm đà, không chất bảo quản.', N'Nấm hương mọc tự nhiên trên các thân gỗ mục vùng núi Tây Bắc.', N'Lào Cai', 1, 1, id FROM DanhMuc WHERE ma_danhmuc = 'nam-tuoi-cac-loai'

-- 4. Nhóm Hạt & Ngũ Cốc
UNION ALL
SELECT N'Hạt Điều Rang Muối Vỏ Lụa A+', 135000, 150000, 95, N'Hũ 500g', 'https://images.unsplash.com/photo-1509912760195-4f6cfd9c0245?w=600', N'Hạt điều Bình Phước size cồ loại 1, béo bùi giòn rụm.', N'Hạt điều tuyển chọn size cồ đồng đều, rang củi thủ công.', N'Bình Phước', 1, 1, id FROM DanhMuc WHERE ma_danhmuc = 'ngu-coc-hat-dinh-duong'
UNION ALL
SELECT N'Gạo Lứt Huyết Rồng Hữu Cơ', 48000, 55000, 150, N'Túi 1Kg', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600', N'Hạt gạo đỏ thẫm giàu chất xơ, phù hợp cho người ăn kiêng.', N'Gạo lứt đỏ nguyên cám sạch, chỉ số đường huyết thấp.', N'Sóc Trăng', 1, 0, id FROM DanhMuc WHERE ma_danhmuc = 'ngu-coc-hat-dinh-duong'

-- 5. Nhóm Nông Sản Chế Biến
UNION ALL
SELECT N'Mật Ong Rừng Hoa Cà Phê Nguyên Chất', 145000, 170000, 70, N'Chai 500ml', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=600', N'Mật ong sánh vàng óng, ngọt thanh tự nhiên.', N'Mật ong thu hoạch vào mùa hoa cà phê nở rộ tại Đắk Lắk.', N'Đắk Lắk', 1, 1, id FROM DanhMuc WHERE ma_danhmuc = 'nong-san-say-kho'
UNION ALL
SELECT N'Xoài Sấy Dẻo Tự Nhiên Không Đường', 75000, 85000, 85, N'Túi Zip 200g', 'https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=600', N'Miếng xoài dẻo mịn, vị chua ngọt tự nhiên, không tẩm ướp.', N'Sản xuất từ xoài cát tươi chín mọng bằng công nghệ sấy lạnh.', N'Đồng Tháp', 1, 0, id FROM DanhMuc WHERE ma_danhmuc = 'nong-san-say-kho'

-- 6. Nhóm Gia Vị
UNION ALL
SELECT N'Tiêu Đen Phú Quốc Thượng Hạng', 68000, 75000, 110, N'Hũ 200g', 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600', N'Hạt tiêu chắc mẩy, cay nồng đậm đà.', N'Tiêu đen thu hoạch chín vụ tại đảo Phú Quốc, phơi nắng tự nhiên.', N'Kiên Giang', 1, 0, id FROM DanhMuc WHERE ma_danhmuc = 'gia-vi-nong-nghiep';
GO

-- 4. Kiểm tra lại kết quả
SELECT 
    sp.id, 
    sp.ten AS [Tên Sản Phẩm], 
    dm.ten_danhmuc AS [Danh Mục],
    FORMAT(sp.gia, 'N0') + ' đ' AS [Giá Bán],
    sp.xuat_xu AS [Xuất Xứ]
FROM SanPham sp
JOIN DanhMuc dm ON sp.danh_muc_id = dm.id;
GO
select * from SanPham
IF OBJECT_ID('dbo.Slide','U') IS NULL
CREATE TABLE dbo.Slide(
    Id        INT IDENTITY(1,1) PRIMARY KEY,
    TieuDe    NVARCHAR(200) NOT NULL,          -- dòng tiêu đề 1
    TieuDePhu NVARCHAR(200) NULL,              -- dòng tiêu đề 2
    Badge     NVARCHAR(100) NULL,              -- nhãn vàng nhỏ phía trên
    MoTa      NVARCHAR(500) NULL,              -- đoạn mô tả ngắn
    DacDiem   NVARCHAR(500) NULL,              -- 'icon|chữ;icon|chữ;...' (icon Bootstrap Icons)
    IconNoi   NVARCHAR(200) NULL,              -- emoji bay lơ lửng, ngăn cách bằng dấu phẩy
    ViTri     VARCHAR(10) NOT NULL DEFAULT 'left',   -- left | center | right
    NutChu    NVARCHAR(50) NULL,               -- chữ trên nút chính
    NutLink   NVARCHAR(200) NULL,              -- link nút chính
    ThuTu     INT NOT NULL DEFAULT 0,
    HienThi   BIT NOT NULL DEFAULT 1
);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Slide)
INSERT INTO dbo.Slide (TieuDe, TieuDePhu, Badge, MoTa, DacDiem, IconNoi, ViTri, NutChu, NutLink, ThuTu) VALUES
(N'Rau Củ Quả Tươi Sạch', N'Cho cuộc sống khỏe mạnh hơn!', N'100% TƯƠI MỚI MỖI NGÀY',
 N'Thu hoạch trực tiếp tại vườn, giao tận tay bạn ngay trong ngày.',
 N'bi-shield-check|100% nông sản sạch;bi-truck|Giao hàng nhanh chóng;bi-cash-coin|Giá cả hợp lý',
 N'🥬,🍅,🥕,🌽,🥦,🌶️', 'left', N'Mua ngay', N'#san-pham', 1),

(N'Trái Cây Chín Mọng', N'Ngọt thanh từ vườn nhà', N'MÙA TRÁI CÂY MỚI',
 N'Cam, táo, nho, dâu tây hái chín cây, mọng nước và giàu vitamin.',
 N'bi-sun|Hái chín tự nhiên;bi-droplet-half|Mọng nước;bi-heart-pulse|Giàu vitamin C',
 N'🍊,🍎,🍇,🍓,🍍,🍋', 'right', N'Xem trái cây', N'#san-pham', 2),

(N'Siêu Ưu Đãi Hôm Nay', N'Giảm đến 30% toàn bộ rau củ', N'FLASH SALE TRONG NGÀY',
 N'Đặt hàng ngay hôm nay để nhận mã giảm giá và quà tặng kèm hấp dẫn.',
 N'bi-lightning-charge|Flash sale mỗi ngày;bi-gift|Quà tặng kèm;bi-ticket-perforated|Mã giảm 10%',
 N'🎉,🏷️,💥,🛒,🎁,⭐', 'center', N'Săn ưu đãi', N'#khuyen-mai', 3),

(N'Giao Hàng Hỏa Tốc', N'Nhận rau tươi chỉ trong 2 giờ', N'GIAO NHANH NỘI THÀNH',
 N'Đặt trước 17h, rau củ tươi được giao đến cửa nhà bạn trong chưa đầy 2 giờ.',
 N'bi-stopwatch|Giao trong 2 giờ;bi-geo-alt|Toàn thành phố;bi-box-seam|Đóng gói giữ lạnh',
 N'🛵,📦,⏱️,🏠,🚚,📍', 'left', N'Đặt hàng', N'#san-pham', 4),

(N'Từ Nông Trại Đến Bàn Ăn', N'Minh bạch nguồn gốc chuẩn VietGAP', N'AN TOÀN TỪ GỐC',
 N'Mỗi sản phẩm đều có mã QR truy xuất nguồn gốc, bạn biết rõ rau được trồng ở đâu.',
 N'bi-patch-check|Chuẩn VietGAP;bi-qr-code|Truy xuất bằng QR;bi-people|120 nhà vườn liên kết',
 N'🚜,🌾,🌱,🐝,🌻,🍃', 'right', N'Tìm hiểu thêm', N'#gioi-thieu', 5),

(N'Combo Gia Đình Tiết Kiệm', N'Chỉ từ 149.000₫ mỗi combo', N'COMBO BÁN CHẠY',
 N'Rau củ theo mùa được chọn sẵn, đủ cho cả nhà dùng 3 ngày, miễn phí giao hàng.',
 N'bi-basket3|8 loại rau củ;bi-truck|Miễn phí giao;bi-piggy-bank|Tiết kiệm đến 25%',
 N'🧺,🥗,🍲,👨‍👩‍👧,🥒,🍆', 'center', N'Xem combo', N'#combo', 6);
GO

SELECT * FROM dbo.Slide ORDER BY ThuTu;



-- Xoa bang neu da ton tai de tao moi tu dau
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL
    DROP TABLE dbo.Users;
GO
-- 1. Tao moi bang (neu chua tao)
CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fullname NVARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER' 
        CONSTRAINT CK_Users_Role CHECK (role IN ('ADMIN', 'EMPLOYEE', 'CUSTOMER')),
    salary DECIMAL(18, 2) DEFAULT 0.00, -- Muc luong thang (vnd)
    status BIT DEFAULT 1,               -- 1: Hoat dong, 0: Khoa
    created_at DATETIME DEFAULT GETDATE()
);
GO


INSERT INTO Users (fullname, username, email, password, role, salary, status, created_at) VALUES
-- 1. Ban Quan tri (ADMIN)
(N'Nguyễn Quản Trị', 'admin', 'admin@gmail.com', 'admin123', 'ADMIN', 35000000.00, 1, '2026-01-10 08:30:00'),
(N'Trần Minh Hoàng', 'hoang_superadmin', 'hoangtm@company.com', '123456', 'ADMIN', 30000000.00, 1, '2026-01-15 09:00:00'),
(N'Lê Bảo Ngọc', 'ngoc_sysadmin', 'ngoclb@company.com', '123456', 'ADMIN', 28000000.00, 1, '2026-02-01 10:15:00'),

-- 2. Nhan vien (EMPLOYEE)
(N'Phạm Văn Nam', 'nam_dev', 'nampv@company.com', '123456', 'EMPLOYEE', 18500000.00, 1, '2026-02-10 14:00:00'),
(N'Đỗ Thị Mai', 'mai_tester', 'maidt@company.com', '123456', 'EMPLOYEE', 14000000.00, 1, '2026-02-12 08:45:00'),
(N'Vũ Đức Thắng', 'thang_backend', 'thangvd@company.com', '123456', 'EMPLOYEE', 22000000.00, 1, '2026-02-20 11:30:00'),
(N'Hoàng Yến Nhi', 'nhi_frontend', 'nhihy@company.com', '123456', 'EMPLOYEE', 16000000.00, 1, '2026-03-01 09:20:00'),
(N'Bùi Quốc Anh', 'anh_sale', 'anhbq@company.com', '123456', 'EMPLOYEE', 12000000.00, 1, '2026-03-05 13:10:00'),
(N'Ngô Thu Thảo', 'thao_hr', 'thaont@company.com', '123456', 'EMPLOYEE', 15000000.00, 1, '2026-03-10 15:40:00'),
(N'Đinh Quang Hải', 'hai_support', 'haidq@company.com', '123456', 'EMPLOYEE', 10500000.00, 1, '2026-03-15 16:00:00'),
(N'Lý Tuấn Kiệt', 'kiet_designer', 'kietlt@company.com', '123456', 'EMPLOYEE', 17000000.00, 1, '2026-03-18 10:00:00'),
(N'Trương Hồng Phượng', 'phuong_accountant', 'phuongth@company.com', '123456', 'EMPLOYEE', 13500000.00, 1, '2026-03-22 08:00:00'),
(N'Đặng Hữu Phúc', 'phuc_intern', 'phucdh@company.com', '123456', 'EMPLOYEE', 5000000.00, 1, '2026-04-01 08:30:00'),
(N'Phan Thanh Tùng', 'tung_old_emp', 'tungpt@company.com', '123456', 'EMPLOYEE', 11000000.00, 0, '2026-01-20 09:00:00'), -- Bi khoa

-- 3. Khach hang (CUSTOMER)
(N'Võ Thanh Tú', 'thanhtu99', 'thanhtu99@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-02 10:20:00'),
(N'Dương Gia Huy', 'huy_duong', 'huygiahuy@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-05 11:45:00'),
(N'Hồ Bích Trâm', 'tram_ho', 'bichtram.ho@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-10 14:15:00'),
(N'Cao Thái Sơn', 'son_cao', 'thaisoncao@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-12 18:20:00'),
(N'Lâm Mỹ Linh', 'mylinh_lam', 'linh.lam98@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-15 19:30:00'),
(N'Tạ Đình Phong', 'phong_ta', 'dinhphong.ta@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-18 21:05:00'),
(N'Mai Phương Thúy', 'thuy_mai', 'phuongthuy.mai@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-20 07:45:00'),
(N'Châu Gia Bảo', 'bao_chau', 'giabao.chau@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-22 12:00:00'),
(N'Lê Quỳnh Anh', 'quynhanh_le', 'quynhanh2004@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-25 15:10:00'),
(N'Phạm Hùng Cường', 'cuong_pham', 'hungcuong.p@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-27 16:50:00'),
(N'Trần Thu Hà', 'ha_tran96', 'thuhatran96@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-04-29 09:15:00'),
(N'Nguyễn Hữu Đạt', 'dat_nguyen', 'huudat.nguyen@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-05-02 20:40:00'),
(N'Đoàn Khánh Linh', 'linh_doan', 'khanhlinh.doan@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-05-05 13:25:00'),
(N'Hà Trọng Nhân', 'nhan_ha', 'trongnhan.ha@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-05-08 17:05:00'),
(N'Vũ Thị Kim Ngân', 'ngan_kim', 'kimngan.vu@gmail.com', '123456', 'CUSTOMER', 0.00, 1, '2026-05-10 11:35:00'),
(N'Trịnh Minh Tuấn', 'tuan_spam', 'spamuser@gmail.com', '123456', 'CUSTOMER', 0.00, 0, '2026-05-12 14:00:00'); -- Bi khoa
GO

-- Kiem tra lai ket qua vua them
select * from Users

SELECT TOP 10 * FROM Users ORDER BY id DESC;
















USE nha;
GO

/* =====================================================
   1. GIỎ HÀNG (mỗi khách 1 dòng / 1 sản phẩm)
   ===================================================== */
IF OBJECT_ID('dbo.GioHang','U') IS NULL
CREATE TABLE dbo.GioHang (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    user_id     INT NOT NULL,
    san_pham_id INT NOT NULL,
    so_luong    INT NOT NULL DEFAULT 1 CONSTRAINT CK_GioHang_SL CHECK (so_luong > 0),
    ngay_them   DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_GioHang_User    FOREIGN KEY (user_id)     REFERENCES dbo.Users(id)    ON DELETE CASCADE,
    CONSTRAINT FK_GioHang_SanPham FOREIGN KEY (san_pham_id) REFERENCES dbo.SanPham(id)  ON DELETE CASCADE,
    CONSTRAINT UQ_GioHang UNIQUE (user_id, san_pham_id)      -- thêm lại cùng SP thì cộng dồn số lượng
);
GO

/* =====================================================
   2. ĐƠN HÀNG
   trang_thai: Chờ xử lý -> Đã xử lý (nhân viên bấm xử lý) | Đã hủy
   nhan_vien_id: NULL cho tới khi có nhân viên bấm "Xử lý"
   ===================================================== */
IF OBJECT_ID('dbo.DonHang','U') IS NULL
CREATE TABLE dbo.DonHang (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    ma_don         VARCHAR(30)   NOT NULL UNIQUE,            -- vd: DH20261105-0001
    khach_hang_id  INT NULL,                                 -- khách đặt
    nhan_vien_id   INT NULL,                                 -- nhân viên xử lý
    ten_nguoi_nhan NVARCHAR(100) NOT NULL,
    sdt            VARCHAR(20)   NOT NULL,
    dia_chi        NVARCHAR(300) NOT NULL,
    ghi_chu        NVARCHAR(500) NULL,
    phuong_thuc_tt NVARCHAR(50)  NOT NULL DEFAULT N'COD',    -- COD / Chuyển khoản / Ví điện tử
    tong_tien      DECIMAL(18,0) NOT NULL DEFAULT 0,
    trang_thai     NVARCHAR(30)  NOT NULL DEFAULT N'Chờ xử lý'
        CONSTRAINT CK_DonHang_TT CHECK (trang_thai IN (N'Chờ xử lý', N'Đã xử lý', N'Đã hủy')),
    ngay_dat       DATETIME NOT NULL DEFAULT GETDATE(),
    ngay_xu_ly     DATETIME NULL,
    -- SQL Server không cho 2 FK cùng SET NULL về 1 bảng => nhan_vien_id để NO ACTION
    CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY (khach_hang_id) REFERENCES dbo.Users(id) ON DELETE SET NULL,
    CONSTRAINT FK_DonHang_NhanVien  FOREIGN KEY (nhan_vien_id)  REFERENCES dbo.Users(id)
);
GO

/* =====================================================
   3. CHI TIẾT ĐƠN HÀNG (lưu lại tên + giá tại thời điểm mua)
   ===================================================== */
IF OBJECT_ID('dbo.ChiTietDonHang','U') IS NULL
CREATE TABLE dbo.ChiTietDonHang (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    don_hang_id  INT NOT NULL,
    san_pham_id  INT NULL,
    ten_san_pham NVARCHAR(255) NOT NULL,
    don_gia      DECIMAL(18,0) NOT NULL,
    so_luong     INT NOT NULL CONSTRAINT CK_CT_SL CHECK (so_luong > 0),
    CONSTRAINT FK_CT_DonHang FOREIGN KEY (don_hang_id) REFERENCES dbo.DonHang(id)  ON DELETE CASCADE,
    CONSTRAINT FK_CT_SanPham FOREIGN KEY (san_pham_id) REFERENCES dbo.SanPham(id)  ON DELETE SET NULL
);
GO

CREATE INDEX IX_DonHang_TrangThai ON dbo.DonHang(trang_thai, ngay_dat);
CREATE INDEX IX_DonHang_NhanVien  ON dbo.DonHang(nhan_vien_id, trang_thai);
GO

/* =====================================================
   4. DỮ LIỆU MẪU (3 đơn "Chờ xử lý" của khách thanhtu99, huy_duong, tram_ho)
   ===================================================== */
IF NOT EXISTS (SELECT 1 FROM dbo.DonHang)
BEGIN
    DECLARE @id INT;

    INSERT INTO dbo.DonHang (ma_don, khach_hang_id, ten_nguoi_nhan, sdt, dia_chi, phuong_thuc_tt, tong_tien)
    VALUES ('DH20261105-0001', (SELECT id FROM Users WHERE username='thanhtu99'),
            N'Võ Thanh Tú', '0901234567', N'12 Nguyễn Huệ, Quận 1, TP.HCM', N'COD', 0);
    SET @id = SCOPE_IDENTITY();
    INSERT INTO dbo.ChiTietDonHang (don_hang_id, san_pham_id, ten_san_pham, don_gia, so_luong)
    SELECT @id, id, ten, gia, q FROM (VALUES (1,2),(5,1)) v(sp,q) JOIN SanPham ON SanPham.id = v.sp;
    UPDATE dbo.DonHang SET tong_tien = (SELECT SUM(don_gia*so_luong) FROM ChiTietDonHang WHERE don_hang_id=@id) WHERE id=@id;

    INSERT INTO dbo.DonHang (ma_don, khach_hang_id, ten_nguoi_nhan, sdt, dia_chi, phuong_thuc_tt, tong_tien)
    VALUES ('DH20261105-0002', (SELECT id FROM Users WHERE username='huy_duong'),
            N'Dương Gia Huy', '0912345678', N'45 Lê Lợi, Thủ Đức, TP.HCM', N'Chuyển khoản', 0);
    SET @id = SCOPE_IDENTITY();
    INSERT INTO dbo.ChiTietDonHang (don_hang_id, san_pham_id, ten_san_pham, don_gia, so_luong)
    SELECT @id, id, ten, gia, q FROM (VALUES (6,2),(12,1),(10,1)) v(sp,q) JOIN SanPham ON SanPham.id = v.sp;
    UPDATE dbo.DonHang SET tong_tien = (SELECT SUM(don_gia*so_luong) FROM ChiTietDonHang WHERE don_hang_id=@id) WHERE id=@id;

    INSERT INTO dbo.DonHang (ma_don, khach_hang_id, ten_nguoi_nhan, sdt, dia_chi, ghi_chu, phuong_thuc_tt, tong_tien)
    VALUES ('DH20261105-0003', (SELECT id FROM Users WHERE username='tram_ho'),
            N'Hồ Bích Trâm', '0987000111', N'8 Trần Hưng Đạo, Bình Thạnh, TP.HCM', N'Giao giờ hành chính', N'COD', 0);
    SET @id = SCOPE_IDENTITY();
    INSERT INTO dbo.ChiTietDonHang (don_hang_id, san_pham_id, ten_san_pham, don_gia, so_luong)
    SELECT @id, id, ten, gia, q FROM (VALUES (3,3),(11,2)) v(sp,q) JOIN SanPham ON SanPham.id = v.sp;
    UPDATE dbo.DonHang SET tong_tien = (SELECT SUM(don_gia*so_luong) FROM ChiTietDonHang WHERE don_hang_id=@id) WHERE id=@id;
END
GO

SELECT dh.ma_don, dh.ten_nguoi_nhan, dh.tong_tien, dh.trang_thai, ct.ten_san_pham, ct.so_luong
FROM DonHang dh JOIN ChiTietDonHang ct ON ct.don_hang_id = dh.id
ORDER BY dh.id;


select * from DonHang

















USE nha;
GO

/* =====================================================
   1. BẢNG EMPLOYEE: lấy từ bảng Users (role = EMPLOYEE)
      + cột san_pham_da_ban (tổng sản phẩm nhân viên đã xử lý bán)
   ===================================================== */
IF OBJECT_ID('dbo.Employee','U') IS NULL
CREATE TABLE dbo.Employee (
    user_id          INT           NOT NULL PRIMARY KEY,
    fullname         NVARCHAR(100) NOT NULL,
    username         VARCHAR(50)   NOT NULL,
    email            VARCHAR(100)  NOT NULL,
    salary           DECIMAL(18,2) NOT NULL DEFAULT 0,
    san_pham_da_ban  INT           NOT NULL DEFAULT 0,   -- tổng số sản phẩm đã bán
    so_don_da_xu_ly  INT           NOT NULL DEFAULT 0,   -- tổng số đơn đã xử lý
    CONSTRAINT FK_Employee_Users FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE CASCADE
);
GO

-- Đổ dữ liệu nhân viên có sẵn từ bảng Users
INSERT INTO dbo.Employee (user_id, fullname, username, email, salary)
SELECT u.id, u.fullname, u.username, u.email, ISNULL(u.salary,0)
FROM dbo.Users u
WHERE u.role = 'EMPLOYEE'
  AND NOT EXISTS (SELECT 1 FROM dbo.Employee e WHERE e.user_id = u.id);
GO

-- Tính lại số liệu từ các đơn đã xử lý (nếu đã có đơn trước đó)
UPDATE e
SET e.so_don_da_xu_ly = x.so_don,
    e.san_pham_da_ban = x.so_sp
FROM dbo.Employee e
JOIN (SELECT dh.nhan_vien_id AS uid,
             COUNT(DISTINCT dh.id)        AS so_don,
             ISNULL(SUM(ct.so_luong),0)   AS so_sp
      FROM dbo.DonHang dh
      LEFT JOIN dbo.ChiTietDonHang ct ON ct.don_hang_id = dh.id
      WHERE dh.trang_thai = N'Đã xử lý' AND dh.nhan_vien_id IS NOT NULL
      GROUP BY dh.nhan_vien_id) x ON x.uid = e.user_id;
GO

/* =====================================================
   2. TRIGGER: khi thêm user mới có role EMPLOYEE -> tự thêm vào Employee
   ===================================================== */
IF OBJECT_ID('dbo.trg_Users_ThemEmployee','TR') IS NOT NULL DROP TRIGGER dbo.trg_Users_ThemEmployee;
GO
CREATE TRIGGER dbo.trg_Users_ThemEmployee ON dbo.Users AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Employee (user_id, fullname, username, email, salary)
    SELECT i.id, i.fullname, i.username, i.email, ISNULL(i.salary,0)
    FROM inserted i
    WHERE i.role = 'EMPLOYEE'
      AND NOT EXISTS (SELECT 1 FROM dbo.Employee e WHERE e.user_id = i.id);
END
GO

/* =====================================================
   3. TRIGGER: khi nhân viên bấm "Xử lý đơn" (trạng thái -> Đã xử lý)
      => cộng số sản phẩm của đơn đó vào san_pham_da_ban của nhân viên.
      Chạy trong cùng transaction với DonHangDAO.xuLyDonHang nên lỗi tồn kho
      (rollback) sẽ hoàn lại luôn, không cần sửa code Java.
   ===================================================== */
IF OBJECT_ID('dbo.trg_DonHang_CapNhatEmployee','TR') IS NOT NULL DROP TRIGGER dbo.trg_DonHang_CapNhatEmployee;
GO
CREATE TRIGGER dbo.trg_DonHang_CapNhatEmployee ON dbo.DonHang AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE(trang_thai) RETURN;

    DECLARE @moi TABLE (uid INT PRIMARY KEY, so_don INT, so_sp INT);

    INSERT INTO @moi (uid, so_don, so_sp)
    SELECT i.nhan_vien_id, COUNT(DISTINCT i.id), ISNULL(SUM(ct.so_luong),0)
    FROM inserted i
    JOIN deleted d ON d.id = i.id
    LEFT JOIN dbo.ChiTietDonHang ct ON ct.don_hang_id = i.id
    WHERE i.trang_thai = N'Đã xử lý'
      AND d.trang_thai <> N'Đã xử lý'
      AND i.nhan_vien_id IS NOT NULL
    GROUP BY i.nhan_vien_id;

    -- đảm bảo người xử lý đã có dòng trong Employee
    INSERT INTO dbo.Employee (user_id, fullname, username, email, salary)
    SELECT u.id, u.fullname, u.username, u.email, ISNULL(u.salary,0)
    FROM dbo.Users u
    WHERE u.id IN (SELECT uid FROM @moi)
      AND NOT EXISTS (SELECT 1 FROM dbo.Employee e WHERE e.user_id = u.id);

    UPDATE e
    SET e.san_pham_da_ban = e.san_pham_da_ban + m.so_sp,
        e.so_don_da_xu_ly = e.so_don_da_xu_ly + m.so_don
    FROM dbo.Employee e
    JOIN @moi m ON m.uid = e.user_id;
END
GO

-- Kiểm tra
SELECT * FROM dbo.Employee ORDER BY san_pham_da_ban DESC;

