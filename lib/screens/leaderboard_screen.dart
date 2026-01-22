// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/user_model.dart';
import '../models/daily_challenge_model.dart';
import '../services/daily_challenge_service.dart';
import '../services/username_service.dart';
import '../widgets/username_dialog.dart';
import '../utils/colors.dart';
import 'dart:math';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  LeaderboardEntry? _userStats;
  List<LeaderboardEntry> _topPlayers = [];
  bool _isLoading = true;
  String _username = 'MathKid';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _loadLeaderboard();
    _checkAndPromptUsername();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkAndPromptUsername() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final usernameService = Provider.of<UsernameService>(context, listen: false);
    final username = await usernameService.getUsername(user.uid);

    if (mounted) {
      setState(() {
        _username = username;
      });

      if (username == 'MathKid') {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          _showUsernamePrompt();
        }
      }
    }
  }

  void _showUsernamePrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -40,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Text('🏆', style: TextStyle(fontSize: 50)),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Bienvenue Champion !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pour apparaître dans le classement',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Choisis ton nom d\'utilisateur !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicNeue',
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, color: AppColors.info, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Ton nom sera visible par tous',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontFamily: 'ComicNeue',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    'Plus tard',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ComicNeue',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  await _showUsernameDialog();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit_rounded, color: AppColors.primary, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Choisir mon nom',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'ComicNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Future<void> _showUsernameDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => UsernameDialog(currentUsername: _username),
    );

    if (result != null && mounted) {
      setState(() => _username = result);
      _loadLeaderboard();
    }
  }

  Future<void> _loadLeaderboard() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final service = Provider.of<DailyChallengeService>(context, listen: false);

    try {
      final userStats = await service.getUserStats(user.uid);
      final topPlayers = await service.getTopLeaderboard(limit: 20);

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
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMiddle,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(user),
              const SizedBox(height: 16),
              _buildTabButtons(),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _isLoading ? _buildLoadingState() : _buildLeaderboardList(),
                    _buildUserHistory(),
                    _buildStatsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Remplace cette méthode dans ton fichier leaderboard_screen.dart

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation du trophée qui pulse
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.2),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.surface.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '🏆',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          // CircularProgressIndicator stylisé
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '🏆 Chargement du classement...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppUser? user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [AppColors.primary, AppColors.primary],
                      ).createShader(bounds),
                      child: const Text(
                        ' CLASSEMENT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'ComicNeue',
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    if (user != null)
                      StreamBuilder<String>(
                        stream: Provider.of<UsernameService>(context, listen: false)
                            .watchUsername(user.uid),
                        builder: (context, snapshot) {
                          final displayName = snapshot.data ?? _username;
                          return GestureDetector(
                            onTap: _showUsernameDialog,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.2),
                                    AppColors.primary.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person, color: AppColors.primary, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    displayName,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ComicNeue',
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.edit_rounded, color: AppColors.primary, size: 14),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.4)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: '🏅 TOP 20'),
          Tab(text: '👤 MOI'),
          Tab(text: '📊 STATS'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    if (_topPlayers.isEmpty) {
      return _buildEmptyState(
        "🎯 Aucun champion",
        "Sois le premier à relever le défi !",
      );
    }

    final currentUserId = Provider.of<AppUser?>(context)?.uid;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _topPlayers.length,
      itemBuilder: (context, index) {
        final player = _topPlayers[index];
        final rank = index + 1;
        final isMe = player.userId == currentUserId;

        return _buildLeaderboardCard(player, rank, isMe, index);
      },
    );
  }

  Widget _buildLeaderboardCard(LeaderboardEntry player, int rank, bool isMe, int index) {
    List<Color> cardGradient;
    Color borderColor;

    if (rank == 1) {
      cardGradient = [const Color(0xFFFFD700), const Color(0xFFFFA500)];
      borderColor = const Color(0xFFFFD700);
    } else if (rank == 2) {
      cardGradient = [const Color(0xFFC0C0C0), const Color(0xFFA8A8A8)];
      borderColor = const Color(0xFFC0C0C0);
    } else if (rank == 3) {
      cardGradient = [const Color(0xFFCD7F32), const Color(0xFFB8732D)];
      borderColor = const Color(0xFFCD7F32);
    } else if (isMe) {
      cardGradient = [AppColors.warning.withOpacity(0.9), AppColors.surface.withOpacity(0.8)];
      borderColor = AppColors.warning;
    } else {
      cardGradient = [AppColors.primary.withOpacity(0.15), AppColors.secondary.withOpacity(0.1)];
      borderColor = Colors.transparent;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: rank <= 3 || isMe
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: cardGradient,
          )
              : null,
          color: rank > 3 && !isMe ? Colors.white : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: rank <= 3 || isMe ? 2.5 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: rank <= 3 || isMe
                  ? borderColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: rank <= 3 || isMe ? 15 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildRankBadge(rank),
              const SizedBox(width: 16),
              _buildAvatar(player, rank, isMe),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            player.userName,
                            style: TextStyle(
                              color: rank <= 3
                                  ? Colors.white
                                  : (isMe ? Colors.white : Colors.black),
                              fontWeight: FontWeight.bold,
                              fontSize: rank <= 3 ? 18 : 16,
                              fontFamily: 'ComicNeue',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'TOI',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: rank <= 3 ? Colors.white70 : AppColors.warning,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${player.totalStars} étoiles',
                          style: TextStyle(
                            color: rank <= 3
                                ? Colors.white70
                                : (isMe ? Colors.white70 : AppColors.textSecondary),
                            fontSize: 13,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: rank <= 3 || isMe
                          ? Colors.white.withOpacity(0.25)
                          : AppColors.surface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '${player.totalScore}',
                      style: TextStyle(
                        color: rank <= 3 || isMe ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'points',
                    style: TextStyle(
                      color: rank <= 3
                          ? Colors.white70
                          : (isMe ? Colors.white70 : AppColors.textSecondary),
                      fontSize: 11,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    String emoji;
    LinearGradient? gradient;
    Color? solidColor;

    if (rank == 1) {
      emoji = '👑';
      gradient = const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      );
    } else if (rank == 2) {
      emoji = '🥈';
      gradient = const LinearGradient(
        colors: [Color(0xFFC0C0C0), Color(0xFF999999)],
      );
    } else if (rank == 3) {
      emoji = '🥉';
      gradient = const LinearGradient(
        colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
      );
    } else {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
        ),
        child: Center(
          child: Text(
            '$rank',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              fontSize: 16,
              fontFamily: 'ComicNeue',
            ),
          ),
        ),
      );
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildAvatar(LeaderboardEntry player, int rank, bool isMe) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: rank <= 3
              ? [Colors.white, Colors.white.withOpacity(0.9)]
              : (isMe
              ? [Colors.white, Colors.white.withOpacity(0.95)]
              : [AppColors.primary, AppColors.surface]),
        ),
        border: Border.all(
          color: rank <= 3 || isMe ? Colors.white : Colors.transparent,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          player.userName[0].toUpperCase(),
          style: TextStyle(
            color: rank <= 3 || isMe ? AppColors.primary : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
          ),
        ),
      ),
    );
  }

  Widget _buildUserHistory() {
    return _buildEmptyState(
      "📜 Ton Historique",
      "Tes exploits légendaires apparaîtront ici !",
    );
  }

  Widget _buildStatsTab() {
    if (_userStats == null) {
      return _buildEmptyState(
        "📊 Pas encore de stats",
        "Relève ton premier défi pour débloquer tes statistiques !",
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatCard(
            "🔥 Série Actuelle",
            "${_userStats!.currentStreak}",
            "jours consécutifs",
            Icons.local_fire_department,
            LinearGradient(colors: [AppColors.error, AppColors.warning]),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            "⭐ Total Étoiles",
            "${_userStats!.totalStars}",
            "étoiles collectées",
            Icons.star_rounded,
            LinearGradient(colors: [AppColors.warning, AppColors.surface]),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            "🏆 Record Personnel",
            "${_userStats!.bestStreak}",
            "jours - ton meilleur",
            Icons.emoji_events,
            LinearGradient(colors: [AppColors.info, AppColors.primary]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      String subtitle,
      IconData icon,
      Gradient gradient,
      ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'ComicNeue',
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.emoji_events_outlined,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 26,
              fontFamily: 'ComicNeue',
              shadows: [
                Shadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontFamily: 'ComicNeue',
              ),
            ),
          ),
        ],
      ),
    );
  }
}