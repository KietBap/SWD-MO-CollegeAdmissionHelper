import 'package:dio/dio.dart';
import 'package:collegeadmissionhelper/models/major.dart';
import '../models/paginated_response.dart';
import 'token_service.dart';

class MajorService {
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/major",
      headers: {
        'Accept': 'application/json',
      },
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  MajorService() {
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

  Future<List<Major>> getMajors(String universityId,
      {int pageNumber = 1, int pageSize = 99}) async {
    try {
      final response = await _dio.get(
        "/all-by-universityid",
        queryParameters: {
          "uniId": universityId,
          "pageNumber": pageNumber,
          "pageSize": pageSize,
        },
      );

      if (response.statusCode == 200) {
        PaginatedResponse<Major> paginatedResponse =
            PaginatedResponse<Major>.fromJson(
                response.data, (json) => Major.fromJson(json));
        return paginatedResponse.items;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
  }
}
