import 'package:collegeadmissionhelper/models/major_request.dart';
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

  Future<List<Major>> getMajorsByUniversity(String universityId,
      {int pageNumber = 1, int pageSize = 99}) async {
    try {
      final response = await _dio.get(
        "/by-university/$universityId",
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
        },
      );

      if (response.statusCode == 200) {
        PaginatedResponse<Major> paginatedResponse =
            PaginatedResponse<Major>.fromJson(
                response.data, (json) => Major.fromJson(json));
        print('sdsdsdsd ${paginatedResponse.items}');
        return paginatedResponse.items;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
  }

  Future<List<Major>> getAllMajors(String? majorName,
      {int pageNumber = 1, int pageSize = 99}) async {
    try {
      final response = await _dio.get(
        "",
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          if (majorName != null) "majorName": majorName
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

  Future<void> createMajor(MajorRequest request) async {
    try {
      final response = await _dio.post(
        "",
        data: {
          "name": request.name,
          "description": request.description,
          "relatedSkills": request.relatedSkills,
        },
      );
      if (response.statusCode == 200) {
        print("Ngành học đã được tạo: ${response.data}");
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
  }

  Future<void> updateMajor(String id, MajorRequest updateRequest) async {
    try {
      final data = updateRequest.toUpdateJson();
      if (data.isEmpty) {
        print("Không có dữ liệu cần cập nhật!");
        return;
      }
      print("Dữ liệu gửi lên: $data");
      final response = await _dio.patch(
        '/$id',
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      print("Cập nhật thành công: ${response.data}");
    } catch (e) {
      print("Lỗi khi cập nhật ngành học: $e");
    }
  }

  Future<void> deleteMajor(String MajorId) async {
    try {
      final response = await _dio.delete(
        "/$MajorId",
        queryParameters: {"id ": MajorId},
      );
      if (response.statusCode == 200) {
        print("Ngành học đã được cập nhật: ${response.data}");
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
  }
}
