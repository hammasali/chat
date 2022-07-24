import 'package:bloc/bloc.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  void logOut() async {
    try {
      emit(LogoutLoadingState());
      await FirebaseRepo.instance.updateStatus(false);
      await FirebaseRepo.instance.signOutUser();
      emit(LogoutSuccessState());
    } on PlatformException catch (e) {
      emit(LogoutUnSuccessState(message: e.message));
    } on FirebaseAuthException catch (e) {
      emit(LogoutUnSuccessState(message: e.message));
    }
  }
}
