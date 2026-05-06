import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository].
///
/// Delegates to [AuthRemoteDatasource] for actual HTTP calls.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<AuthEntity> login({
    required String username,
    required String password,
  }) async {
    try {
      return await remoteDatasource.login(
        username: username,
        password: password,
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Login gagal: $e');
    }
  }
}
