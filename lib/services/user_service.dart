import 'package:collegeadmissionhelper/models/paginated_response.dart';
import 'package:collegeadmissionhelper/models/user.dart';
import 'package:dio/dio.dart';
import 'token_service.dart';

class UserService {
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/user",
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 5),
  ));

  UserService() {
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

  Future<PaginatedResponse<User>> getAllUser(
      {String? email,
      String? phoneNumber,
      int page = 1,
      int pageSize = 100}) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'pageNumber': page,
          'pageSize': pageSize
        },
      );
      if (response.statusCode == 200) {
        return PaginatedResponse<User>.fromJson(
          response.data,
          (json) => User.fromJson(json),
        );
      } else {
        throw Exception('Lỗi tải danh sách người dùng');
      }
    } catch (e) {
      throw Exception('Lỗi API: $e');
    }
  }

  Future<User> getUserById(String userId) async {
    try {
      final response = await _dio.get('/$userId');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final Map<String, dynamic> userData =
            data.containsKey('message') ? data['message'] : data;
        return User.fromJson(userData);
      } else {
        throw Exception('Lỗi tải thông tin người dùng');
      }
    } catch (e) {
      throw Exception('Lỗi API: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await _dio.delete(
        '/$userId',
        queryParameters: {"id ": userId},
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception('Lỗi API: $e');
    }
  }

  Future<void> updateUser(String userId, User user) async {
    try {
      final data = user.toJson();
      if (data.isEmpty) {
        print("Không có dữ liệu cần cập nhật!");
        return;
      }
      print("Dữ liệu gửi lên: $data");
      final response = await _dio.patch(
        '/$userId',
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) return;
      throw Exception('Lỗi update');
    } catch (e) {
      throw Exception("Lỗi khi cập nhật tài khoản: $e");
    }
  }
}
