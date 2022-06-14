part of 'home_bloc.dart';

abstract class HomeStatus extends Equatable {
  const HomeStatus();

  @override
  List<Object> get props => [];
}

class HomeStatusInitial extends HomeStatus {
  const HomeStatusInitial();
}

class HomeStatusLoading extends HomeStatus {}

class HomeStatusLoaded extends HomeStatus {}

class HomeStatusError extends HomeStatus {
  final String message;

  const HomeStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
