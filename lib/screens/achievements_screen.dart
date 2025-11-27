import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';
import '../services/achievement_service.dart';
import '../services/lives_service.dart';
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
      final livesService = Provider.of<LivesService>(context, listen: false);

      // Réclamer l'achievement
      final livesReward = await achievementService.claimAchievement(user.uid, achievement.id);

      // Ajouter les vies
      await livesService.addLivesFromAchievement(user.uid, livesReward);

      // Célébration !
      _confettiController.play();
      _showSuccessDialog(achievement, livesReward);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(Achievement achievement, int lives) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              width: 120,
              height: 120,
              repeat: false,
            ),
            const SizedBox(height: 16),
            Text(
              achievement.icon,
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 8),
            Text(
              'Récompense réclamée !',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicNeue',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+$lives vies ❤️',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Super !'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.christ, Colors.white],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildStatsCard(),
                _buildTabBar(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
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
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.christ,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Achievements 🏆',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'ComicNeue',
              ),
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
        final unclaimedLives = service.getTotalUnclaimedLives();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    '${stats['completed']}/${stats['total']}',
                    'Complétés',
                    Icons.check_circle,
                    Colors.green,
                  ),
                  _buildStatItem(
                    '${stats['unclaimed']}',
                    'À réclamer',
                    Icons.card_giftcard,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    '$unclaimedLives ❤️',
                    'Vies dispo',
                    Icons.favorite,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: stats['completionRate'],
                  backgroundColor: Colors.grey[200],
                  color: AppColors.secondary,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(stats['completionRate'] * 100).toInt()}% complétés',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
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
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'ComicNeue',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        labelColor: AppColors.christ,
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
        ),
        tabs: const [
          Tab(text: 'Tous'),
          Tab(text: 'Complétés'),
          Tab(text: 'À réclamer'),
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
                Icon(
                  showUnclaimed ? Icons.done_all : Icons.emoji_events_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  showUnclaimed
                      ? 'Aucun achievement à réclamer'
                      : 'Aucun achievement pour le moment',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return _buildAchievementCard(achievements[index], service);
          },
        );
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, AchievementService service) {
    final userAchievement = service.userAchievements[achievement.id];
    final progress = service.getAchievementProgress(achievement.id);
    final isCompleted = userAchievement?.isCompleted ?? false;
    final isClaimed = userAchievement?.isClaimed ?? false;
    final isSecret = achievement.isSecret && !isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icône de l'achievement
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isCompleted
                    ? LinearGradient(
                  colors: [Colors.yellow[300]!, Colors.orange[400]!],
                )
                    : null,
                color: isCompleted ? null : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isSecret ? '🔒' : achievement.icon,
                  style: TextStyle(
                    fontSize: 30,
                    color: isSecret ? Colors.grey : null,
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
                  Text(
                    isSecret ? '???' : achievement.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.black : Colors.grey[600],
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSecret ? 'Achievement secret' : achievement.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!isSecret) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        color: isCompleted ? Colors.green : AppColors.secondary,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${userAchievement?.currentProgress ?? 0}/${achievement.targetValue}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Bouton de récompense
            if (isCompleted && !isClaimed)
              ElevatedButton(
                onPressed: () => _claimAchievement(achievement),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.card_giftcard, size: 20),
                    Text(
                      '+${achievement.livesReward}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else if (isClaimed)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}