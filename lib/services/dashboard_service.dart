import 'package:collegeadmissionhelper/models/uni_major.dart';
import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../models/login_stats_response.dart';

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
        var data = response.data['totalUsers'];
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
        var data = response.data['totalUniversities'];
        return data.toString();
      } else {
        return "Lỗi: ${response.statusCode}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }

  Future<LoginStatsResponse> getUserLoginStats(
      String startDate, String endDate) async {
    try {
      final inputFormat = DateFormat("dd/MM/yyyy hh:mm a");
      final outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

      final parsedStartDate = inputFormat.parse(startDate);
      final parsedEndDate = inputFormat.parse(endDate);

      final formattedStartDate = outputFormat.format(parsedStartDate);
      final formattedEndDate = outputFormat.format(parsedEndDate);

      var response = await _dio.get(
        "/user-login-stats",
        queryParameters: {
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
        },
      );

      if (response.statusCode == 200) {
        return LoginStatsResponse.fromJson(response.data);
      } else {
        print("API Error: ${response.statusCode} - ${response.statusMessage}");
        return LoginStatsResponse(
          message: "Error: ${response.statusCode}",
          data: LoginStatsData(values: []),
        );
      }
    } catch (e) {
      print("Connection Error: $e");
      return LoginStatsResponse(
        message: "Lỗi kết nối: $e",
        data: LoginStatsData(values: []),
      );
    }
  }

  Future<List<UniMajor>> getTopReviewedUniMajors({
    required int year,
    required String period,
    required int value,
  }) async {
    try {
      var response = await _dio.get(
        "/top-reviewed-unimajors",
        queryParameters: {
          'year': year,
          'period': period,
          'value': value,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data']['\$values'];
        return dataList.map((json) => UniMajor.fromJson(json)).toList();
      } else {
        print("API Error: ${response.statusCode} - ${response.statusMessage}");
        return [];
      }
    } catch (e) {
      print("Connection Error: $e");
      return [];
    }
  }
}
