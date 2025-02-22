import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://apistore.cybersoft.edu.vn/api/Product"));
  Future<List<dynamic>> getDashboardData() async {
    try {
      print("$_dio");
      final response = await _dio.get('/dashboard');
      return response.data;
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }
}
