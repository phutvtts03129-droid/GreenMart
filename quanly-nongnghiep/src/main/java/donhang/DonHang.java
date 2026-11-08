package donhang;


import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class DonHang {
    public static final String CHO_XU_LY = "Chờ xử lý";
    public static final String DA_XU_LY  = "Đã xử lý";
    public static final String DA_HUY    = "Đã hủy";

    private int id;
    private String maDon;
    private Integer khachHangId;
    private Integer nhanVienId;
    private String tenNguoiNhan;
    private String sdt;
    private String diaChi;
    private String ghiChu;
    private String phuongThucTt;
    private BigDecimal tongTien;
    private String trangThai;
    private Timestamp ngayDat;
    private Timestamp ngayXuLy;

    // Dữ liệu join thêm để hiển thị
    private String tenKhachHang;
    private String tenNhanVien;
    private int tongSp;
    private List<ChiTietDonHang> chiTiet = new ArrayList<>();

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getMaDon() { return maDon; }
    public void setMaDon(String maDon) { this.maDon = maDon; }
    public Integer getKhachHangId() { return khachHangId; }
    public void setKhachHangId(Integer khachHangId) { this.khachHangId = khachHangId; }
    public Integer getNhanVienId() { return nhanVienId; }
    public void setNhanVienId(Integer nhanVienId) { this.nhanVienId = nhanVienId; }
    public String getTenNguoiNhan() { return tenNguoiNhan; }
    public void setTenNguoiNhan(String tenNguoiNhan) { this.tenNguoiNhan = tenNguoiNhan; }
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
    public String getPhuongThucTt() { return phuongThucTt; }
    public void setPhuongThucTt(String phuongThucTt) { this.phuongThucTt = phuongThucTt; }
    public BigDecimal getTongTien() { return tongTien; }
    public void setTongTien(BigDecimal tongTien) { this.tongTien = tongTien; }
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    public Timestamp getNgayDat() { return ngayDat; }
    public void setNgayDat(Timestamp ngayDat) { this.ngayDat = ngayDat; }
    public Timestamp getNgayXuLy() { return ngayXuLy; }
    public void setNgayXuLy(Timestamp ngayXuLy) { this.ngayXuLy = ngayXuLy; }
    public String getTenKhachHang() { return tenKhachHang; }
    public void setTenKhachHang(String tenKhachHang) { this.tenKhachHang = tenKhachHang; }
    public String getTenNhanVien() { return tenNhanVien; }
    public void setTenNhanVien(String tenNhanVien) { this.tenNhanVien = tenNhanVien; }
    public int getTongSp() { return tongSp; }
    public void setTongSp(int tongSp) { this.tongSp = tongSp; }
    public List<ChiTietDonHang> getChiTiet() { return chiTiet; }
    public void setChiTiet(List<ChiTietDonHang> chiTiet) { this.chiTiet = chiTiet; }
}