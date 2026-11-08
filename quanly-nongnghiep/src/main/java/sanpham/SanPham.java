package sanpham;

import java.sql.Timestamp;

public class SanPham {
    private int id;
    private String ten;
    private double gia;
    private Double giaGoc;
    private int soLuong;
    private String donViTinh;
    private String hinhAnh;
    private String motaNgan;
    private String motaChiTiet;
    private String xuatXu;
    private boolean trangThai;
    private boolean noiBat;
    private Integer danhMucId;
    private Timestamp ngayTao;
    private int daBan;
    private int khuyenMai;

    public SanPham() {}

    public SanPham(int id, String ten, double gia, Double giaGoc, int soLuong, String donViTinh,
                   String hinhAnh, String motaNgan, String motaChiTiet, String xuatXu,
                   boolean trangThai, boolean noiBat, Integer danhMucId, Timestamp ngayTao,
                   int daBan, int khuyenMai) {
        this.id = id;
        this.ten = ten;
        this.gia = gia;
        this.giaGoc = giaGoc;
        this.soLuong = soLuong;
        this.donViTinh = donViTinh;
        this.hinhAnh = hinhAnh;
        this.motaNgan = motaNgan;
        this.motaChiTiet = motaChiTiet;
        this.xuatXu = xuatXu;
        this.trangThai = trangThai;
        this.noiBat = noiBat;
        this.danhMucId = danhMucId;
        this.ngayTao = ngayTao;
        this.daBan = daBan;
        this.khuyenMai = khuyenMai;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTen() { return ten; }
    public void setTen(String ten) { this.ten = ten; }

    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }

    public Double getGiaGoc() { return giaGoc; }
    public void setGiaGoc(Double giaGoc) { this.giaGoc = giaGoc; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public String getDonViTinh() { return donViTinh; }
    public void setDonViTinh(String donViTinh) { this.donViTinh = donViTinh; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public String getMotaNgan() { return motaNgan; }
    public void setMotaNgan(String motaNgan) { this.motaNgan = motaNgan; }

    public String getMotaChiTiet() { return motaChiTiet; }
    public void setMotaChiTiet(String motaChiTiet) { this.motaChiTiet = motaChiTiet; }

    public String getXuatXu() { return xuatXu; }
    public void setXuatXu(String xuatXu) { this.xuatXu = xuatXu; }

    public boolean isTrangThai() { return trangThai; }
    public void setTrangThai(boolean trangThai) { this.trangThai = trangThai; }

    public boolean isNoiBat() { return noiBat; }
    public void setNoiBat(boolean noiBat) { this.noiBat = noiBat; }

    public Integer getDanhMucId() { return danhMucId; }
    public void setDanhMucId(Integer danhMucId) { this.danhMucId = danhMucId; }

    public Timestamp getNgayTao() { return ngayTao; }
    public void setNgayTao(Timestamp ngayTao) { this.ngayTao = ngayTao; }

    public int getDaBan() { return daBan; }
    public void setDaBan(int daBan) { this.daBan = daBan; }

    public int getKhuyenMai() { return khuyenMai; }
    public void setKhuyenMai(int khuyenMai) { this.khuyenMai = khuyenMai; }
}