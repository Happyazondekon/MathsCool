import 'package:flutter/material.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/screens/level_selection.dart';
import 'package:mathscool/screens/profile_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;
  String? _avatarPath;
  static const String _avatarPrefsKey = 'user_avatar_path';

  @override
  void initState() {
    super.initState();

    // Animation pour un effet subtil sur le fond
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Chargement de l'avatar depuis les SharedPreferences
    _loadSavedAvatar();
  }

  Future<void> _loadSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAvatar = prefs.getString(_avatarPrefsKey);

    if (savedAvatar != null && mounted) {
      setState(() {
        _avatarPath = savedAvatar;
      });
    }
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser;

    // Récupération du nom d'utilisateur
    final displayName = currentUser?.displayName ?? 'MathKid';
    // Récupération de l'URL de la photo utilisateur
    final photoURL = currentUser?.photoURL;

    return Scaffold(
      body: Stack(
        children: [
          // Fond avec dégradé de Noël
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xDBA30E0E), // Bleu nuit de Noël
                      Color(0xDBD12C2C),
                      Color(0xDBD15959),
                      Color(0xFFE8F4F8), // Blanc neigeux
                    ],
                    stops: [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
                child: CustomPaint(
                  painter: _ChristmasMathBackgroundPainter(animationValue: _backgroundAnimation.value),
                  size: Size(size.width, size.height),
                ),
              );
            },
          ),

          // Éléments décoratifs de Noël
          if (size.height > 600) ...[
            // Flocons de neige animés
            ...List.generate(8, (index) => _buildSnowflake(size, index)),

            // Étoiles scintillantes
            Positioned(
              top: 80,
              left: 40,
              child: _buildTwinklingStar(30, delay: 0),
            ),
            Positioned(
              top: 120,
              right: 60,
              child: _buildTwinklingStar(25, delay: 500),
            ),
            Positioned(
              bottom: 200,
              left: 30,
              child: _buildTwinklingStar(20, delay: 1000),
            ),

            // Cadeaux décoratifs
            Positioned(
              bottom: 100,
              left: -10,
              child: _buildGiftBox(50, Colors.red),
            ),
            Positioned(
              bottom: 120,
              right: -10,
              child: _buildGiftBox(45, Colors.green),
            ),
          ],

          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: [
                    // En-tête avec thème de Noël
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo avec décoration de Noël
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AnimatedScale(
                                scale: 1.1,
                                duration: const Duration(seconds: 2),
                                curve: Curves.elasticOut,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: size.width < 350 ? 24 : 26,
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
                                              color: Colors.red.withOpacity(0.5),
                                              blurRadius: 15,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Cool',
                                        style: TextStyle(
                                          color: Color(0xFFFFD700), // Or
                                          fontStyle: FontStyle.italic,
                                          shadows: [
                                            Shadow(
                                              color: Colors.red.withOpacity(0.5),
                                              blurRadius: 15,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Petit bonnet de Noël sur le logo
                              Positioned(
                                top: -15,
                                right: -5,
                                child: Text(
                                  '🎅',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              // Bouton notifications avec thème de Noël
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationSettingsScreen(
                                      userName: displayName,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red.withOpacity(0.8),
                                        Colors.green.withOpacity(0.8),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.yellow.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),

                              // Avatar avec bordure festive
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                ).then((_) => _loadSavedAvatar()),
                                child: AnimatedScale(
                                  scale: _isPressed ? 0.9 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red,
                                          Colors.green,
                                          Color(0xFFFFD700),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Color.alphaBlend(
                                          AppColors.christ.withOpacity(0.1),
                                          Colors.white,
                                        ),
                                        backgroundImage: _getProfileImage(photoURL),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Message de bienvenue festif
                    AnimatedSlide(
                      offset: const Offset(0, -0.2),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🎄 Joyeux Noël $displayName! 🎅',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ComicNeue',
                            shadows: [
                              Shadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Contenu principal
                    SizedBox(
                      height: size.height * 0.6,
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

                          // Bouton principal avec thème de Noël
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
                                  width: size.width * 0.75,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFDC143C), // Rouge Noël
                                        Color(0xFF228B22), // Vert sapin
                                        Color(0xFFFFD700), // Or
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFFFD700).withOpacity(0.5),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '🎁',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Déballer les maths !',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'ComicNeue',
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 5,
                                              ),
                                            ],
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

                    // Espacement en bas pour le scroll
                    SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Flocon de neige animé
  Widget _buildSnowflake(Size screenSize, int index) {
    final random = Random(index);
    final left = random.nextDouble() * screenSize.width;
    final animationDelay = random.nextInt(3000);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -50.0, end: screenSize.height + 50),
      duration: Duration(seconds: 8 + random.nextInt(4)),
      builder: (context, value, child) {
        return Positioned(
          left: left + sin(value / 50) * 30,
          top: value,
          child: Text(
            ['❄️', '❅', '❆'][random.nextInt(3)],
            style: TextStyle(
              fontSize: 20 + random.nextDouble() * 15,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  // Étoile scintillante
  Widget _buildTwinklingStar(double size, {required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            '⭐',
            style: TextStyle(fontSize: size),
          ),
        );
      },
      onEnd: () {
        if (mounted) {
          Future.delayed(Duration(milliseconds: delay), () {
            if (mounted) setState(() {});
          });
        }
      },
    );
  }

  // Cadeau décoratif
  Widget _buildGiftBox(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ruban vertical
          Center(
            child: Container(
              width: size * 0.2,
              height: size,
              color: Color(0xFFFFD700),
            ),
          ),
          // Ruban horizontal
          Center(
            child: Container(
              width: size,
              height: size * 0.2,
              color: Color(0xDBD15959),
            ),
          ),
          // Nœud
          Positioned(
            top: size * 0.3,
            left: size * 0.3,
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: BoxDecoration(
                color: Color(0xFFFFD700),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour déterminer quelle image de profil afficher
  ImageProvider _getProfileImage(String? photoURL) {
    if (_avatarPath != null) {
      if (_avatarPath!.startsWith('assets/')) {
        return AssetImage(_avatarPath!);
      }
      return NetworkImage(_avatarPath!);
    }
    else if (photoURL != null) {
      if (photoURL.startsWith('assets/')) {
        return AssetImage(photoURL);
      }
      return NetworkImage(photoURL);
    }
    return const AssetImage('assets/avatars/avatar1.png');
  }
}

// Painter pour le fond mathématique de Noël
class _ChristmasMathBackgroundPainter extends CustomPainter {
  final double animationValue;

  _ChristmasMathBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final seedValue = 42;
    final random = Random(seedValue);

    // Symboles mathématiques avec couleurs de Noël
    final colors = [
      Colors.red.withOpacity(0.1),
      Colors.green.withOpacity(0.1),
      Colors.white.withOpacity(0.08),
      Color(0xFFFFD700).withOpacity(0.1),
    ];

    for (int i = 0; i < 30; i++) {
      paint.color = colors[i % colors.length];

      final x = random.nextDouble() * size.width + sin(animationValue + i * 0.5) * 30;
      final y = random.nextDouble() * size.height + cos(animationValue + i * 0.5) * 30;
      final radius = (random.nextDouble() * 20 + 10) * (0.8 + 0.2 * sin(animationValue * 0.5));

      if (i % 4 == 0) {
        // Dessiner des étoiles
        _drawStar(canvas, Offset(x, y), radius, paint);
      } else if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else {
        final symbols = ['+', '-', '×', '÷', '=', '🎄', '⭐', '❄️'];
        final textPainter = TextPainter(
          text: TextSpan(
            text: symbols[random.nextInt(symbols.length)],
            style: TextStyle(
              color: colors[i % colors.length],
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

  // Dessiner une étoile
  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final points = 5;
    final angle = (2 * pi) / points;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * 0.5;
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
  bool shouldRepaint(covariant _ChristmasMathBackgroundPainter oldDelegate) => true;
}