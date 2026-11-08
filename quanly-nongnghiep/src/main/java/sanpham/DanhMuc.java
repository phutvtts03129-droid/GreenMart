package sanpham;


import java.sql.Timestamp;

public class DanhMuc {
    private int id;
    private String maDanhMuc;
    private String tenDanhMuc;
    private String icon;
    private String hinhAnh;
    private String mota;
    private int thuTu;
    private boolean trangThai;
    private Timestamp ngayTao;

    public DanhMuc() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getMaDanhMuc() { return maDanhMuc; }
    public void setMaDanhMuc(String maDanhMuc) { this.maDanhMuc = maDanhMuc; }

    public String getTenDanhMuc() { return tenDanhMuc; }
    public void setTenDanhMuc(String tenDanhMuc) { this.tenDanhMuc = tenDanhMuc; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public String getMota() { return mota; }
    public void setMota(String mota) { this.mota = mota; }

    public int getThuTu() { return thuTu; }
    public void setThuTu(int thuTu) { this.thuTu = thuTu; }

    public boolean isTrangThai() { return trangThai; }
    public void setTrangThai(boolean trangThai) { this.trangThai = trangThai; }

    public Timestamp getNgayTao() { return ngayTao; }
    public void setNgayTao(Timestamp ngayTao) { this.ngayTao = ngayTao; }
}