import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/models/user_model.dart';
import 'package:mathscool/screens/level_selection.dart';
import 'package:mathscool/screens/profile_screen.dart';
import 'package:mathscool/screens/notification_settings_screen.dart';
import 'package:mathscool/screens/store_screen.dart'; // Import Boutique
import 'package:mathscool/utils/colors.dart';

// Nouveaux imports pour le système de vies
import 'package:mathscool/services/lives_service.dart';
import 'package:mathscool/widgets/lives_display.dart';

import '../services/achievement_service.dart';
import '../widgets/chatbot_floating_button.dart';
import '../widgets/daily_challenge_button.dart';
import 'achievements_screen.dart';

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

    // --- NOUVEAU : Chargement des vies au démarrage ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AppUser?>(context, listen: false);
      if (user != null) {
        Provider.of<LivesService>(context, listen: false).loadLives(user.uid);
      }
    });
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xDBA30E0E), // Bleu nuit de Noël (Rouge foncé ici selon ton code)
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
                                          color: const Color(0xFFFFD700), // Or
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
                              const Positioned(
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
                              // J'ai retiré LivesDisplay d'ici
                              // Bouton Achievements avec badge
                              Consumer<AchievementService>(
                                builder: (context, achievementService, _) {
                                  final unclaimedCount = achievementService.getUnclaimedAchievements().length;

                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.orange.shade400.withOpacity(0.8),
                                                Colors.yellow.shade400.withOpacity(0.8),
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.emoji_events,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      if (unclaimedCount > 0)
                                        Positioned(
                                          top: 0,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 20,
                                              minHeight: 20,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$unclaimedCount',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),

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
                                onTap: () async {
                                  // 1. On attend le retour de la page profil
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                  );

                                  // 2. Une fois revenu, on exécute ces actions :
                                  if (mounted) {
                                    // Recharger l'avatar (votre logique existante)
                                    await _loadSavedAvatar();

                                    // IMPORTANT : Recharger les infos utilisateur Firebase pour avoir le nouveau nom
                                    await authService.reloadUser();

                                    // IMPORTANT : Forcer la reconstruction de l'écran pour afficher le nouveau texte
                                    setState(() {});
                                  }
                                },
                                child: AnimatedScale(
                                  scale: _isPressed ? 0.9 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
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
                                      decoration: const BoxDecoration(
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
                        margin: const EdgeInsets.only(top: 5, bottom: 5), // Réduit le bottom margin
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
                          '🎄 HoHoHo $displayName! 🎅',
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

                    // --- NOUVEAU EMPLACEMENT DES VIES ---
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LivesDisplay(showTimer: true),
                    ),
                    const SizedBox(height: 10),

                    // Contenu principal
                    // Contenu principal
                    SizedBox(
                      height: size.height * 0.6,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Lottie Animation
                          Positioned(
                            top: size.height * 0.02,
                            child: Lottie.asset(
                              'assets/animations/home.json',
                              width: size.width * 0.8,
                              height: size.height * 0.4,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Bouton principal (toggle)
                          Positioned(
                            bottom: size.height * 0.14,
                            child: ChristmasToggleButton(size: size),
                          ),

                          // ✅ Bouton Défi du jour EN DESSOUS du toggle
                          Positioned(
                            bottom: size.height * 0.05,
                            left: 20,
                            right: 20,
                            child: const DailyChallengeButton(),
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
          ),Positioned(
            bottom: 20,
            right: 20,
            child: const ChatbotFloatingButton(),
          ),
        ],
      ),
    );
  }

  // Flocon de neige animé
  Widget _buildSnowflake(Size screenSize, int index) {
    final random = Random(index);
    final left = random.nextDouble() * screenSize.width;
    // final animationDelay = random.nextInt(3000); // Non utilisé mais gardé pour ref

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
              color: const Color(0xFFFFD700),
            ),
          ),
          // Ruban horizontal
          Center(
            child: Container(
              width: size,
              height: size * 0.2,
              color: const Color(0xDBD15959),
            ),
          ),
          // Nœud
          Positioned(
            top: size * 0.3,
            left: size * 0.3,
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: const BoxDecoration(
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
      if (_avatarPath!.startsWith('base64:')) {
        try {
          final base64String = _avatarPath!.substring(7);
          final bytes = base64Decode(base64String);
          return MemoryImage(bytes);
        } catch (e) {
          print('Error decoding base64 image: $e');
          return const AssetImage('assets/avatars/avatar1.png');
        }
      } else if (_avatarPath!.startsWith('assets/')) {
        return AssetImage(_avatarPath!);
      } else if (_avatarPath!.startsWith('http')) {
        return NetworkImage(_avatarPath!);
      }
    }

    if (photoURL != null) {
      if (photoURL.startsWith('assets/')) {
        return AssetImage(photoURL);
      } else if (photoURL.startsWith('http')) {
        return NetworkImage(photoURL);
      }
    }

    return const AssetImage('assets/avatars/avatar1.png');
  }
}

// Classe pour le bouton toggle animé
class ChristmasToggleButton extends StatefulWidget {
  final Size size;

  const ChristmasToggleButton({super.key, required this.size});

  @override
  State<ChristmasToggleButton> createState() => _ChristmasToggleButtonState();
}

class _ChristmasToggleButtonState extends State<ChristmasToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<BorderRadius> _borderRadiusAnimation;
  bool _isClosed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOutBack),
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    _borderRadiusAnimation = Tween<BorderRadius>(
      begin: BorderRadius.circular(40),
      end: BorderRadius.circular(100),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleButton() async {
    // --- NOUVEAU : Vérification des vies avant l'animation ---
    final user = Provider.of<AppUser?>(context, listen: false);
    final livesService = Provider.of<LivesService>(context, listen: false);

    if (user != null) {
      final canPlay = await livesService.canPlay(user.uid);
      if (!canPlay) {
        _showNoLivesDialog();
        return; // Arrête tout si pas de vies
      }
    }

    // Si on a des vies, on continue l'animation normale
    if (_isClosed) {
      _animationController.reverse();
    } else {
      _animationController.forward().then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LevelSelectionScreen()),
        );
        // Réinitialiser après la navigation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _animationController.reverse();
          }
        });
      });
    }
    setState(() {
      _isClosed = !_isClosed;
    });
  }

  // --- NOUVEAU : Dialogue "Plus de vies" ---
  void _showNoLivesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.favorite_border, color: Colors.red),
            SizedBox(width: 10),
            Text("Plus de vies !", style: TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tu as besoin de repos ou d'un coup de pouce ! 💖",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Attends qu'elles se rechargent ou visite la boutique.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Plus tard", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.christ,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StoreScreen()),
              );
            },
            child: const Text("Recharger ⚡"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: InkWell(
              onTap: _toggleButton,
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: widget.size.width * 0.75,
                height: 75,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFC62828), // Rouge foncé
                      Color(0xFFD32F2F), // Rouge moyen
                      Color(0xFF2E7D32), // Vert sapin
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.5, 1.0],
                  ),
                  borderRadius: _borderRadiusAnimation.value,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFFFFF).withOpacity(0.6),
                      blurRadius: 20 * _scaleAnimation.value,
                      offset: Offset(0, 10 * _scaleAnimation.value),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: const Color(0xFFF1CC39).withOpacity(0.4),
                      blurRadius: 15 * _scaleAnimation.value,
                      offset: Offset(0, 5 * _scaleAnimation.value),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Effet de brillance qui disparaît
                    Positioned(
                      top: -10 * _scaleAnimation.value,
                      left: -10 * _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: 30 * _scaleAnimation.value,
                          height: 30 * _scaleAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),

                    // Contenu principal
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            padding: EdgeInsets.all(8 * _scaleAnimation.value),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2 * _opacityAnimation.value),
                            ),
                            child: Transform.rotate(
                              angle: _animationController.value * 2 * pi,
                              child: Text(
                                '🎄',
                                style: TextStyle(
                                  fontSize: 28 * _scaleAnimation.value,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 15 * _scaleAnimation.value),

                          Flexible(
                            child: Opacity(
                              opacity: _opacityAnimation.value,
                              child: Text(
                                'Déballer les maths !',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20 * _scaleAnimation.value,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'ComicNeue',
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10 * _scaleAnimation.value),

                          Opacity(
                            opacity: _opacityAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(6 * _scaleAnimation.value),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.15),
                              ),
                              child: Text(
                                '❄️',
                                style: TextStyle(
                                  fontSize: 16 * _scaleAnimation.value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bordure lumineuse
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: _borderRadiusAnimation.value,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1 * _opacityAnimation.value),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

    const seedValue = 42;
    final random = Random(seedValue);

    // Symboles mathématiques avec couleurs de Noël
    final colors = [
      Colors.red.withOpacity(0.1),
      Colors.green.withOpacity(0.1),
      Colors.white.withOpacity(0.08),
      const Color(0xFFFFD700).withOpacity(0.1),
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
    const points = 5;
    const angle = (2 * pi) / points;

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