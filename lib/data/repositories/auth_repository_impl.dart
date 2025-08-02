import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final user = await _remoteDataSource.signIn(email, password);
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure('Authentication failed: ${e.message}'));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
    UserEntity user,
    String password,
  ) async {
    try {
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        type: user.type,
        createdAt: user.createdAt,
        averageRating: user.averageRating,
        reviewCount: user.reviewCount,
      );

      final result = await _remoteDataSource.signUp(userModel, password);
      return Right(result.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _remoteDataSource.authStateChanges();
  }
}
