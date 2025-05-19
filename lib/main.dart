import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'main_screen.dart';
import 'pages/login_page.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home_page.dart';
import 'pages/level_selection_page.dart';
import 'pages/leaderboard_page.dart';
import 'pages/about_page.dart';
import 'pages/register_page.dart';
import 'pages/settings_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox<Map>('userSettings');
  await Hive.openBox<Map>('gameData');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _currentLocale;
  bool _isDarkMode = false;
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isGuestMode = false;
  bool _isFirstLaunch = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
    _setupConnectivityListener();
  }

  Future<void> _loadInitialSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    _currentUser = user;

    if (user != null) {
      final prefs = await _authService.loadUserPreferences(user.uid);
      if (prefs != null) {
        if (mounted) {
          setState(() {
            final lang = prefs['language'];
            final theme = prefs['theme'];
            _currentLocale = lang is String ? Locale(lang) : const Locale('en');
            _isDarkMode = theme == 'dark';
          });
        }
      }
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
      if (!_isOffline) {
        _syncData();
      }
    });
  }

  Future<void> _syncData() async {
    final gameDataBox = Hive.box<Map>('gameData');
    final userSettingsBox = Hive.box<Map>('userSettings');

    if (_currentUser != null) {
      final localGameData = gameDataBox.get(_currentUser!.uid);
      if (localGameData != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUser!.uid)
              .update({'score': localGameData['score'] ?? 0});
          gameDataBox.delete(_currentUser!.uid);
        } catch (e) {
          print("Error syncing game data: $e");
        }
      }

      final localSettings = userSettingsBox.get(_currentUser!.uid);
      if (localSettings != null) {
        try {
          await _authService.updateUserPreferences(
            uid: _currentUser!.uid,
            language: localSettings['language'],
            theme: localSettings['theme'],
          );
          userSettingsBox.delete(_currentUser!.uid);
        } catch (e) {
          print("Error syncing user settings: $e");
        }
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    Hive.close();
    super.dispose();
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
    if (_currentUser != null) {
      _authService.saveUserPreference(
        _currentUser!.uid,
        'language',
        newLocale.languageCode,
      );
    }
  }

  void _changeTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
    if (_currentUser != null) {
      _authService.saveUserPreference(
        _currentUser!.uid,
        'theme',
        isDark ? 'dark' : 'light',
      );
    }
  }

  void _enterGuestMode() {
    setState(() {
      _isGuestMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Memorizer',
      debugShowCheckedModeBanner: false,
      theme:
          _isDarkMode
              ? ThemeData.dark(useMaterial3: true)
              : ThemeData.light(useMaterial3: true),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kk')],
      locale: _currentLocale,
      home:
          _currentUser != null || _isGuestMode
              ? MainScreen(
                onDoubleTap: () {
                  _changeLocale(
                    _currentLocale == const Locale('en')
                        ? const Locale('ru')
                        : const Locale('en'),
                  );
                },
                onChangeTheme: _changeTheme,
                onChangeLocale: _changeLocale,
                isGuestMode: _isGuestMode,
                isOffline: _isOffline,
              )
              : LoginPage(
                onLoginSuccess: () {},
                onLocaleChanged: _changeLocale,
                onThemeChanged: _changeTheme,
                onEnterGuestMode: _enterGuestMode,
              ),
      routes: {
        '/level_select': (context) => LevelSelectionPage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
