import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }

  // Register
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user settings document
      await _firestore.collection('users').doc(result.user!.uid).set({
        'theme': 'light', // default theme
        'language': 'en', // default language
      });

      return result.user;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  // Load user preferences
  Future<Map<String, dynamic>?> loadUserPreferences(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Load Preferences Error: $e');
      return null;
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences({
    required String uid,
    String? language,
    String? theme,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        if (language != null) 'language': language,
        if (theme != null) 'theme': theme,
      });
    } catch (e) {
      print('Update Preferences Error: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() => _auth.currentUser;
}
