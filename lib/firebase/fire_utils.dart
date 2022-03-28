import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/changed_document.dart';

class FireUtils {
  static DbDocChangeType convertChangeType(
    DocumentChangeType fireChangeType,
  ) {
    switch (fireChangeType) {
      case DocumentChangeType.added:
        return DbDocChangeType.added;
      case DocumentChangeType.modified:
        return DbDocChangeType.updated;
      case DocumentChangeType.removed:
        return DbDocChangeType.removed;
    }
  }
}
