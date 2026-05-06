// Basic smoke test for RenovaSim.
// This test simply verifies that the app can be instantiated
// with the required dependencies without crashing.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_project/core/network/api_client.dart';
import 'package:flutter_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_project/features/users/data/datasources/user_remote_datasource.dart';
import 'package:flutter_project/features/users/data/repositories/user_repository_impl.dart';
import 'package:flutter_project/features/users/domain/usecases/fetch_users_usecase.dart';
import 'package:flutter_project/features/users/domain/usecases/create_user_usecase.dart';
import 'package:flutter_project/features/users/domain/usecases/update_user_usecase.dart';
import 'package:flutter_project/features/users/domain/usecases/delete_user_usecase.dart';
import 'package:flutter_project/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    final httpClient = http.Client();
    final apiClient = ApiClient(client: httpClient);

    final authDatasource = AuthRemoteDatasourceImpl(apiClient: apiClient);
    final authRepository = AuthRepositoryImpl(remoteDatasource: authDatasource);
    final loginUseCase = LoginUseCase(authRepository);

    final userDatasource = UserRemoteDatasourceImpl(apiClient: apiClient);
    final userRepository = UserRepositoryImpl(remoteDatasource: userDatasource);
    final fetchUsersUseCase = FetchUsersUseCase(userRepository);
    final createUserUseCase = CreateUserUseCase(userRepository);
    final updateUserUseCase = UpdateUserUseCase(userRepository);
    final deleteUserUseCase = DeleteUserUseCase(userRepository);

    await tester.pumpWidget(MyApp(
      loginUseCase: loginUseCase,
      fetchUsersUseCase: fetchUsersUseCase,
      createUserUseCase: createUserUseCase,
      updateUserUseCase: updateUserUseCase,
      deleteUserUseCase: deleteUserUseCase,
    ));

    // Verify the login page renders
    expect(find.text('Selamat Datang!'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
