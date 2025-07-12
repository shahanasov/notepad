import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notepad/features/notes/data/note_repository.dart';
import 'package:notepad/features/notes/data/notes_model.dart';

/// Provides FirebaseAuth instance globally
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provides auth state stream
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// NoteRepository provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return NoteRepository(firestore);
});

///  Notes Stream Provider
final userNotesProvider = StreamProvider<List<NoteModel>>((ref) {
  final repo = ref.watch(noteRepositoryProvider);
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return const Stream.empty(); // prevent crash

  return repo.getNotes(user.uid);
});
