/// Categorises the kind of server or network error that occurred.
///
/// Each [ApiFailure] subtype corresponds to exactly one [ServerFailure] value,
/// allowing callers to branch on error kind without inspecting [runtimeType].
enum ServerFailure {
  /// Device has no network connectivity.
  noNetwork('No network connection'),

  /// An unexpected exception was thrown during the request.
  exception('Request exception'),

  /// The server rejected the request due to missing or invalid credentials.
  unauthorized('Unauthorized'),

  /// The client has exceeded the server's rate limit.
  tooManyRequests('Too many requests'),

  /// The server returned an HTTP error response (4xx / 5xx).
  response('Server response error'),

  /// The failure reason could not be determined.
  unknown('Unknown error');

  const ServerFailure(this.label);

  /// Short human-readable description of this failure kind.
  final String label;
}
