import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
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

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  // Future<bool> refreshAccessToken() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? refreshToken = prefs.getString('refreshToken');

  //     if (refreshToken == null) return false;

  //     var response = await _dio.post(
  //       'https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/auth/auth-account',
  //       data: {
  //         "refreshToken": refreshToken,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       String newAccessToken = response.data["accessToken"];
  //       await prefs.setString('accessToken', newAccessToken);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }
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
  }
}
