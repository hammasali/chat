part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccessful extends AuthState {
  final User? user;

  AuthSuccessful({this.user});
}

class AuthUnSuccessful extends AuthState {}
