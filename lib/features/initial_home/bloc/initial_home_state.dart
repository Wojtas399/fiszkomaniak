part of 'initial_home_bloc.dart';

class InitialHomeState extends Equatable {
  final InitialHomeMode mode;
  final bool isUserLogged;

  const InitialHomeState({
    required this.mode,
    required this.isUserLogged,
  });

  @override
  List<Object> get props => [mode, isUserLogged];

  InitialHomeState copyWith({
    InitialHomeMode? mode,
    bool? isUserLogged,
  }) {
    return InitialHomeState(
      mode: mode ?? this.mode,
      isUserLogged: isUserLogged ?? this.isUserLogged,
    );
  }
}

enum InitialHomeMode {
  login,
  register,
}
