// lib/data/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('AuthService: Attempting sign up for $email');
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('AuthService: Sign up successful for ${credential.user?.email}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('AuthService: Sign up failed - ${e.code}: ${e.message}');
      // Handle specific errors
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'invalid-email') {
        print('The email address is invalid.');
      }
      return null;
    } catch (e) {
      print('AuthService: Unexpected error during sign up: $e');
      return null;
    }
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('AuthService: Attempting sign in for $email');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('AuthService: Sign in successful for ${credential.user?.email}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('AuthService: Sign in failed - ${e.code}: ${e.message}');
      // Handle specific errors
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else if (e.code == 'invalid-email') {
        print('The email address is invalid.');
      } else if (e.code == 'user-disabled') {
        print('This user account has been disabled.');
      }
      return null;
    } catch (e) {
      print('AuthService: Unexpected error during sign in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      print('AuthService: Signing out');
      await _firebaseAuth.signOut();
      print('AuthService: Sign out successful');
    } catch (e) {
      print('AuthService: Error during sign out: $e');
    }
  }
}