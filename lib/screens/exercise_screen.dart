import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// Models & Data
import 'package:mathscool/models/exercise_model.dart';
import 'package:mathscool/data/static_exercises.dart';
import 'package:mathscool/models/user_model.dart';

// Services
import 'package:mathscool/services/progress_service.dart';
import 'package:mathscool/services/lives_service.dart';
import 'package:mathscool/services/achievement_service.dart';
import 'package:mathscool/services/hybrid_exercise_service.dart';
import 'package:mathscool/models/achievement_model.dart';

// Screens
import 'package:mathscool/screens/help_screen.dart';
import 'package:mathscool/screens/progress_screen.dart';
import 'package:mathscool/screens/store_screen.dart';
import 'package:mathscool/screens/achievements_screen.dart';

// Utils & Widgets
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/widgets/lives_display.dart';
import 'package:mathscool/widgets/chatbot_floating_button.dart';
import 'package:mathscool/widgets/connection_status_badge.dart';

import ' chatbot_screen.dart';
import '../services/sound_service.dart';

class ExerciseScreen extends StatefulWidget {
  final String level;
  final String theme;
  final bool isInfiniteMode;

  const ExerciseScreen({
    super.key,
    required this.level,
    required this.theme,
    this.isInfiniteMode = false,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with SingleTickerProviderStateMixin {
  List<Exercise> _exercises = [];
  int _currentIndex = 0;
  int _score = 0;
  String _feedbackMessage = '';
  bool _showFeedback = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late final ProgressService _progressService;
  bool _isSaving = false;
  bool _isLoadingExercises = true;
  String? _connectionStatus;

  bool get isCollege => ['6ème', '5ème', '4ème', '3ème'].contains(widget.level);

  @override
  void initState() {
    super.initState();
    _progressService = ProgressService();

    _loadExercises();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = Provider.of<AppUser?>(context, listen: false);
      final livesService = Provider.of<LivesService>(context, listen: false);
      final achievementService = Provider.of<AchievementService>(context, listen: false);

      if (user != null) {
        await achievementService.initialize();
        await achievementService.loadUserAchievements(user.uid);

        final canPlay = await livesService.canPlay(user.uid);
        if (!canPlay) {
          _showNoLivesDialog();
        }
      }
    });
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoadingExercises = true);

    try {
      final hybridService = HybridExerciseService();

      final exerciseCount = widget.isInfiniteMode ? 100 : 20;

      final exercises = await hybridService.getExercises(
        level: widget.level,
        theme: widget.theme,
        count: exerciseCount,
        forceGenerated: widget.isInfiniteMode,
      );

      final stats = await hybridService.getExerciseStats(widget.level, widget.theme);

      if (mounted) {
        setState(() {
          _exercises = exercises;
          _isLoadingExercises = false;

          if (widget.isInfiniteMode) {
            _connectionStatus = stats['hasConnection']
                ? 'Mode Infini'
                : '';
          } else {
            _connectionStatus = stats['hasConnection']
                ? ''
                : 'Mode hors ligne';
          }
        });

        if (_exercises.isNotEmpty) {
          _animationController.forward();
        }
      }
    } catch (e) {
      print('❌ Erreur chargement exercices: $e');
      if (mounted) {
        setState(() {
          _exercises = [];
          _isLoadingExercises = false;
          _connectionStatus = '⚠️ Erreur de chargement';
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _answerQuestion(int selectedIndex) async {
    if (_isSaving) return;

    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final exercise = _exercises[_currentIndex];
    final isCorrect = selectedIndex == exercise.correctAnswer;

    // ✅ AJOUTER LE SON
    final soundService = SoundService();

    final livesService = Provider.of<LivesService>(context, listen: false);

    if (isCorrect) {
      await soundService.playCorrectAnswer();
      setState(() {
        _score++;
        _feedbackMessage = isCollege
            ? "Excellent ! Réponse correcte ✅"
            : "Bravo ! 🥳 C'est correct 🎉";
        _showFeedback = true;
      });
    } else {
      await soundService.playWrongAnswer();
      bool stillHasLives = await livesService.loseLife(user.uid);

      if (!stillHasLives) {
        _showNoLivesDialog();
        return;
      }

      setState(() {
        _feedbackMessage = "Oups ! Tu perds une vie 💔";
        _showFeedback = true;
      });
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _progressService.updateResult(
        user.uid,
        exercise.question,
        selectedIndex,
        exercise.correctAnswer,
      );

      final achievementService = Provider.of<AchievementService>(context, listen: false);

      List<Achievement> newAchievements = await achievementService.updateProgress(
        userId: user.uid,
        type: AchievementType.exercisesCompleted,
        incrementBy: 1,
        level: widget.level,
      );
      // AJOUTER CES LIGNES :

// Si mode infini
      if (widget.isInfiniteMode) {
        final infiniteAchievements = await achievementService.updateInfiniteModeProgress(
          userId: user.uid,
          exercisesCompleted: 1,
        );
        newAchievements.addAll(infiniteAchievements);
      }

// Vérifier les achievements temporels
      final timeAchievements = await achievementService.checkTimeBasedAchievements(user.uid);
      newAchievements.addAll(timeAchievements);

// Si score parfait sur tout le thème (à la fin)
      if (isCorrect && _currentIndex == _exercises.length - 1 && _score == _exercises.length) {
        final themeAchievements = await achievementService.updateThemeMastery(
          userId: user.uid,
          theme: widget.theme,
          level: widget.level,
        );
        newAchievements.addAll(themeAchievements);
      }

      if (isCorrect && _score == _exercises.length) {
        final perfectAchievements = await achievementService.updateProgress(
          userId: user.uid,
          type: AchievementType.perfectScore,
          incrementBy: 1,
          level: widget.level,
        );
        newAchievements.addAll(perfectAchievements);
      }

      if (newAchievements.isNotEmpty && mounted) {
        _showAchievementUnlockedSnackbar(newAchievements);
      }

    } catch (e) {
      print('Erreur lors de la sauvegarde: $e');
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showFeedback = false;
        _isSaving = false;
        if (_currentIndex < _exercises.length - 1) {
          _currentIndex++;
          _animationController.reset();
          _animationController.forward();
        } else {
          _currentIndex++;
        }
      });
    }
  }

  void _showAchievementUnlockedSnackbar(List<Achievement> achievements) {
    for (var achievement in achievements) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(achievement.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🎉 Achievement débloqué !',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${achievement.name} (+${achievement.livesReward} vies)',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Voir',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AchievementsScreen()),
              );
            },
          ),
        ),
      );
    }
  }

  void _showNoLivesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Text("💔", style: TextStyle(fontSize: 40)),
              ),
              const SizedBox(height: 16),
              const Text(
                "Aïe ! Plus de vies 💔",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: Color(0xFFD32F2F),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Tu as utilisé toutes tes vies pour le moment.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontFamily: 'ComicNeue'),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tu peux attendre qu'elles se rechargent ou en récupérer tout de suite !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'ComicNeue'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Quitter",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'ComicNeue',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StoreScreen()),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flash_on, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Recharger",
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

  void _goToManual() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatbotScreen(userId: '',),
      ),
    );
  }

  void _goToProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProgressScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingExercises) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF6B6B),
                Color(0xFFD32F2F),
                Colors.red,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.isInfiniteMode
                              ? 'Génération infinie...'
                              : 'Préparation des exercices...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'ComicNeue',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_exercises.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF6B6B),
                Color(0xFFD32F2F),
                Colors.red,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade300,
                                  Colors.yellow.shade500,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Text("🔧", style: TextStyle(fontSize: 80)),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Exercices en préparation ! 🚧",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ComicNeue',
                                    color: Color(0xFFD32F2F),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Le professeur prépare les sujets de ${widget.theme}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'ComicNeue',
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B6B),
              Color(0xFFD32F2F),
              Colors.red,
            ],
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              painter: _MathBackgroundPainter(),
              size: MediaQuery.of(context).size,
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _currentIndex < _exercises.length
                        ? _buildExerciseScreen()
                        : _buildResultsScreen(),
                  ),
                ],
              ),
            ),
            if (_showFeedback) _buildFeedbackOverlay(),
            if (_isSaving)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            if (_connectionStatus != null)
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: ConnectionStatusBadge(
                    status: _connectionStatus!,
                    isInfiniteMode: widget.isInfiniteMode,
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              right: 20,
              child: const ChatbotFloatingButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFD32F2F)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12),

          const LivesDisplay(showTimer: false),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.theme,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ComicNeue',
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${widget.level} • $_score/${_exercises.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseScreen() {
    final exercise = _exercises[_currentIndex];
    bool useListView = exercise.options.any((option) => option.length > 15);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 22,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      children: List.generate(
                        _exercises.length,
                            (index) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: index <= _currentIndex
                                  ? Colors.yellow.shade400
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: index < _currentIndex
                                ? const Icon(Icons.star, color: Colors.white, size: 14)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade300,
                    Colors.yellow.shade500,
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Question ${_currentIndex + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Hero(
              tag: 'question_card',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 3,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        size: 40,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: buildMathText(
                        exercise.question,
                        fontSize: isCollege && exercise.question.length > 50 ? 20 : 26,
                        color: Color(0xFFD32F2F),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: useListView
                  ? ListView.builder(
                itemCount: exercise.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildOptionButton(index, exercise, isList: true),
                  );
                },
              )
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemCount: exercise.options.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return _buildOptionButton(index, exercise);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, Exercise exercise, {bool isList = false}) {
    final colors = [
      const Color(0xFFFF7043),
      const Color(0xFF66BB6A),
      const Color(0xFF42A5F5),
      const Color(0xFFFFCA28),
    ];

    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: _isSaving ? null : () => _answerQuestion(index),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.95, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          height: isList ? 70 : null,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                Color.lerp(color, Colors.white, 0.2)!,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 3,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: buildMathText(
                  exercise.options[index],
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // FEEDBACK OVERLAY - REDESIGN COMPLET
  Widget _buildFeedbackOverlay() {
    final isCorrect = _feedbackMessage.contains("Bravo") || _feedbackMessage.contains("correcte");

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: isCorrect ? Colors.green : Colors.red,
                width: 4,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isCorrect
                    ? [Colors.green.shade50, Colors.white]
                    : [Colors.red.shade50, Colors.white],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    isCorrect ? "🎉" : "💔",
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _feedbackMessage,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                    height: 1.3,
                    fontFamily: 'ComicNeue',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // RESULTS SCREEN - REDESIGN COMPLET
  Widget _buildResultsScreen() {
    final double percentage = (_score / _exercises.length) * 100.0;
    final bool isMathKid = percentage >= 100.0;
    final bool isOnRightTrack = percentage >= 50.0 && percentage < 100.0;

    String titleText;
    if (isCollege) {
      titleText = isMathKid ? '🎉 Tu es un Expert ! 🎉' : (isOnRightTrack ? '🌟 Bien joué ! 🌟' : '🙂 Courage !');
    } else {
      titleText = isMathKid ? '🎉 Tu es un Mathkid! 🎉' : (isOnRightTrack ? '🌟 Tu es sur la bonne voie! 🌟' : '🙂 Presque un Mathkid!');
    }

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade300,
                    Colors.yellow.shade500,
                  ],
                ),
              ),
              child: Center(
                child: Lottie.asset(
                  isMathKid || isOnRightTrack
                      ? 'assets/animations/success.json'
                      : 'assets/animations/encouragement.json',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    titleText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isMathKid
                          ? Color(0xFFD32F2F)
                          : isOnRightTrack
                          ? Colors.green
                          : Colors.orange,
                      fontFamily: 'ComicNeue',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isMathKid
                        ? 'Parfait! Tu maîtrises parfaitement! 🎯'
                        : isOnRightTrack
                        ? 'Excellent travail! Continue comme ça! 💪'
                        : 'N\'hésite pas à demander de l\'aide pour t\'améliorer! 📚',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontFamily: 'ComicNeue',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 20,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 20,
                          width: 200 * (_score / _exercises.length.toDouble()),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isMathKid
                                  ? [Color(0xFFD32F2F), Colors.red.shade400]
                                  : isOnRightTrack
                                  ? [Colors.green, Colors.lightGreen]
                                  : [Colors.orange, Colors.deepOrange],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${percentage.toInt()}% correct • $_score/${_exercises.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (percentage >= 50.0) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton.icon(
                        onPressed: _goToProgress,
                        icon: const Icon(Icons.trending_up, color: Colors.white, size: 20),
                        label: const Text(
                          'Voir ma progression',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9C27B0),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                  if (percentage < 50.0) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton.icon(
                        onPressed: _goToManual,
                        icon: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                        label: const Text(
                          'Consulter le Manuel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
                          label: const Text(
                            'Retour',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'ComicNeue',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD32F2F),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                              _score = 0;
                              _animationController.reset();
                              _animationController.forward();
                            });
                          },
                          icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 20),
                          label: const Text(
                            'Rejouer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'ComicNeue',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MathBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Ajout de symboles du collège
    final mathSymbols = ['+', '-', '×', '÷', '=', '%', '√', 'x', 'y', 'π'];
    final random = Random();

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final symbolSize = random.nextDouble() * 30 + 10;

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), symbolSize / 2, paint);
      } else if (i % 3 == 1) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${random.nextInt(10)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: symbolSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
            text: mathSymbols[random.nextInt(mathSymbols.length)],
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: symbolSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

InlineSpan buildMathText(
    String input, {
      double fontSize = 22,
      Color color = Colors.black,
    }) {
  final Map<String, String> expo = {
    "0": "⁰",
    "1": "¹",
    "2": "²",
    "3": "³",
    "4": "⁴",
    "5": "⁵",
    "6": "⁶",
    "7": "⁷",
    "8": "⁸",
    "9": "⁹",
    "-": "⁻",
  };

  List<InlineSpan> spans = [];

  for (int i = 0; i < input.length; i++) {
    if (input[i] == '^' && i + 1 < input.length) {
      String exp = "";
      int j = i + 1;

      while (j < input.length && expo.containsKey(input[j])) {
        exp += expo[input[j]]!;
        j++;
      }

      spans.add(
        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: Text(
              exp,
              style: TextStyle(
                fontSize: fontSize * 0.65,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'ComicNeue',
              ),
            ),
          ),
        ),
      );

      i = j - 1;
    } else {
      spans.add(
        TextSpan(
          text: input[i],
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'ComicNeue',
          ),
        ),
      );
    }
  }

  return TextSpan(children: spans);
}