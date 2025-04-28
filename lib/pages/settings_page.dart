import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _selectedLocale = widget.currentLocale;
  }

  void _onThemeSwitchChanged(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.onThemeChanged(value);
  }

  void _onLocaleChanged(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    widget.onLocaleChanged(locale);
  }

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
            child: Padding(
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
                  ),
                  SwitchListTile(
                    title: Text(
                      AppLocalizations.of(context)!.darkMode,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: _isDarkMode,
                    onChanged: _onThemeSwitchChanged,
                    activeColor: const Color(
                      0xFFFFC300,
                    ), //  Customize switch color
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<Locale>(
                    value: _selectedLocale,
                    dropdownColor:
                        isDark
                            ? Colors.grey[900]
                            : Colors.white, //  Customize dropdown background
                    style: TextStyle(color: Colors.white),
                    items: [
                      DropdownMenuItem(
                        value: const Locale('en'),
                        child: Text(
                          AppLocalizations.of(context)!.english,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: const Locale('ru'),
                        child: Text(
                          AppLocalizations.of(context)!.russian,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: const Locale('kk'),
                        child: Text(
                          AppLocalizations.of(context)!.kazakh,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    onChanged: (locale) {
                      if (locale != null) _onLocaleChanged(locale);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
