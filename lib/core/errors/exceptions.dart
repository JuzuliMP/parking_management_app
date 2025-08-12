import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable {
  final String message;

  const AppException(this.message);

  @override
  List<Object> get props => [message];
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}
