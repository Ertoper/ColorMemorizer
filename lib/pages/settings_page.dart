import 'package:color_memorizer/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onLogout;

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onLogout,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;
  late Locale _selectedLocale;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _selectedLocale = widget.currentLocale;
  }

  void _onThemeSwitchChanged(bool value) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthService().updateUserPreferences(
        uid: user.uid,
        theme: value ? 'dark' : 'light',
      );
    }
    widget.onThemeChanged(value);
  }

  void _onLocaleChanged(Locale locale) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthService().updateUserPreferences(
        uid: user.uid,
        language: locale.languageCode,
      );
    }
    widget.onLocaleChanged(locale);
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.logoutConfirmTitle),
            content: Text(AppLocalizations.of(context)!.logoutConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancelButton),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  widget.onLogout();
                },
                child: Text(
                  AppLocalizations.of(context)!.logoutButton,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        isDark ? const Color(0xFF001D3D) : const Color(0xFFFFC300);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    title: Text(
                      AppLocalizations.of(context)!.settingsTitle,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                  ),
                  if (_currentUser != null) ...[
                    Card(
                      color: Colors.black.withOpacity(0.5),
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title: Text(
                          _currentUser!.email ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.accountTitle,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Card(
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text(
                            AppLocalizations.of(context)!.darkMode,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              _isDarkMode = value;
                            });
                            _onThemeSwitchChanged(value);
                          },
                          activeColor: const Color(0xFFFFC300),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.language,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: DropdownButton<Locale>(
                            value: _selectedLocale,
                            dropdownColor:
                                isDark ? Colors.grey[900] : Colors.white,
                            underline: Container(),
                            items: [
                              DropdownMenuItem(
                                value: const Locale('en'),
                                child: Text(
                                  AppLocalizations.of(context)!.english,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: const Locale('ru'),
                                child: Text(
                                  AppLocalizations.of(context)!.russian,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: const Locale('kk'),
                                child: Text(
                                  AppLocalizations.of(context)!.kazakh,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                            onChanged: (locale) {
                              if (locale != null) _onLocaleChanged(locale);
                            },
                          ),
                        ),
                      ],
                    ),
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
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
}
