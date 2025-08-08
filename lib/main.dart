import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/dependency_injection.dart';
import 'features/product/presentation/cubit/product_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

// import 'features/auth/presentation/cubit/auth_state.dart';
// import 'features/auth/presentation/screen/login_screen.dart';
import 'features/splash/presentation/screen/splash_screen.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: appRouter.generateRoute,

    );
  }
}
