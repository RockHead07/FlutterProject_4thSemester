import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/constants/app_colors.dart';
import 'core/network/api_client.dart';

// Auth feature
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

// Users feature
import 'features/users/data/datasources/user_remote_datasource.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/usecases/fetch_users_usecase.dart';
import 'features/users/domain/usecases/create_user_usecase.dart';
import 'features/users/domain/usecases/update_user_usecase.dart';
import 'features/users/domain/usecases/delete_user_usecase.dart';
import 'features/users/presentation/blocs/users_bloc.dart';

void main() {
  // ── Manual Dependency Injection ──────────────────────────────────────────
  final httpClient = http.Client();
  final apiClient = ApiClient(client: httpClient);

  // Auth DI chain
  final authDatasource = AuthRemoteDatasourceImpl(apiClient: apiClient);
  final authRepository = AuthRepositoryImpl(remoteDatasource: authDatasource);
  final loginUseCase = LoginUseCase(authRepository);

  // Users DI chain
  final userDatasource = UserRemoteDatasourceImpl(apiClient: apiClient);
  final userRepository = UserRepositoryImpl(remoteDatasource: userDatasource);
  final fetchUsersUseCase = FetchUsersUseCase(userRepository);
  final createUserUseCase = CreateUserUseCase(userRepository);
  final updateUserUseCase = UpdateUserUseCase(userRepository);
  final deleteUserUseCase = DeleteUserUseCase(userRepository);

  runApp(MyApp(
    loginUseCase: loginUseCase,
    fetchUsersUseCase: fetchUsersUseCase,
    createUserUseCase: createUserUseCase,
    updateUserUseCase: updateUserUseCase,
    deleteUserUseCase: deleteUserUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final FetchUsersUseCase fetchUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.fetchUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(loginUseCase: loginUseCase),
        ),
        BlocProvider(
          create: (_) => UsersBloc(
            fetchUsersUseCase: fetchUsersUseCase,
            createUserUseCase: createUserUseCase,
            updateUserUseCase: updateUserUseCase,
            deleteUserUseCase: deleteUserUseCase,
          ),
        ),
      ],
      // Global Color Pallete Design System
      // System must only follow this color scheme rules!
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
    );
  }
}