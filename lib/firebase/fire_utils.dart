import 'package:cloud_firestore/cloud_firestore.dart';
import 'fire_document.dart';

class FireUtils {
  static FireDocument<T>? convertDocumentSnapshotToFireDocument<T>(
    DocumentSnapshot<T> doc,
  ) {
    final data = doc.data();
    if (data != null) {
      return FireDocument(id: doc.id, data: data);
    }
    return null;
  }
}
