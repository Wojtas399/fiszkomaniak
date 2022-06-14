part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String loggedUserAvatarUrl;
  final HomeStatus status;

  const HomeState({
    this.loggedUserAvatarUrl = '',
    this.status = const HomeStatusInitial(),
  });

  @override
  List<Object> get props => [
        loggedUserAvatarUrl,
        status,
      ];

  HomeState copyWith({
    String? loggedUserAvatarUrl,
    HomeStatus? status,
  }) {
    return HomeState(
      loggedUserAvatarUrl: loggedUserAvatarUrl ?? this.loggedUserAvatarUrl,
      status: status ?? HomeStatusLoaded(),
    );
  }
}
