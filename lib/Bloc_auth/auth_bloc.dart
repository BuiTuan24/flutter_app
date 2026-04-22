import 'package:flutter_application_1/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;

  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepo.login(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepo.register(
          fullName: event.fullName,
          phone: event.phone,
          email: event.email,
          password: event.password,
          birthYear: event.birthYear,
          gender: event.gender,
          avatar: event.avatar,
        );
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<LogoutEvent>((event, emit) async {
      await authRepo.logout();
      emit(Unauthenticated());
    });
  }
}