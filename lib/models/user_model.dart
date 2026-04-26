// lib/models/user_model.dart
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String token;
  final String email;

  const UserModel({
    required this.token,
    required this.email,
  });

  @override
  List<Object?> get props => [token, email];
}