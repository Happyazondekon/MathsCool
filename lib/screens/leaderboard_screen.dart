// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/user_model.dart';
import '../models/daily_challenge_model.dart';
import '../services/daily_challenge_service.dart';
import 'dart:math';

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
    _tabController = TabController(length: 3, vsync: this);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F), Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _MathBackgroundPainter(),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildTabButtons(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _isLoading
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : _buildLeaderboardList(),
                        _buildUserHistory(),
                        _buildStatsTab(),
                      ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Classements 🏅',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
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

  Widget _buildTabButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        labelColor: Colors.red,
        unselectedLabelColor: Colors.white,
        tabs: const [
          Tab(text: 'Top 10'),
          Tab(text: 'Moi'),
          Tab(text: 'Stats'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    if (_topPlayers.isEmpty) {
      return _buildEmptyState("Aucun score", "Sois le premier à jouer !");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _topPlayers.length,
      itemBuilder: (context, index) {
        final player = _topPlayers[index];
        final rank = index + 1;
        final isMe = player.userId == Provider.of<AppUser?>(context)?.uid;
        final isTop3 = rank <= 3;

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.all(isTop3 ? 20 : 15),
          decoration: BoxDecoration(
            color: isMe ? Colors.white : Colors.white.withOpacity(isTop3 ? 0.3 : 0.15),
            borderRadius: BorderRadius.circular(25),
            border: isTop3
                ? Border.all(color: _getRankColor(rank), width: 3)
                : (isMe ? Border.all(color: Colors.white, width: 2) : null),
            boxShadow: isTop3 ? [
              BoxShadow(
                color: _getRankColor(rank).withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ] : null,
          ),
          child: Row(
            children: [
              _buildRankBadge(rank),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.userName,
                      style: TextStyle(
                        color: isMe ? Colors.red : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTop3 ? 20 : 16,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    if (isTop3) Text(
                      'Elite MathKid 🌟',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${player.totalScore} pts',
                    style: TextStyle(
                      color: isMe ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTop3 ? 22 : 16,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      Text(
                        '${player.totalStars}',
                        style: TextStyle(
                          color: isMe ? Colors.red : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildRankBadge(int rank) {
    if (rank == 1) return const Text('🥇', style: TextStyle(fontSize: 35));
    if (rank == 2) return const Text('🥈', style: TextStyle(fontSize: 35));
    if (rank == 3) return const Text('🥉', style: TextStyle(fontSize: 35));

    return Container(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'ComicNeue',
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return const Color(0xFFC0C0C0); // Argent
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return Colors.transparent;
  }

  Widget _buildUserHistory() {
    return _buildEmptyState("Mon Historique", "Tes derniers défis apparaîtront ici bientôt !");
  }

  Widget _buildStatsTab() {
    if (_userStats == null) return _buildEmptyState("Pas de statistiques", "Relève ton premier défi pour voir tes stats !");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _buildStatCard("Série Actuelle", "${_userStats!.currentStreak} jours", Icons.local_fire_department, Colors.orange),
          const SizedBox(height: 15),
          _buildStatCard("Total Étoiles", "${_userStats!.totalStars} ⭐", Icons.star, Colors.amber),
          const SizedBox(height: 15),
          _buildStatCard("Meilleure Série", "${_userStats!.bestStreak} jours", Icons.emoji_events, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'ComicNeue')),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87, fontFamily: 'ComicNeue')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String sub) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.leaderboard_outlined, size: 80, color: Colors.white30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'ComicNeue')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(sub, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontFamily: 'ComicNeue')),
          ),
        ],
      ),
    );
  }
}

class _MathBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    final random = Random(42);
    final mathSymbols = ['+', '-', '×', '÷', '=', '√', 'π'];

    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final symbolSize = random.nextDouble() * 20 + 10;

      final textPainter = TextPainter(
        text: TextSpan(
          text: mathSymbols[random.nextInt(mathSymbols.length)],
          style: TextStyle(
            color: Colors.white.withOpacity(0.1),
            fontSize: symbolSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}