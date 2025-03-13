import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/auth"
  ));

  Future<bool> login(String username, String password) async {
    try {
      var response = await _dio.post(
        '/auth-account',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        String accessToken = response.data["accessToken"];
        String? userId = _tokenService.checkUserId(accessToken);
        String? name = _tokenService.checkUserName(accessToken);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('name', name!);
        await prefs.setString('userId', userId!);
        
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
