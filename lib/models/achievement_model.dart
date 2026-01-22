import 'package:cloud_firestore/cloud_firestore.dart';

enum AchievementType {
  exercisesCompleted,
  perfectScore,
  streak,
  badgesEarned,
  livesUsedWisely,
  fastLearner,
  mathKid,
  allCategories,
  infiniteMode,
  levelMastery,
  themeMastery,
}

enum AchievementDifficulty {
  easy,   // 10 gems
  medium, // 20 gems
  hard,   // 30 gems
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final int targetValue;
  final int gemsReward; // ✅ CHANGÉ : gems au lieu de vies
  final AchievementDifficulty difficulty; // ✅ NOUVEAU
  final String? requiredLevel;
  final bool isSecret;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.targetValue,
    required this.gemsReward,
    this.difficulty = AchievementDifficulty.easy,
    this.requiredLevel,
    this.isSecret = false,
  });

  // ✅ Helper pour backward compatibility (si certains endroits utilisent encore livesReward)
  int get livesReward => 0; // Les achievements ne donnent plus de vies

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.toString(),
      'targetValue': targetValue,
      'gemsReward': gemsReward,
      'difficulty': difficulty.toString(),
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
      gemsReward: data['gemsReward'] as int? ?? 10, // Défaut 10 gems
      difficulty: AchievementDifficulty.values.firstWhere(
            (e) => e.toString() == (data['difficulty'] ?? 'AchievementDifficulty.easy'),
        orElse: () => AchievementDifficulty.easy,
      ),
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
  final bool isClaimed;

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

class PredefinedAchievements {
  static List<Achievement> getAllAchievements() {
    return [
      // 🎯 SÉRIE : PREMIERS PAS (Easy - 10 gems)
      Achievement(
        id: 'first_steps',
        name: 'Premiers pas',
        description: 'Résous ton premier exercice',
        icon: '👶',
        type: AchievementType.exercisesCompleted,
        targetValue: 1,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'getting_started',
        name: 'En route !',
        description: 'Résous 5 exercices',
        icon: '🚀',
        type: AchievementType.exercisesCompleted,
        targetValue: 5,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'on_track',
        name: 'Sur la bonne voie',
        description: 'Résous 15 exercices',
        icon: '🛤️',
        type: AchievementType.exercisesCompleted,
        targetValue: 15,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),

      // 📚 SÉRIE : APPRENTISSAGE (Medium - 20 gems)
      Achievement(
        id: 'beginner',
        name: 'Apprenti',
        description: 'Résous 25 exercices',
        icon: '📚',
        type: AchievementType.exercisesCompleted,
        targetValue: 25,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'learner',
        name: 'Apprenant',
        description: 'Résous 50 exercices',
        icon: '📖',
        type: AchievementType.exercisesCompleted,
        targetValue: 50,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'student',
        name: 'Élève studieux',
        description: 'Résous 75 exercices',
        icon: '🎓',
        type: AchievementType.exercisesCompleted,
        targetValue: 75,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),

      // 🏆 SÉRIE : MAÎTRISE (Hard - 30 gems)
      Achievement(
        id: 'skilled',
        name: 'Compétent',
        description: 'Résous 100 exercices',
        icon: '🎖️',
        type: AchievementType.exercisesCompleted,
        targetValue: 100,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'expert',
        name: 'Expert',
        description: 'Résous 150 exercices',
        icon: '🥇',
        type: AchievementType.exercisesCompleted,
        targetValue: 150,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'master',
        name: 'Maître',
        description: 'Résous 200 exercices',
        icon: '👑',
        type: AchievementType.exercisesCompleted,
        targetValue: 200,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'champion',
        name: 'Champion',
        description: 'Résous 300 exercices',
        icon: '🏆',
        type: AchievementType.exercisesCompleted,
        targetValue: 300,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'legend',
        name: 'Légende',
        description: 'Résous 500 exercices',
        icon: '⭐',
        type: AchievementType.exercisesCompleted,
        targetValue: 500,
        gemsReward: 50, // ✅ BONUS pour accomplissement majeur
        difficulty: AchievementDifficulty.hard,
      ),

      // ✨ SÉRIE : PERFECTION (Easy/Medium)
      Achievement(
        id: 'perfectionist',
        name: 'Perfectionniste',
        description: 'Obtiens un score parfait',
        icon: '✨',
        type: AchievementType.perfectScore,
        targetValue: 1,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'flawless_trio',
        name: 'Trio parfait',
        description: 'Obtiens 3 scores parfaits',
        icon: '💎',
        type: AchievementType.perfectScore,
        targetValue: 3,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'perfect_five',
        name: 'Main parfaite',
        description: 'Obtiens 5 scores parfaits',
        icon: '🌟',
        type: AchievementType.perfectScore,
        targetValue: 5,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'perfect_ten',
        name: 'Perfection absolue',
        description: 'Obtiens 10 scores parfaits',
        icon: '💫',
        type: AchievementType.perfectScore,
        targetValue: 10,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'perfect_master',
        name: 'Maître parfait',
        description: 'Obtiens 20 scores parfaits',
        icon: '🎯',
        type: AchievementType.perfectScore,
        targetValue: 20,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),

      // 🔥 SÉRIE : STREAK (Easy/Medium/Hard)
      Achievement(
        id: 'daily_player',
        name: 'Joueur quotidien',
        description: 'Joue 3 jours d\'affilée',
        icon: '📅',
        type: AchievementType.streak,
        targetValue: 3,
        gemsReward: 15, // ✅ BONUS car streak = engagement
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'committed',
        name: 'Engagé',
        description: 'Joue 5 jours d\'affilée',
        icon: '🔥',
        type: AchievementType.streak,
        targetValue: 5,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'weekly_warrior',
        name: 'Guerrier hebdomadaire',
        description: 'Joue 7 jours d\'affilée',
        icon: '⚔️',
        type: AchievementType.streak,
        targetValue: 7,
        gemsReward: 50, // ✅ GROS BONUS pour 1 semaine
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'two_weeks',
        name: 'Fortnight fighter',
        description: 'Joue 14 jours d\'affilée',
        icon: '💪',
        type: AchievementType.streak,
        targetValue: 14,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'monthly_master',
        name: 'Maître mensuel',
        description: 'Joue 30 jours d\'affilée',
        icon: '🌙',
        type: AchievementType.streak,
        targetValue: 30,
        gemsReward: 100, // ✅ MEGA BONUS pour 1 mois
        difficulty: AchievementDifficulty.hard,
      ),

      // ♾️ SÉRIE : MODE INFINI (Medium/Hard)
      Achievement(
        id: 'infinite_beginner',
        name: 'Infini débutant',
        description: 'Résous 25 exercices en mode infini',
        icon: '♾️',
        type: AchievementType.infiniteMode,
        targetValue: 25,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'infinite_explorer',
        name: 'Explorateur infini',
        description: 'Résous 50 exercices en mode infini',
        icon: '🌌',
        type: AchievementType.infiniteMode,
        targetValue: 50,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'infinite_warrior',
        name: 'Guerrier infini',
        description: 'Résous 100 exercices en mode infini',
        icon: '⚡',
        type: AchievementType.infiniteMode,
        targetValue: 100,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'infinite_master',
        name: 'Maître de l\'infini',
        description: 'Résous 200 exercices en mode infini',
        icon: '🎆',
        type: AchievementType.infiniteMode,
        targetValue: 200,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),

      // 🌙 SÉRIE : ACHIEVEMENTS SECRETS (Medium/Hard)
      Achievement(
        id: 'night_owl',
        name: 'Oiseau de nuit',
        description: 'Joue entre minuit et 6h du matin',
        icon: '🦉',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
        isSecret: true,
      ),
      Achievement(
        id: 'early_bird',
        name: 'Lève-tôt',
        description: 'Joue entre 5h et 7h du matin',
        icon: '🦅',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
        isSecret: true,
      ),
      Achievement(
        id: 'weekend_warrior',
        name: 'Guerrier du week-end',
        description: 'Joue tous les week-ends pendant un mois',
        icon: '🎮',
        type: AchievementType.exercisesCompleted,
        targetValue: 20,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
        isSecret: true,
      ),
      Achievement(
        id: 'lucky_seven',
        name: 'Sept chanceux',
        description: 'Résous 777 exercices',
        icon: '🍀',
        type: AchievementType.exercisesCompleted,
        targetValue: 777,
        gemsReward: 77, // ✅ Easter egg thématique
        difficulty: AchievementDifficulty.hard,
        isSecret: true,
      ),
    ];
  }
}