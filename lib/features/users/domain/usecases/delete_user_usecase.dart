import '../repositories/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  Future<void> call({
    required String token,
    required int id,
  }) {
    return repository.deleteUser(token: token, id: id);
  }
}
