// lib/blocs/users/users_state.dart
part of 'users_bloc.dart';

enum UsersStatus { initial, loading, success, failure }

class UsersState extends Equatable {
  final UsersStatus status;
  final List<ApiUser> users;
  final String? errorMessage;

  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  UsersState copyWith({
    UsersStatus? status,
    List<ApiUser>? users,
    String? errorMessage,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage];
}
