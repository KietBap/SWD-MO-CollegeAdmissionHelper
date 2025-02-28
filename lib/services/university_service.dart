import 'package:collegeadmissionhelper/models/paginated_response.dart';
import 'package:collegeadmissionhelper/models/university.dart';
import 'package:dio/dio.dart';

class UniversityService {
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net",
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 5),
  ));
  Future<PaginatedResponse<University>> getAllUniversities(
      {int page = 1, int pageSize = 5}) async {
    try {
      final response = await _dio.get(
        'https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/university/all',
        queryParameters: {
          'pageNumber': page,
          'pageSize': pageSize,
        },
      );
      print("Raw Response Data: ${response.data}");
      if (response.statusCode == 200) {
        return PaginatedResponse<University>.fromJson(
          response.data,
          (json) => University.fromJson(json),
        );
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<University> getUniversity({String id = ''}) async {
    try {
      final response = await _dio.get(
        'https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/university/all',
        queryParameters: {
          'id': id,
        },
      );
      print("Raw Response Data: ${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
