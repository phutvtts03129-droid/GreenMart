package kiemth;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import kiemthu.TinhToan;

public class TinhToanTest {

    TinhToan tt = new TinhToan();

    @Test
    public void testCong() {
        assertEquals(5, tt.cong(2, 3));
    }

    @Test
    public void testTru() {
        assertEquals(2, tt.tru(5, 3));
    }

    @Test
    public void testNhan() {
        assertEquals(12, tt.nhan(3, 4));
    }

}