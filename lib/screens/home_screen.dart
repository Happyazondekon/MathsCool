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
                  painter: _MathBackgroundPainter(animationValue: _backgroundAnimation.value),
                  size: Size(size.width, size.height),
                ),
              );
            },
          ),

          // Éléments décoratifs
          if (size.height > 600) ...[
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
          ],

          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: [
                    // En-tête
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                          // Avatar avec gestion de l'image
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfileScreen()),
                            ).then((_) => _loadSavedAvatar()),
                            child: AnimatedScale(
                              scale: _isPressed ? 0.9 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                padding: const EdgeInsets.all(6),
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
                                  radius: 20,
                                  backgroundColor: Color.alphaBlend(
                                    AppColors.primary.withOpacity(0.1),
                                    Colors.white,
                                  ),
                                  backgroundImage: _getProfileImage(photoURL),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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

                    // Message de bienvenue avec le nom d'utilisateur
                    AnimatedSlide(
                      offset: const Offset(0, -0.2),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Text(
                          'Bonjour $displayName 👋',
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
                                  width: size.width * 0.75,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.secondary, AppColors.primary],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.play_circle_filled,
                                            color: Colors.white, size: 30),
                                        const SizedBox(width: 10),
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
  final double animationValue;

  _MathBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final seedValue = 42;
    final random = Random(seedValue);

    for (int i = 0; i < 30; i++) {
      // Utilisation de l'animation pour un mouvement fluide
      final x = random.nextDouble() * size.width + sin(animationValue + i * 0.5) * 30;
      final y = random.nextDouble() * size.height + cos(animationValue + i * 0.5) * 30;

      final radius = (random.nextDouble() * 20 + 10) * (0.8 + 0.2 * sin(animationValue * 0.5));

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
            text: ['+', '-','0','1','×', '÷', '='][random.nextInt(5)],
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
  bool shouldRepaint(covariant _MathBackgroundPainter oldDelegate) => true;
}