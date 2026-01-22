import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';
import 'gems_service.dart'; // ✅ IMPORT AJOUTÉ

class AchievementService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GemsService _gemsService; // ✅ AJOUTÉ

  List<Achievement> _allAchievements = [];
  Map<String, UserAchievement> _userAchievements = {};

  List<Achievement> get allAchievements => _allAchievements;
  Map<String, UserAchievement> get userAchievements => _userAchievements;

  // ✅ CONSTRUCTEUR MODIFIÉ pour injecter GemsService
  AchievementService(this._gemsService) {
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
    if (_allAchievements.isEmpty) initialize();

    try {
      final doc = await _firestore
          .collection('userAchievements')
          .doc(userId)
          .get();

      _userAchievements = {};

      for (var achievement in _allAchievements) {
        _userAchievements[achievement.id] = UserAchievement(
          achievementId: achievement.id,
          currentProgress: 0,
          isCompleted: false,
          isClaimed: false,
        );
      }

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            if (_allAchievements.any((a) => a.id == key)) {
              _userAchievements[key] = UserAchievement.fromFirestore(value);
            }
          }
        });
      } else {
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
    if (_allAchievements.isEmpty) initialize();
    if (_userAchievements.isEmpty) await loadUserAchievements(userId);

    List<Achievement> newlyCompleted = [];
    bool needsSave = false;

    try {
      for (var achievement in _allAchievements) {
        if (achievement.type != type) continue;

        if (achievement.requiredLevel != null &&
            achievement.requiredLevel != level) continue;

        UserAchievement userAchievement = _userAchievements[achievement.id] ?? UserAchievement(
          achievementId: achievement.id,
          currentProgress: 0,
          isCompleted: false,
          isClaimed: false,
        );

        if (userAchievement.isCompleted) continue;

        final newProgress = userAchievement.currentProgress + incrementBy;
        final isNowCompleted = newProgress >= achievement.targetValue;

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

      if (needsSave) {
        await _saveUserAchievements(userId);
        notifyListeners();
      }

    } catch (e) {
      if (kDebugMode) print('Erreur mise à jour progression: $e');
    }

    return newlyCompleted;
  }

  /// ✅ MODIFIÉ : Réclamer les récompenses d'un achievement (maintenant en Gems)
  Future<int> claimAchievement(String userId, String achievementId) async {
    try {
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

      // ✅ DONNER DES GEMS AU LIEU DE VIES
      await _gemsService.rewardAchievement(
        userId,
        achievementId,
        achievement.gemsReward,
      );

      return achievement.gemsReward; // ✅ Retourner les gems gagnés

    } catch (e) {
      if (kDebugMode) print('Erreur réclamation achievement: $e');
      rethrow;
    }
  }

  /// Obtenir les achievements complétés mais non réclamés
  List<Achievement> getUnclaimedAchievements() {
    List<Achievement> unclaimed = [];

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

  /// ✅ MODIFIÉ : Obtenir le nombre total de gems non réclamés
  int getTotalUnclaimedGems() {
    int total = 0;
    for (var achievement in getUnclaimedAchievements()) {
      total += achievement.gemsReward;
    }
    return total;
  }

  /// ✅ BACKWARD COMPATIBILITY : Ancienne méthode qui retournait des vies
  int getTotalUnclaimedLives() {
    // Retourner 0 car les achievements ne donnent plus de vies
    return 0;
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

    // ✅ CALCULER LES GEMS TOTAUX GAGNÉS
    int totalGemsEarned = 0;
    _userAchievements.forEach((key, value) {
      if (value.isClaimed) {
        final achievement = _allAchievements.firstWhere(
              (a) => a.id == key,
          orElse: () => Achievement(
            id: '',
            name: '',
            description: '',
            icon: '',
            type: AchievementType.exercisesCompleted,
            targetValue: 0,
            gemsReward: 0,
          ),
        );
        totalGemsEarned += achievement.gemsReward;
      }
    });

    return {
      'total': total,
      'completed': completed,
      'claimed': claimed,
      'unclaimed': completed - claimed,
      'totalGemsEarned': totalGemsEarned, // ✅ CHANGÉ
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

  // Méthodes existantes (inchangées)
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

  Future<List<Achievement>> updateThemeMastery({
    required String userId,
    required String theme,
    required String level,
  }) async {
    return await updateProgress(
      userId: userId,
      type: AchievementType.themeMastery,
      incrementBy: 1,
    );
  }

  Future<List<Achievement>> updateLevelMastery({
    required String userId,
    required String level,
  }) async {
    return await updateProgress(
      userId: userId,
      type: AchievementType.levelMastery,
      incrementBy: 1,
    );
  }

  Future<List<Achievement>> checkTimeBasedAchievements(String userId) async {
    List<Achievement> unlocked = [];
    final now = DateTime.now();

    if (now.hour >= 0 && now.hour < 6) {
      final nightOwl = await updateProgress(
        userId: userId,
        type: AchievementType.exercisesCompleted,
        incrementBy: 1,
      );
      unlocked.addAll(nightOwl.where((a) => a.id == 'night_owl'));
    }

    if (now.hour >= 5 && now.hour < 7) {
      final earlyBird = await updateProgress(
        userId: userId,
        type: AchievementType.exercisesCompleted,
        incrementBy: 1,
      );
      unlocked.addAll(earlyBird.where((a) => a.id == 'early_bird'));
    }

    return unlocked;
  }
}