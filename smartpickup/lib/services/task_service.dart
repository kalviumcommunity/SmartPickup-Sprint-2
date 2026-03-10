import 'package:cloud_firestore/cloud_firestore.dart';

/// All Firestore write (and read) operations for the `tasks` collection.
///
/// Demonstrates:
///  • [addTask]    — .add()    auto-generated ID
///  • [setTask]    — .set()    write to a specific document ID
///  • [updateTask] — .update() modify specific fields only
///  • [deleteTask] — .delete()
///  • [getTasks]   — real-time stream for a given user
class TaskService {
  static const _col = 'tasks';
  final _db = FirebaseFirestore.instance;

  // ── CREATE — auto-generated document ID ───────────────────────────────────
  Future<DocumentReference> addTask({
    required String uid,
    required String title,
    required String description,
    String priority = 'medium',
  }) async {
    return _db.collection(_col).add({
      'uid': uid,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': false,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  // ── SET — write to a known document ID (creates or fully replaces) ─────────
  Future<void> setTask({
    required String docId,
    required String uid,
    required String title,
    required String description,
    String priority = 'medium',
  }) async {
    await _db.collection(_col).doc(docId).set({
      'uid': uid,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': false,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  // ── UPDATE — only the fields that changed ─────────────────────────────────
  Future<void> updateTask({
    required String docId,
    String? title,
    String? description,
    String? priority,
    bool? isCompleted,
  }) async {
    final Map<String, dynamic> data = {
      'updatedAt': Timestamp.now(),
    };
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (priority != null) data['priority'] = priority;
    if (isCompleted != null) data['isCompleted'] = isCompleted;

    await _db.collection(_col).doc(docId).update(data);
  }

  // ── TOGGLE COMPLETION — convenience wrapper around update ─────────────────
  Future<void> toggleComplete(String docId, bool current) =>
      updateTask(docId: docId, isCompleted: !current);

  // ── DELETE ─────────────────────────────────────────────────────────────────
  Future<void> deleteTask(String docId) =>
      _db.collection(_col).doc(docId).delete();

  // ── STREAM — real-time listener for a user's tasks ────────────────────────
  Stream<QuerySnapshot> getTasks(String uid) => _db
      .collection(_col)
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots();
}
