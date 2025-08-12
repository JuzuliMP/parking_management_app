import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String mobileNumber, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String mobileNumber, String password) async {
    try {
      final requestData = {'mobile': mobileNumber, 'password': password};

      final response = await dio.post(
        AppConstants.loginEndpoint,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Check if we have user data in the response
        if (data['user'] != null && data['accessToken'] != null) {
          final userModel = UserModel.fromJson(data);
          return userModel;
        } else if (data['success'] == true && data['data'] != null) {
          // Fallback for old API format
          final userModel = UserModel.fromJson(data['data']);
          return userModel;
        } else {
          final errorMessage = data['message'] ?? 'Login failed';
          throw AuthException(errorMessage);
        }
      } else {
        final errorMessage = 'Login failed with status: ${response.statusCode}';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data?['message'] ?? 'Login failed';

        if (statusCode == 401) {
          throw AuthException('Invalid credentials');
        } else if (statusCode == 400) {
          throw ValidationException(message);
        } else if (statusCode == 500) {
          throw ServerException('Server error: $message');
        } else {
          throw ServerException('Server error: $message');
        }
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
