import 'package:equatable/equatable.dart';

abstract class BlocStatus extends Equatable {
  const BlocStatus();

  @override
  List<Object> get props => [];
}

class BlocStatusInitial extends BlocStatus {
  const BlocStatusInitial();
}

class BlocStatusLoading extends BlocStatus {
  const BlocStatusLoading();
}

class BlocStatusComplete<T> extends BlocStatus {
  final T? info;

  const BlocStatusComplete({this.info});
}

class BlocStatusError extends BlocStatus {
  final String message;

  const BlocStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
