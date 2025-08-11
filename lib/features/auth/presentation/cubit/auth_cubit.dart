import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/user.dart';
import '../../../../core/errors/failures.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

  Future<void> login(String mobileNumber, String password) async {
    emit(AuthLoading());
    
    final result = await loginUseCase(LoginParams(
      mobileNumber: mobileNumber,
      password: password,
    ));

    result.fold(
      (failure) {
        if (failure is AuthFailure) {
          emit(AuthError(message: failure.message));
        } else if (failure is NetworkFailure) {
          emit(AuthError(message: failure.message));
        } else if (failure is ServerFailure) {
          emit(AuthError(message: failure.message));
        } else if (failure is ValidationFailure) {
          emit(AuthError(message: failure.message));
        } else {
          emit(AuthError(message: 'An unexpected error occurred'));
        }
      },
      (user) {
        emit(AuthSuccess(user: user));
      },
    );
  }

  void reset() {
    emit(AuthInitial());
  }
}
