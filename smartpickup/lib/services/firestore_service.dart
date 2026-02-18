import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addNote(String uid, String text) async {
    await _db.collection('notes').add({
      'uid': uid,
      'text': text,
      'time': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getNotes(String uid) {
    return _db
        .collection('notes')
        .where('uid', isEqualTo: uid)
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> deleteNote(String docId) async {
    await _db.collection('notes').doc(docId).delete();
  }
}
