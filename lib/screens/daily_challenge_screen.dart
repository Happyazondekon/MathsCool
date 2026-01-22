// lib/screens/daily_challenge_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/user_model.dart';
import '../models/daily_challenge_model.dart';
import '../models/exercise_model.dart';
import '../services/daily_challenge_service.dart';
import '../services/hybrid_exercise_service.dart';
import '../services/lives_service.dart';
import '../services/sound_service.dart';
import '../utils/colors.dart';
import '../widgets/chatbot_floating_button.dart';
import 'daily_challenge_result_screen.dart';
import 'store_screen.dart';
import 'dart:math';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({Key? key}) : super(key: key);

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> with SingleTickerProviderStateMixin {
  DailyChallenge? _challenge;
  List<Exercise> _exercises = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  bool _hasAlreadyCompleted = false;
  bool _showLevelSelection = true;
  String? _selectedLevel;

  // Timer
  late DateTime _startTime;
  int _elapsedSeconds = 0;

  // Sauvegarde des réponses
  Map<String, bool> _answers = {};

  // Feedback
  String _feedbackMessage = '';
  bool _showFeedback = false;
  bool _isSaving = false;

  late AnimationController _animationController;

  // Liste des niveaux
  final List<String> _levels = [
    'CI', 'CP', 'CE1', 'CE2', 'CM1', 'CM2',
    '6ème', '5ème', '4ème', '3ème'
  ];

  final List<String> _descriptions = [
    'Pour les débutants',
    'Premiers calculs',
    'Bases de mathématiques',
    'Niveau intermédiaire',
    'Niveau avancé',
    'Expert',
    'Entrée au collège',
    'Niveau central',
    'Approfondissement',
    'Préparation brevet'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _checkIfAlreadyCompleted();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkIfAlreadyCompleted() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final service = Provider.of<DailyChallengeService>(context, listen: false);
      final completed = await service.hasTodayChallengeCompleted(user.uid);

      if (mounted) {
        setState(() {
          _hasAlreadyCompleted = completed;
          _isLoading = false;
          if (completed) _showLevelSelection = false;
        });
      }
    } catch (e) {
      print('❌ Erreur vérification: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadChallengeWithLevel(String level) async {
    setState(() {
      _isLoading = true;
      _showLevelSelection = false;
      _selectedLevel = level;
    });

    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final service = Provider.of<DailyChallengeService>(context, listen: false);

    try {
      // Récupérer le défi
      final challenge = await service.getTodayChallenge(level);

      // Charger les exercices
      final exerciseService = HybridExerciseService();
      final exercises = await exerciseService.getExercises(
        level: challenge.level,
        theme: challenge.theme,
        count: challenge.totalQuestions,
      );

      if (mounted) {
        setState(() {
          _challenge = challenge;
          _exercises = exercises;
          _isLoading = false;
          _startTime = DateTime.now();
        });
        _animationController.forward();
      }
    } catch (e) {
      print('❌ Erreur chargement défi: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _answerQuestion(int selectedIndex) async {
    if (_isSaving) return;

    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final exercise = _exercises[_currentIndex];
    final isCorrect = selectedIndex == exercise.correctAnswer;
    final soundService = SoundService();

    final livesService = Provider.of<LivesService>(context, listen: false);

    setState(() => _isSaving = true);

    if (isCorrect) {
      await soundService.playCorrectAnswer();
      setState(() {
        _score++;
        _feedbackMessage = "Bravo ! 🥳 C'est correct 🎉";
        _showFeedback = true;
      });
    } else {
      await soundService.playWrongAnswer();
      // Perte de vie
      bool stillHasLives = await livesService.loseLife(user.uid);

      if (!stillHasLives) {
        setState(() => _isSaving = false);
        _showNoLivesDialog();
        return;
      }

      setState(() {
        _feedbackMessage = "Oups ! Tu perds une vie 💔";
        _showFeedback = true;
      });
    }

    _answers[exercise.question] = isCorrect;

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
          _finishChallenge();
        }
      });
    }
  }

  Future<void> _finishChallenge() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null || _challenge == null) return;

    _elapsedSeconds = DateTime.now().difference(_startTime).inSeconds;

    final result = DailyChallengeResult(
      userId: user.uid,
      challengeId: _challenge!.id,
      score: _score,
      timeSeconds: _elapsedSeconds,
      completedAt: DateTime.now(),
      answers: _answers,
      stars: DailyChallengeResult.calculateStars(_score, _exercises.length),
    );

    try {
      final service = Provider.of<DailyChallengeService>(context, listen: false);
      await service.saveResult(result);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DailyChallengeResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      print('Erreur sauvegarde résultat: $e');
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
              colors: [AppColors.error.withOpacity(0.1), Colors.white],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Text("💔", style: TextStyle(fontSize: 40)),
              ),
              const SizedBox(height: 16),
              Text(
                "Aïe ! Plus de vies 💔",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Tu as utilisé toutes tes vies pour le moment.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontFamily: 'ComicNeue'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Quitter",
                        style: TextStyle(
                          color: AppColors.textSecondary,
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
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StoreScreen()),
                        );
                      },
                      child: const Text(
                        "Recharger ⚡",
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontWeight: FontWeight.bold,
                        ),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (_hasAlreadyCompleted) {
      return _buildAlreadyCompletedScreen();
    }

    if (_showLevelSelection) {
      return _buildLevelSelectionScreen();
    }

    if (_challenge == null || _exercises.isEmpty) {
      return _buildNoChallengeScreen();
    }

    return Scaffold(
      body: Container(
        // Fond avec l'image MathsCool
        decoration: BoxDecoration(
        image: DecorationImage(
        image: const AssetImage('assets/images/bgc_math.png'),
    fit: BoxFit.cover,
    opacity: 0.15, // Opacité légère pour la lisibilité
    ),
    ),
    child :Container(
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
                    child: _buildExerciseScreen(),
                  ),
                ],
              ),
            ),
            if (_showFeedback) _buildFeedbackOverlay(),
            if (_isSaving && !_showFeedback)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            const Positioned(
              bottom: 20,
              right: 20,
              child: ChatbotFloatingButton(),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildAlreadyCompletedScreen() {
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/success.json', height: 200),
                const SizedBox(height: 20),
                Text(
                  'Défi déjà complété ! 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                    fontFamily: 'ComicNeue',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Reviens demain pour un nouveau défi !',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textLight.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Retour', style: TextStyle(fontSize: 18, fontFamily: 'ComicNeue')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoChallengeScreen() {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: AppColors.textLight),
              const SizedBox(height: 20),
              Text(
                'Aucun défi disponible',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textLight,
                  fontFamily: 'ComicNeue',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSelectionScreen() {
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
              _buildSelectionHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _levels.length,
                    itemBuilder: (context, index) {
                      return _buildLevelCard(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
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
                child: Text(
                  'Défi Quotidien 🏆',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.warning, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Choisis ton niveau de défi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(int index) {
    final List<List<Color>> gradientColors = [
      [AppColors.accent, AppColors.warning],                    // CI
      [AppColors.info, AppColors.secondary],                    // CP
      [AppColors.success, Color(0xFF059669)],                   // CE1
      [AppColors.gradientEnd, Color(0xFFEC4899)],               // CE2
      [AppColors.secondary, Color(0xFF7C3AED)],                 // CM1
      [AppColors.error, Color(0xFFDC2626)],                     // CM2
      [Color(0xFF06B6D4), Color(0xFF0891B2)],                   // 6ème
      [Color(0xFF14B8A6), Color(0xFF0D9488)],                   // 5ème
      [AppColors.warning, Color(0xFFF97316)],                   // 4ème
      [Color(0xFF64748B), Color(0xFF475569)],
    ];

    final List<IconData> icons = [
      Icons.child_care_rounded,
      Icons.emoji_people_rounded,
      Icons.school_rounded,
      Icons.psychology_rounded,
      Icons.emoji_objects_rounded,
      Icons.workspace_premium_rounded,
      Icons.menu_book_rounded,
      Icons.calculate_rounded,
      Icons.architecture_rounded,
      Icons.history_edu_rounded,
    ];

    final bool isCollege = index >= 6;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 80)),
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
      child: GestureDetector(
        onTap: () => _loadChallengeWithLevel(_levels[index]),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors[index],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: gradientColors[index][1].withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (isCollege)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Collège',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: gradientColors[index][1],
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        icons[index],
                        size: 44,
                        color: gradientColors[index][1],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _levels[index],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        _descriptions[index],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${_challenge!.theme} - ${_challenge!.level}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  'Question ${_currentIndex + 1}/${_exercises.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
          scale: Tween<double>(begin: 0.8, end: 1.0).evaluate(_animationController),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Barre de progression
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
                                  ? AppColors.accent
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

            // Badge Question
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.warning, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, size: 24, color: Colors.white),
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

            // Carte Question
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
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: 40,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: buildMathText(
                  exercise.question,
                  fontSize: 26,
                  color: AppColors.primary,
                ),
              ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Options
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
          return Transform.scale(scale: value, child: child);
        },
        child: Container(
          height: isList ? 70 : null,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.8)],
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
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: buildMathText(
                  exercise.options[index],
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackOverlay() {
    final isCorrect = _feedbackMessage.contains("Bravo");

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, double value, child) {
            return Transform.scale(scale: value, child: child);
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
}

class _MathBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

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
// Après la classe _MathBackgroundPainter, ajoutez :

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