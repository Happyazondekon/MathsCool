// lib/screens/daily_challenge_result_screen.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import '../models/daily_challenge_model.dart';
import '../services/sound_service.dart';
import '../utils/colors.dart';
import 'leaderboard_screen.dart';
import 'dart:math';

class DailyChallengeResultScreen extends StatefulWidget {
  final DailyChallengeResult result;
  const DailyChallengeResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<DailyChallengeResultScreen> createState() => _DailyChallengeResultScreenState();
}

class _DailyChallengeResultScreenState extends State<DailyChallengeResultScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _scoreAnimation = Tween<double>(begin: 0, end: widget.result.score.toDouble()).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();

    if (widget.result.stars >= 2) {
      SoundService().playVictory();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _confettiController.play();
      });
    }

    SoundService().playStars(widget.result.stars);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = widget.result.stars >= 2;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: // Fond avec image MathsCool et superposition
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/bgc_math.png'),
                fit: BoxFit.cover,
                opacity: 0.2, // Opacité légère pour laisser voir les motifs mathématiques
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientStart.withOpacity(0.85),
                  AppColors.gradientMiddle.withOpacity(0.75),
                  AppColors.gradientEnd.withOpacity(0.65),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                ),
                child: const Text(
                  'RÉSULTAT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTrophySection(bool isSuccess) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = 1.0 + (_pulseController.value * 0.1);
                      return Transform.scale(
                        scale: scale,
                        child: Lottie.asset(
                          isSuccess
                              ? 'assets/animations/success.json'
                              : 'assets/animations/encouragement.json',
                          width: 160,
                          height: 160,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isSuccess ? '🎉 FANTASTIQUE ! 🎉' : '💪 BIEN JOUÉ ! 💪',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isSuccess
                    ? 'Tu as brillamment réussi ce défi !'
                    : 'Continue, tu progresses chaque jour !',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideValue = Curves.easeOutCubic.transform(
          const Interval(0.2, 0.7, curve: Curves.easeOut).transform(_animationController.value),
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - slideValue)),
          child: Opacity(
            opacity: slideValue,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'TON SCORE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: _scoreAnimation,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_scoreAnimation.value.toInt()}",
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: 'ComicNeue',
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'PTS',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStarsSection() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideValue = Curves.easeOutCubic.transform(
          const Interval(0.4, 0.9, curve: Curves.easeOut).transform(_animationController.value),
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - slideValue)),
          child: Opacity(
            opacity: slideValue,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'PERFORMANCE',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final isEarned = i < widget.result.stars;
                      final delay = i * 0.15;

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 600 + (i * 150)),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: isEarned ? value : 0.9,
                            child: Transform.rotate(
                              angle: isEarned ? (value * pi * 0.2 - pi * 0.1) : 0,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  gradient: isEarned
                                      ? LinearGradient(
                                    colors: [
                                      AppColors.warning,
                                      AppColors.accent,
                                    ],
                                  )
                                      : null,
                                  color: isEarned ? null : Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                  boxShadow: isEarned
                                      ? [
                                    BoxShadow(
                                      color: AppColors.warning.withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ]
                                      : null,
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 40,
                                  color: isEarned ? Colors.white : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.result.stars}/3 étoiles',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsCards() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideValue = Curves.easeOutCubic.transform(
          const Interval(0.5, 1.0, curve: Curves.easeOut).transform(_animationController.value),
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - slideValue)),
          child: Opacity(
            opacity: slideValue,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.timer_rounded,
                    label: 'Temps',
                    value: '${widget.result.timeSeconds}s',
                    gradient: LinearGradient(
                      colors: [AppColors.info, AppColors.primary],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.grade_rounded,
                    label: 'Score',
                    value: '${widget.result.score}',
                    gradient: LinearGradient(
                      colors: [AppColors.warning, AppColors.accent],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontFamily: 'ComicNeue',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontFamily: 'ComicNeue',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            ),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFD700),
                    const Color(0xFFFFA500),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emoji_events, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'VOIR LE CLASSEMENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      fontFamily: 'ComicNeue',
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              ),
              child: const Center(
                child: Text(
                  'RETOUR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'ComicNeue',
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter pour les éléments flottants
class _FloatingElementsPainter extends CustomPainter {
  final double animationValue;

  _FloatingElementsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final random = Random(42);

    // Étoiles scintillantes
    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final phase = (animationValue + i * 0.1) % 1.0;
      final opacity = (sin(phase * 2 * pi) * 0.5 + 0.5) * 0.25;

      paint.color = Colors.white.withOpacity(opacity);

      final starSize = random.nextDouble() * 6 + 3;
      _drawStar(canvas, Offset(x, y), starSize, paint);
    }

    // Cercles flottants
    for (int i = 0; i < 15; i++) {
      final x = (random.nextDouble() * size.width + animationValue * 30) % size.width;
      final y = (random.nextDouble() * size.height + animationValue * 50) % size.height;
      final circleSize = random.nextDouble() * 20 + 10;

      paint.color = Colors.white.withOpacity(0.1);
      canvas.drawCircle(Offset(x, y), circleSize, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const points = 5;
    const angle = (2 * pi) / points;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? size : size * 0.5;
      final x = center.dx + r * cos(i * angle / 2 - pi / 2);
      final y = center.dy + r * sin(i * angle / 2 - pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FloatingElementsPainter oldDelegate) => true;
}