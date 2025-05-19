import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

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

      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'language': 'en',
        'theme': 'light',
        'score': 0,
      });
      final userSettingsBox = Hive.box<Map>('userSettings');
      await userSettingsBox.put(result.user!.uid, {
        'email': email,
        'language': 'en',
        'theme': 'light',
        'score': 0,
      });

      return result.user;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  Future<Map?> loadUserPreferences(String uid) async {
    try {
      final userSettingsBox = Hive.box<Map>('userSettings');
      final localSettings = userSettingsBox.get(uid);
      if (localSettings != null) {
        return localSettings;
      }

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        await userSettingsBox.put(uid, data);
      }
      return data;
    } catch (e) {
      print('Load Preferences Error: $e');
      return null;
    }
  }

  Future<void> updateUserPreferences({
    required String uid,
    String? language,
    String? theme,
  }) async {
    try {
      final userSettingsBox = Hive.box<Map>('userSettings');
      final existingSettings = userSettingsBox.get(uid) ?? {};
      if (language != null) existingSettings['language'] = language;
      if (theme != null) existingSettings['theme'] = theme;
      await userSettingsBox.put(uid, existingSettings);

      await _firestore.collection('users').doc(uid).update({
        if (language != null) 'language': language,
        if (theme != null) 'theme': theme,
      });
    } catch (e) {
      print('Update Preferences Error: $e');
    }
  }

  Future<void> saveUserPreference(String uid, String key, String value) async {
    try {
      final userSettingsBox = Hive.box<Map>('userSettings');
      final existingSettings = userSettingsBox.get(uid) ?? {};
      existingSettings[key] = value;
      await userSettingsBox.put(uid, existingSettings);

      await _firestore.collection('users').doc(uid).update({key: value});
    } catch (e) {
      print('Save Preference Error: $e');
    }
  }
}
