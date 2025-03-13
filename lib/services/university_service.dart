import 'package:collegeadmissionhelper/models/paginated_response.dart';
import 'package:collegeadmissionhelper/models/university.dart';
import 'package:dio/dio.dart';
import 'token_service.dart';

class UniversityService {
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/university",
  ));

  UniversityService() {
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

  Future<PaginatedResponse<University>> getAllUniversities(
      {String? uniCode,
      String? type,
      String? location,
      page = 1,
      int pageSize = 100}) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          if (uniCode != null) 'uniCode': uniCode,
          if (type != null) 'type': type,
          if (location != null) 'location': location,
          'pageNumber': page,
          'pageSize': pageSize,
        },
      );
      if (response.statusCode == 200) {
        return PaginatedResponse<University>.fromJson(
          response.data,
          (json) => University.fromJson(json),
        );
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
  }

  Future<University> getUniversityById(String universityId) async {
    try {
      final response = await _dio.get("/$universityId");
      if (response.statusCode == 200) {
        final data = response.data['message'];
        if (data == null) {
          throw Exception("Không tìm thấy dữ liệu trường đại học");
        }
        return University.fromJson(data);
      } else {
        throw Exception('Failed to load university');
      }
    } catch (e) {
      print("Error fetching university: $e");
      throw Exception('Error fetching university: $e');
    }
  }
}
