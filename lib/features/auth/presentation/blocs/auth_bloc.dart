import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase(
        username: event.username,
        password: event.password,
      );
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthInitial());
  }
}
