import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';

class AchievementService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Achievement> _allAchievements = [];
  Map<String, UserAchievement> _userAchievements = {};

  List<Achievement> get allAchievements => _allAchievements;
  Map<String, UserAchievement> get userAchievements => _userAchievements;

  // --- CORRECTION 1 : Constructeur pour charger la liste statique immédiatement ---
  AchievementService() {
    _allAchievements = PredefinedAchievements.getAllAchievements();
  }

  /// Initialiser les achievements (Garder pour compatibilité)
  Future<void> initialize() async {
    if (_allAchievements.isEmpty) {
      _allAchievements = PredefinedAchievements.getAllAchievements();
    }
  }

  /// Charger les achievements de l'utilisateur
  Future<void> loadUserAchievements(String userId) async {
    // S'assurer que la liste de référence est chargée
    if (_allAchievements.isEmpty) initialize();

    try {
      final doc = await _firestore
          .collection('userAchievements')
          .doc(userId)
          .get();

      _userAchievements = {};

      // 1. Initialiser avec des valeurs par défaut pour TOUS les achievements définis dans l'app
      // C'est crucial pour les nouveaux achievements ajoutés lors d'une mise à jour
      for (var achievement in _allAchievements) {
        _userAchievements[achievement.id] = UserAchievement(
          achievementId: achievement.id,
          currentProgress: 0,
          isCompleted: false,
          isClaimed: false,
        );
      }

      // 2. Si des données existent dans Firestore, on met à jour par dessus les défauts
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            // On ne charge que si l'achievement existe encore dans notre code
            if (_allAchievements.any((a) => a.id == key)) {
              _userAchievements[key] = UserAchievement.fromFirestore(value);
            }
          }
        });
      } else {
        // Premier chargement : on crée le doc vide pour éviter de recharger à chaque fois
        await _saveUserAchievements(userId);
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Erreur chargement achievements: $e');
    }
  }

  /// Sauvegarder les achievements de l'utilisateur
  Future<void> _saveUserAchievements(String userId) async {
    try {
      final Map<String, dynamic> data = {};
      _userAchievements.forEach((key, value) {
        data[key] = value.toFirestore();
      });

      await _firestore
          .collection('userAchievements')
          .doc(userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('Erreur sauvegarde achievements: $e');
    }
  }

  /// Mettre à jour la progression d'un achievement
  Future<List<Achievement>> updateProgress({
    required String userId,
    required AchievementType type,
    int incrementBy = 1,
    String? level,
  }) async {
    // S'assurer que tout est chargé avant de traiter
    if (_allAchievements.isEmpty) initialize();
    if (_userAchievements.isEmpty) await loadUserAchievements(userId);

    List<Achievement> newlyCompleted = [];
    bool needsSave = false;

    try {
      for (var achievement in _allAchievements) {
        // Vérifier si l'achievement correspond au type d'action (ex: exercice terminé)
        if (achievement.type != type) continue;

        // Vérifier le niveau requis si applicable
        if (achievement.requiredLevel != null &&
            achievement.requiredLevel != level) continue;

        // --- CORRECTION 2 : Gestion robuste si l'entrée est nulle ---
        // On récupère l'existant OU on crée une instance par défaut
        UserAchievement userAchievement = _userAchievements[achievement.id] ?? UserAchievement(
          achievementId: achievement.id,
          currentProgress: 0,
          isCompleted: false,
          isClaimed: false,
        );

        // Si déjà complété, on ne fait rien
        if (userAchievement.isCompleted) continue;

        // Mettre à jour la progression
        final newProgress = userAchievement.currentProgress + incrementBy;
        final isNowCompleted = newProgress >= achievement.targetValue;

        // Mettre à jour la map locale
        _userAchievements[achievement.id] = userAchievement.copyWith(
          currentProgress: newProgress,
          isCompleted: isNowCompleted,
          completedAt: isNowCompleted ? DateTime.now() : null,
        );

        needsSave = true;

        if (isNowCompleted) {
          newlyCompleted.add(achievement);
          if (kDebugMode) print("🏆 Achievement débloqué: ${achievement.name}");
        }
      }

      // Sauvegarder uniquement si il y a eu des changements
      if (needsSave) {
        await _saveUserAchievements(userId);
        notifyListeners();
      }

    } catch (e) {
      if (kDebugMode) print('Erreur mise à jour progression: $e');
    }

    return newlyCompleted;
  }

  /// Réclamer les récompenses d'un achievement
  Future<int> claimAchievement(String userId, String achievementId) async {
    try {
      // S'assurer que la liste est chargée pour le 'firstWhere'
      if (_allAchievements.isEmpty) initialize();

      final achievement = _allAchievements.firstWhere(
            (a) => a.id == achievementId,
        orElse: () => throw Exception('Achievement non trouvé'),
      );

      final userAchievement = _userAchievements[achievementId];

      if (userAchievement == null) throw Exception('Achievement utilisateur non trouvé');
      if (!userAchievement.isCompleted) throw Exception('Achievement non complété');
      if (userAchievement.isClaimed) throw Exception('Récompense déjà réclamée');

      // Marquer comme réclamé
      _userAchievements[achievementId] = userAchievement.copyWith(
        isClaimed: true,
      );

      await _saveUserAchievements(userId);
      notifyListeners();

      return achievement.livesReward;

    } catch (e) {
      if (kDebugMode) print('Erreur réclamation achievement: $e');
      rethrow;
    }
  }

  /// Obtenir les achievements complétés mais non réclamés
  List<Achievement> getUnclaimedAchievements() {
    List<Achievement> unclaimed = [];

    // Sécurité si appelé trop tôt
    if (_allAchievements.isEmpty) return [];

    for (var achievement in _allAchievements) {
      final userAchievement = _userAchievements[achievement.id];

      if (userAchievement != null &&
          userAchievement.isCompleted &&
          !userAchievement.isClaimed) {
        unclaimed.add(achievement);
      }
    }

    return unclaimed;
  }

  /// Obtenir le nombre total de vies non réclamées
  int getTotalUnclaimedLives() {
    int total = 0;
    for (var achievement in getUnclaimedAchievements()) {
      total += achievement.livesReward;
    }
    return total;
  }

  /// Obtenir la progression d'un achievement (0.0 à 1.0)
  double getAchievementProgress(String achievementId) {
    try {
      if (_allAchievements.isEmpty) return 0.0;

      final achievement = _allAchievements.firstWhere(
            (a) => a.id == achievementId,
        orElse: () => throw Exception('Achievement non trouvé'),
      );

      final userAchievement = _userAchievements[achievementId];
      if (userAchievement == null) return 0.0;

      return (userAchievement.currentProgress / achievement.targetValue).clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }

  /// Obtenir les statistiques des achievements
  Map<String, dynamic> getAchievementStats() {
    int completed = 0;
    int claimed = 0;
    int total = _allAchievements.length;

    _userAchievements.forEach((key, value) {
      if (value.isCompleted) completed++;
      if (value.isClaimed) claimed++;
    });

    return {
      'total': total,
      'completed': completed,
      'claimed': claimed,
      'unclaimed': completed - claimed,
      'totalLivesEarned': claimed * 2, // Moyenne approximative
      'completionRate': total > 0 ? (completed / total) : 0.0,
    };
  }

  /// Stream pour écouter les changements en temps réel
  Stream<Map<String, UserAchievement>> watchUserAchievements(String userId) {
    return _firestore
        .collection('userAchievements')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return {};
      }

      final Map<String, UserAchievement> achievements = {};
      final data = snapshot.data()!;

      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          achievements[key] = UserAchievement.fromFirestore(value);
        }
      });

      return achievements;
    });
  }

  // Ajouter après la méthode updateProgress existante :

  /// Mise à jour spécifique pour le mode infini
  Future<List<Achievement>> updateInfiniteModeProgress({
    required String userId,
    int exercisesCompleted = 1,
  }) async {
    return await updateProgress(
      userId: userId,
      type: AchievementType.infiniteMode,
      incrementBy: exercisesCompleted,
    );
  }

  /// Mise à jour pour la maîtrise d'un thème
  Future<List<Achievement>> updateThemeMastery({
    required String userId,
    required String theme,
    required String level,
  }) async {
    // TODO: Tracker les thèmes complétés dans Firestore
    // Pour l'instant, on incrémente juste le compteur
    return await updateProgress(
      userId: userId,
      type: AchievementType.themeMastery,
      incrementBy: 1,
    );
  }

  /// Mise à jour pour la maîtrise d'un niveau
  Future<List<Achievement>> updateLevelMastery({
    required String userId,
    required String level,
  }) async {
    // TODO: Tracker les niveaux complétés dans Firestore
    return await updateProgress(
      userId: userId,
      type: AchievementType.levelMastery,
      incrementBy: 1,
    );
  }

  /// Vérifier les achievements secrets basés sur l'heure/date
  Future<List<Achievement>> checkTimeBasedAchievements(String userId) async {
    List<Achievement> unlocked = [];
    final now = DateTime.now();

    // Oiseau de nuit (minuit - 6h)
    if (now.hour >= 0 && now.hour < 6) {
      final nightOwl = await updateProgress(
        userId: userId,
        type: AchievementType.exercisesCompleted,
        incrementBy: 1,
      );
      unlocked.addAll(nightOwl.where((a) => a.id == 'night_owl'));
    }

    // Lève-tôt (5h - 7h)
    if (now.hour >= 5 && now.hour < 7) {
      final earlyBird = await updateProgress(
        userId: userId,
        type: AchievementType.exercisesCompleted,
        incrementBy: 1,
      );
      unlocked.addAll(earlyBird.where((a) => a.id == 'early_bird'));
    }

    // Noël (25 décembre)
    if (now.month == 12 && now.day == 25) {
      final christmas = await updateProgress(
        userId: userId,
        type: AchievementType.exercisesCompleted,
        incrementBy: 1,
      );
      unlocked.addAll(christmas.where((a) => a.id == 'christmas_special'));
    }

    // Nouvel An (1er janvier)
    if (now.month == 1 && now.day == 1) {
      final newYear = await updateProgress(
        userId: userId,
        type: AchievementType.exercisesCompleted,
        incrementBy: 1,
      );
      unlocked.addAll(newYear.where((a) => a.id == 'new_year'));
    }

    return unlocked;
  }
}
