import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_memorizer/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onLogout;
  final bool isUserLoggedIn;

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onLogout,
    required this.isUserLoggedIn,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;
  late Locale _selectedLocale;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();
  bool _isOffline = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _selectedLocale = widget.currentLocale;
    _checkConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = result == ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _onThemeSwitchChanged(bool value) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _authService.saveUserPreference(
        user.uid,
        'theme',
        value ? 'dark' : 'light',
      );
    }
    widget.onThemeChanged(value);
    setState(() {
      _isDarkMode = value;
    });
  }

  void _onLocaleChanged(Locale locale) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _authService.saveUserPreference(
        user.uid,
        'language',
        locale.languageCode,
      );
    }
    widget.onLocaleChanged(locale);
    setState(() {
      _selectedLocale = locale;
    });
  }

  // Method to sync data
  Future<void> _syncData() async {
    if (_currentUser == null) return;

    // Get the boxes
    final userSettingsBox = Hive.box<Map>('userSettings');
    final gameDataBox = Hive.box<Map>('gameData');
    // Sync user settings
    final localSettings = userSettingsBox.get(_currentUser!.uid);
    if (localSettings != null) {
      try {
        await _authService.updateUserPreferences(
          uid: _currentUser!.uid,
          language: localSettings['language'],
          theme: localSettings['theme'],
        );
        await userSettingsBox.delete(_currentUser!.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User settings synced successfully!")),
        );
      } catch (e) {
        print("Error syncing settings: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to sync user settings.")),
        );
      }
    }

    // Sync Game Data
    final localGameData = gameDataBox.get(_currentUser!.uid);
    if (localGameData != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .update({'score': localGameData['score'] ?? 0});
        await gameDataBox.delete(_currentUser!.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Game data synced successfully!")),
        );
      } catch (e) {
        print("Error syncing game data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to sync game data.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _isDarkMode
                  ? 'assets/dark-background.png'
                  : 'assets/light-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.darkModeLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                        value: _isDarkMode,
                        onChanged: _onThemeSwitchChanged,
                        activeColor: Colors.amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.languageLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      DropdownButton<Locale>(
                        value: _selectedLocale,
                        items: const [
                          DropdownMenuItem(
                            value: Locale('kk'),
                            child: Text(
                              'Қазақ',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text(
                              'English',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: Locale('ru'),
                            child: Text(
                              'Русский',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (locale) {
                          if (locale != null) _onLocaleChanged(locale);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_currentUser != null) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _showLogoutConfirmation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.logoutButton,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      // Add sync button
                      onPressed: _isOffline ? null : _syncData,
                      // Disable when offline
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isOffline
                                ? Colors.grey
                                : Colors.blue, // Grey out when offline
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        "Sync Data", // Button text
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logoutConfirmTitle),
          content: Text(AppLocalizations.of(context)!.logoutConfirmMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancelButton),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.confirmButton),
            ),
          ],
          backgroundColor: Colors.black87,
        );
      },
    );
  }
}
