import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../../../../core/routing/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkAuthAndNavigate();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF667eea),
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToCategory) {
            Navigator.of(context).pushReplacementNamed(Routes.categoryScreen);
          } else if (state is SplashNavigateToLogin) {
            Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
          }
        },
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterLogo(size: 96),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
