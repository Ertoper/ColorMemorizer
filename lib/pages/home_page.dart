import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:color_memorizer/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onDoubleTap;
  final ValueChanged<bool> onChangeTheme;
  final ValueChanged<Locale> onChangeLocale;

  const HomePage({
    Key? key,
    required this.onDoubleTap,
    required this.onChangeTheme,
    required this.onChangeLocale,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isOffline = false;
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    // Инициализируем текущее состояние
    _initConnectivity();
    // Слушаем изменения
    _connectivityStream.listen((result) {
      setState(() {
        _isOffline = (result == ConnectivityResult.none);
      });
    });
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _isOffline = (result == ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDark ? const Color(0xFF001D3D) : const Color(0xFFFFC300);

    return GestureDetector(
      onDoubleTap: widget.onDoubleTap,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                isDark ? 'assets/dark-background.png' : 'assets/light-background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),
            if (_isOffline)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    AppLocalizations.of(context)!.noInternetMessage,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                        TextSpan(text: 'C', style: TextStyle(color: Colors.red)),
                        TextSpan(text: 'o', style: TextStyle(color: Colors.green)),
                        TextSpan(text: 'l', style: TextStyle(color: Colors.blue)),
                        TextSpan(text: 'o', style: TextStyle(color: Colors.yellow)),
                        TextSpan(text: 'r', style: TextStyle(color: Colors.purple)),
                        TextSpan(text: 'Memorizer', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _isOffline
                        ? null
                        : () {
                            Navigator.pushNamed(context, '/level_select');
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOffline ? Colors.grey : buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.playButton,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isOffline ? Colors.black38 : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/endless_color_sequence_game_page');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.endlessButton,
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
