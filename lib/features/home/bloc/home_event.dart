part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeEventInitialize extends HomeEvent {}

class HomeEventLoggedUserAvatarUrlUpdated extends HomeEvent {
  final String newLoggedUserAvatarUrl;

  HomeEventLoggedUserAvatarUrlUpdated({required this.newLoggedUserAvatarUrl});

  @override
  List<Object> get props => [newLoggedUserAvatarUrl];
}

class HomeEventAppearanceSettingsUpdated extends HomeEvent {
  final AppearanceSettings appearanceSettings;

  HomeEventAppearanceSettingsUpdated({required this.appearanceSettings});

  @override
  List<Object> get props => [appearanceSettings];
}
