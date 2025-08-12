import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getVehicles({int page = 1, int limit = 10});
  Future<VehicleModel> createVehicle(Map<String, dynamic> vehicleData);
  Future<VehicleModel> updateVehicle(
    String id,
    Map<String, dynamic> vehicleData,
  );
  Future<void> deleteVehicle(String id);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio dio;

  VehicleRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VehicleModel>> getVehicles({int page = 1, int limit = 10}) async {
    try {
      // Calculate skip based on page
      final skip = (page - 1) * limit;

      final requestData = {
        'limit': limit,
        'skip': skip,
        'searchingText': '', // Empty string for no search filter
      };

      final response = await dio.post(
        AppConstants.vehicleListEndpoint,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Check for new API response format
        if (data['message'] == 'success' &&
            data['data'] != null &&
            data['data']['list'] != null) {
          final List<dynamic> vehiclesJson = data['data']['list'];
          final vehicles = vehiclesJson
              .map((json) => VehicleModel.fromJson(json))
              .toList();
          return vehicles;
        } else if (data['success'] == true && data['data'] != null) {
          // Fallback for old API format
          final List<dynamic> vehiclesJson = data['data'];
          final vehicles = vehiclesJson
              .map((json) => VehicleModel.fromJson(json))
              .toList();
          return vehicles;
        } else {
          final errorMessage = data['message'] ?? 'Failed to fetch vehicles';
          throw ServerException(errorMessage);
        }
      } else {
        final errorMessage =
            'Failed to fetch vehicles with status: ${response.statusCode}';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<VehicleModel> createVehicle(Map<String, dynamic> vehicleData) async {
    try {
      // Transform the data to match API requirements
      final requestData = {
        'name': vehicleData['name'],
        'model': vehicleData['model_year']?.toString() ?? '',
        'color': vehicleData['color'],
        'vehicleNumber': vehicleData['vehicle_number'],
      };

      final response = await dio.post(
        AppConstants.vehicleCreateEndpoint,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Check for new API response format
        if (data['message'] == 'OK' && data['data'] != null) {
          final vehicle = VehicleModel.fromJson(data['data']);
          return vehicle;
        } else if (data['message'] == 'success' && data['data'] != null) {
          final vehicle = VehicleModel.fromJson(data['data']);
          return vehicle;
        } else if (data['success'] == true && data['data'] != null) {
          // Fallback for old API format
          final vehicle = VehicleModel.fromJson(data['data']);
          return vehicle;
        } else {
          final errorMessage = data['message'] ?? 'Failed to create vehicle';
          throw ServerException(errorMessage);
        }
      } else {
        final errorMessage =
            'Failed to create vehicle with status: ${response.statusCode}';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<VehicleModel> updateVehicle(
    String id,
    Map<String, dynamic> vehicleData,
  ) async {
    try {
      // Transform the data to match API requirements
      final requestData = {
        'vehicleId': id,
        'name': vehicleData['name'],
        'model': vehicleData['model_year']?.toString() ?? '',
        'color': vehicleData['color'],
        'vehicleNumber': vehicleData['vehicle_number'],
      };

      final response = await dio.put(
        AppConstants.vehicleUpdateEndpoint,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Check for new API response format
        if (data['message'] == 'success' && data['data'] != null) {
          final vehicle = VehicleModel.fromJson(data['data']);
          return vehicle;
        } else if (data['message'] == 'OK' && data['data'] != null) {
          final vehicle = VehicleModel.fromJson(data['data']);
          return vehicle;
        } else if (data['success'] == true && data['data'] != null) {
          // Fallback for old API format
          final vehicle = VehicleModel.fromJson(data['data']);
          return vehicle;
        } else {
          final errorMessage = data['message'] ?? 'Failed to update vehicle';
          throw ServerException(errorMessage);
        }
      } else {
        final errorMessage =
            'Failed to update vehicle with status: ${response.statusCode}';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteVehicle(String id) async {
    try {
      final requestData = {'vehicleId': id};

      final response = await dio.delete(
        AppConstants.vehicleDeleteEndpoint,
        data: requestData,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        // Vehicle deleted successfully
      } else {
        final data = response.data;
        final errorMessage = data['message'] ?? 'Failed to delete vehicle';
        throw ServerException(errorMessage);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException('Connection timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      return NetworkException('No internet connection');
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.data?['message'] ?? 'Request failed';

      if (statusCode == 401) {
        return AuthException('Unauthorized');
      } else if (statusCode == 400) {
        return ValidationException(message);
      } else if (statusCode == 404) {
        return ServerException('Resource not found');
      } else {
        return ServerException('Server error: $message');
      }
    } else {
      return NetworkException('Network error: ${e.message}');
    }
  }
}
