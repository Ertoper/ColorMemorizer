import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/settings_page.dart';

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

  @override
  void initState() {
    super.initState();
    //  Initialize the list here, but without Theme.of(context)
    _pages = [
      HomePage(
        onDoubleTap: widget.onDoubleTap,
        onChangeTheme: widget.onChangeTheme,
        onChangeLocale: widget.onChangeLocale,
      ),
      AboutPage(),
      Container(), //  Placeholder - will be replaced in didChangeDependencies
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //  Now it's safe to use Theme.of(context)
    _pages[2] = SettingsPage(
      isDarkMode: Theme.of(context).brightness == Brightness.dark,
      onThemeChanged: widget.onChangeTheme,
      currentLocale: Localizations.localeOf(context),
      onLocaleChanged: widget.onChangeLocale,
      onLogout: () {},
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
