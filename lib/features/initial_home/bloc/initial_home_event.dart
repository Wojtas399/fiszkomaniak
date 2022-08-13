part of 'initial_home_bloc.dart';

abstract class InitialHomeEvent {}

class InitialHomeEventInitialize extends InitialHomeEvent {}

class InitialHomeEventChangeMode extends InitialHomeEvent {
  final InitialHomeMode mode;

  InitialHomeEventChangeMode({required this.mode});
}
