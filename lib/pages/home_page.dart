//  home_page.dart (Modified)
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        isDark ? const Color(0xFF001D3D) : const Color(0xFFFFC300);

    return GestureDetector(
      onDoubleTap: onDoubleTap,
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
                      Navigator.pushNamed(context, '/level_select');
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
                      Navigator.pushNamed(context, '/leaderboard');
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
