import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onDoubleTap;
  final ValueChanged<bool> onChangeTheme;
  final ValueChanged<Locale> onChangeLocale;
  final bool isGuestMode;
  final bool isOffline; // Add this
  const MainScreen({
    Key? key,
    required this.onDoubleTap,
    required this.onChangeTheme,
    required this.onChangeLocale,
    this.isGuestMode = false,
    required this.isOffline,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final List<Widget> pages = [
      HomePage(
        onDoubleTap: widget.onDoubleTap,
        onChangeTheme: widget.onChangeTheme,
        onChangeLocale: widget.onChangeLocale,
        isOffline: widget.isOffline,
      ),
      AboutPage(),
      SettingsPage(
        isDarkMode: isDarkMode,
        onThemeChanged: widget.onChangeTheme,
        currentLocale: locale,
        onLocaleChanged: widget.onChangeLocale,
        onLogout: () {
          FirebaseAuth.instance.signOut();
        },
        isUserLoggedIn: currentUser != null && !widget.isGuestMode,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? AppLocalizations.of(context)!.home
              : _selectedIndex == 1
              ? AppLocalizations.of(context)!.about
              : AppLocalizations.of(context)!.settings,
        ),
        // Show offline indicator in AppBar
        bottom:
            widget.isOffline
                ? const PreferredSize(
                  preferredSize: Size.fromHeight(20.0),
                  child: Center(
                    child: Text(
                      "Offline Mode", //show offline
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
                : null,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
