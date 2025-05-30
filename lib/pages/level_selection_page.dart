import 'package:flutter/material.dart';
import 'package:color_memorizer/l10n/app_localizations.dart';
import 'color_sequence_game_page.dart'; //  Import the new page

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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ColorSequenceGamePage(
                                      level: levelNumber,
                                    ),
                              ),
                            );
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
