// lib/models/api_user.dart
import 'package:equatable/equatable.dart';

class ApiUser extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? role;
  final String? accountStatus;
  final String? plan;
  final int? pricingPlanId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? jobTitle;
  final String? timezone;
  final String? language;
  final String? avatarPath;

  const ApiUser({
    required this.id,
    required this.username,
    required this.email,
    this.role,
    this.accountStatus,
    this.plan,
    this.pricingPlanId,
    this.firstName,
    this.lastName,
    this.phone,
    this.jobTitle,
    this.timezone,
    this.language,
    this.avatarPath,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
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

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        role,
        accountStatus,
        plan,
        pricingPlanId,
        firstName,
        lastName,
        phone,
        jobTitle,
        timezone,
        language,
        avatarPath,
      ];
}
