import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:color_memorizer/l10n/app_localizations.dart';

class ColorSequenceGamePage extends StatefulWidget {
  final int level;
  const ColorSequenceGamePage({Key? key, required this.level}) : super(key: key);

  @override
  _ColorSequenceGamePageState createState() => _ColorSequenceGamePageState();
}

class _ColorSequenceGamePageState extends State<ColorSequenceGamePage>
    with SingleTickerProviderStateMixin {
  List<Color> sequence = [];
  List<Color> playerSequence = [];
  List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  int sequenceLength = 3;
  bool isPlayerTurn = false;
  bool isShowingSequence = true;
  String message = "";
  bool _initialized = false;
  int _roundsCompleted = 0;
  final int _totalRounds = 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _startGame();
    }
  }

  int _calculateSequenceLength(int level) {
    if (level <= 5) return 3;
    if (level <= 10) return 4;
    if (level <= 15) return 5;
    if (level <= 20) return 6;
    return 7;
  }

  int _calculateColorOptions(int level) {
    if (level <= 5) return 4;
    if (level <= 10) return 5;
    return 6;
  }

  void _startGame() {
    sequenceLength = _calculateSequenceLength(widget.level);
    int colorOptionsCount = _calculateColorOptions(widget.level);
    availableColors = availableColors.sublist(0, colorOptionsCount);

    sequence.clear();
    playerSequence.clear();
    isPlayerTurn = false;
    isShowingSequence = true;
    message = AppLocalizations.of(context)!.watchSequence;
    _roundsCompleted = 0;

    for (int i = 0; i < sequenceLength; i++) {
      sequence.add(availableColors[Random().nextInt(availableColors.length)]);
    }

    _showSequence();
  }

  Future<void> _showSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < sequence.length; i++) {
      if (!mounted) return;
      setState(() {
        message = AppLocalizations.of(context)!.watchSequence;
      });

      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() {
        playerSequence.add(sequence[i]);
      });

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        playerSequence.clear();
      });

      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
    }

    if (!mounted) return;
    setState(() {
      isPlayerTurn = true;
      isShowingSequence = false;
      playerSequence.clear();
      message = AppLocalizations.of(context)!.yourTurn;
    });
  }

  void _handleColorTap(Color color) {
    if (!isPlayerTurn) return;

    setState(() {
      playerSequence.add(color);
    });

    if (playerSequence.length > sequence.length) {
      _endRound(false);
      return;
    }

    for (int i = 0; i < playerSequence.length; i++) {
      if (playerSequence[i] != sequence[i]) {
        _endRound(false);
        return;
      }
    }

    if (playerSequence.length == sequence.length) {
      _endRound(true);
    }
  }

  void _endRound(bool success) {
    if (!mounted) return;
    setState(() {
      isPlayerTurn = false;
      if (success) {
        _roundsCompleted++;
        if (_roundsCompleted < _totalRounds) {
          message = AppLocalizations.of(context)!.correctNextRound;
          if (sequence.length < 5) {
            sequence.add(
              availableColors[Random().nextInt(availableColors.length)],
            );
          }
          playerSequence.clear();
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _showSequence();
            }
          });
        } else {
          message = AppLocalizations.of(context)!.victory;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      } else {
        message = AppLocalizations.of(context)!.gameOver;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  Widget _buildColorButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _handleColorTap(color),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.level} ${widget.level}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                isDark ? 'assets/dark-background.png' : 'assets/light-background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 2, color: Colors.black)]
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: playerSequence
                      .map((color) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 40),
                if (isPlayerTurn)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: availableColors.map(_buildColorButton).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
