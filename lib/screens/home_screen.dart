import 'package:flutter/material.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/screens/level_selection.dart';
import 'package:mathscool/screens/profile_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

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

    _backgroundAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
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
                  painter: _MathBackgroundPainter(animation: _backgroundAnimation.value),
                  size: Size(size.width, size.height),
                ),
              );
            },
          ),

          // Éléments décoratifs - Ajustés pour les petits écrans
          if (size.height > 600) ...[
            Positioned(
              top: 100,
              left: -30,
              child: _buildFloatingShape(Icons.calculate, 60), // Réduit de 80 à 60
            ),
            Positioned(
              bottom: 150,
              right: -20,
              child: _buildFloatingShape(Icons.star, 45), // Réduit de 60 à 45
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Réduit de 15 à 10
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
                                  fontSize: size.width < 350 ? 24 : 26, // Adaptatif selon la largeur
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
                            ).then((_) => _loadSavedAvatar()), // Recharger l'avatar au retour
                            child: AnimatedScale(
                              scale: _isPressed ? 0.9 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                padding: const EdgeInsets.all(6), // Réduit de 8 à 6
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
                                  radius: 20, // Réduit de 24 à 20
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

                    // Message de bienvenue avec le nom d'utilisateur
                    AnimatedSlide(
                      offset: const Offset(0, -0.2),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15), // Réduit les marges
                        child: Text(
                          'Bonjour $displayName 👋',
                          style: TextStyle(
                            fontSize: size.width < 350 ? 20 : 22, // Adaptatif
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
                      height: size.height * 0.6, // Hauteur fixe mais adaptative
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Lottie Animation
                          Positioned(
                            top: size.height * 0.02, // Réduit de 0.05 à 0.02
                            child: Lottie.asset(
                              'assets/animations/home.json',
                              width: size.width * 0.75, // Réduit de 0.8 à 0.75
                              height: size.height * 0.35, // Réduit de 0.4 à 0.35
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Bouton principal
                          Positioned(
                            bottom: size.height * 0.05, // Réduit de 0.1 à 0.05
                            child: AnimatedScale(
                              scale: 1.0,
                              duration: const Duration(seconds: 3),
                              curve: Curves.elasticOut,
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LevelSelectionScreen()),
                                ),
                                borderRadius: BorderRadius.circular(35), // Réduit de 40 à 35
                                child: Container(
                                  width: size.width * 0.75, // Réduit de 0.7 à 0.65
                                  height: 60, // Réduit de 70 à 60
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
                                            color: Colors.white, size: 26), // Réduit de 30 à 26
                                        const SizedBox(width: 8), // Réduit de 10 à 8
                                        Text(
                                          'Commencer à apprendre',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width < 350 ? 16 : 18, // Adaptatif, réduit de 20
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
    // Vérifier d'abord si un avatar a été chargé depuis SharedPreferences
    if (_avatarPath != null) {
      // Si c'est un chemin d'asset
      if (_avatarPath!.startsWith('assets/')) {
        return AssetImage(_avatarPath!);
      }
      // Si c'est une URL (photo uploadée)
      return NetworkImage(_avatarPath!);
    }
    // Si aucun avatar n'est dans les préférences mais que photoURL existe dans le profil Firebase
    else if (photoURL != null) {
      // Si c'est un chemin d'asset
      if (photoURL.startsWith('assets/')) {
        return AssetImage(photoURL);
      }
      // Si c'est une URL
      return NetworkImage(photoURL);
    }
    // Avatar par défaut si rien n'est défini
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