import 'package:equatable/equatable.dart';

/// Pure domain entity representing an authenticated user session.
///
/// Contains only the token and email — no JSON serialization.
class AuthEntity extends Equatable {
  final String token;
  final String email;
  final String? role;

  const AuthEntity({
    required this.token,
    required this.email,
    this.role,
  });

  @override
  List<Object?> get props => [token, email, role];
}
