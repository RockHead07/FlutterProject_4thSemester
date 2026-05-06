import '../entities/auth_entity.dart';

/// Abstract contract for authentication operations.
///
/// Domain layer — no HTTP or Flutter imports allowed.
abstract class AuthRepository {
  /// Authenticate a user with [username] and [password].
  /// Returns an [AuthEntity] on success, throws on failure.
  Future<AuthEntity> login({
    required String username,
    required String password,
  });
}
