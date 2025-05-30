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
      rethrow;
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

      // Initialize user document
      await _firestore.collection('users').doc(result.user!.uid).set({
        'theme': 'light',
        'language': 'en',
        'highestScore': 0, // initialize score
      });

      return result.user;
    } catch (e) {
      print('Register Error: $e');
      rethrow;
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

  // Get highest score
  Future<int> getHighestScore(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      final data = doc.data() as Map<String, dynamic>?;
      return data?['highestScore'] ?? 0;
    } catch (e) {
      print('Get Highest Score Error: $e');
      return 0;
    }
  }

  // Update highest score
  Future<void> updateHighestScore(String uid, int newScore) async {
    try {
      final currentScore = await getHighestScore(uid);
      if (newScore > currentScore) {
        await _firestore.collection('users').doc(uid).update({
          'highestScore': newScore,
        });
      }
    } catch (e) {
      print('Update Highest Score Error: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() => _auth.currentUser;
}