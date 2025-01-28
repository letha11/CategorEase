part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;
  final String confirmPassword;

  const RegisterEvent(
    this.username,
    this.password,
    this.confirmPassword,
  );

  @override
  List<Object> get props => [
        username,
        password,
        confirmPassword,
      ];
}

class LogoutEvent extends AuthEvent {}
