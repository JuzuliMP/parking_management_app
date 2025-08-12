import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../sources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<Either<Failure, User>> login(
    String mobileNumber,
    String password,
  ) async {
    try {
      final userModel = await remoteDataSource.login(mobileNumber, password);

      // Store user data and token
      if (userModel.token != null) {
        await storageService.setString(
          AppConstants.authTokenKey,
          userModel.token!,
        );
        await storageService.setString(
          AppConstants.userDataKey,
          userModel.toJson().toString(),
        );
      }

      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<void> logout() async {
    await storageService.remove(AppConstants.authTokenKey);
    await storageService.remove(AppConstants.userDataKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userData = storageService.getString(AppConstants.userDataKey);
      if (userData != null) {
        // Parse user data from storage
        // This is a simplified implementation
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = storageService.getString(AppConstants.authTokenKey);
    return token != null;
  }
}
