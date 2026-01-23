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
import 'package:mathscool/screens/store_screen.dart';
import 'package:mathscool/utils/colors.dart';

import 'package:mathscool/services/lives_service.dart';
import 'package:mathscool/widgets/lives_display.dart';

import '../services/achievement_service.dart';
import '../services/sound_service.dart';
import '../widgets/chatbot_floating_button.dart';
import '../widgets/daily_challenge_button.dart';
import '../widgets/gems_display_widget.dart';
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

    _loadSavedAvatar();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AppUser?>(context, listen: false);
      if (user != null) {
        Provider.of<LivesService>(context, listen: false).loadLives(user.uid);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SoundService().playBackgroundMusic();
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
    SoundService().stopBackgroundMusic();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser;

    final displayName = currentUser?.displayName ?? 'MathKid';
    final photoURL = currentUser?.photoURL;

    return Scaffold(
      body: Stack(
        children: [
          // Fond avec dégradé moderne
          // Fond avec image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bgc_math.png'),
                fit: BoxFit.cover,
                opacity: 0.15, // Ajustez l'opacité (0.1 = très transparent, 1.0 = opaque)
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.gradientStart.withOpacity(0.8),
                    AppColors.gradientMiddle.withOpacity(0.7),
                    AppColors.gradientEnd.withOpacity(0.6),
                    AppColors.background.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Éléments décoratifs flottants
          if (size.height > 600) ...[
            ...List.generate(8, (index) => _buildFloatingElement(size, index)),
            Positioned(
              top: 80,
              left: 40,
              child: _buildTwinklingIcon(Icons.star, 30, delay: 0),
            ),
            Positioned(
              top: 120,
              right: 60,
              child: _buildTwinklingIcon(Icons.auto_awesome, 25, delay: 500),
            ),
            Positioned(
              bottom: 200,
              left: 30,
              child: _buildTwinklingIcon(Icons.star_border, 20, delay: 1000),
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

// En-tête moderne
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // LOGO : Flexible pour éviter qu'il ne pousse les icônes dehors
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 22, // Taille réduite pour l'espace
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicNeue',
                                ),
                                children: [
                                  TextSpan(text: 'Maths', style: TextStyle(color: AppColors.textLight)),
                                  TextSpan(text: 'Cool', style: TextStyle(color: AppColors.accent, fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ),

                          // GROUPE D'ACTIONS : Très compact
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // GEMS : On cache le bouton "+" sur les petits écrans ( < 360px )
                              GemsDisplayWidget(
                                showPlusButton: MediaQuery.of(context).size.width > 360,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreScreen())),
                              ),
                              const SizedBox(width: 6),

                              // Trophée (Achievements)
                              _buildCompactAction(
                                icon: Icons.emoji_events,
                                color: AppColors.accent,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen())),
                                badgeCount: Provider.of<AchievementService>(context).getUnclaimedAchievements().length,
                              ),
                              const SizedBox(width: 6),

                              // Cloche (Notifications) - AJOUTÉ ICI
                              _buildCompactAction(
                                icon: Icons.notifications,
                                color: AppColors.info,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NotificationSettingsScreen(userName: displayName)),
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Profil / Avatar
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                  if (mounted) {
                                    await _loadSavedAvatar();
                                    await authService.reloadUser();
                                    setState(() {});
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: AppColors.primary,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: _getProfileImage(photoURL),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Message de bienvenue moderne
                    AnimatedSlide(
                      offset: const Offset(0, -0.2),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.waving_hand,
                              color: AppColors.accent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown, // Réduit la taille si le nom est trop long
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Bonjour $displayName !',
                                  style: TextStyle(
                                    fontSize: 20, // Taille idéale par défaut
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textLight,
                                    fontFamily: 'ComicNeue',
                                    shadows: [
                                      Shadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1, // Garde le nom sur une seule ligne
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Affichage des vies
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LivesDisplay(showTimer: true),
                    ),

                    const SizedBox(height: 10),

                    // Contenu principal
                    Column(
                      children: [
                        // Animation Lottie
                        Lottie.asset(
                          'assets/animations/home.json',
                          width: size.width * 0.8,
                          height: size.height * 0.35,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 20),

                        // Bouton principal "Commencer"
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ModernToggleButton(size: size),
                        ),

                        const SizedBox(height: 16),

                        // Bouton Défi du jour
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: DailyChallengeButton(),
                        ),

                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Chatbot flottant
          const Positioned(
            bottom: 20,
            right: 20,
            child: ChatbotFloatingButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElement(Size screenSize, int index) {
    final random = Random(index);
    final left = random.nextDouble() * screenSize.width;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -50.0, end: screenSize.height + 50),
      duration: Duration(seconds: 8 + random.nextInt(4)),
      builder: (context, value, child) {
        return Positioned(
          left: left + sin(value / 50) * 30,
          top: value,
          child: Icon(
            [Icons.circle, Icons.star_border, Icons.add][random.nextInt(3)],
            size: 20 + random.nextDouble() * 15,
            color: [
              AppColors.primary.withOpacity(0.3),
              AppColors.accent.withOpacity(0.3),
              AppColors.textLight.withOpacity(0.3),
            ][random.nextInt(3)],
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

  Widget _buildCompactAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTwinklingIcon(IconData icon, double size, {required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Icon(
            icon,
            size: size,
            color: AppColors.accent.withOpacity(0.6),
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

// Classe pour le bouton toggle moderne
class ModernToggleButton extends StatefulWidget {
  final Size size;

  const ModernToggleButton({super.key, required this.size});

  @override
  State<ModernToggleButton> createState() => _ModernToggleButtonState();
}

class _ModernToggleButtonState extends State<ModernToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
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
  }

  void _toggleButton() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    final livesService = Provider.of<LivesService>(context, listen: false);

    if (user != null) {
      final canPlay = await livesService.canPlay(user.uid);
      if (!canPlay) {
        _showNoLivesDialog();
        return;
      }
    }

    if (_isClosed) {
      _animationController.reverse();
    } else {
      _animationController.forward().then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LevelSelectionScreen()),
        );
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

  void _showNoLivesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.favorite_border, color: AppColors.error),
            const SizedBox(width: 10),
            const Text("Plus de vies !", style: TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold)),
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
            child: Text("Plus tard", style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
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
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 75,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.gradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20 * _scaleAnimation.value,
                      offset: Offset(0, 10 * _scaleAnimation.value),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
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
                            child: Icon(
                              Icons.play_circle_filled,
                              size: 28 * _scaleAnimation.value,
                              color: AppColors.surface,
                            ),
                          ),

                          SizedBox(width: 15 * _scaleAnimation.value),

                          Flexible(
                            child: Opacity(
                              opacity: _opacityAnimation.value,
                              child: Text(
                                'Commencer à jouer',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 20 * _scaleAnimation.value,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'ComicNeue',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10 * _scaleAnimation.value),

                          Opacity(
                            opacity: _opacityAnimation.value,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 24 * _scaleAnimation.value,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
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

// Painter pour le fond mathématique moderne
class _MathBackgroundPainter extends CustomPainter {
  final double animationValue;

  _MathBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    const seedValue = 42;
    final random = Random(seedValue);

    final colors = [
      AppColors.primary.withOpacity(0.1),
      AppColors.secondary.withOpacity(0.1),
      AppColors.accent.withOpacity(0.08),
      AppColors.textLight.withOpacity(0.1),
    ];

    for (int i = 0; i < 30; i++) {
      paint.color = colors[i % colors.length];

      final x = random.nextDouble() * size.width + sin(animationValue + i * 0.5) * 30;
      final y = random.nextDouble() * size.height + cos(animationValue + i * 0.5) * 30;
      final radius = (random.nextDouble() * 20 + 10) * (0.8 + 0.2 * sin(animationValue * 0.5));

      if (i % 4 == 0) {
        _drawStar(canvas, Offset(x, y), radius, paint);
      } else if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else {
        final symbols = ['+', '-', '×', '÷', '=', '²', '√', 'π'];
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
  bool shouldRepaint(covariant _MathBackgroundPainter oldDelegate) => true;
}