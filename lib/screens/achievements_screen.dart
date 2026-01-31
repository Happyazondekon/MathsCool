import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';
import '../services/achievement_service.dart';
import '../services/lives_service.dart';
import '../services/sound_service.dart';
import '../utils/colors.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _tabController = TabController(length: 3, vsync: this);
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final achievementService = Provider.of<AchievementService>(context, listen: false);
    await achievementService.initialize();
    await achievementService.loadUserAchievements(user.uid);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _claimAchievement(Achievement achievement) async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    try {
      final achievementService = Provider.of<AchievementService>(context, listen: false);

      // ✅ Réclamer l'achievement (donne maintenant des gems au lieu de vies)
      final gemsReward = await achievementService.claimAchievement(user.uid, achievement.id);

      await SoundService().playAchievement();
      _confettiController.play();
      _showSuccessDialog(achievement, gemsReward); // ✅ CHANGÉ : gemsReward au lieu de livesReward

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.error}${e.toString()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showSuccessDialog(Achievement achievement, int gems) { // ✅ CHANGÉ : gems au lieu de lives
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.background, AppColors.surface],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.warning],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    achievement.icon,
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.rewardClaimed,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: AppColors.success,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                achievement.name,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontFamily: 'ComicNeue',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // ✅ CHANGÉ : Afficher les gems au lieu des vies
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💎', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      // On remplace .replaceAll(...) par l'appel de fonction direct
                      AppLocalizations.of(context)!.gemsEarned,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.textLight,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  AppLocalizations.of(context)!.awesome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fond avec l'image MathsCool
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/bgc_math.png'),
            fit: BoxFit.cover,
            opacity: 0.15, // Ajusté pour ne pas gêner la lisibilité
          ),
        ),
        child: Container(
          // Superposition du dégradé pour garder le style de l'app
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
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildStatsCard(),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.textLight,
                        strokeWidth: 3,
                      ),
                    )
                        : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAchievementsList(showAll: true),
                        _buildAchievementsList(showCompleted: true),
                        _buildAchievementsList(showUnclaimed: true),
                      ],
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

  Widget _buildHeader() {
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
                  AppLocalizations.of(context)!.achievements,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.collectRewards,
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

  Widget _buildStatsCard() {
    return Consumer<AchievementService>(
      builder: (context, service, _) {
        final stats = service.getAchievementStats();
        final unclaimedGems = service.getTotalUnclaimedGems(); // ✅ CHANGÉ

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    '${stats['completed']}',
                    AppLocalizations.of(context)!.completed,
                    Icons.emoji_events_rounded,
                    AppColors.success,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: AppColors.divider,
                  ),
                  _buildStatItem(
                    '${stats['unclaimed']}',
                    AppLocalizations.of(context)!.toClaim,
                    Icons.card_giftcard_rounded,
                    AppColors.warning,
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: AppColors.divider,
                  ),
                  // ✅ CHANGÉ : Afficher les gems au lieu des vies
                  _buildStatItem(
                    '$unclaimedGems',
                    AppLocalizations.of(context)!.gemsAvailable,
                    Icons.diamond,
                    Colors.amber,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: stats['completionRate'],
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.overallProgress,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  Text(
                    '${(stats['completionRate'] * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'ComicNeue',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontFamily: 'ComicNeue',
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        labelColor: AppColors.textLight,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
          fontSize: 14,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.all),
          Tab(text: AppLocalizations.of(context)!.completed),
          Tab(text: AppLocalizations.of(context)!.toClaim),
        ],
      ),
    );
  }

  Widget _buildAchievementsList({
    bool showAll = false,
    bool showCompleted = false,
    bool showUnclaimed = false,
  }) {
    return Consumer<AchievementService>(
      builder: (context, service, _) {
        List<Achievement> achievements = service.allAchievements;

        if (showCompleted) {
          achievements = achievements.where((a) {
            final userAch = service.userAchievements[a.id];
            return userAch?.isCompleted ?? false;
          }).toList();
        } else if (showUnclaimed) {
          achievements = service.getUnclaimedAchievements();
        }

        if (achievements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    showUnclaimed ? Icons.done_all_rounded : Icons.emoji_events_outlined,
                    size: 80,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  showUnclaimed
                      ? AppLocalizations.of(context)!.noAchievementsToClaim
                      : showCompleted
                      ? AppLocalizations.of(context)!.noCompletedAchievements
                      : AppLocalizations.of(context)!.startPlayingToUnlock,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textLight,
                    fontFamily: 'ComicNeue',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  showUnclaimed
                      ? AppLocalizations.of(context)!.keepPlayingToEarn
                      : AppLocalizations.of(context)!.achievementsWillAppearHere,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return _buildAchievementCard(achievements[index], service, index);
          },
        );
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, AchievementService service, int index) {
    final userAchievement = service.userAchievements[achievement.id];
    final progress = service.getAchievementProgress(achievement.id);
    final isCompleted = userAchievement?.isCompleted ?? false;
    final isClaimed = userAchievement?.isClaimed ?? false;
    final isSecret = achievement.isSecret && !isCompleted;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value.clamp(0.0, 1.0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCompleted
                ? [AppColors.surface, AppColors.background]
                : [AppColors.surface.withOpacity(0.95), AppColors.background],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? AppColors.success.withOpacity(0.3) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône de l'achievement
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: isCompleted
                      ? LinearGradient(
                    colors: [AppColors.accent, AppColors.warning],
                  )
                      : LinearGradient(
                    colors: [AppColors.disabled, AppColors.border],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isCompleted
                          ? AppColors.accent.withOpacity(0.4)
                          : AppColors.disabled.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isSecret ? AppLocalizations.of(context)!.secretAchievement : achievement.icon,
                    style: TextStyle(
                      fontSize: 36,
                      color: isSecret ? AppColors.textSecondary : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Infos de l'achievement
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isSecret ? '???' : achievement.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                              fontFamily: 'ComicNeue',
                            ),
                          ),
                        ),
                        if (!isSecret)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('💎', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(
                                  '+${achievement.gemsReward}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textLight,
                                    fontFamily: 'ComicNeue',
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isSecret ? AppLocalizations.of(context)!.secretAchievementDescription : achievement.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!isSecret) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation(
                                    isCompleted ? AppColors.success : AppColors.primary,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${userAchievement?.currentProgress ?? 0}/${achievement.targetValue}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                              fontFamily: 'ComicNeue',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Bouton de récompense
              if (isCompleted && !isClaimed)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: () => _claimAchievement(achievement),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.textLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      elevation: 5,
                    ),
                    child:  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.card_giftcard_rounded, size: 24),
                        SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(context)!.claim,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (isClaimed)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 32,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}