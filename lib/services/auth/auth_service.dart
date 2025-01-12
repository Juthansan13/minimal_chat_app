import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


// GET CURRENT USER
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign In with Email and Password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optional: Check if user exists in Firestore
     // final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
     // if (!userDoc.exists) {
        _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'uid': userCredential.user!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
     // }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth-specific errors
      throw Exception(_getErrorMessage(e.code));
    }
  }

  /// Sign Up with Email and Password
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth-specific errors
      throw Exception(_getErrorMessage(e.code));
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Failed to sign out: $e");
    }
  }

  

  /// Delete Account
  Future<void> deleteAccount() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).delete(); // Delete Firestore data
        await currentUser.delete(); // Delete Firebase Auth account
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  /// Error Message Handler
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return "The email address is not valid.";
      case 'user-disabled':
        return "This user account has been disabled.";
      case 'user-not-found':
        return "No user found for this email.";
      case 'wrong-password':
        return "Incorrect password.";
      case 'email-already-in-use':
        return "The email address is already in use.";
      case 'operation-not-allowed':
        return "Email/password accounts are not enabled.";
      case 'weak-password':
        return "The password is too weak.";
      default:
        return "An unknown error occurred. Please try again.";
    }
  }
}
