// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../models/daily_challenge_model.dart';
import '../services/daily_challenge_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LeaderboardEntry? _userStats;
  List<LeaderboardEntry> _topPlayers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboard() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final service = Provider.of<DailyChallengeService>(context, listen: false);

    try {
      final userStats = await service.getUserStats(user.uid);
      final topPlayers = await service.getTopLeaderboard();

      if (mounted) {
        setState(() {
          _userStats = userStats;
          _topPlayers = topPlayers;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur chargement leaderboard: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F), Colors.red],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              if (_userStats != null) _buildUserStatsCard(),
              const SizedBox(height: 16),
              _buildTabBar(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTopLeaderboard(),
                    _buildUserHistory(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFD32F2F)),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Classement 🏆',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  'Top des champions du mois',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildUserStatsCard() {
    if (_userStats == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes stats 📊',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${_userStats!.currentStreak} jours',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                '${_userStats!.totalScore}',
                'Points',
                Icons.emoji_events,
                Colors.orange,
              ),
              _buildStatItem(
                '${_userStats!.challengesCompleted}',
                'Défis',
                Icons.done_all,
                Colors.green,
              ),
              _buildStatItem(
                '${_userStats!.totalStars}',
                'Étoiles',
                Icons.star,
                Colors.yellow.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'Top 10'),
          Tab(text: 'Mon historique'),
        ],
      ),
    );
  }

  Widget _buildTopLeaderboard() {
    if (_topPlayers.isEmpty) {
      return const Center(
        child: Text(
          'Aucun joueur pour l\'instant',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _topPlayers.length,
      itemBuilder: (context, index) {
        final player = _topPlayers[index];
        final rank = index + 1;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: rank <= 3
                ? Colors.amber.withOpacity(0.2)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            border: rank <= 3
                ? Border.all(color: Colors.amber, width: 2)
                : null,
          ),
          child: Row(
            children: [
              // Rang
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: rank == 1
                      ? const LinearGradient(colors: [Colors.yellow, Colors.amber])
                      : rank == 2
                      ? const LinearGradient(colors: [Colors.grey, Colors.blueGrey])
                      : rank == 3
                      ? const LinearGradient(colors: [Colors.orange, Colors.deepOrange])
                      : const LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : '$rank',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: rank <= 3 ? 20 : 16,
                      color: rank > 3 ? Colors.white : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info joueur
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '🔥 Série: ${player.currentStreak} jours',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${player.totalScore} pts',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 16),
                      Text(
                        '${player.totalStars}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserHistory() {
    // TODO: Implémenter l'historique de l'utilisateur
    return const Center(
      child: Text(
        'Historique à venir',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}