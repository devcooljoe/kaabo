import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
  
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class AuthFailure extends Failure {
  final String message;
  
  const AuthFailure(this.message);
  
  @override
  List<Object> get props => [message];
}