import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/about_page.dart';
import 'pages/settings_page.dart';
import 'pages/level_selection_page.dart';
import 'pages/leaderboard_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
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
  User? _currentUser;

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
      setState(() {
        _currentUser = user;
      });
    });
  }

  void _changeTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _setSystemLocale() {
    Locale systemLocale = WidgetsBinding.instance.window.locale;
    if (_supportedLocales.contains(systemLocale)) {
      setState(() {
        _locale = systemLocale;
      });
    }
  }

  void _cycleLocale() {
    setState(() {
      final currentIndex = _supportedLocales.indexOf(_locale);
      _locale =
          _supportedLocales[(currentIndex + 1) % _supportedLocales.length];
    });
  }

  void _handleAuthStateChange(User? user) {
    setState(() {
      _currentUser = user;
    });
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
            backgroundColor: Color(0xFFFFC300),
            foregroundColor: Colors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
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
            backgroundColor: Color(0xFF001D3D),
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
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
        '/':
            (context) =>
                _currentUser == null
                    ? LoginPage(
                      onLoginSuccess: () {
                        setState(() {
                          _currentUser = FirebaseAuth.instance.currentUser;
                        });
                      },
                    )
                    : MainScreen(
                      onDoubleTap: _cycleLocale,
                      onChangeTheme: _changeTheme,
                      onChangeLocale: _changeLocale,
                    ),
        '/home':
            (context) => MainScreen(
              onDoubleTap: _cycleLocale,
              onChangeTheme: _changeTheme,
              onChangeLocale: _changeLocale,
            ),
        '/about': (context) => AboutPage(),
        '/settings':
            (context) => SettingsPage(
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
              onThemeChanged: _changeTheme,
              currentLocale: Localizations.localeOf(context),
              onLocaleChanged: _changeLocale,
              onLogout: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
        '/level_select':
            (context) =>
                _currentUser == null
                    ? LoginPage(
                      onLoginSuccess: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/level_select',
                        );
                      },
                    )
                    : LevelSelectionPage(),
        '/leaderboard':
            (context) =>
                _currentUser == null
                    ? LoginPage(
                      onLoginSuccess: () {
                        Navigator.pushReplacementNamed(context, '/leaderboard');
                      },
                    )
                    : LeaderboardPage(),
        '/login':
            (context) => LoginPage(
              onLoginSuccess: () {
                setState(() {
                  _currentUser = FirebaseAuth.instance.currentUser;
                });
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
        '/register':
            (context) => RegisterPage(
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
