// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';
import 'pages/login_page.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => UserRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        // Global Color Pallete Design System
        // System must only follow this color shceme rules!
        child: MaterialApp(
          title: 'Biodata - Bagus Insan Pradana',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.lightGreen,
              tertiary: AppColors.darkGreen,
              surface: AppColors.lightBg,
              error: AppColors.error,
            ),
            scaffoldBackgroundColor: AppColors.lightBg,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.lightBg,
              prefixIconColor: AppColors.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                ),
              ),
            ),
          ),
          initialRoute: '/login',
          routes: {
            '/login': (_) => const LoginPage(),
          },
        ),
      ),
    );
  }
}