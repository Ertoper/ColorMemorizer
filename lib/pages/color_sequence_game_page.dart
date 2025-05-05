import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ColorSequenceGamePage extends StatefulWidget {
  final int level;

  const ColorSequenceGamePage({Key? key, required this.level})
    : super(key: key);

  @override
  _ColorSequenceGamePageState createState() => _ColorSequenceGamePageState();
}

class _ColorSequenceGamePageState extends State<ColorSequenceGamePage> {
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
  final int _totalRounds = 3; // Define the total number of rounds

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
    await Future.delayed(const Duration(milliseconds: 500)); // Initial delay

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
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      } else {
        message = AppLocalizations.of(context)!.gameOver;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  Widget _buildColorButton(Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _handleColorTap(color),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const CircleBorder(),
          ),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.level} ${widget.level}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/dark-background.png'
                  : 'assets/light-background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      playerSequence.map((color) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 50),
                if (isPlayerTurn)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      (availableColors.length / 2).ceil(),
                      (rowIndex) {
                        final start = rowIndex * 2;
                        final end = (start + 2).clamp(
                          0,
                          availableColors.length,
                        );
                        final rowColors = availableColors.sublist(start, end);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: rowColors.map(_buildColorButton).toList(),
                        );
                      },
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
