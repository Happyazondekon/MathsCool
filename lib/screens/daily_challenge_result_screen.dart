// lib/screens/daily_challenge_result_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import '../models/daily_challenge_model.dart';
import '../services/sound_service.dart';
import 'leaderboard_screen.dart';
import 'dart:math';

class DailyChallengeResultScreen extends StatefulWidget {
  final DailyChallengeResult result;
  const DailyChallengeResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<DailyChallengeResultScreen> createState() => _DailyChallengeResultScreenState();
}

class _DailyChallengeResultScreenState extends State<DailyChallengeResultScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scoreAnimation = Tween<double>(begin: 0, end: widget.result.score.toDouble()).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
    );

    _animationController.forward();
    if (widget.result.stars >= 2) {
      Future.delayed(const Duration(milliseconds: 800), () => _confettiController.play());
    }
    // ✅ JOUER LE SON DE VICTOIRE
    if (widget.result.stars >= 2) {
      SoundService().playVictory();
      Future.delayed(const Duration(milliseconds: 800), () {
        _confettiController.play();
      });
    }

    // ✅ JOUER LE SON D'ÉTOILES
    SoundService().playStars(widget.result.stars);

  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FOND IDENTIQUE AU DAILY CHALLENGE SCREEN
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F), Colors.red],
              ),
            ),
          ),

          // SYMBOLES MATHÉMATIQUES FLOTTANTS (Même logique que DailyChallengeScreen)
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _MathBackgroundPainter(),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildGlassCard(),
                    ),
                  ),
                ),
                _buildActionButtons(),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Confettis
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 50,
              colors: const [Colors.white, Colors.yellow, Colors.pink, Colors.blue, Colors.orange],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        "DÉFI TERMINÉ",
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
        ),
      ),
    );
  }

  Widget _buildGlassCard() {
    final bool isSuccess = widget.result.stars >= 2;
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                isSuccess ? 'assets/animations/success.json' : 'assets/animations/encouragement.json',
                height: 150,
              ),
              const SizedBox(height: 20),

              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return Text(
                    "${_scoreAnimation.value.toInt()}",
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                    ),
                  );
                },
              ),
              const Text(
                "Points gagnés",
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'ComicNeue'),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Icon(
                  Icons.star_rounded,
                  size: 50,
                  color: i < widget.result.stars ? Colors.amber : Colors.white24,
                )),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniStat(Icons.timer_rounded, "${widget.result.timeSeconds}s", "Temps"),
                  _buildMiniStat(Icons.star_border_rounded, "${widget.result.stars}/3", "Étoiles"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'ComicNeue')),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12, fontFamily: 'ComicNeue')),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // BOUTON DORÉ
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Gold to Orange-Gold
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "CLASSEMENTS 🏅",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'ComicNeue',
                    shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // BOUTON RETOUR
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: const Center(
                child: Text(
                  "RETOUR",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'ComicNeue'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Background Painter identique au DailyChallengeScreen
class _MathBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final mathSymbols = ['+', '-', '×', '÷', '=', '%', '√', 'x', 'y', 'π'];
    final random = Random(42); // Seed fixe pour la stabilité visuelle

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final symbolSize = random.nextDouble() * 30 + 10;

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), symbolSize / 2, paint);
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
            text: i % 3 == 1 ? '${random.nextInt(10)}' : mathSymbols[random.nextInt(mathSymbols.length)],
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: symbolSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}