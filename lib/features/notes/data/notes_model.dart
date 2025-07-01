import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String message;
  final Timestamp? timestamp;

  NoteModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'],
    );
  }
}
