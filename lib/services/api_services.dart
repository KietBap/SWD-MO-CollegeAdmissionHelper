import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com/posts/1"));

  Future<List<dynamic>> getDashboardData() async {
    try {
      final response = await _dio.get('/dashboard');
      return response.data;
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }
}
