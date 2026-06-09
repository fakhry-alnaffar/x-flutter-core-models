import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';
import 'package:test/test.dart';

void main() {
  // -------------------------------------------------------------------------
  // CanceledRequestFailure
  // -------------------------------------------------------------------------
  group('CanceledRequestFailure', () {
    test('implements Failure', () {
      expect(const CanceledRequestFailure(), isA<Failure>());
    });

    test('const identity', () {
      const a = CanceledRequestFailure();
      const b = CanceledRequestFailure();
      expect(identical(a, b), isTrue);
    });

    test('value equality', () {
      expect(const CanceledRequestFailure(), equals(const CanceledRequestFailure()));
    });

    test('hashCode is stable', () {
      expect(
        const CanceledRequestFailure().hashCode,
        equals(const CanceledRequestFailure().hashCode),
      );
    });

    test('toString', () {
      expect(const CanceledRequestFailure().toString(), 'CanceledRequestFailure{}');
    });
  });

  // -------------------------------------------------------------------------
  // ApiFailure — shared base behaviour, tested through concrete subtypes
  // -------------------------------------------------------------------------
  group('ApiFailure (base behaviour)', () {
    test('same subtype + same fields are equal', () {
      const a = ApiUndefinedFailure(message: 'err', statusCode: 500);
      const b = ApiUndefinedFailure(message: 'err', statusCode: 500);
      expect(a, equals(b));
    });

    test('same subtype + different message are not equal', () {
      const a = ApiUndefinedFailure(message: 'a');
      const b = ApiUndefinedFailure(message: 'b');
      expect(a, isNot(equals(b)));
    });

    test('different subtypes are not equal even with same ServerFailure value', () {
      // Both map to ServerFailure.unknown
      const a = ApiUndefinedFailure(message: '');
      const b = ApiUnknownFailure();
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      const a = ApiUndefinedFailure(message: 'err', statusCode: 500);
      const b = ApiUndefinedFailure(message: 'err', statusCode: 500);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString includes runtimeType, failure, statusCode, message', () {
      const f = ApiUndefinedFailure(message: 'oops', statusCode: 422);
      final s = f.toString();
      expect(s, contains('ApiUndefinedFailure'));
      expect(s, contains('422'));
      expect(s, contains('oops'));
    });
  });

  // -------------------------------------------------------------------------
  // Concrete ApiFailure subtypes
  // -------------------------------------------------------------------------
  group('ApiResponseFailure', () {
    test('maps to ServerFailure.response', () {
      const f = ApiResponseFailure(statusCode: 404, message: 'not found');
      expect(f.failure, ServerFailure.response);
      expect(f.statusCode, 404);
      expect(f.message, 'not found');
    });

    test('message defaults to empty', () {
      expect(const ApiResponseFailure(statusCode: 500).message, '');
    });

    test('value equality', () {
      const a = ApiResponseFailure(statusCode: 404, message: 'not found');
      const b = ApiResponseFailure(statusCode: 404, message: 'not found');
      expect(a, equals(b));
    });

    test('toString contains class name and statusCode', () {
      final s = const ApiResponseFailure(statusCode: 503).toString();
      expect(s, contains('ApiResponseFailure'));
      expect(s, contains('503'));
    });
  });

  group('ApiUndefinedFailure', () {
    test('maps to ServerFailure.unknown with all fields', () {
      const f = ApiUndefinedFailure(message: 'undef', statusCode: 422);
      expect(f.failure, ServerFailure.unknown);
      expect(f.message, 'undef');
      expect(f.statusCode, 422);
    });
  });

  group('ConnectionFailure', () {
    test('maps to ServerFailure.noNetwork', () {
      expect(const ConnectionFailure().failure, ServerFailure.noNetwork);
      expect(const ConnectionFailure().message, '');
    });

    test('value equality', () {
      expect(const ConnectionFailure(), equals(const ConnectionFailure()));
    });

    test('toString contains class name', () {
      expect(const ConnectionFailure().toString(), contains('ConnectionFailure'));
    });
  });

  group('ApiExceptionFailure', () {
    test('maps to ServerFailure.exception', () {
      const f = ApiExceptionFailure(message: 'timeout');
      expect(f.failure, ServerFailure.exception);
      expect(f.message, 'timeout');
    });
  });

  group('ApiUnauthorizedFailure', () {
    test('maps to ServerFailure.unauthorized', () {
      expect(const ApiUnauthorizedFailure().failure, ServerFailure.unauthorized);
    });

    test('value equality', () {
      expect(const ApiUnauthorizedFailure(), equals(const ApiUnauthorizedFailure()));
    });
  });

  group('ApiTooManyRequestsFailure', () {
    test('maps to ServerFailure.tooManyRequests', () {
      expect(const ApiTooManyRequestsFailure().failure, ServerFailure.tooManyRequests);
    });

    test('value equality', () {
      expect(const ApiTooManyRequestsFailure(), equals(const ApiTooManyRequestsFailure()));
    });
  });

  group('ApiUnknownFailure', () {
    test('maps to ServerFailure.unknown', () {
      expect(const ApiUnknownFailure().failure, ServerFailure.unknown);
    });

    test('value equality', () {
      expect(const ApiUnknownFailure(), equals(const ApiUnknownFailure()));
    });
  });

  // -------------------------------------------------------------------------
  // ServerFailure enhanced enum
  // -------------------------------------------------------------------------
  group('ServerFailure', () {
    test('has exactly 6 values', () {
      expect(ServerFailure.values.length, 6);
    });

    test('all values are present', () {
      expect(ServerFailure.values, containsAll([
        ServerFailure.noNetwork,
        ServerFailure.exception,
        ServerFailure.unauthorized,
        ServerFailure.tooManyRequests,
        ServerFailure.response,
        ServerFailure.unknown,
      ]));
    });

    test('each value has a non-empty label', () {
      for (final v in ServerFailure.values) {
        expect(v.label, isNotEmpty, reason: '$v.label must not be empty');
      }
    });

    test('exhaustive switch covers all values', () {
      for (final v in ServerFailure.values) {
        final label = switch (v) {
          ServerFailure.noNetwork       => 'noNetwork',
          ServerFailure.exception       => 'exception',
          ServerFailure.unauthorized    => 'unauthorized',
          ServerFailure.tooManyRequests => 'tooManyRequests',
          ServerFailure.response        => 'response',
          ServerFailure.unknown         => 'unknown',
        };
        expect(label, isNotEmpty);
      }
    });
  });

  // -------------------------------------------------------------------------
  // DefaultProgressState
  // -------------------------------------------------------------------------
  group('DefaultProgressState', () {
    test('implements BaseProgressState', () {
      expect(const DefaultProgressState(showProgress: true), isA<BaseProgressState>());
    });

    test('showProgress: true', () {
      expect(const DefaultProgressState(showProgress: true).showProgress, isTrue);
    });

    test('showProgress: false', () {
      expect(const DefaultProgressState(showProgress: false).showProgress, isFalse);
    });

    test('const identity for same args', () {
      const a = DefaultProgressState(showProgress: true);
      const b = DefaultProgressState(showProgress: true);
      expect(identical(a, b), isTrue);
    });

    test('value equality', () {
      expect(
        DefaultProgressState(showProgress: true),
        equals(DefaultProgressState(showProgress: true)),
      );
    });

    test('inequality on different showProgress', () {
      expect(
        DefaultProgressState(showProgress: true),
        isNot(equals(DefaultProgressState(showProgress: false))),
      );
    });

    test('hashCode consistent with equality', () {
      expect(
        DefaultProgressState(showProgress: true).hashCode,
        equals(DefaultProgressState(showProgress: true).hashCode),
      );
    });

    test('toString', () {
      expect(
        const DefaultProgressState(showProgress: true).toString(),
        'DefaultProgressState{showProgress: true}',
      );
    });

    test('copyWith changes showProgress', () {
      const original = DefaultProgressState(showProgress: true);
      final copy = original.copyWith(showProgress: false);
      expect(copy.showProgress, isFalse);
    });

    test('copyWith with no args returns equivalent instance', () {
      const original = DefaultProgressState(showProgress: true);
      final copy = original.copyWith();
      expect(copy, equals(original));
    });
  });

  // -------------------------------------------------------------------------
  // BaseProgressState sealed exhaustive switch
  // -------------------------------------------------------------------------
  group('BaseProgressState', () {
    test('sealed exhaustive switch compiles and runs', () {
      final BaseProgressState state = DefaultProgressState(showProgress: false);
      final result = switch (state) {
        DefaultProgressState s => s.showProgress,
      };
      expect(result, isFalse);
    });
  });
}
