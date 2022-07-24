part of 'landing_cubit.dart';

@immutable
abstract class LandingState {}

class LandingInitial extends LandingState {}

class LandingLoadingState extends LandingState {}

class LandingSuccessState extends LandingState {
  final User? user;

  LandingSuccessState(this.user);
}

class LandingUnSuccessState extends LandingState {
  final String? message;

  LandingUnSuccessState({this.message});
}

