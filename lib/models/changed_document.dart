import 'package:equatable/equatable.dart';

class ChangedDocument<T> extends Equatable {
  final TypeOfDocumentChange changeType;
  final T doc;

  const ChangedDocument({
    required this.changeType,
    required this.doc,
  });

  @override
  List<Object> get props => [changeType];
}

enum TypeOfDocumentChange { added, updated, removed }
