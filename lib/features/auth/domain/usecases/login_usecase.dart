import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login.
///
/// Encapsulates the login business rule by delegating
/// to the [AuthRepository] abstraction.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthEntity> call({
    required String username,
    required String password,
  }) {
    return repository.login(username: username, password: password);
  }
}
