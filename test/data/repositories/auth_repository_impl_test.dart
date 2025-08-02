import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:kaabo/core/errors/failures.dart';
import 'package:kaabo/data/repositories/auth_repository_impl.dart';
import 'package:kaabo/data/datasources/remote/auth_remote_datasource.dart';
import 'package:kaabo/data/models/user_model.dart';
import 'package:kaabo/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  final tUserModel = UserModel(
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
    phone: '1234567890',
    type: UserType.tenant,
    createdAt: DateTime(2024, 1, 1),
  );

  final tUserEntity = UserEntity(
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
    phone: '1234567890',
    type: UserType.tenant,
    createdAt: DateTime(2024, 1, 1),
  );

  group('signIn', () {
    test('should return UserEntity when sign in is successful', () async {
      when(
        () => mockRemoteDataSource.signIn(any(), any()),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signIn('test@test.com', 'password');

      expect(result, equals(Right(tUserEntity)));
      verify(() => mockRemoteDataSource.signIn('test@test.com', 'password'));
    });

    test('should return AuthFailure when sign in fails', () async {
      when(
        () => mockRemoteDataSource.signIn(any(), any()),
      ).thenThrow(Exception('Sign in failed'));

      final result = await repository.signIn('test@test.com', 'password');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });

  group('signUp', () {
    test('should return UserEntity when sign up is successful', () async {
      when(
        () => mockRemoteDataSource.signUp(any(), any()),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signUp(tUserEntity, 'password');

      expect(result, equals(Right(tUserEntity)));
    });

    test('should return AuthFailure when sign up fails', () async {
      when(
        () => mockRemoteDataSource.signUp(any(), any()),
      ).thenThrow(Exception('Sign up failed'));

      final result = await repository.signUp(tUserEntity, 'password');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });

  group('signOut', () {
    test('should return void when sign out is successful', () async {
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, equals(const Right(null)));
      verify(() => mockRemoteDataSource.signOut());
    });

    test('should return AuthFailure when sign out fails', () async {
      when(
        () => mockRemoteDataSource.signOut(),
      ).thenThrow(Exception('Sign out failed'));

      final result = await repository.signOut();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should be failure'),
      );
    });
  });

  group('getCurrentUser', () {
    test('should return UserEntity when user exists', () async {
      when(
        () => mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result, equals(Right(tUserEntity)));
    });

    test('should return null when no user exists', () async {
      when(
        () => mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, equals(const Right(null)));
    });
  });
}
