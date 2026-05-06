import 'package:equatable/equatable.dart';

/// Pure domain entity representing a user in the system.
///
/// Contains all user fields — no JSON serialization.
/// All 14 fields from the original ApiUser are preserved.
class UserEntity extends Equatable {
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

  const UserEntity({
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
