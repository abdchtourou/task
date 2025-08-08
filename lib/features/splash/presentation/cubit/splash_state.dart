import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashChecking extends SplashState {}

class SplashNavigateToLogin extends SplashState {}

class SplashNavigateToCategory extends SplashState {}

