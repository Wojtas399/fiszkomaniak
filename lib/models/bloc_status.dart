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

  @override
  List<Object> get props => [info ?? ''];
}

class BlocStatusError<T> extends BlocStatus {
  final T? errorType;

  const BlocStatusError({required this.errorType});

  @override
  List<Object> get props => [errorType ?? ''];
}
