import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<UserEntity> call({
    required String token,
    required int id,
    required Map<String, dynamic> body,
  }) {
    return repository.updateUser(token: token, id: id, body: body);
  }
}
