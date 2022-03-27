import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/changed_document.dart';

class FireUtils {
  static TypeOfDocumentChange convertChangeType(
    DocumentChangeType fireChangeType,
  ) {
    switch (fireChangeType) {
      case DocumentChangeType.added:
        return TypeOfDocumentChange.added;
      case DocumentChangeType.modified:
        return TypeOfDocumentChange.updated;
      case DocumentChangeType.removed:
        return TypeOfDocumentChange.removed;
    }
  }
}
