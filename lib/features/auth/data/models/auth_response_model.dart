import '../../domain/entities/auth_entity.dart';

/// Data model for auth responses — extends [AuthEntity] with JSON parsing.
class AuthResponseModel extends AuthEntity {
  const AuthResponseModel({
    required super.token,
    required super.email,
  });

  /// Parse the Laravel login response.
  ///
  /// Expected JSON structure:
  /// ```json
  /// { "data": { "token": "...", "user": { "email": "..." } } }
  /// ```
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] as Map<String, dynamic>? ?? {};
    return AuthResponseModel(
      token: (payload['token'] ?? '') as String,
      email: (payload['user']?['email'] ?? '') as String,
    );
  }
}
