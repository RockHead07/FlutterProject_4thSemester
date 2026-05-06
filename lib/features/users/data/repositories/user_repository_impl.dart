import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

/// Concrete implementation of [UserRepository].
///
/// Delegates to [UserRemoteDatasource] for actual HTTP calls.
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<UserEntity>> fetchUsers({
    required String token,
    int page = 1,
  }) async {
    try {
      return await remoteDatasource.fetchUsers(token: token, page: page);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal mengambil data users: $e');
    }
  }

  @override
  Future<UserEntity> fetchUser({
    required String token,
    required int id,
  }) async {
    try {
      return await remoteDatasource.fetchUser(token: token, id: id);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal mengambil detail user: $e');
    }
  }

  @override
  Future<UserEntity> createUser({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      return await remoteDatasource.createUser(token: token, body: body);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal membuat user: $e');
    }
  }

  @override
  Future<UserEntity> updateUser({
    required String token,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    try {
      return await remoteDatasource.updateUser(token: token, id: id, body: body);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal mengubah user: $e');
    }
  }

  @override
  Future<void> deleteUser({
    required String token,
    required int id,
  }) async {
    try {
      return await remoteDatasource.deleteUser(token: token, id: id);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal menghapus user: $e');
    }
  }
}
