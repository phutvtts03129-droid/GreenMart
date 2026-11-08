
package API;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Base64;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/chat-ai")
public class ChatAIServlet extends HttpServlet {

    // 1. CẤU HÌNH GEMINI API

    private static final String API_URL =
            "";

   private static final String API_KEY =
        System.getenv("GOOGLE_API_KEY");


    // 2. GIỚI HẠN DỮ LIỆU

    private static final int MAX_BODY_BYTES = 8 * 1024 * 1024;
    private static final int MAX_TEXT_LENGTH = 2000;
    private static final int MAX_HISTORY = 10;


    // 3. THIẾT LẬP VAI TRÒ CHO AI

    private static final String SYSTEM_PROMPT =
            "Bạn là trợ lý ảo của cửa hàng nông sản sạch Nông Sản Xanh tại TP.HCM. "
          + "Luôn trả lời bằng tiếng Việt, thân thiện, ngắn gọn và rõ ràng. "
          + "Bạn có nhiệm vụ tư vấn về rau củ quả, cách chọn mua, "
          + "bảo quản, chế biến, thực đơn và sản phẩm nông sản. "
          + "Bạn có thể hỗ trợ khách hàng về combo sản phẩm, "
          + "giao hàng và đổi trả. "
          + "Khi khách hàng gửi ảnh, hãy phân tích nội dung ảnh, "
          + "đọc tên sản phẩm, giá và thông tin hiển thị nếu có. "
          + "Không tự ý bịa giá sản phẩm hoặc chương trình khuyến mãi. "
          + "Nếu không chắc chắn về thông tin, hãy khuyên khách hàng "
          + "liên hệ hotline 0987 654 321.";


    // 4. KHỞI TẠO GSON VÀ HTTP CLIENT

    private static final Gson GSON = new Gson();

    private static final HttpClient HTTP = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(15))
            .build();


    // 5. NHẬN YÊU CẦU TỪ GIAO DIỆN CHAT

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp) throws IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        try {

            // BƯỚC 1: ĐỌC DỮ LIỆU TỪ JAVASCRIPT

            byte[] raw = req.getInputStream()
                    .readNBytes(MAX_BODY_BYTES + 1);

            if (raw.length > MAX_BODY_BYTES) {
                write(resp, 413, "error",
                        "Dữ liệu quá lớn, hãy chọn ảnh nhỏ hơn.");
                return;
            }

            JsonObject in;

            try {
                in = GSON.fromJson(
                        new String(raw, StandardCharsets.UTF_8),
                        JsonObject.class
                );

            } catch (JsonParseException e) {
                write(resp, 400, "error",
                        "Dữ liệu gửi lên không hợp lệ.");
                return;
            }

            if (in == null) {
                write(resp, 400, "error",
                        "Không nhận được dữ liệu.");
                return;
            }


            // BƯỚC 2: LẤY CÂU HỎI VÀ ẢNH

            String message = str(in, "message");
            String image = str(in, "image");

            if (message.isBlank() && image.isBlank()) {
                write(resp, 400, "error",
                        "Bạn chưa nhập câu hỏi.");
                return;
            }

            if (message.length() > MAX_TEXT_LENGTH) {
                message = message.substring(0, MAX_TEXT_LENGTH);
            }


            // BƯỚC 3: KIỂM TRA API KEY

          String key = API_KEY == null ? "" : API_KEY.trim();

            if (key.isBlank()
                    || key.equals("YOUR_NEW_GEMINI_API_KEY")) {

                write(resp, 500, "error",
                        "Server chưa được cấu hình Gemini API Key.");
                return;
            }


            // BƯỚC 4: TẠO DANH SÁCH HỘI THOẠI

            JsonArray contents = new JsonArray();

            // Lấy lịch sử trò chuyện

            JsonElement hist = in.get("history");

            if (hist != null && hist.isJsonArray()) {

                JsonArray history = hist.getAsJsonArray();

                int from = Math.max(
                        0,
                        history.size() - MAX_HISTORY
                );

                for (int i = from; i < history.size(); i++) {

                    JsonElement element = history.get(i);

                    if (!element.isJsonObject()) {
                        continue;
                    }

                    JsonObject obj = element.getAsJsonObject();

                    String role = str(obj, "role");
                    String content = str(obj, "content");

                    if (content.isBlank()) {
                        continue;
                    }

                    if (!role.equals("user")
                            && !role.equals("assistant")
                            && !role.equals("model")) {
                        continue;
                    }

                    if (content.length() > MAX_TEXT_LENGTH) {
                        content = content.substring(
                                0, MAX_TEXT_LENGTH
                        );
                    }

                    // Gemini sử dụng model thay cho assistant

                    if (role.equals("assistant")) {
                        role = "model";
                    }

                    contents.add(createMessage(role, content));
                }
            }


            // BƯỚC 5: TẠO TIN NHẮN HIỆN TẠI

            JsonObject last = new JsonObject();

            last.addProperty("role", "user");

            JsonArray parts = new JsonArray();

            // Thêm nội dung văn bản

            JsonObject textPart = new JsonObject();

            textPart.addProperty(
                    "text",
                    message.isBlank()
                            ? "Hãy phân tích nội dung trong ảnh này."
                            : message
            );

            parts.add(textPart);


            // Nếu người dùng gửi ảnh

            if (!image.isEmpty()) {

                String mimeType;

                if (image.startsWith("data:image/jpeg;base64,")) {
                    mimeType = "image/jpeg";

                } else if (image.startsWith("data:image/png;base64,")) {
                    mimeType = "image/png";

                } else {
                    write(resp, 400, "error",
                            "Ảnh chỉ hỗ trợ định dạng JPG hoặc PNG.");
                    return;
                }

                // Lấy phần Base64 phía sau dấu phẩy

                String base64 = image.substring(
                        image.indexOf(",") + 1
                );

                // Kiểm tra dữ liệu Base64

                try {
                    Base64.getDecoder().decode(base64);

                } catch (IllegalArgumentException e) {
                    write(resp, 400, "error",
                            "Dữ liệu ảnh không hợp lệ.");
                    return;
                }

                // Tạo dữ liệu ảnh cho Gemini

                JsonObject inlineData = new JsonObject();

                inlineData.addProperty("mimeType", mimeType);
                inlineData.addProperty("data", base64);

                JsonObject imagePart = new JsonObject();

                imagePart.add("inlineData", inlineData);

                parts.add(imagePart);
            }

            last.add("parts", parts);

            contents.add(last);


            // BƯỚC 6: TẠO REQUEST GEMINI

            JsonObject payload = new JsonObject();

            // Thêm vai trò và hướng dẫn cho AI

            JsonObject systemInstruction = new JsonObject();

            JsonArray systemParts = new JsonArray();

            JsonObject systemText = new JsonObject();

            systemText.addProperty("text", SYSTEM_PROMPT);

            systemParts.add(systemText);

            systemInstruction.add("parts", systemParts);

            payload.add("systemInstruction", systemInstruction);

            // Thêm nội dung hội thoại

            payload.add("contents", contents);


            // BƯỚC 7: GỬI REQUEST ĐẾN GEMINI

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .timeout(Duration.ofSeconds(120))
                    .header("Content-Type", "application/json")
                    .header("x-goog-api-key", key)
                    .POST(
                            HttpRequest.BodyPublishers.ofString(
                                    GSON.toJson(payload),
                                    StandardCharsets.UTF_8
                            )
                    )
                    .build();


            HttpResponse<String> res = HTTP.send(
                    request,
                    HttpResponse.BodyHandlers.ofString(
                            StandardCharsets.UTF_8
                    )
            );


            // BƯỚC 8: KIỂM TRA KẾT QUẢ API

            if (res.statusCode() < 200 || res.statusCode() >= 300) {

                log("Gemini API lỗi: " + res.statusCode());
                log("Chi tiết: " + res.body());

                write(resp, 502, "error",
                        "Gemini API đang gặp lỗi mã "
                        + res.statusCode()
                        + ". Vui lòng thử lại.");

                return;
            }


            // BƯỚC 9: ĐỌC CÂU TRẢ LỜI GEMINI

            JsonObject result = GSON.fromJson(
                    res.body(),
                    JsonObject.class
            );

            String reply = extractReply(result);

            if (reply.isBlank()) {

                log("Gemini không trả về nội dung văn bản.");

                write(resp, 502, "error",
                        "Trợ lý chưa tạo được câu trả lời.");

                return;
            }


            // BƯỚC 10: TRẢ KẾT QUẢ VỀ JAVASCRIPT

            write(resp, 200, "reply", reply.trim());


        } catch (InterruptedException e) {

            Thread.currentThread().interrupt();

            write(resp, 500, "error",
                    "Yêu cầu đã bị gián đoạn.");

        } catch (Exception e) {

            log("ChatAIServlet lỗi", e);

            write(resp, 500, "error",
                    "Có lỗi xảy ra trên máy chủ.");
        }
    }


    // 6. TẠO TIN NHẮN HỘI THOẠI

    private static JsonObject createMessage(
            String role,
            String content) {

        JsonObject obj = new JsonObject();

        obj.addProperty("role", role);

        JsonArray parts = new JsonArray();

        JsonObject textPart = new JsonObject();

        textPart.addProperty("text", content);

        parts.add(textPart);

        obj.add("parts", parts);

        return obj;
    }


    // 7. LẤY NỘI DUNG TRẢ LỜI TỪ GEMINI

    private static String extractReply(JsonObject result) {

        StringBuilder sb = new StringBuilder();

        if (result == null
                || !result.has("candidates")
                || !result.get("candidates").isJsonArray()) {

            return "";
        }

        JsonArray candidates = result.getAsJsonArray("candidates");

        if (candidates.isEmpty()) {
            return "";
        }

        JsonObject candidate = candidates.get(0).getAsJsonObject();

        if (!candidate.has("content")
                || !candidate.get("content").isJsonObject()) {
            return "";
        }

        JsonObject content = candidate.getAsJsonObject("content");

        if (!content.has("parts")
                || !content.get("parts").isJsonArray()) {
            return "";
        }

        JsonArray parts = content.getAsJsonArray("parts");

        for (JsonElement element : parts) {

            if (!element.isJsonObject()) {
                continue;
            }

            JsonObject part = element.getAsJsonObject();

            String text = str(part, "text");

            if (!text.isBlank()) {
                sb.append(text);
            }
        }

        return sb.toString();
    }


    // 8. ĐỌC CHUỖI JSON AN TOÀN

    private static String str(JsonObject obj, String key) {

        if (obj == null
                || !obj.has(key)
                || obj.get(key).isJsonNull()
                || !obj.get(key).isJsonPrimitive()) {

            return "";
        }

        return obj.get(key).getAsString();
    }


    // 9. TRẢ JSON VỀ GIAO DIỆN

    private static void write(
            HttpServletResponse resp,
            int status,
            String key,
            String value) throws IOException {

        resp.setStatus(status);

        JsonObject obj = new JsonObject();

        obj.addProperty(key, value);

        resp.getWriter().write(GSON.toJson(obj));
    }

}