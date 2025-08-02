import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/core/errors/failures.dart';
import 'package:kaabo/domain/entities/user_entity.dart';
import 'package:kaabo/domain/repositories/auth_repository.dart';
import 'package:kaabo/presentation/providers/auth_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late AuthController authController;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authController = AuthController(mockAuthRepository);
  });

  final tUserEntity = UserEntity(
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
    phone: '1234567890',
    type: UserType.tenant,
    createdAt: DateTime(2024, 1, 1),
  );

  group('AuthController', () {
    group('signIn', () {
      test('should return UserEntity when sign in is successful', () async {
        when(
          () => mockAuthRepository.signIn(any(), any()),
        ).thenAnswer((_) async => Right(tUserEntity));

        final result = await authController.signIn('test@test.com', 'password');

        expect(result, equals(Right(tUserEntity)));
        verify(() => mockAuthRepository.signIn('test@test.com', 'password'));
      });

      test('should return AuthFailure when sign in fails', () async {
        final failure = AuthFailure('Sign in failed');
        when(
          () => mockAuthRepository.signIn(any(), any()),
        ).thenAnswer((_) async => Left(failure));

        final result = await authController.signIn('test@test.com', 'password');

        expect(result, equals(Left(failure)));
      });

      test('should update state to loading then data on success', () async {
        when(
          () => mockAuthRepository.signIn(any(), any()),
        ).thenAnswer((_) async => Right(tUserEntity));

        expect(authController.state.isLoading, false);

        final future = authController.signIn('test@test.com', 'password');

        await future;
        expect(authController.state.hasValue, true);
      });
    });

    group('signUp', () {
      test('should return UserEntity when sign up is successful', () async {
        when(
          () => mockAuthRepository.signUp(any(), any()),
        ).thenAnswer((_) async => Right(tUserEntity));

        final result = await authController.signUp(tUserEntity, 'password');

        expect(result, equals(Right(tUserEntity)));
        verify(() => mockAuthRepository.signUp(tUserEntity, 'password'));
      });

      test('should return AuthFailure when sign up fails', () async {
        final failure = AuthFailure('Sign up failed');
        when(
          () => mockAuthRepository.signUp(any(), any()),
        ).thenAnswer((_) async => Left(failure));

        final result = await authController.signUp(tUserEntity, 'password');

        expect(result, equals(Left(failure)));
      });
    });

    group('signOut', () {
      test('should call repository signOut', () async {
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => const Right(null));

        await authController.signOut();

        verify(() => mockAuthRepository.signOut());
      });

      test('should update state on signOut failure', () async {
        final failure = AuthFailure('Sign out failed');
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => Left(failure));

        await authController.signOut();

        expect(authController.state, isA<AsyncError>());
      });
    });
  });
}
