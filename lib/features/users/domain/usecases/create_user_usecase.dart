import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<UserEntity> call({
    required String token,
    required Map<String, dynamic> body,
  }) {
    return repository.createUser(token: token, body: body);
  }
}
