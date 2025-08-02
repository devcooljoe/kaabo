import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/core/errors/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure should extend Failure', () {
      final failure = ServerFailure();
      expect(failure, isA<Failure>());
    });

    test('CacheFailure should extend Failure', () {
      final failure = CacheFailure();
      expect(failure, isA<Failure>());
    });

    test('NetworkFailure should extend Failure', () {
      final failure = NetworkFailure();
      expect(failure, isA<Failure>());
    });

    test('AuthFailure should extend Failure and contain message', () {
      const message = 'Authentication failed';
      final failure = AuthFailure(message);

      expect(failure, isA<Failure>());
      expect(failure.message, equals(message));
    });

    test('AuthFailure should support equality comparison', () {
      const message = 'Authentication failed';
      final failure1 = AuthFailure(message);
      final failure2 = AuthFailure(message);

      expect(failure1, equals(failure2));
    });

    test('AuthFailure should have correct props', () {
      const message = 'Authentication failed';
      final failure = AuthFailure(message);

      expect(failure.props, equals([message]));
    });

    test('Different AuthFailures should not be equal', () {
      final failure1 = AuthFailure('Message 1');
      final failure2 = AuthFailure('Message 2');

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
