// Core failure types for functional error handling
// Using fpdart Either<Failure, T> pattern to eliminate exceptions

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, originalError];
}

// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class NoConnectionFailure extends Failure {
  const NoConnectionFailure({
    super.message = 'No internet connection',
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Server related failures
class ServerFailure extends Failure {
  final int statusCode;

  const ServerFailure({
    required super.message,
    required this.statusCode,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class UnauthorizedFailure extends ServerFailure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class ForbiddenFailure extends ServerFailure {
  const ForbiddenFailure({
    super.message = 'Access forbidden',
    super.statusCode = 403,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class NotFoundFailure extends ServerFailure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Cache/Local storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Validation failures
class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;

  const ValidationFailure({
    required super.message,
    required this.fieldErrors,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

// Generic/Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Type alias for Result pattern
typedef Result<T> = Either<Failure, T>;

// Extension for easier Result handling
extension ResultX<T> on Result<T> {
  T getOrElse(T Function(Failure) onFailure) {
    return fold(onFailure, (t) => t);
  }

  T getOrThrow() {
    return fold(
      (failure) => throw failure,
      (t) => t,
    );
  }

  bool get isSuccess => isRight();
  bool get isFailure => isLeft();

  Failure? get failureOrNull => fold((l) => l, (r) => null);
  T? get valueOrNull => fold((l) => null, (r) => r);
}