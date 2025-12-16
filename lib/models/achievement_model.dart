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

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final int targetValue;
  final int livesReward;
  final String? requiredLevel;
  final bool isSecret;

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
      // 🎯 SÉRIE : PREMIERS PAS (1 vie chacun)
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
        id: 'getting_started',
        name: 'En route !',
        description: 'Résous 5 exercices',
        icon: '🚀',
        type: AchievementType.exercisesCompleted,
        targetValue: 5,
        livesReward: 1,
      ),
      Achievement(
        id: 'on_track',
        name: 'Sur la bonne voie',
        description: 'Résous 15 exercices',
        icon: '🛤️',
        type: AchievementType.exercisesCompleted,
        targetValue: 15,
        livesReward: 1,
      ),

      // 📚 SÉRIE : APPRENTISSAGE (1-2 vies)
      Achievement(
        id: 'beginner',
        name: 'Apprenti',
        description: 'Résous 25 exercices',
        icon: '📚',
        type: AchievementType.exercisesCompleted,
        targetValue: 25,
        livesReward: 2,
      ),
      Achievement(
        id: 'learner',
        name: 'Apprenant',
        description: 'Résous 50 exercices',
        icon: '📖',
        type: AchievementType.exercisesCompleted,
        targetValue: 50,
        livesReward: 2,
      ),
      Achievement(
        id: 'student',
        name: 'Élève studieux',
        description: 'Résous 75 exercices',
        icon: '🎓',
        type: AchievementType.exercisesCompleted,
        targetValue: 75,
        livesReward: 2,
      ),

      // 🏆 SÉRIE : MAÎTRISE (2-3 vies)
      Achievement(
        id: 'skilled',
        name: 'Compétent',
        description: 'Résous 100 exercices',
        icon: '🎖️',
        type: AchievementType.exercisesCompleted,
        targetValue: 100,
        livesReward: 2,
      ),
      Achievement(
        id: 'expert',
        name: 'Expert',
        description: 'Résous 150 exercices',
        icon: '🏅',
        type: AchievementType.exercisesCompleted,
        targetValue: 150,
        livesReward: 3,
      ),
      Achievement(
        id: 'master',
        name: 'Maître',
        description: 'Résous 200 exercices',
        icon: '👑',
        type: AchievementType.exercisesCompleted,
        targetValue: 200,
        livesReward: 3,
      ),
      Achievement(
        id: 'champion',
        name: 'Champion',
        description: 'Résous 300 exercices',
        icon: '🏆',
        type: AchievementType.exercisesCompleted,
        targetValue: 300,
        livesReward: 3,
      ),
      Achievement(
        id: 'legend',
        name: 'Légende',
        description: 'Résous 500 exercices',
        icon: '⭐',
        type: AchievementType.exercisesCompleted,
        targetValue: 500,
        livesReward: 3,
      ),

      // ✨ SÉRIE : PERFECTION (1-3 vies)
      Achievement(
        id: 'perfectionist',
        name: 'Perfectionniste',
        description: 'Obtiens un score parfait',
        icon: '✨',
        type: AchievementType.perfectScore,
        targetValue: 1,
        livesReward: 1,
      ),
      Achievement(
        id: 'flawless_trio',
        name: 'Trio parfait',
        description: 'Obtiens 3 scores parfaits',
        icon: '💎',
        type: AchievementType.perfectScore,
        targetValue: 3,
        livesReward: 2,
      ),
      Achievement(
        id: 'perfect_five',
        name: 'Main parfaite',
        description: 'Obtiens 5 scores parfaits',
        icon: '🌟',
        type: AchievementType.perfectScore,
        targetValue: 5,
        livesReward: 2,
      ),
      Achievement(
        id: 'perfect_ten',
        name: 'Perfection absolue',
        description: 'Obtiens 10 scores parfaits',
        icon: '💫',
        type: AchievementType.perfectScore,
        targetValue: 10,
        livesReward: 3,
      ),
      Achievement(
        id: 'perfect_master',
        name: 'Maître parfait',
        description: 'Obtiens 20 scores parfaits',
        icon: '🎯',
        type: AchievementType.perfectScore,
        targetValue: 20,
        livesReward: 3,
      ),

      // 🔥 SÉRIE : STREAK (1-3 vies)
      Achievement(
        id: 'daily_player',
        name: 'Joueur quotidien',
        description: 'Joue 3 jours d\'affilée',
        icon: '📅',
        type: AchievementType.streak,
        targetValue: 3,
        livesReward: 1,
      ),
      Achievement(
        id: 'committed',
        name: 'Engagé',
        description: 'Joue 5 jours d\'affilée',
        icon: '🔥',
        type: AchievementType.streak,
        targetValue: 5,
        livesReward: 2,
      ),
      Achievement(
        id: 'weekly_warrior',
        name: 'Guerrier hebdomadaire',
        description: 'Joue 7 jours d\'affilée',
        icon: '⚔️',
        type: AchievementType.streak,
        targetValue: 7,
        livesReward: 2,
      ),
      Achievement(
        id: 'two_weeks',
        name: 'Fortnight fighter',
        description: 'Joue 14 jours d\'affilée',
        icon: '💪',
        type: AchievementType.streak,
        targetValue: 14,
        livesReward: 3,
      ),
      Achievement(
        id: 'monthly_master',
        name: 'Maître mensuel',
        description: 'Joue 30 jours d\'affilée',
        icon: '🌙',
        type: AchievementType.streak,
        targetValue: 30,
        livesReward: 3,
      ),

      // ♾️ SÉRIE : MODE INFINI (2-3 vies)
      Achievement(
        id: 'infinite_beginner',
        name: 'Infini débutant',
        description: 'Résous 25 exercices en mode infini',
        icon: '♾️',
        type: AchievementType.infiniteMode,
        targetValue: 25,
        livesReward: 2,
      ),
      Achievement(
        id: 'infinite_explorer',
        name: 'Explorateur infini',
        description: 'Résous 50 exercices en mode infini',
        icon: '🌌',
        type: AchievementType.infiniteMode,
        targetValue: 50,
        livesReward: 2,
      ),
      Achievement(
        id: 'infinite_warrior',
        name: 'Guerrier infini',
        description: 'Résous 100 exercices en mode infini',
        icon: '⚡',
        type: AchievementType.infiniteMode,
        targetValue: 100,
        livesReward: 3,
      ),
      Achievement(
        id: 'infinite_master',
        name: 'Maître de l\'infini',
        description: 'Résous 200 exercices en mode infini',
        icon: '🎆',
        type: AchievementType.infiniteMode,
        targetValue: 200,
        livesReward: 3,
      ),

      // 💪 SÉRIE : EFFICACITÉ (1-2 vies)
      Achievement(
        id: 'efficient_player',
        name: 'Joueur efficace',
        description: 'Termine 20 exercices avec 5 vies max perdues',
        icon: '💪',
        type: AchievementType.livesUsedWisely,
        targetValue: 20,
        livesReward: 2,
      ),
      Achievement(
        id: 'careful_learner',
        name: 'Apprenant prudent',
        description: 'Termine 50 exercices avec 10 vies max perdues',
        icon: '🛡️',
        type: AchievementType.livesUsedWisely,
        targetValue: 50,
        livesReward: 2,
      ),
      Achievement(
        id: 'strategic_mind',
        name: 'Esprit stratégique',
        description: 'Termine 100 exercices avec 15 vies max perdues',
        icon: '🧠',
        type: AchievementType.livesUsedWisely,
        targetValue: 100,
        livesReward: 3,
      ),

      // ⚡ SÉRIE : VITESSE (1-2 vies)
      Achievement(
        id: 'speed_demon',
        name: 'Éclair',
        description: 'Résous 10 exercices en moins de 5 minutes',
        icon: '⚡',
        type: AchievementType.fastLearner,
        targetValue: 10,
        livesReward: 2,
      ),
      Achievement(
        id: 'lightning_fast',
        name: 'Foudre',
        description: 'Résous 20 exercices en moins de 10 minutes',
        icon: '⚡',
        type: AchievementType.fastLearner,
        targetValue: 20,
        livesReward: 2,
      ),
      Achievement(
        id: 'time_master',
        name: 'Maître du temps',
        description: 'Résous 50 exercices en moins de 20 minutes',
        icon: '⏱️',
        type: AchievementType.fastLearner,
        targetValue: 50,
        livesReward: 3,
      ),

      // 🎖️ SÉRIE : BADGES (1-2 vies)
      Achievement(
        id: 'badge_collector',
        name: 'Collectionneur',
        description: 'Obtiens 3 badges',
        icon: '🎖️',
        type: AchievementType.badgesEarned,
        targetValue: 3,
        livesReward: 1,
      ),
      Achievement(
        id: 'badge_hunter',
        name: 'Chasseur de badges',
        description: 'Obtiens 5 badges',
        icon: '🏅',
        type: AchievementType.badgesEarned,
        targetValue: 5,
        livesReward: 2,
      ),
      Achievement(
        id: 'badge_master',
        name: 'Maître des badges',
        description: 'Obtiens 10 badges',
        icon: '👑',
        type: AchievementType.badgesEarned,
        targetValue: 10,
        livesReward: 2,
      ),

      // 🎯 SÉRIE : MATHKID (2-3 vies)
      Achievement(
        id: 'math_kid_achievement',
        name: 'MathKid certifié',
        description: 'Obtiens le statut MathKid',
        icon: '🎯',
        type: AchievementType.mathKid,
        targetValue: 1,
        livesReward: 2,
      ),
      Achievement(
        id: 'math_kid_trio',
        name: 'Trio MathKid',
        description: 'Obtiens 3 statuts MathKid',
        icon: '🌟',
        type: AchievementType.mathKid,
        targetValue: 3,
        livesReward: 3,
      ),
      Achievement(
        id: 'math_kid_master',
        name: 'MathKid maître',
        description: 'Obtiens 5 statuts MathKid',
        icon: '👨‍🏫',
        type: AchievementType.mathKid,
        targetValue: 5,
        livesReward: 3,
      ),

      // 📊 SÉRIE : THÈMES (2-3 vies)
      Achievement(
        id: 'theme_explorer',
        name: 'Explorateur de thèmes',
        description: 'Complète 3 thèmes différents',
        icon: '🗺️',
        type: AchievementType.themeMastery,
        targetValue: 3,
        livesReward: 2,
      ),
      Achievement(
        id: 'theme_specialist',
        name: 'Spécialiste',
        description: 'Complète 5 thèmes différents',
        icon: '📊',
        type: AchievementType.themeMastery,
        targetValue: 5,
        livesReward: 2,
      ),
      Achievement(
        id: 'theme_master',
        name: 'Maître des thèmes',
        description: 'Complète 10 thèmes différents',
        icon: '🎓',
        type: AchievementType.themeMastery,
        targetValue: 10,
        livesReward: 3,
      ),

      // 🎓 SÉRIE : NIVEAUX (2-3 vies)
      Achievement(
        id: 'level_beginner',
        name: 'Multi-niveau',
        description: 'Complète 2 niveaux différents',
        icon: '📈',
        type: AchievementType.levelMastery,
        targetValue: 2,
        livesReward: 2,
      ),
      Achievement(
        id: 'level_master',
        name: 'Maître des niveaux',
        description: 'Complète 4 niveaux différents',
        icon: '🎯',
        type: AchievementType.levelMastery,
        targetValue: 4,
        livesReward: 3,
      ),
      Achievement(
        id: 'all_levels',
        name: 'Tous les niveaux',
        description: 'Complète tous les niveaux disponibles',
        icon: '🏆',
        type: AchievementType.levelMastery,
        targetValue: 10,
        livesReward: 3,
      ),

      // 🌙 SÉRIE : ACHIEVEMENTS SECRETS (1-3 vies)
      Achievement(
        id: 'night_owl',
        name: 'Oiseau de nuit',
        description: 'Joue entre minuit et 6h du matin',
        icon: '🦉',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        livesReward: 2,
        isSecret: true,
      ),
      Achievement(
        id: 'early_bird',
        name: 'Lève-tôt',
        description: 'Joue entre 5h et 7h du matin',
        icon: '🐦',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        livesReward: 2,
        isSecret: true,
      ),
      Achievement(
        id: 'weekend_warrior',
        name: 'Guerrier du week-end',
        description: 'Joue tous les week-ends pendant un mois',
        icon: '🎮',
        type: AchievementType.exercisesCompleted,
        targetValue: 20,
        livesReward: 2,
        isSecret: true,
      ),
      Achievement(
        id: 'lucky_seven',
        name: 'Sept chanceux',
        description: 'Résous 777 exercices',
        icon: '🍀',
        type: AchievementType.exercisesCompleted,
        targetValue: 777,
        livesReward: 3,
        isSecret: true,
      ),
      Achievement(
        id: 'christmas_special',
        name: 'Esprit de Noël',
        description: 'Joue le 25 décembre',
        icon: '🎄',
        type: AchievementType.exercisesCompleted,
        targetValue: 1,
        livesReward: 3,
        isSecret: true,
      ),
      Achievement(
        id: 'new_year',
        name: 'Bonne année !',
        description: 'Joue le 1er janvier',
        icon: '🎆',
        type: AchievementType.exercisesCompleted,
        targetValue: 1,
        livesReward: 3,
        isSecret: true,
      ),
      Achievement(
        id: 'marathon_player',
        name: 'Marathonien',
        description: 'Joue pendant 2 heures d\'affilée',
        icon: '🏃',
        type: AchievementType.exercisesCompleted,
        targetValue: 100,
        livesReward: 3,
        isSecret: true,
      ),
      Achievement(
        id: 'comeback_king',
        name: 'Roi du retour',
        description: 'Reviens après 30 jours d\'absence',
        icon: '👑',
        type: AchievementType.exercisesCompleted,
        targetValue: 1,
        livesReward: 2,
        isSecret: true,
      ),
    ];
  }
}