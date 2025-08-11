import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.mobileNumber, params.password);
  }
}

class LoginParams extends Equatable {
  final String mobileNumber;
  final String password;

  const LoginParams({
    required this.mobileNumber,
    required this.password,
  });

  @override
  List<Object> get props => [mobileNumber, password];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
