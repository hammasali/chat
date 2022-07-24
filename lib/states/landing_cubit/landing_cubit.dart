import 'package:bloc/bloc.dart';
import 'package:chat/services/models/userInfo_model.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'landing_state.dart';

class LandingCubit extends Cubit<LandingState> {
  LandingCubit() : super(LandingInitial());

  void signUpButtonPressedEvent(String email, String password) async {
    try {
      emit(LandingLoadingState());

      var user = await FirebaseRepo.instance.createUser(email, password);

      if (user != null) {
        await FirebaseRepo.instance.addNewUserData(UserInfoModel(
            email: email.trim(), timestamp: Timestamp.now(), status: true));
        emit(LandingSuccessState(user));
      }
    }

    //==================Errors=======================
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(LandingUnSuccessState(
            message: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(LandingUnSuccessState(
            message: 'The account already exists for that email.'));
      } else if (e.code == 'user-not-found') {
        emit(LandingUnSuccessState(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LandingUnSuccessState(
            message: 'Wrong password provided for that user.'));
      } else if (e.message == 'Given String is empty or null') {
        emit(LandingUnSuccessState(message: 'Please provide credentials'));
      } else {
        emit(LandingUnSuccessState(message: e.code));
      }
    } on PlatformException catch (e) {
      emit(LandingUnSuccessState(message: e.code));
    } on String catch (e) {
      emit(LandingUnSuccessState(message: e));
    }
  }

  void logInButtonPressedEvent(String email, String password) async {
    try {
      emit(LandingLoadingState());
      var user =
          await FirebaseRepo.instance.signInUser(email.trim(), password.trim());
      emit(LandingSuccessState(user));
    }

    //==================Errors=======================
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(LandingUnSuccessState(
            message: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(LandingUnSuccessState(
            message: 'The account already exists for that email.'));
      } else if (e.code == 'user-not-found') {
        emit(LandingUnSuccessState(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LandingUnSuccessState(
            message: 'Wrong password provided for that user.'));
      } else if (e.message == 'Given String is empty or null') {
        emit(LandingUnSuccessState(message: 'Please provide credentials'));
      } else {
        emit(LandingUnSuccessState(message: e.code));
      }
    } on PlatformException catch (e) {
      emit(LandingUnSuccessState(message: e.code));
    } on String catch (e) {
      emit(LandingUnSuccessState(message: e));
    } catch (e) {
      emit(LandingUnSuccessState(message: e.toString()));
    }
  }
}
