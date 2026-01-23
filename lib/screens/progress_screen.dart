import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/widgets/progress_chart.dart';
import 'package:mathscool/services/progress_service.dart';
import 'package:mathscool/models/user_model.dart';
import 'package:mathscool/models/user_progress_model.dart';
import 'package:confetti/confetti.dart';
import '../widgets/theme_badge.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  bool showGradeProgress = false;
  late AnimationController _badgeAnimationController;
  late ConfettiController _confettiController;

  UserProgress? _userProgress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _badgeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _loadUserProgress();
  }

  @override
  void dispose() {
    _badgeAnimationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProgress() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final progress = await _progressService.getUserProgress(user.uid);

      if (mounted) {
        setState(() {
          _userProgress = progress;
          _isLoading = false;

          if (progress != null && progress.hasMathKidBadge) {
            _badgeAnimationController.forward();
            _confettiController.play();
          }
        });
      }
    } catch (e) {
      print('Erreur lors du chargement de la progression: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getLevelNumberForTheme(String theme) {
    switch (theme.toLowerCase()) {
      case 'addition': return '1';
      case 'soustraction': return '2';
      case 'multiplication': return '3';
      case 'division': return '4';
      case 'géométrie': return '5';
      case 'nombres relatifs': return '6';
      case 'fractions': return '7';
      case 'algèbre': return '8';
      case 'puissances': return '9';
      case 'théorèmes': return '10';
      case 'statistiques': return '11';
      default: return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgc_math.png'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientStart.withOpacity(0.8),
                  AppColors.gradientMiddle.withOpacity(0.7),
                  AppColors.gradientEnd.withOpacity(0.6),
                  AppColors.background.withOpacity(0.5),
                ],
              ),
            ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  if (!_isLoading) _buildToggleButtons(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.textLight,
                        strokeWidth: 3,
                      ),
                    )
                        : _userProgress == null
                        ? Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erreur lors du chargement',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ComicNeue',
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                        : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ProgressChart(
                            progressData: showGradeProgress
                                ? _userProgress!.progressByGrade
                                : _userProgress!.progressByCategory,
                            title: showGradeProgress
                                ? 'Progression par niveau'
                                : 'Progression par catégorie',
                          ),
                          const SizedBox(height: 20),
                          if (_userProgress!.hasMathKidBadge)
                            _buildMathKidBadge(),
                          const SizedBox(height: 20),
                          _buildBadgesSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Confettis
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.1,
                shouldLoop: false,
                colors: [
                  AppColors.success,
                  AppColors.info,
                  AppColors.gradientEnd,
                  AppColors.accent,
                  AppColors.secondary,
                  AppColors.warning,
                ],
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Ma Progression',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  'Suis ton évolution ! 📊',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showGradeProgress = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: !showGradeProgress
                      ? LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  )
                      : null,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_rounded,
                      size: 20,
                      color: !showGradeProgress ? AppColors.textLight : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Par catégorie',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        fontSize: 14,
                        color: !showGradeProgress ? AppColors.textLight : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showGradeProgress = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: showGradeProgress
                      ? LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  )
                      : null,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 20,
                      color: showGradeProgress ? AppColors.textLight : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Par niveau',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        fontSize: 14,
                        color: showGradeProgress ? AppColors.textLight : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMathKidBadge() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _badgeAnimationController,
          curve: Curves.elasticOut,
        ),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondary,
              AppColors.primary,
              Color(0xFF5B21B6),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_rounded,
                    size: 70,
                    color: AppColors.accent,
                  ),
                  Positioned(
                    bottom: 20,
                    child: Text(
                      "80%",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '🎯 MATHKID 🎯',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
                fontFamily: 'ComicNeue',
                letterSpacing: 2,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Super Champion !',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection() {
    if (_userProgress == null) return const SizedBox.shrink();

    int earnedBadges = _userProgress!.earnedBadges.length;
    int totalBadges = _userProgress!.progressByCategory.length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.textLight,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mes Badges',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '$earnedBadges/$totalBadges badges obtenus',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Barre de progression
            Container(
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: totalBadges > 0 ? earnedBadges / totalBadges : 0.0,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  minHeight: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Message de progression
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: earnedBadges == totalBadges
                      ? [AppColors.success.withOpacity(0.2), AppColors.success.withOpacity(0.3)]
                      : [AppColors.warning.withOpacity(0.2), AppColors.warning.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    earnedBadges == totalBadges
                        ? Icons.celebration_rounded
                        : Icons.trending_up_rounded,
                    color: earnedBadges == totalBadges
                        ? AppColors.success
                        : AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      earnedBadges == totalBadges
                          ? '🎉 Tous les badges débloqués ! Champion !'
                          : 'Continue pour débloquer ${totalBadges - earnedBadges} badge${totalBadges - earnedBadges > 1 ? 's' : ''} !',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: earnedBadges == totalBadges
                            ? AppColors.success
                            : AppColors.warning,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grille de badges
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: _userProgress!.progressByCategory.entries.map((entry) {
                final earned = _userProgress!.hasBadge(entry.key);
                final index = _userProgress!.progressByCategory.keys.toList().indexOf(entry.key);

                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOutBack,
                  builder: (context, animationValue, child) {
                    return Transform.scale(
                      scale: animationValue.clamp(0.0, 1.0),
                      child: Opacity(
                        opacity: animationValue.clamp(0.0, 1.0),
                        child: ThemeBadge(
                          theme: entry.key,
                          level: _getLevelNumberForTheme(entry.key),
                          obtained: earned,
                          progress: entry.value,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Conseil
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.info.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.info,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      earnedBadges == 0
                          ? 'Commence à résoudre des exercices pour gagner tes premiers badges !'
                          : earnedBadges == totalBadges
                          ? 'Bravo ! Tu es un véritable champion ! 🌟'
                          : 'Super ! Continue comme ça pour débloquer tous les badges !',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}