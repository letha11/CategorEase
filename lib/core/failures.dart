import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String? message;
  final Object? exception;

  const Failure({this.message = "Something went wrong", this.exception});

  @override
  List<Object?> get props => [message, exception];
}

class AuthFailure extends Failure {
  const AuthFailure({String? message, super.exception})
      : super(message: message ?? 'Authentication Failed');
}

class ServerFailure extends Failure {
  const ServerFailure({String? message, super.exception})
      : super(message: message ?? 'Server error, please try again later');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({String? message, super.exception})
      : super(message: message ?? 'Timeout, please try again later');
}
