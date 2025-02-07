import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
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
    Failure? failure;
    bool? isLoggedIn;

    final loginResult =
        await _authRepository.login(event.username, event.password);

    loginResult.match(
      (l) => failure = l,
      (r) => isLoggedIn = r,
    );

    if (failure != null && isLoggedIn != null) {
      emit(AuthFailed(message: failure!.message));
      return;
    }

    final userResult = await _authRepository.getAuthenticatedUser();

    userResult.fold(
      (l) => emit(AuthFailed(message: failure!.message)),
      (r) {
        emit(
          AuthSuccess(isLoggedIn!),
        );
      },
    );
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    Failure? failure;
    bool? isLoggedIn;

    final loginResult = await _authRepository.register(
      event.username,
      event.password,
      event.confirmPassword,
    );

    loginResult.match(
      (l) => failure = l,
      (r) => isLoggedIn = r,
    );

    if (failure != null && isLoggedIn != null) {
      emit(AuthFailed(message: failure!.message));
      return;
    }

    final userResult = await _authRepository.getAuthenticatedUser();

    userResult.fold(
      (l) => emit(AuthFailed(message: failure!.message)),
      (r) => emit(
        AuthSuccess(isLoggedIn!),
      ),
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
