import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
  ));
  Future<bool> login(String username, String password) async {
    try {
      var response = await _dio.post(
        'https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/auth/auth-account',
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
        String refreshToken = response.data["refreshToken"];
        String sub = _tokenService.checkUserSub(accessToken);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('sub', sub);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? googleUserName = prefs.getString('userName');
    String? subUserName = prefs.getString('sub');

    if (googleUserName != null && googleUserName.isNotEmpty) {
      return googleUserName;
    } else if (subUserName != null && subUserName.isNotEmpty) {
      return subUserName;
    }
    return "Người dùng";
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    String? token = await getToken();
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/mainMenu');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('sub');
    await prefs.remove('userName');
  }
}
