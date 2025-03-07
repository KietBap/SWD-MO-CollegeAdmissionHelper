import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';

class DashboardService {
  TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/dashboard",
  ));

  DashboardService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _tokenService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<String> getTotalUser() async {
    try {
      var response = await _dio.get("/total-users");

      if (response.statusCode == 200) {
        var data = response.data;
        return data.toString();
      } else {
        return "Lỗi: ${response.statusCode}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }

  Future<String> getTotalUniversities() async {
    try {
      var response = await _dio.get("/total-universitys");

      if (response.statusCode == 200) {
        var data = response.data;
        return data.toString();
      } else {
        return "Lỗi: ${response.statusCode}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }
}
