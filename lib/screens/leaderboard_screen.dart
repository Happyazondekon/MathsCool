// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/user_model.dart';
import '../models/daily_challenge_model.dart';
import '../services/daily_challenge_service.dart';
import '../services/username_service.dart'; // ✅ AJOUT
import '../widgets/username_dialog.dart'; // ✅ AJOUT
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
  late AnimationController _bounceController;
  LeaderboardEntry? _userStats;
  List<LeaderboardEntry> _topPlayers = [];
  bool _isLoading = true;
  String _username = 'MathKid'; // ✅ AJOUT

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _loadLeaderboard();
    _checkAndPromptUsername(); // ✅ AJOUT
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  // ✅ NOUVELLE MÉTHODE : Vérifier et afficher le dialog si username = MathKid
  Future<void> _checkAndPromptUsername() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final usernameService = Provider.of<UsernameService>(context, listen: false);
    final username = await usernameService.getUsername(user.uid);

    if (mounted) {
      setState(() {
        _username = username;
      });

      // Si c'est encore MathKid, afficher le dialog après 1 seconde
      if (username == 'MathKid') {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          _showUsernamePrompt();
        }
      }
    }
  }

  // ✅ NOUVELLE MÉTHODE : Afficher le dialog de choix de username
  void _showUsernamePrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 400),
            )..forward(),
            curve: Curves.easeOutBack,
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade300,
                    Colors.blue.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Motifs décoratifs
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
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
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),

                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icône avec animation
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Text(
                              '🏆',
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Titre
                        const Text(
                          'Bienvenue Champion !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ComicNeue',
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Pour apparaître dans le classement',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontFamily: 'ComicNeue',
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Message dans un container
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Choisis ton nom d\'utilisateur unique !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicNeue',
                                  color: Colors.purple.shade700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue.shade600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Ton nom sera visible par tous les joueurs',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
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

                        // Boutons
                        Row(
                          children: [
                            // Bouton Plus tard
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Plus tard',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'ComicNeue',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Bouton Choisir mon nom
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
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit_rounded,
                                          color: Colors.purple.shade700,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Choisir mon nom',
                                          style: TextStyle(
                                            color: Colors.purple.shade700,
                                            fontSize: 16,
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

  // ✅ NOUVELLE MÉTHODE : Afficher le dialog de modification de username
  Future<void> _showUsernameDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => UsernameDialog(
        currentUsername: _username,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _username = result;
      });

      // Recharger le leaderboard pour voir le nouveau nom
      _loadLeaderboard();
    }
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
    final user = Provider.of<AppUser?>(context); // ✅ AJOUT pour StreamBuilder

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
            // Fond animé avec étoiles et confettis
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _AnimatedBackgroundPainter(_animationController.value),
                );
              },
            ),

            SafeArea(
              child: Column(
                children: [
                  _buildHeader(user), // ✅ MODIFIÉ
                  const SizedBox(height: 10),
                  if (!_isLoading && _topPlayers.length >= 3) _buildPodiumPreview(),
                  const SizedBox(height: 15),
                  _buildTabButtons(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _isLoading
                            ? _buildLoadingState()
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 6,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            '🏆 Chargement des champions... 🏆',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ MODIFIÉ : Header avec bouton d'édition du username
  Widget _buildHeader(AppUser? user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.35),
            Colors.white.withOpacity(0.25),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  '🏆 Classements',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontFamily: 'ComicNeue',
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                // ✅ AJOUT : Affichage du username avec bouton d'édition
                if (user != null)
                  StreamBuilder<String>(
                    stream: Provider.of<UsernameService>(context, listen: false).watchUsername(user.uid),
                    builder: (context, snapshot) {
                      final displayName = snapshot.data ?? _username;

                      return GestureDetector(
                        onTap: _showUsernameDialog,
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicNeue',
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
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
    );
  }

  Widget _buildPodiumPreview() {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          // Position 2 (Argent) - Gauche
          Positioned(
            left: 10,
            bottom: 10,
            child: _buildPodiumPlace(2, _topPlayers[1], 90),
          ),

          // Position 1 (Or) - Centre
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: _buildPodiumPlace(1, _topPlayers[0], 120),
            ),
          ),

          // Position 3 (Bronze) - Droite
          Positioned(
            right: 10,
            bottom: 10,
            child: _buildPodiumPlace(3, _topPlayers[2], 70),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(int rank, LeaderboardEntry player, double height) {
    final colors = {
      1: [const Color(0xFFFFD700), const Color(0xFFFFA500)], // Or
      2: [const Color(0xFFC0C0C0), const Color(0xFF999999)], // Argent
      3: [const Color(0xFFCD7F32), const Color(0xFF8B4513)], // Bronze
    };

    final emojis = {1: '👑', 2: '🥈', 3: '🥉'};
    final sizes = {1: 50.0, 2: 42.0, 3: 38.0};

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (rank * 150)),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              final bounce = rank == 1 ? sin(_bounceController.value * pi) * 5 : 0.0;
              return Transform.translate(
                offset: Offset(0, -bounce),
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar avec couronne et effet glow
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Effet glow pour le 1er
                    if (rank == 1)
                      Container(
                        width: sizes[rank]! + 20,
                        height: sizes[rank]! + 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                    Container(
                      width: sizes[rank],
                      height: sizes[rank],
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: colors[rank]!),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: colors[rank]![0].withOpacity(0.6),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          emojis[rank]!,
                          style: TextStyle(fontSize: sizes[rank]! * 0.55),
                        ),
                      ),
                    ),

                    // Couronne animée pour le 1er
                    if (rank == 1)
                      Positioned(
                        top: -15,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: sin(_animationController.value * 2 * pi) * 0.1,
                              child: const Text('👑', style: TextStyle(fontSize: 30)),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Nom avec style
                Container(
                  constraints: const BoxConstraints(maxWidth: 95),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                  ),
                  child: Text(
                    player.userName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: rank == 1 ? 15 : 13,
                      fontFamily: 'ComicNeue',
                      shadows: const [
                        Shadow(color: Colors.black38, blurRadius: 3),
                      ],
                    ),
                  ),
                ),

                // Score avec badge
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors[rank]!),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${player.totalScore}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: rank == 1 ? 16 : 14,
                          fontFamily: 'ComicNeue',
                          shadows: const [
                            Shadow(color: Colors.black26, blurRadius: 2),
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
      },
    );
  }

  Widget _buildTabButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.35),
            Colors.white.withOpacity(0.25),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFFFF8E1)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        labelColor: Colors.red,
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontFamily: 'ComicNeue',
          fontSize: 15,
          shadows: [
            Shadow(color: Colors.black12, blurRadius: 2),
          ],
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: '🏅 TOP 10'),
          Tab(text: '👤 MOI'),
          Tab(text: '📊 STATS'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    if (_topPlayers.isEmpty) {
      return _buildEmptyState(
        "🎯 Aucun score",
        "Sois le premier champion !",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _topPlayers.length,
      itemBuilder: (context, index) {
        final player = _topPlayers[index];
        final rank = index + 1;
        final isMe = player.userId == Provider.of<AppUser?>(context)?.uid;
        final isTop3 = rank <= 3;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 80)),
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
              gradient: isMe
                  ? LinearGradient(
                colors: [
                  Colors.white,
                  Colors.amber.shade100,
                ],
              )
                  : LinearGradient(
                colors: [
                  Colors.white.withOpacity(isTop3 ? 0.40 : 0.25),
                  Colors.white.withOpacity(isTop3 ? 0.35 : 0.20),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isTop3
                    ? _getRankColor(rank)
                    : (isMe ? Colors.amber : Colors.white.withOpacity(0.4)),
                width: isTop3 || isMe ? 4 : 2,
              ),
              boxShadow: [
                if (isTop3 || isMe)
                  BoxShadow(
                    color: (isMe ? Colors.amber : _getRankColor(rank))
                        .withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: Stack(
              children: [
                // Effet de brillance pour top 3
                if (isTop3)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _ShimmerPainter(
                              _animationController.value,
                              _getRankColor(rank),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.all(isTop3 ? 18 : 14),
                  child: Row(
                    children: [
                      _buildRankBadge(rank),
                      const SizedBox(width: 16),
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
                                      color: isMe ? Colors.red.shade700 : Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: isTop3 ? 19 : 16,
                                      fontFamily: 'ComicNeue',
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.amber, Colors.orange.shade600],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'TOI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (isTop3)
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _getRankColor(rank).withOpacity(0.4),
                                      _getRankColor(rank).withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Text(
                                  '⭐ LÉGENDE ⭐',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'ComicNeue',
                                    shadows: [
                                      Shadow(color: Colors.black26, blurRadius: 2),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade500,
                                  Colors.deepOrange.shade700,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              '${player.totalScore}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: isTop3 ? 22 : 18,
                                fontFamily: 'ComicNeue',
                                shadows: const [
                                  Shadow(
                                    color: Colors.black38,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${player.totalStars}',
                                  style: TextStyle(
                                    color: isMe ? Colors.red.shade700 : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'ComicNeue',
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.7),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Center(
          child: Text('👑', style: TextStyle(fontSize: 30)),
        ),
      );
    }

    if (rank == 2) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFC0C0C0), Color(0xFF999999)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Text('🥈', style: TextStyle(fontSize: 28)),
        ),
      );
    }

    if (rank == 3) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCD7F32).withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Text('🥉', style: TextStyle(fontSize: 28)),
        ),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2.5),
      ),
      child: Center(
        child: Text(
          '$rank',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'ComicNeue',
            shadows: [
              Shadow(color: Colors.black26, blurRadius: 2),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return Colors.transparent;
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
            const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
            ),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            "⭐ Total Étoiles",
            "${_userStats!.totalStars}",
            "étoiles collectées",
            Icons.star_rounded,
            const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            "🏆 Record Personnel",
            "${_userStats!.bestStreak}",
            "jours - ton meilleur",
            Icons.emoji_events,
            const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
            ),
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
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
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
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
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
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black87,
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
                          color: Colors.grey.shade600,
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
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
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
          const SizedBox(height: 25),
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

// Painter pour le fond animé avec étoiles et confettis
class _AnimatedBackgroundPainter extends CustomPainter {
  final double animationValue;

  _AnimatedBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = Random(42);

    // Dessiner des étoiles scintillantes
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final phase = (animationValue + i * 0.1) % 1.0;
      final opacity = (sin(phase * 2 * pi) * 0.5 + 0.5) * 0.3;

      paint.color = Colors.white.withOpacity(opacity);

      // Étoiles à 5 branches
      final starSize = random.nextDouble() * 8 + 4;
      _drawStar(canvas, Offset(x, y), starSize, paint);
    }

    // Confettis flottants
    for (int i = 0; i < 20; i++) {
      final x = (random.nextDouble() * size.width + animationValue * 50) % size.width;
      final y = (random.nextDouble() * size.height + animationValue * 100) % size.height;
      final confettiSize = random.nextDouble() * 6 + 3;

      final colors = [
        Colors.yellow,
        Colors.pink,
        Colors.cyan,
        Colors.orange,
      ];

      paint.color = colors[i % colors.length].withOpacity(0.4);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(animationValue * 2 * pi + i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: confettiSize, height: confettiSize * 1.5),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }

    // Symboles mathématiques flottants
    final mathSymbols = ['🎯', '⭐', '🏆', '💎', '🔥', '⚡'];
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final textPainter = TextPainter(
        text: TextSpan(
          text: mathSymbols[random.nextInt(mathSymbols.length)],
          style: TextStyle(
            fontSize: random.nextDouble() * 20 + 15,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Appliquer l'opacité basée sur l'animation
      final opacity = (sin((animationValue + i * 0.2) * 2 * pi) * 0.5 + 0.5) * 0.15;
      canvas.saveLayer(
        Rect.fromLTWH(x, y, textPainter.width, textPainter.height),
        Paint()..color = Colors.white.withOpacity(opacity),
      );
      textPainter.paint(canvas, Offset(x, y));
      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const points = 5;
    const angle = (2 * pi) / points;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? size : size * 0.5;
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
  bool shouldRepaint(_AnimatedBackgroundPainter oldDelegate) => true;
}

// Painter pour l'effet de brillance
class _ShimmerPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _ShimmerPainter(this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0),
          color.withOpacity(0.15),
          color.withOpacity(0),
        ],
        stops: [
          (animationValue - 0.3).clamp(0.0, 1.0),
          animationValue.clamp(0.0, 1.0),
          (animationValue + 0.3).clamp(0.0, 1.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) => true;
}