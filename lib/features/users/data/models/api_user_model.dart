import '../../domain/entities/user_entity.dart';

/// Data model extending [UserEntity] with JSON serialization.
///
/// Preserves all field mappings from the original `ApiUser` class.
class ApiUserModel extends UserEntity {
  const ApiUserModel({
    required super.id,
    required super.username,
    required super.email,
    super.role,
    super.accountStatus,
    super.plan,
    super.pricingPlanId,
    super.firstName,
    super.lastName,
    super.phone,
    super.jobTitle,
    super.timezone,
    super.language,
    super.avatarPath,
  });

  factory ApiUserModel.fromJson(Map<String, dynamic> json) {
    return ApiUserModel(
      id: json['id'] as int,
      username: (json['username'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      role: json['role'] as String?,
      accountStatus: json['account_status'] as String?,
      plan: json['plan'] as String?,
      pricingPlanId: json['pricing_plan_id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      jobTitle: json['job_title'] as String?,
      timezone: json['timezone'] as String?,
      language: json['language'] as String?,
      avatarPath: json['avatar_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'account_status': accountStatus,
      'plan': plan,
      'pricing_plan_id': pricingPlanId,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'job_title': jobTitle,
      'timezone': timezone,
      'language': language,
      'avatar_path': avatarPath,
    };
  }
}
