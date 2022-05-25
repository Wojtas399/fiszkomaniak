import 'package:equatable/equatable.dart';

class ChangedDocument<T> extends Equatable {
  final DbDocChangeType changeType;
  final T doc;

  const ChangedDocument({
    required this.changeType,
    required this.doc,
  });

  @override
  List<Object> get props => [changeType];
}

enum DbDocChangeType { added, updated, removed }

class GroupedDbDocuments<T> extends Equatable {
  final List<T> addedDocuments;
  final List<T> updatedDocuments;
  final List<T> removedDocuments;

  const GroupedDbDocuments({
    required this.addedDocuments,
    required this.updatedDocuments,
    required this.removedDocuments,
  });

  @override
  List<Object> get props => [
        addedDocuments,
        updatedDocuments,
        removedDocuments,
      ];
}

GroupedDbDocuments<T> groupDbDocuments<T>(
  List<ChangedDocument<T>> dbDocuments,
) {
  final List<T> addedDocuments = [];
  final List<T> updatedDocuments = [];
  final List<T> removedDocuments = [];
  for (final document in dbDocuments) {
    switch (document.changeType) {
      case DbDocChangeType.added:
        addedDocuments.add(document.doc);
        break;
      case DbDocChangeType.updated:
        updatedDocuments.add(document.doc);
        break;
      case DbDocChangeType.removed:
        removedDocuments.add(document.doc);
        break;
    }
  }
  return GroupedDbDocuments(
    addedDocuments: addedDocuments,
    updatedDocuments: updatedDocuments,
    removedDocuments: removedDocuments,
  );
}
