// lib/screens/daily_challenge_result_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import '../models/daily_challenge_model.dart';
import 'leaderboard_screen.dart';

class DailyChallengeResultScreen extends StatefulWidget {
  final DailyChallengeResult result;

  const DailyChallengeResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<DailyChallengeResultScreen> createState() => _DailyChallengeResultScreenState();
}

class _DailyChallengeResultScreenState extends State<DailyChallengeResultScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    if (widget.result.stars >= 2) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getPerformanceMessage() {
    final percentage = (widget.result.score / 10) * 100;
    if (percentage >= 90) return "Incroyable ! Tu es un génie ! 🏆";
    if (percentage >= 70) return "Super travail ! Continue comme ça ! ⭐";
    if (percentage >= 50) return "Pas mal ! Tu progresses ! 💪";
    return "Continue à t'entraîner ! 📚";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F), Colors.red],
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Animation Lottie
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Lottie.asset(
                          widget.result.stars >= 2
                              ? 'assets/animations/success.json'
                              : 'assets/animations/encouragement.json',
                          height: 200,
                          repeat: false,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Carte de résultat
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Défi terminé ! 🎉',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD32F2F),
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _getPerformanceMessage(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontFamily: 'ComicNeue',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),

                            // Score
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatCard(
                                  '${widget.result.score}/10',
                                  'Score',
                                  Icons.check_circle,
                                  Colors.green,
                                ),
                                _buildStatCard(
                                  '${widget.result.timeSeconds}s',
                                  'Temps',
                                  Icons.timer,
                                  Colors.blue,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Étoiles
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    index < widget.result.stars
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.orange,
                                    size: 50,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Boutons d'action
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                          );
                        },
                        icon: const Icon(Icons.leaderboard, size: 24),
                        label: const Text(
                          'Voir le classement 🏆',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Retour à l\'accueil'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Confettis
              if (widget.result.stars >= 2)
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 30,
                    gravity: 0.1,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}