// lib/blocs/users/users_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/api_user.dart';
import '../../repositories/user_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository _userRepository;

  UsersBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UsersState()) {
    on<UsersLoad>(_onUsersLoad);
    on<UserCreate>(_onUserCreate);
    on<UserUpdate>(_onUserUpdate);
    on<UserDelete>(_onUserDelete);
  }

  Future<void> _onUsersLoad(UsersLoad event, Emitter<UsersState> emit) async {
    emit(state.copyWith(status: UsersStatus.loading, errorMessage: null));
    try {
      final users = await _userRepository.fetchUsers(
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
      final created = await _userRepository.createUser(
        token: event.token,
        body: event.body,
      );
      final updated = List<ApiUser>.from(state.users)..insert(0, created);
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
      final updatedUser = await _userRepository.updateUser(
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
      await _userRepository.deleteUser(
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
