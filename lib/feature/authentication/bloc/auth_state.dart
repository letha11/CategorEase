part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final bool isLoggedIn;

  const AuthSuccess(this.isLoggedIn);

  @override
  List<Object> get props => [isLoggedIn];
}

final class AuthFailed extends AuthState {
  final String? message;

  const AuthFailed({this.message});

  @override
  List<Object?> get props => [message];
}
