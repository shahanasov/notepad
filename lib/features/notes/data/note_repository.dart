
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepad/features/notes/data/notes_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  /// Add a new note to the user's notes subcollection
  Future<void> addNote({
    required String uid,
    required String title,
    required String message,
  }) async {
    final noteData = {
      'title': title,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .add(noteData);
  }

  /// Get all notes in real-time for a user
Stream<List<NoteModel>> getNotes(String uid) {
  return _firestore
      .collection('users')
      .doc(uid)
      .collection('notes')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => NoteModel.fromDoc(doc)).toList());
}

}


  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

