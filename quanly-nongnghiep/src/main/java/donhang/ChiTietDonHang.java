package donhang;


import java.math.BigDecimal;

public class ChiTietDonHang {
    private int id;
    private int donHangId;
    private Integer sanPhamId;
    private String tenSanPham;
    private BigDecimal donGia;
    private int soLuong;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getDonHangId() { return donHangId; }
    public void setDonHangId(int donHangId) { this.donHangId = donHangId; }
    public Integer getSanPhamId() { return sanPhamId; }
    public void setSanPhamId(Integer sanPhamId) { this.sanPhamId = sanPhamId; }
    public String getTenSanPham() { return tenSanPham; }
    public void setTenSanPham(String tenSanPham) { this.tenSanPham = tenSanPham; }
    public BigDecimal getDonGia() { return donGia; }
    public void setDonGia(BigDecimal donGia) { this.donGia = donGia; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public BigDecimal getThanhTien() {
        return donGia == null ? BigDecimal.ZERO : donGia.multiply(BigDecimal.valueOf(soLuong));
    }
}