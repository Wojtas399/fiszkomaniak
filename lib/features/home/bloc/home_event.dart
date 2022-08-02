part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeEventInitialize extends HomeEvent {}

class HomeEventListenedParamsUpdated extends HomeEvent {
  final HomeStateListenedParams params;

  HomeEventListenedParamsUpdated({required this.params});
}
