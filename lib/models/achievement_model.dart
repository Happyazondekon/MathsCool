import 'package:cloud_firestore/cloud_firestore.dart';

enum AchievementType {
  exercisesCompleted,    // Nombre d'exercices résolus
  perfectScore,          // Score parfait sur un thème
  streak,                // Jours consécutifs de jeu
  badgesEarned,          // Nombre de badges obtenus
  livesUsedWisely,       // Utiliser moins de X vies sur Y exercices
  fastLearner,           // Terminer X exercices en moins de Y minutes
  mathKid,               // Obtenir le statut MathKid
  allCategories,         // Compléter toutes les catégories d'un niveau
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon; // Emoji ou nom d'icône
  final AchievementType type;
  final int targetValue; // Valeur cible à atteindre
  final int livesReward; // Nombre de vies à gagner
  final String? requiredLevel; // Niveau requis (optionnel)
  final bool isSecret; // Achievement caché

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.targetValue,
    required this.livesReward,
    this.requiredLevel,
    this.isSecret = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.toString(),
      'targetValue': targetValue,
      'livesReward': livesReward,
      'requiredLevel': requiredLevel,
      'isSecret': isSecret,
    };
  }

  factory Achievement.fromFirestore(Map<String, dynamic> data) {
    return Achievement(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      icon: data['icon'] as String,
      type: AchievementType.values.firstWhere(
            (e) => e.toString() == data['type'],
      ),
      targetValue: data['targetValue'] as int,
      livesReward: data['livesReward'] as int,
      requiredLevel: data['requiredLevel'] as String?,
      isSecret: data['isSecret'] as bool? ?? false,
    );
  }
}

class UserAchievement {
  final String achievementId;
  final int currentProgress;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool isClaimed; // Si les vies ont été réclamées

  UserAchievement({
    required this.achievementId,
    required this.currentProgress,
    required this.isCompleted,
    this.completedAt,
    required this.isClaimed,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'achievementId': achievementId,
      'currentProgress': currentProgress,
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'isClaimed': isClaimed,
    };
  }

  factory UserAchievement.fromFirestore(Map<String, dynamic> data) {
    return UserAchievement(
      achievementId: data['achievementId'] as String,
      currentProgress: data['currentProgress'] as int? ?? 0,
      isCompleted: data['isCompleted'] as bool? ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      isClaimed: data['isClaimed'] as bool? ?? false,
    );
  }

  UserAchievement copyWith({
    String? achievementId,
    int? currentProgress,
    bool? isCompleted,
    DateTime? completedAt,
    bool? isClaimed,
  }) {
    return UserAchievement(
      achievementId: achievementId ?? this.achievementId,
      currentProgress: currentProgress ?? this.currentProgress,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }
}

// Liste des achievements prédéfinis
class PredefinedAchievements {
  static List<Achievement> getAllAchievements() {
    return [
      // Achievements basiques
      Achievement(
        id: 'first_steps',
        name: 'Premiers pas',
        description: 'Résous ton premier exercice',
        icon: '👶',
        type: AchievementType.exercisesCompleted,
        targetValue: 1,
        livesReward: 1,
      ),
      Achievement(
        id: 'beginner',
        name: 'Apprenti',
        description: 'Résous 10 exercices',
        icon: '📚',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        livesReward: 2,
      ),
      Achievement(
        id: 'intermediate',
        name: 'Élève studieux',
        description: 'Résous 50 exercices',
        icon: '🎓',
        type: AchievementType.exercisesCompleted,
        targetValue: 50,
        livesReward: 3,
      ),
      Achievement(
        id: 'expert',
        name: 'Expert',
        description: 'Résous 100 exercices',
        icon: '🏆',
        type: AchievementType.exercisesCompleted,
        targetValue: 100,
        livesReward: 5,
      ),

      // Achievements de perfection
      Achievement(
        id: 'perfectionist',
        name: 'Perfectionniste',
        description: 'Obtiens un score parfait sur un thème',
        icon: '⭐',
        type: AchievementType.perfectScore,
        targetValue: 1,
        livesReward: 2,
      ),
      Achievement(
        id: 'perfect_master',
        name: 'Maître Parfait',
        description: 'Obtiens 5 scores parfaits',
        icon: '🌟',
        type: AchievementType.perfectScore,
        targetValue: 5,
        livesReward: 4,
      ),

      // Achievements de streak
      Achievement(
        id: 'daily_player',
        name: 'Joueur quotidien',
        description: 'Joue pendant 3 jours consécutifs',
        icon: '📅',
        type: AchievementType.streak,
        targetValue: 3,
        livesReward: 2,
      ),
      Achievement(
        id: 'weekly_warrior',
        name: 'Guerrier hebdomadaire',
        description: 'Joue pendant 7 jours consécutifs',
        icon: '🔥',
        type: AchievementType.streak,
        targetValue: 7,
        livesReward: 5,
      ),

      // Achievements de badges
      Achievement(
        id: 'badge_collector',
        name: 'Collectionneur',
        description: 'Obtiens 3 badges',
        icon: '🎖️',
        type: AchievementType.badgesEarned,
        targetValue: 3,
        livesReward: 2,
      ),
      Achievement(
        id: 'badge_master',
        name: 'Maître des badges',
        description: 'Obtiens tous les badges d\'un niveau',
        icon: '👑',
        type: AchievementType.badgesEarned,
        targetValue: 5,
        livesReward: 5,
      ),

      // Achievements spéciaux
      Achievement(
        id: 'efficient_player',
        name: 'Joueur efficace',
        description: 'Termine 20 exercices en perdant moins de 5 vies',
        icon: '💪',
        type: AchievementType.livesUsedWisely,
        targetValue: 20,
        livesReward: 3,
      ),
      Achievement(
        id: 'speed_demon',
        name: 'Éclair',
        description: 'Résous 10 exercices en moins de 5 minutes',
        icon: '⚡',
        type: AchievementType.fastLearner,
        targetValue: 10,
        livesReward: 3,
      ),
      Achievement(
        id: 'math_kid_achievement',
        name: 'MathKid certifié',
        description: 'Obtiens le statut MathKid',
        icon: '🎯',
        type: AchievementType.mathKid,
        targetValue: 1,
        livesReward: 5,
      ),

      // Achievements secrets
      Achievement(
        id: 'night_owl',
        name: 'Oiseau de nuit',
        description: '???',
        icon: '🦉',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        livesReward: 2,
        isSecret: true,
      ),
      Achievement(
        id: 'christmas_special',
        name: 'Esprit de Noël',
        description: '???',
        icon: '🎄',
        type: AchievementType.exercisesCompleted,
        targetValue: 25,
        livesReward: 5,
        isSecret: true,
      ),
    ];
  }
}