import 'package:equatable/equatable.dart';

abstract class HttpStatus extends Equatable {
  const HttpStatus();

  @override
  List<Object> get props => [];
}

class HttpStatusInitial extends HttpStatus {
  const HttpStatusInitial();
}

class HttpStatusSubmitting extends HttpStatus {}

class HttpStatusSuccess extends HttpStatus {
  final String? message;

  const HttpStatusSuccess({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

class HttpStatusFailure extends HttpStatus {
  final String message;

  const HttpStatusFailure({required this.message});

  @override
  List<Object> get props => [message];
}
