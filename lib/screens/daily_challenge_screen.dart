// lib/screens/daily_challenge_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/user_model.dart';
import '../models/daily_challenge_model.dart';
import '../models/exercise_model.dart';
import '../services/daily_challenge_service.dart';
import '../services/hybrid_exercise_service.dart';
import '../widgets/chatbot_floating_button.dart';
import 'daily_challenge_result_screen.dart';

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

  // Timer
  late DateTime _startTime;
  int _elapsedSeconds = 0;

  // Sauvegarde des réponses
  Map<String, bool> _answers = {};

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadChallenge();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadChallenge() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) {
      print('❌ User is null');
      return;
    }

    print('✅ User ID: ${user.uid}');

    final service = Provider.of<DailyChallengeService>(context, listen: false);

    try {
      print('🔍 Vérification completion...');

      // Vérifier si déjà complété
      final completed = await service.hasTodayChallengeCompleted(user.uid);

      print('📊 Défi complété: $completed');

      if (completed) {
        setState(() {
          _hasAlreadyCompleted = true;
          _isLoading = false;
        });
        return;
      }

      print('🎯 Récupération du défi...');

      // Récupérer le défi
      final challenge = await service.getTodayChallenge('CE2'); // TODO: Utiliser le niveau de l'utilisateur

      print('✅ Défi récupéré: ${challenge.theme} - ${challenge.level}');

      print('📚 Chargement des exercices...');

      // Charger les exercices
      final exerciseService = HybridExerciseService();
      final exercises = await exerciseService.getExercises(
        level: challenge.level,
        theme: challenge.theme,
        count: challenge.totalQuestions,
      );

      print('✅ ${exercises.length} exercices chargés');

      if (mounted) {
        setState(() {
          _challenge = challenge;
          _exercises = exercises;
          _isLoading = false;
        });
        _animationController.forward();

        print('✅ UI mise à jour avec succès');
      }
    } catch (e, stackTrace) {
      print('❌ Erreur chargement défi: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _answerQuestion(int selectedIndex) {
    final exercise = _exercises[_currentIndex];
    final isCorrect = selectedIndex == exercise.correctAnswer;

    if (isCorrect) {
      setState(() => _score++);
    }

    _answers[exercise.question] = isCorrect;

    setState(() {
      if (_currentIndex < _exercises.length - 1) {
        _currentIndex++;
        _animationController.reset();
        _animationController.forward();
      } else {
        _finishChallenge();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (_hasAlreadyCompleted) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
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
                  const Text(
                    'Défi déjà complété ! 🎉',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Reviens demain pour un nouveau défi !',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Retour', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_challenge == null || _exercises.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Aucun défi disponible')),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
          ),
        ),
        child: Stack(
          children: [
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
            const Positioned(
              bottom: 20,
              right: 20,
              child: ChatbotFloatingButton(),
            ),
          ],
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
              color: Colors.green,
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

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _animationController.value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Carte Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
              child: Text(
                exercise.question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Options
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.3,
                ),
                itemCount: exercise.options.length,
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

  Widget _buildOptionButton(int index, Exercise exercise) {
    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            exercise.options[index],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}