import 'package:x_flutter_core_models/src/domain/failure/failure.dart';
import 'package:x_flutter_core_models/src/domain/failure/networking/server_failure.dart';

/// Abstract base for all server and network failures.
///
/// Do not instantiate [ApiFailure] directly — use one of the typed subtypes:
/// [ConnectionFailure], [ApiUnauthorizedFailure], [ApiTooManyRequestsFailure],
/// [ApiExceptionFailure], [ApiResponseFailure], [ApiUndefinedFailure], or
/// [ApiUnknownFailure].
///
/// Equality is value-based: two instances of the same concrete subtype with
/// identical [failure], [statusCode], and [message] are considered equal.
abstract class ApiFailure implements Failure {
  /// The broad category of this failure.
  final ServerFailure failure;

  /// HTTP status code returned by the server, if available.
  final int? statusCode;

  /// Human-readable description of the error.
  final String message;

  /// Creates an [ApiFailure] with the given [failure] category, optional
  /// [message], and optional HTTP [statusCode].
  const ApiFailure(
    this.failure, {
    this.message = '',
    this.statusCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is ApiFailure &&
          other.failure == failure &&
          other.statusCode == statusCode &&
          other.message == message);

  @override
  int get hashCode => Object.hash(runtimeType, failure, statusCode, message);

  /// Format: `ClassName{failure: …, statusCode: …, message: …}`
  @override
  String toString() =>
      '$runtimeType{failure: $failure, statusCode: $statusCode, message: $message}';
}

/// The server returned an HTTP error response with a specific [statusCode].
///
/// Use for any 4xx / 5xx response that does not have a more specific subtype.
class ApiResponseFailure extends ApiFailure {
  /// Creates an [ApiResponseFailure] with the required HTTP [statusCode] and
  /// an optional [message].
  const ApiResponseFailure({
    required int statusCode,
    String message = '',
  }) : super(ServerFailure.response, statusCode: statusCode, message: message);
}

/// The server returned an unrecognised or unexpected error payload.
class ApiUndefinedFailure extends ApiFailure {
  const ApiUndefinedFailure({
    int? statusCode,
    required String message,
  }) : super(ServerFailure.undefined, message: message, statusCode: statusCode);
}

/// The device has no network connectivity.
class ConnectionFailure extends ApiFailure {
  const ConnectionFailure() : super(ServerFailure.noNetwork);
}

/// An unexpected exception was thrown while executing the request.
class ApiExceptionFailure extends ApiFailure {
  /// Creates an [ApiExceptionFailure] with a [message] describing the exception.
  const ApiExceptionFailure({required String message})
      : super(ServerFailure.exception, message: message);
}

/// The server rejected the request due to missing or invalid credentials (401).
class ApiUnauthorizedFailure extends ApiFailure {
  const ApiUnauthorizedFailure() : super(ServerFailure.unauthorized);
}

/// The client has been rate-limited by the server (429).
class ApiTooManyRequestsFailure extends ApiFailure {
  /// Creates an [ApiTooManyRequestsFailure] for HTTP 429 rate-limit responses.
  const ApiTooManyRequestsFailure() : super(ServerFailure.tooManyRequests);
}

/// The failure reason could not be determined.
class ApiUnknownFailure extends ApiFailure {
  const ApiUnknownFailure() : super(ServerFailure.unknown);
}
