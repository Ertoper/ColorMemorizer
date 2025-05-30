import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:color_memorizer/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'pages/about_page.dart';
import 'pages/settings_page.dart';
import 'pages/level_selection_page.dart';
import 'pages/leaderboard_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/endless_color_sequence_game_page.dart';
import 'main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('kk');
  ThemeMode _themeMode = ThemeMode.system;
  User? _currentUser; // Текущий пользователь
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Locale> _supportedLocales = [
    const Locale('en'),
    const Locale('ru'),
    const Locale('kk'),
  ];

  @override
  void initState() {
    super.initState();
    _setSystemLocale();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _currentUser = user;
        _loadUserSettings(user.uid);
      } else {
        setState(() {
          _currentUser = null;
          _locale = const Locale('kk');
          _themeMode = ThemeMode.system;
        });
      }
    });
  }

  void _changeTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
    _saveUserSettings();
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _saveUserSettings();
  }

  void _cycleLocale() {
    setState(() {
      final currentIndex = _supportedLocales.indexOf(_locale);
      _locale = _supportedLocales[(currentIndex + 1) % _supportedLocales.length];
    });
    _saveUserSettings();
  }

  void _setSystemLocale() {
    Locale systemLocale = WidgetsBinding.instance.window.locale;
    if (_supportedLocales.contains(systemLocale)) {
      setState(() {
        _locale = systemLocale;
      });
    }
  }

  Future<void> _loadUserSettings(String uid) async {
    try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
            final data = doc.data()!;
            setState(() {
                _themeMode = _themeModeFromString(data['theme'] ?? 'system');
                _locale = Locale(data['language'] ?? 'kk');
            });
        } else {
            setState(() {
                _themeMode = ThemeMode.system;
                _locale = const Locale('kk');
            });
        }
    } catch (e) {
        print('Error loading user settings: $e');
    }
}

Future<void> _saveUserSettings() async {
    if (_currentUser == null) return;
    try {
        await _firestore.collection('users').doc(_currentUser!.uid).set({
            'theme': _themeModeToString(_themeMode),
            'language': _locale.languageCode,
        }, SetOptions(merge: true));
    } catch (e) {
        print('Error saving user settings: $e');
    }
}

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      default:
        return 'system';
    }
  }

  ThemeMode _themeModeFromString(String str) {
    switch (str) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC300),
            foregroundColor: Colors.black,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF001D3D),
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[850],
        ),
      ),
      locale: _locale,
      supportedLocales: _supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('kk');
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return const Locale('kk');
      },
      routes: {
        '/': (context) => _currentUser == null
            ? LoginPage(
                onLoginSuccess: () {
                  setState(() {
                    _currentUser = FirebaseAuth.instance.currentUser;
                  });
                },
                onLocaleChanged: _changeLocale,
                onThemeChanged: _changeTheme,
              )
            : MainScreen(
                onDoubleTap: _cycleLocale,
                onChangeTheme: _changeTheme,
                onChangeLocale: _changeLocale,
              ),
        '/home': (context) => MainScreen(
              onDoubleTap: _cycleLocale,
              onChangeTheme: _changeTheme,
              onChangeLocale: _changeLocale,
            ),
        '/endless_color_sequence_game_page': (context) => EndlessColorSequenceGamePage(),
        '/about': (context) => AboutPage(),
        '/settings': (context) => _currentUser == null
            ? LoginPage(
                onLoginSuccess: () {
                  Navigator.pushReplacementNamed(context, '/settings');
                },
                onLocaleChanged: _changeLocale,
                onThemeChanged: _changeTheme,
              )
            : SettingsPage(
                isDarkMode: Theme.of(context).brightness == Brightness.dark,
                onThemeChanged: _changeTheme,
                currentLocale: Localizations.localeOf(context),
                onLocaleChanged: _changeLocale,
                onLogout: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
              ),
        '/level_select': (context) => _currentUser == null
            ? LoginPage(
                onLoginSuccess: () {
                  Navigator.pushReplacementNamed(context, '/level_select');
                },
                onLocaleChanged: _changeLocale,
                onThemeChanged: _changeTheme,
              )
            : LevelSelectionPage(),
        '/leaderboard': (context) => _currentUser == null
            ? LoginPage(
                onLoginSuccess: () {
                  Navigator.pushReplacementNamed(context, '/leaderboard');
                },
                onLocaleChanged: _changeLocale,
                onThemeChanged: _changeTheme,
              )
            : LeaderboardPage(),
        '/login': (context) => LoginPage(
              onLoginSuccess: () {
                setState(() {
                  _currentUser = FirebaseAuth.instance.currentUser;
                });
                Navigator.pushReplacementNamed(context, '/home');
              },
              onLocaleChanged: _changeLocale,
              onThemeChanged: _changeTheme,
            ),
        '/register': (context) => RegisterPage(
              onRegisterSuccess: () {
                setState(() {
                  _currentUser = FirebaseAuth.instance.currentUser;
                });
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
      },
      initialRoute: '/',
    );
  }
}
