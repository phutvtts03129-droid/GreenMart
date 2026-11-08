package sanpham;


import java.util.ArrayList;
import java.util.List;

public class Slide {
    private int id;
    private String tieuDe;
    private String tieuDePhu;
    private String badge;
    private String moTa;
    private String dacDiem;   // "icon|chữ;icon|chữ"
    private String iconNoi;   // "🥬,🍅,🥕"
    private String viTri = "left";
    private String nutChu;
    private String nutLink;
    private int thuTu;

    public Slide() {}

    public Slide(String tieuDe, String tieuDePhu, String badge, String moTa, String dacDiem,
                 String iconNoi, String viTri, String nutChu, String nutLink) {
        this.tieuDe = tieuDe;
        this.tieuDePhu = tieuDePhu;
        this.badge = badge;
        this.moTa = moTa;
        this.dacDiem = dacDiem;
        this.iconNoi = iconNoi;
        setViTri(viTri);
        this.nutChu = nutChu;
        this.nutLink = nutLink;
    }

    /** Danh sách emoji bay lơ lửng */
    public List<String> getIconList() {
        List<String> ds = new ArrayList<>();
        if (iconNoi != null) {
            for (String s : iconNoi.split(",")) {
                if (!s.trim().isEmpty()) ds.add(s.trim());
            }
        }
        return ds;
    }

    /** Mỗi phần tử: [0] = tên icon Bootstrap, [1] = chữ hiển thị */
    public List<String[]> getDacDiemList() {
        List<String[]> ds = new ArrayList<>();
        if (dacDiem != null) {
            for (String item : dacDiem.split(";")) {
                String[] p = item.split("\\|", 2);
                if (p.length == 2) ds.add(new String[]{p[0].trim(), p[1].trim()});
            }
        }
        return ds;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }
    public String getTieuDePhu() { return tieuDePhu; }
    public void setTieuDePhu(String tieuDePhu) { this.tieuDePhu = tieuDePhu; }
    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    public String getDacDiem() { return dacDiem; }
    public void setDacDiem(String dacDiem) { this.dacDiem = dacDiem; }
    public String getIconNoi() { return iconNoi; }
    public void setIconNoi(String iconNoi) { this.iconNoi = iconNoi; }
    public String getViTri() { return viTri; }
    public void setViTri(String viTri) {
        String v = viTri == null ? "left" : viTri.trim().toLowerCase();
        this.viTri = (v.equals("right") || v.equals("center")) ? v : "left";
    }
    public String getNutChu() { return nutChu; }
    public void setNutChu(String nutChu) { this.nutChu = nutChu; }
    public String getNutLink() { return nutLink; }
    public void setNutLink(String nutLink) { this.nutLink = nutLink; }
    public int getThuTu() { return thuTu; }
    public void setThuTu(int thuTu) { this.thuTu = thuTu; }
}