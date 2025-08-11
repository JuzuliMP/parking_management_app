import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable {
  final String message;
  
  const AppException(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerException extends AppException {
  const ServerException(String message) : super(message);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class AuthException extends AppException {
  const AuthException(String message) : super(message);
}

class ValidationException extends AppException {
  const ValidationException(String message) : super(message);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
}
