// lib/blocs/users/users_event.dart
part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class UsersLoad extends UsersEvent {
  final String token;
  final int page;

  const UsersLoad({required this.token, this.page = 1});

  @override
  List<Object?> get props => [token, page];
}

class UserCreate extends UsersEvent {
  final String token;
  final Map<String, dynamic> body;

  const UserCreate({required this.token, required this.body});

  @override
  List<Object?> get props => [token, body];
}

class UserUpdate extends UsersEvent {
  final String token;
  final int id;
  final Map<String, dynamic> body;

  const UserUpdate({required this.token, required this.id, required this.body});

  @override
  List<Object?> get props => [token, id, body];
}

class UserDelete extends UsersEvent {
  final String token;
  final int id;

  const UserDelete({required this.token, required this.id});

  @override
  List<Object?> get props => [token, id];
}
