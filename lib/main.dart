//  main.dart (Modified)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pages/about_page.dart';
import 'pages/settings_page.dart';
import 'pages/level_selection_page.dart';
import 'pages/leaderboard_page.dart';
import 'main_screen.dart'; //  Import MainScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('kk');
  ThemeMode _themeMode = ThemeMode.system;

  final List<Locale> _supportedLocales = [
    const Locale('en'),
    const Locale('ru'),
    const Locale('kk'),
  ];

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

  @override
  void initState() {
    super.initState();
    _setSystemLocale();
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
      //  Define named routes here
      routes: {
        '/':
            (context) => MainScreen(
              //  Use MainScreen as the home
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
            ),
        '/level_select': (context) => LevelSelectionPage(),
        '/leaderboard': (context) => LeaderboardPage(),
      },
      initialRoute: '/', //  Set the initial route
    );
  }
}
