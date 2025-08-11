import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  const Failure({this.message = 'An unexpected error occurred'});

  final String message;

  @override
  List<Object> get props => [message];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred'});
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

/// Failure for network-related errors
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error occurred'});
}

/// Failure for authentication-related errors
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed'});
}

/// Failure for validation-related errors
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failed'});
}

/// Failure for general errors
class GeneralFailure extends Failure {
  const GeneralFailure({super.message = 'An error occurred'});
}
