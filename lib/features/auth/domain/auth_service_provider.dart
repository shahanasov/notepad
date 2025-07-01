import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notepad/core/providers/auth_provider.dart';
import 'package:notepad/features/auth/data/auth_repository.dart';


/// Provides access to Firebase Auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthRepository(firebaseAuth);
});

/// Service layer that abstracts authentication use cases
final authServiceProvider = Provider<AuthService>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AuthService(authRepo);
});

class AuthService {
  final AuthRepository _repo;

  AuthService(this._repo);

  // Sign in with email/password
  Future<void> signIn(String email, String password) {
    return _repo.signIn(email, password);
  }

  // Sign up with email/password
  Future<void> signUp(String email, String password) {
    return _repo.signUp(email, password);
  }

  // Sign out
  Future<void> signOut() {
    return _repo.signOut();
  }

  // Get auth state stream
  Stream get authState => _repo.authStateChanges();

  // Get current user
  get currentUser => _repo.getCurrentUser();
}
