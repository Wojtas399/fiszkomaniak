import 'package:equatable/equatable.dart';

class FireDoc<T> extends Equatable {
  final String id;
  final T doc;

  const FireDoc({required this.id, required this.doc});

  @override
  List<dynamic> get props => [id, doc];
}
