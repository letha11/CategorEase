import 'package:bloc/bloc.dart';
import 'package:categorease/feature/authentication/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _authRepository.login(event.username, event.password);

    result.match(
      (failure) => emit(AuthFailed(message: failure.message)),
      (success) => emit(AuthSuccess(success)),
    );
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _authRepository.register(
        event.username, event.password, event.confirmPassword);

    result.match(
      (failure) => emit(AuthFailed(message: failure.message)),
      (success) => emit(AuthSuccess(success)),
    );
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _authRepository.logout();

    result.match(
      (failure) => emit(const AuthFailed()),
      (success) => emit(AuthSuccess(success)),
    );
  }
}
