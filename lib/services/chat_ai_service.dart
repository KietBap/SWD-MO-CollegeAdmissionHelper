import 'package:dio/dio.dart';

class ChatService {
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api",
  ));

  Future<String> sendMessage(String text) async {
    try {
      var response =
          await _dio.get("/gemini", queryParameters: {"prompt": text});

      if (response.statusCode == 200) {
        var data = response.data;
        var superText = data["message"]["content"] ?? "Không có tin nhắn!";
        return formatGeminiResponse(superText);
      } else {
        return "Lỗi: ${response.statusCode}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }

  String formatGeminiResponse(String response) {
    response = response
        .replaceAll("\\n", "\n")
        .trim(); // Chuyển ký tự xuống dòng escape
    response = response.replaceAll("*", " "); // Thay dấu * bằng khoảng trắng

    return response;
  }

}
