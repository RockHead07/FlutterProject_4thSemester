import 'package:equatable/equatable.dart';

/// Base failure class for all application failures.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure when server returns an error response (4xx, 5xx).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure when there is no network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for unexpected / unhandled errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
