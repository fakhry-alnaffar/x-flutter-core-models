import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

// ---------------------------------------------------------------------------
// Failure hierarchy
// ---------------------------------------------------------------------------

void testCanceledRequestFailure() {
  const f1 = CanceledRequestFailure();
  const f2 = CanceledRequestFailure();
  assert(identical(f1, f2), 'const constructor must produce identical instances');
  // Static type confirms it implements Failure — verified at compile time.
  Failure _ = f1;
}

void testApiFailureBase() {
  final f = ApiFailure(ServerFailure.unknown, message: 'oops', statusCode: 500);
  assert(f.failure == ServerFailure.unknown);
  assert(f.message == 'oops');
  assert(f.statusCode == 500);
  assert(f.toString().contains('oops'));
  assert(f.toString().contains('500'));
}

void testApiFailureDefaults() {
  final f = ApiFailure(ServerFailure.response);
  assert(f.message == '');
  assert(f.statusCode == null);
}

void testApiUndefinedFailure() {
  final f = ApiUndefinedFailure(message: 'undefined', statusCode: 422);
  assert(f.failure == ServerFailure.unknown);
  assert(f.message == 'undefined');
  assert(f.statusCode == 422);
  assert(f.toString().contains('ApiUndefinedFailure'));
  assert(f.toString().contains('422'));
}

void testConnectionFailure() {
  final f = ConnectionFailure();
  assert(f.failure == ServerFailure.noNetwork);
  assert(f.message == '');
  assert(f.toString().contains('ConnectionFailure'));
}

void testApiExceptionFailure() {
  final f = ApiExceptionFailure(message: 'timeout');
  assert(f.failure == ServerFailure.exception);
  assert(f.message == 'timeout');
  assert(f.toString().contains('timeout'));
}

void testApiUnauthorizedFailure() {
  final f = ApiUnauthorizedFailure();
  assert(f.failure == ServerFailure.unAuthorized);
  assert(f.toString().contains('ApiUnauthorizedFailure'));
}

void testApiTooManyRequestsFailure() {
  final f = ApiTooManyRequestsFailure();
  assert(f.failure == ServerFailure.tooManyRequests);
  assert(f.toString().contains('ApiTooManyRequestsFailure'));
}

void testApiUnknownFailure() {
  final f = ApiUnknownFailure();
  assert(f.failure == ServerFailure.unknown);
  assert(f.toString().contains('ApiUnknownFailure'));
}

// ---------------------------------------------------------------------------
// ServerFailure enum
// ---------------------------------------------------------------------------

void testServerFailureValues() {
  assert(ServerFailure.values.length == 6, 'ServerFailure must have exactly 6 values');
  assert(ServerFailure.values.contains(ServerFailure.noNetwork));
  assert(ServerFailure.values.contains(ServerFailure.exception));
  assert(ServerFailure.values.contains(ServerFailure.unAuthorized));
  assert(ServerFailure.values.contains(ServerFailure.tooManyRequests));
  assert(ServerFailure.values.contains(ServerFailure.response));
  assert(ServerFailure.values.contains(ServerFailure.unknown));
}

void testServerFailureExhaustiveSwitch() {
  // If any ServerFailure value were missing from this switch the compiler
  // would produce a non-exhaustive error — reaching here means it's complete.
  for (final v in ServerFailure.values) {
    final label = switch (v) {
      ServerFailure.noNetwork       => 'noNetwork',
      ServerFailure.exception       => 'exception',
      ServerFailure.unAuthorized    => 'unAuthorized',
      ServerFailure.tooManyRequests => 'tooManyRequests',
      ServerFailure.response        => 'response',
      ServerFailure.unknown         => 'unknown',
    };
    assert(label.isNotEmpty);
  }
}

// ---------------------------------------------------------------------------
// BaseProgressState sealed hierarchy
// ---------------------------------------------------------------------------

void testDefaultProgressStateTrue() {
  const s = DefaultProgressState(showProgress: true);
  assert(s.showProgress == true);
  // Assignable to sealed base — verified at compile time.
  BaseProgressState _ = s;
}

void testDefaultProgressStateFalse() {
  const s = DefaultProgressState(showProgress: false);
  assert(s.showProgress == false);
}

void testDefaultProgressStateConstIdentity() {
  const a = DefaultProgressState(showProgress: true);
  const b = DefaultProgressState(showProgress: true);
  assert(identical(a, b), 'const instances with same args must be identical');
}

void testSealedExhaustiveSwitch() {
  // Exhaustive switch over sealed BaseProgressState — compile error if a
  // subtype is missing.
  final BaseProgressState state = DefaultProgressState(showProgress: false);
  final result = switch (state) {
    DefaultProgressState s => s.showProgress,
  };
  assert(result == false);
}

// ---------------------------------------------------------------------------
// Runner
// ---------------------------------------------------------------------------

void main() {
  final tests = <String, void Function()>{
    'CanceledRequestFailure: const identity + implements Failure':  testCanceledRequestFailure,
    'ApiFailure: fields and toString':                              testApiFailureBase,
    'ApiFailure: default values':                                   testApiFailureDefaults,
    'ApiUndefinedFailure: fields, type, toString':                  testApiUndefinedFailure,
    'ConnectionFailure: fields and toString':                       testConnectionFailure,
    'ApiExceptionFailure: fields and toString':                     testApiExceptionFailure,
    'ApiUnauthorizedFailure: fields and toString':                  testApiUnauthorizedFailure,
    'ApiTooManyRequestsFailure: fields and toString':               testApiTooManyRequestsFailure,
    'ApiUnknownFailure: fields and toString':                       testApiUnknownFailure,
    'ServerFailure: all 6 values present':                          testServerFailureValues,
    'ServerFailure: exhaustive switch compiles and runs':           testServerFailureExhaustiveSwitch,
    'DefaultProgressState: showProgress true':                      testDefaultProgressStateTrue,
    'DefaultProgressState: showProgress false':                     testDefaultProgressStateFalse,
    'DefaultProgressState: const identity':                         testDefaultProgressStateConstIdentity,
    'BaseProgressState: sealed exhaustive switch':                  testSealedExhaustiveSwitch,
  };

  var passed = 0;
  var failed = 0;

  for (final entry in tests.entries) {
    try {
      entry.value();
      print('[PASS] ${entry.key}');
      passed++;
    } catch (e) {
      print('[FAIL] ${entry.key}');
      print('       $e');
      failed++;
    }
  }

  print('');
  print('Results: $passed passed, $failed failed out of ${tests.length} tests');

  if (failed > 0) throw Exception('$failed test(s) failed');
}
