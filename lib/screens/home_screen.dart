import 'package:flutter/material.dart';
import 'package:mathscool/screens/level_selection.dart';
import 'package:mathscool/screens/profile_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String selectedAvatar = 'assets/avatars/avatar1.png';
  bool _isPressed = false;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _loadSelectedAvatar();

    // Animation pour un effet subtil sur le fond
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadSelectedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar = prefs.getString('selectedAvatar') ?? 'assets/avatars/avatar1.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fond avec dégradé amélioré
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      Color.lerp(AppColors.primary, Colors.white, 0.3)!,
                      Color.lerp(AppColors.primary, Colors.white, 0.6)!,
                      Colors.white,
                    ],
                    stops: [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
                child: CustomPaint(
                  painter: _MathBackgroundPainter(animation: _backgroundAnimation.value),
                  size: Size(size.width, size.height),
                ),
              );
            },
          ),

          // Éléments décoratifs
          Positioned(
            top: 100,
            left: -30,
            child: _buildFloatingShape(Icons.calculate, 80),
          ),
          Positioned(
            bottom: 150,
            right: -20,
            child: _buildFloatingShape(Icons.star, 60),
          ),

          SafeArea(
            child: Column(
              children: [
                // En-tête
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedScale(
                        scale: 1.1,
                        duration: const Duration(seconds: 2),
                        curve: Curves.elasticOut,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ComicNeue',
                            ),
                            children: [
                              TextSpan(
                                text: 'Maths',
                                style: TextStyle(
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: 'Cool',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontStyle: FontStyle.italic,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Avatar
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        ).then((_) => _loadSelectedAvatar()),
                        child: AnimatedScale(
                          scale: _isPressed ? 0.9 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Color.alphaBlend(
                                AppColors.primary.withOpacity(0.1),
                                Colors.white,
                              ),
                              child: Image.asset(selectedAvatar),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Message de bienvenue
                AnimatedSlide(
                  offset: const Offset(0, -0.2),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'Bonjour MathKid 👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'ComicNeue',
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Contenu principal
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lottie Animation
                      Positioned(
                        top: size.height * 0.05,
                        child: Lottie.asset(
                          'assets/animations/home.json',
                          width: size.width * 0.8,
                          height: size.height * 0.4,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Bouton principal
                      Positioned(
                        bottom: size.height * 0.1,
                        child: AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(seconds: 3),
                          curve: Curves.elasticOut,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LevelSelectionScreen()),
                            ),
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              width: size.width * 0.7,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.secondary, AppColors.primary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_circle_filled,
                                        color: Colors.white, size: 30),
                                    SizedBox(width: 10),
                                    Text(
                                      'Commencer à apprendre',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'ComicNeue',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingShape(IconData icon, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          AppColors.accent.withOpacity(0.2),
          Colors.white,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
          size: size * 0.5,
        ),
      ),
    );
  }
}

class _MathBackgroundPainter extends CustomPainter {
  final double animation;

  _MathBackgroundPainter({this.animation = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final seedValue = 42; // Valeur fixe pour un motif cohérent
    final random = Random(seedValue);

    for (int i = 0; i < 30; i++) {
      // Utilisation de l'animation pour un léger mouvement des éléments
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      // Animation subtile des éléments
      final x = baseX + sin(animation * i * 0.1) * 5;
      final y = baseY + cos(animation * i * 0.1) * 5;

      final radius = (random.nextDouble() * 20 + 10) * animation;

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
            text: ['+', '-', '×', '÷', '='][random.nextInt(5)],
            style: TextStyle(
              color: Colors.white.withOpacity(0.08),
              fontSize: radius * 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - radius, y - radius));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MathBackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation;
}