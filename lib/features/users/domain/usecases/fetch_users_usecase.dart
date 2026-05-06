import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class FetchUsersUseCase {
  final UserRepository repository;

  FetchUsersUseCase(this.repository);

  Future<List<UserEntity>> call({
    required String token,
    int page = 1,
  }) {
    return repository.fetchUsers(token: token, page: page);
  }
}
