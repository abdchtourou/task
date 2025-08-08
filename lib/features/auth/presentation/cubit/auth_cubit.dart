import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_current_user_use_case.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/logout_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await getCurrentUserUseCase.call();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) =>
          user == null
              ? emit(AuthUnauthenticated())
              : emit(AuthAuthenticated(user)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await loginUseCase.call(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase.call();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (ok) => emit(AuthUnauthenticated()),
    );
  }
}
