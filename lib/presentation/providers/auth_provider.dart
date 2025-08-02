import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../core/di/injection.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => getIt<AuthRepository>());

final authStateProvider = StreamProvider<UserEntity?>((ref) async* {
  final repository = ref.watch(authRepositoryProvider);
  final result = await repository.getCurrentUser();
  yield result.fold((l) => null, (r) => r);
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AsyncValue.data(null));

  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _repository.signIn(email, password);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
    return result;
  }

  Future<Either<Failure, UserEntity>> signUp(UserEntity user, String password) async {
    state = const AsyncValue.loading();
    final result = await _repository.signUp(user, password);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
    return result;
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    final result = await _repository.signOut();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}