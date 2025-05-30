import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/settings_page.dart';
import 'package:color_memorizer/l10n/app_localizations.dart'; // Import for localized strings

class MainScreen extends StatefulWidget {
  final VoidCallback onDoubleTap;
  final ValueChanged<bool> onChangeTheme;
  final ValueChanged<Locale> onChangeLocale;

  const MainScreen({
    Key? key,
    required this.onDoubleTap,
    required this.onChangeTheme,
    required this.onChangeLocale,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  User? _currentUser; // Track the current authenticated user

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser; // Initialize with current user
    // Listen for authentication state changes to update UI dynamically
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
          // If user logs out while on a restricted page (e.g., Settings),
          // navigate to the Home page to prevent showing a blank page or error.
          if (user == null && _selectedIndex == 2) { // If currently on Settings tab
            _selectedIndex = 0; // Switch to Home tab
          }
        });
      }
    });

    // Initialize the list of pages. SettingsPage is a placeholder here,
    // its actual instance will be created in didChangeDependencies.
    _pages = [
      HomePage(
        onDoubleTap: widget.onDoubleTap,
        onChangeTheme: widget.onChangeTheme,
        onChangeLocale: widget.onChangeLocale,
      ),
      AboutPage(),
      Container(), // Placeholder for SettingsPage
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // It's safe to use Theme.of(context) here to create SettingsPage
    _pages[2] = SettingsPage(
      isDarkMode: Theme.of(context).brightness == Brightness.dark,
      onThemeChanged: widget.onChangeTheme,
      currentLocale: Localizations.localeOf(context),
      onLocaleChanged: widget.onChangeLocale,
      onLogout: () {
        // This callback is triggered when logout is initiated from SettingsPage.
        // The actual sign-out and navigation to '/' is handled in main.dart.
      },
    );
  }

  // Handles taps on the bottom navigation bar items
  void _onItemTapped(int index) {
    // If the user is a guest and tries to access the 'Settings' tab (index 2)
    // This is a defensive check, as main.dart's routing should prevent guests
    // from even reaching MainScreen if it contains restricted content.
    if (index == 2 && _currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.loginToAccessFeature),
          duration: const Duration(seconds: 2),
        ),
      );
      // Optionally, you could navigate to the login page here:
      // Navigator.pushNamed(context, '/login');
      return; // Prevent navigation to the Settings page
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: AppLocalizations.of(context)!.about),
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

