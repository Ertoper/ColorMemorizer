import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class ColorSequenceGamePage extends StatefulWidget {
  final int level;

  const ColorSequenceGamePage({Key? key, required this.level})
    : super(key: key);

  @override
  _ColorSequenceGamePageState createState() => _ColorSequenceGamePageState();
}

class _ColorSequenceGamePageState extends State<ColorSequenceGamePage> {
  final List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  List<Color> sequence = [];
  List<Color> playerSequence = [];

  int sequenceLength = 3;
  bool isPlayerTurn = false;
  bool isShowingSequence = true;
  String message = "";

  bool _initialized = false;

  int _roundsCompleted = 0;
  final int _totalRounds = 3;
  int _playerScore = 0;

  final Random _random = Random();

  Timer? _sequenceTimer;
  Timer? _levelTimer;

  int _sequenceIndex = 0;
  int _levelTimeLeft = 0;

  final List<int> _roundTimers = [10, 8, 6];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initGame();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _sequenceTimer?.cancel();
    _levelTimer?.cancel();
    super.dispose();
  }

  void _initGame() {
    sequenceLength = 3 + (widget.level ~/ 10);
    sequence.clear();
    playerSequence.clear();

    _playerScore = 0;
    _roundsCompleted = 0;
    _sequenceIndex = 0;

    message = "";
    isPlayerTurn = false;
    isShowingSequence = true;

    _generateSequence();
  }

  void _startLevelTimer() {
    _levelTimer?.cancel();

    _levelTimeLeft =
        _roundsCompleted < _roundTimers.length
            ? _roundTimers[_roundsCompleted]
            : _roundTimers.last;

    _levelTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_levelTimeLeft <= 0) {
        timer.cancel();
        _gameOver();
      } else {
        setState(() => _levelTimeLeft--);
      }
    });
  }

  void _generateSequence() {
    sequence.clear();
    for (int i = 0; i < sequenceLength; i++) {
      sequence.add(availableColors[_random.nextInt(availableColors.length)]);
    }
    if (mounted) {
      setState(() {
        isShowingSequence = true;
        _sequenceIndex = 0;
        isPlayerTurn = false;
        message = "";
      });
    }
    _startSequenceTimer();
  }

  void _startSequenceTimer() {
    _sequenceTimer?.cancel();
    _sequenceIndex = 0;

    _sequenceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sequenceIndex < sequence.length) {
        if (mounted) setState(() => _sequenceIndex++);
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            isShowingSequence = false;
            isPlayerTurn = true;
            message = AppLocalizations.of(context)!.yourTurn;
            playerSequence.clear();
          });
          _startLevelTimer();
        }
      }
    });
  }

  void _handleColorTap(Color color) {
    if (!isPlayerTurn || playerSequence.length >= sequence.length) return;

    setState(() => playerSequence.add(color));
    _checkSequence();
  }

  void _checkSequence() {
    if (playerSequence.last != sequence[playerSequence.length - 1]) {
      _levelTimer?.cancel();
      _gameOver();
      return;
    }

    if (playerSequence.length == sequence.length) {
      _levelTimer?.cancel();

      _playerScore += sequence.length * 10;
      setState(() => message = AppLocalizations.of(context)!.correctSequence);

      _roundsCompleted++;

      if (_roundsCompleted < _totalRounds) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _generateSequence();
        });
      } else {
        _gameWon();
      }
    }
  }

  void _gameOver() {
    _updateUserScore(_playerScore);
    setState(() {
      message = AppLocalizations.of(context)!.gameOver;
      isPlayerTurn = false;
      isShowingSequence = false;
    });
    _showGameOverDialog();
  }

  void _gameWon() {
    _updateUserScore(_playerScore);
    setState(() {
      message = AppLocalizations.of(context)!.youWin;
      isPlayerTurn = false;
      isShowingSequence = false;
    });
    _showGameOverDialog();
  }

  Future<void> _updateUserScore(int points) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final gameDataBox = Hive.box<Map>('gameData');

      try {
        Map? localGameData = gameDataBox.get(uid);
        int currentScore = localGameData?['score'] ?? 0;
        int newScore = currentScore + points;

        await gameDataBox.put(uid, {'score': newScore});
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'score': newScore,
        });
      } catch (e) {
        print('Error updating score: $e');
      }
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(message, style: const TextStyle(color: Colors.white)),
          content: Text(
            "${AppLocalizations.of(context)!.yourScore}: $_playerScore",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initGame();
              },
              child: Text(
                AppLocalizations.of(context)!.playAgain,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.backToLevels,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () => _handleColorTap(color),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border:
              isPlayerTurn ? Border.all(color: Colors.white, width: 2) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gameTitle),
        backgroundColor: Colors.black87,
      ),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  '${AppLocalizations.of(context)!.timeLeft}: $_levelTimeLeft',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(sequence.length, (index) {
                    Color displayColor = Colors.grey;
                    if (isShowingSequence && index < _sequenceIndex) {
                      displayColor = sequence[index];
                    } else if (!isShowingSequence &&
                        index < playerSequence.length) {
                      displayColor = playerSequence[index];
                    }
                    return Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: displayColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 50),
                if (isPlayerTurn)
                  Column(
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
                const SizedBox(height: 20),
                Text(
                  '${AppLocalizations.of(context)!.yourScore}: $_playerScore',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
