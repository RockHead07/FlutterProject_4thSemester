import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/fetch_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final FetchUsersUseCase _fetchUsersUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  UsersBloc({
    required FetchUsersUseCase fetchUsersUseCase,
    required CreateUserUseCase createUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  })  : _fetchUsersUseCase = fetchUsersUseCase,
        _createUserUseCase = createUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        super(const UsersState()) {
    on<UsersLoad>(_onUsersLoad);
    on<UserCreate>(_onUserCreate);
    on<UserUpdate>(_onUserUpdate);
    on<UserDelete>(_onUserDelete);
  }

  Future<void> _onUsersLoad(UsersLoad event, Emitter<UsersState> emit) async {
    emit(state.copyWith(status: UsersStatus.loading, errorMessage: null));
    try {
      final users = await _fetchUsersUseCase(
        token: event.token,
        page: event.page,
      );
      emit(state.copyWith(status: UsersStatus.success, users: users));
    } catch (e) {
      emit(state.copyWith(
        status: UsersStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  Future<void> _onUserCreate(UserCreate event, Emitter<UsersState> emit) async {
    emit(state.copyWith(status: UsersStatus.loading, errorMessage: null));
    try {
      final created = await _createUserUseCase(
        token: event.token,
        body: event.body,
      );
      final updated = List<UserEntity>.from(state.users)..insert(0, created);
      emit(state.copyWith(status: UsersStatus.success, users: updated));
    } catch (e) {
      emit(state.copyWith(
        status: UsersStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  Future<void> _onUserUpdate(UserUpdate event, Emitter<UsersState> emit) async {
    emit(state.copyWith(status: UsersStatus.loading, errorMessage: null));
    try {
      final updatedUser = await _updateUserUseCase(
        token: event.token,
        id: event.id,
        body: event.body,
      );

      final updated = state.users
          .map((user) => user.id == updatedUser.id ? updatedUser : user)
          .toList();

      emit(state.copyWith(status: UsersStatus.success, users: updated));
    } catch (e) {
      emit(state.copyWith(
        status: UsersStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  Future<void> _onUserDelete(UserDelete event, Emitter<UsersState> emit) async {
    emit(state.copyWith(status: UsersStatus.loading, errorMessage: null));
    try {
      await _deleteUserUseCase(
        token: event.token,
        id: event.id,
      );

      final updated = state.users.where((user) => user.id != event.id).toList();
      emit(state.copyWith(status: UsersStatus.success, users: updated));
    } catch (e) {
      emit(state.copyWith(
        status: UsersStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceAll('Exception: ', '');
  }
}
