import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
