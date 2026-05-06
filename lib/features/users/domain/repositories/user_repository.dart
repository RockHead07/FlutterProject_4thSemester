import '../entities/user_entity.dart';

/// Abstract contract for user CRUD operations.
///
/// Domain layer — no HTTP or Flutter imports allowed.
abstract class UserRepository {
  /// Fetch paginated list of users.
  Future<List<UserEntity>> fetchUsers({
    required String token,
    int page = 1,
  });

  /// Fetch a single user by [id].
  Future<UserEntity> fetchUser({
    required String token,
    required int id,
  });

  /// Create a new user.
  Future<UserEntity> createUser({
    required String token,
    required Map<String, dynamic> body,
  });

  /// Update an existing user by [id].
  Future<UserEntity> updateUser({
    required String token,
    required int id,
    required Map<String, dynamic> body,
  });

  /// Delete a user by [id].
  Future<void> deleteUser({
    required String token,
    required int id,
  });
}
