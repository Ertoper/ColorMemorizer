import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> players = [];
  String currentUserEmail = '...';
  int yourScore = 0;
  int yourPlace = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .orderBy('score', descending: true)
              .get();

      players =
          querySnapshot.docs.map((doc) {
            return {
              'email': doc['email'],
              'score': doc['score'] ?? 0,
              'uid': doc.id,
            };
          }).toList();

      if (FirebaseAuth.instance.currentUser != null) {
        currentUserEmail = FirebaseAuth.instance.currentUser!.email ?? 'You';
        for (int i = 0; i < players.length; i++) {
          if (players[i]['uid'] == FirebaseAuth.instance.currentUser!.uid) {
            yourScore = players[i]['score'];
            yourPlace = i + 1;
            break;
          }
        }
      } else {
        currentUserEmail = 'Guest';
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  child:
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : players.isEmpty
                          ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.noPlayers,
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
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
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    title: Text(
                                      player['email'],
                                      style: TextStyle(
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    trailing: Text(
                                      '${player['score']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black,
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
