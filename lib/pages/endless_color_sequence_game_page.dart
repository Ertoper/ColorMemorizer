import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_memorizer/l10n/app_localizations.dart';

class EndlessColorSequenceGamePage extends StatefulWidget {
  const EndlessColorSequenceGamePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EndlessColorSequenceGamePageState createState() =>
      _EndlessColorSequenceGamePageState();
}

class _EndlessColorSequenceGamePageState
    extends State<EndlessColorSequenceGamePage> {
  final List<Color> allColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  List<Color> availableColors = [];
  List<Color> sequence = [];
  List<Color> playerSequence = [];

  int level = 1;
  int highestScore = 0;
  bool isPlayerTurn = false;
  bool isShowingSequence = false;
  String message = "";
  Color? highlightedColor;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _loadHighestScore();
    _startLevel();
  }

  Future<void> _loadHighestScore() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc =
          await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      setState(() {
        highestScore = data?['highestScore'] ?? 0;
      });
    }
  }

  Future<void> _updateHighestScore() async {
    final user = _auth.currentUser;
    if (user != null && level > highestScore) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'highestScore': level});
      setState(() {
        highestScore = level;
      });
    }
  }

  void _startLevel() {
    setState(() {
      availableColors =
          allColors.sublist(0, min(4 + level ~/ 3, allColors.length));
      sequence = List.generate(
          3 + level ~/ 2,
          (_) => availableColors[
              Random().nextInt(availableColors.length)]);
      playerSequence.clear();
      isPlayerTurn = false;
      isShowingSequence = true;
      message = AppLocalizations.of(context)!.watchSequence;
    });
    _showSequence();
  }

  Future<void> _showSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (var color in sequence) {
      if (!mounted) return;
      setState(() {
        highlightedColor = color;
      });
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() {
        highlightedColor = null;
      });
      await Future.delayed(const Duration(milliseconds: 200));
    }
    if (!mounted) return;
    setState(() {
      isPlayerTurn = true;
      message = AppLocalizations.of(context)!.yourTurn;
    });
  }

  void _handleColorTap(Color color) async {
    if (!isPlayerTurn) return;

    setState(() {
      highlightedColor = color;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() {
      highlightedColor = null;
      playerSequence.add(color);
    });

    final index = playerSequence.length - 1;
    if (playerSequence[index] != sequence[index]) {
      _endGame();
      return;
    }
    if (playerSequence.length == sequence.length) {
      setState(() {
        level++;
        message = AppLocalizations.of(context)!.correctNextLevel;
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _startLevel();
      });
    }
  }

  void _endGame() {
    setState(() {
      isPlayerTurn = false;
      message = AppLocalizations.of(context)!
          .gameOverLevel(level.toString());
    });
    _updateHighestScore();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  Widget _buildColorButton(Color color) {
    final isHighlighted = color == highlightedColor;

    return GestureDetector(
      onTap: () => _handleColorTap(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isHighlighted ? 90 : 80,
        height: isHighlighted ? 90 : 80,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isHighlighted
                  ? Colors.white.withOpacity(0.8)
                  : color.withOpacity(0.6),
              blurRadius: isHighlighted ? 25 : 15,
              spreadRadius: isHighlighted ? 8 : 5,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.level}: $level | ${AppLocalizations.of(context)!.record}: $highestScore"),
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
                isDark
                    ? 'assets/dark-background.png'
                    : 'assets/light-background.png',
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
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
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
