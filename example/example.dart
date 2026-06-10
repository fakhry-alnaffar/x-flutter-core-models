import 'package:x_flutter_core_models/x_flutter_core_models.dart';

void main() {
  // --- Failure types ---

  // Represent a network error result from a repository.
  const Failure noNetwork = ConnectionFailure();
  const Failure unauthorized = ApiUnauthorizedFailure();
  const Failure rateLimited = ApiTooManyRequestsFailure();
  const Failure serverError = ApiResponseFailure(statusCode: 503, message: 'Service unavailable');
  const Failure exception = ApiExceptionFailure(message: 'Timeout after 30s');
  const Failure canceled = CanceledRequestFailure();

  // Branch on failure kind using the ServerFailure enum — no runtimeType checks needed.
  for (final failure in [noNetwork, unauthorized, rateLimited, serverError, exception, canceled]) {
    if (failure is ApiFailure) {
      switch (failure.failure) {
        case ServerFailure.noNetwork:
          print('No network — show offline banner');
        case ServerFailure.unauthorized:
          print('Unauthorized — redirect to login');
        case ServerFailure.tooManyRequests:
          print('Rate limited — back off and retry');
        case ServerFailure.response:
          print('HTTP ${failure.statusCode} — ${failure.message}');
        case ServerFailure.exception:
          print('Exception — ${failure.message}');
        case ServerFailure.undefined:
          print('Undefined error — ${failure.message}');
        case ServerFailure.unknown:
          print('Unknown failure');
      }
    } else if (failure is CanceledRequestFailure) {
      print('Request canceled — ignore silently');
    }
  }

  // --- Progress state ---

  const BaseProgressState loading = DefaultProgressState(showProgress: true);
  const BaseProgressState idle = DefaultProgressState(showProgress: false);

  for (final state in [loading, idle]) {
    switch (state) {
      case DefaultProgressState s:
        print(s.showProgress ? 'Show spinner' : 'Hide spinner');
    }
  }

  // copyWith for immutable state updates.
  final next = (loading as DefaultProgressState).copyWith(showProgress: false);
  print('After update: ${next.showProgress}');
}
