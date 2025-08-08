import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/usecase/get_current_user_use_case.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  SplashCubit({required this.getCurrentUserUseCase}) : super(SplashInitial());

  Future<void> checkAuthAndNavigate() async {
    emit(SplashChecking());
    final result = await getCurrentUserUseCase();
    result.fold(
      (_) => emit(SplashNavigateToLogin()),
      (user) =>
          user == null
              ? emit(SplashNavigateToLogin())
              : emit(SplashNavigateToCategory()),
    );
  }
}

