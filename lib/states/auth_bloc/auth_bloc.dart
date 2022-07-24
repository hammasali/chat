import 'package:bloc/bloc.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    try {
      on<AuthAppStartedEvent>((event, emit) async {
        var isSignIn = await FirebaseRepo.instance.authSignIn();
        if (isSignIn) {
          var user = FirebaseRepo.instance.getCurrentUser();
          emit(AuthSuccessful(user: user));
        } else {
          emit(AuthUnSuccessful());
        }
      });
    } catch (e) {
      throw AuthUnSuccessful();
    }
  }
}
