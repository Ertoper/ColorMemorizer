import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('kk');
  final List<Locale> _supportedLocales = [
    const Locale('en'),
    const Locale('ru'),
    const Locale('kk'),
  ];

  @override
  void initState() {
    super.initState();
    _setSystemLocale();
  }

  // Функция для учета системного языка
  void _setSystemLocale() {
    // ignore: deprecated_member_use
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
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFC300), // светлая тема кнопки
            foregroundColor: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF001D3D), // тёмная тема кнопки
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
      home: HomePage(onDoubleTap: _cycleLocale),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onDoubleTap;

  const HomePage({super.key, required this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        isDark ? const Color(0xFF001D3D) : const Color(0xFFFFC300);

    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Свайп влево
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AboutPage(),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                isDark
                    ? 'assets/dark-background.png'
                    : 'assets/light-background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'C',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: 'o',
                          style: TextStyle(color: Colors.green),
                        ),
                        TextSpan(
                          text: 'l',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: 'o',
                          style: TextStyle(color: Colors.yellow),
                        ),
                        TextSpan(
                          text: 'r',
                          style: TextStyle(color: Colors.purple),
                        ),
                        TextSpan(
                          text: 'Memorizer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LevelSelectionPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.playButton,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LeaderboardPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.leaderboardButton,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelSelectionPage extends StatelessWidget {
  final int numberOfLevels = 30;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark
                  ? 'assets/dark-background.png'
                  : 'assets/light-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Positioned.fill(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    AppLocalizations.of(context)!.levelSelectionPageTitle,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: numberOfLevels,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final levelNumber = index + 1;
                        return ElevatedButton(
                          onPressed: () {
                            print('Level $levelNumber selected');
                          },
                          child: Text('$levelNumber'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Свайп вправо
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.aboutPageTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.appDescription,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.credits,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
        backgroundColor: isDark ? Colors.black : const Color(0xFF003F88),
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {'name': 'Aruzhan', 'score': 120},
    {'name': 'Dias', 'score': 110},
    {'name': 'Marat', 'score': 105},
    {'name': 'Alina', 'score': 100},
    {'name': 'Ersayyn', 'score': 95},
  ];

  final String currentUser = 'You';
  final int yourScore = 95;
  final int yourPlace = 5;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark
                  ? 'assets/dark-background.png'
                  : 'assets/light-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Positioned.fill(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    AppLocalizations.of(context)!.leaderboardPageTitle,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.yourRank}: $yourPlace',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.yourScore}: $yourScore',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return Card(
                          color:
                              isDark
                                  ? Colors.grey[900]
                                  : Colors.white.withOpacity(0.8),
                          child: ListTile(
                            leading: Text(
                              '#${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            title: Text(
                              player['name'],
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            trailing: Text(
                              '${player['score']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
