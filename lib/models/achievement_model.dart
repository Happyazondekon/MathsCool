import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';

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
  final String nameKey; // ✅ Clé de traduction au lieu du nom directement
  final String descriptionKey; // ✅ Clé de traduction au lieu de la description directement
  final String icon;
  final AchievementType type;
  final int targetValue;
  final int gemsReward;
  final AchievementDifficulty difficulty;
  final String? requiredLevel;
  final bool isSecret;

  Achievement({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.icon,
    required this.type,
    required this.targetValue,
    required this.gemsReward,
    this.difficulty = AchievementDifficulty.easy,
    this.requiredLevel,
    this.isSecret = false,
  });

  // ✅ Méthode pour obtenir le nom traduit
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Utilisation de la réflexion dynamique pour accéder à la clé
    switch (nameKey) {
      case 'achievementFirstSteps': return l10n.achievementFirstSteps;
      case 'achievementGettingStarted': return l10n.achievementGettingStarted;
      case 'achievementOnTrack': return l10n.achievementOnTrack;
      case 'achievementBeginner': return l10n.achievementBeginner;
      case 'achievementLearner': return l10n.achievementLearner;
      case 'achievementStudent': return l10n.achievementStudent;
      case 'achievementSkilled': return l10n.achievementSkilled;
      case 'achievementExpert': return l10n.achievementExpert;
      case 'achievementMaster': return l10n.achievementMaster;
      case 'achievementChampion': return l10n.achievementChampion;
      case 'achievementLegend': return l10n.achievementLegend;
      case 'achievementPerfectionist': return l10n.achievementPerfectionist;
      case 'achievementFlawlessTrio': return l10n.achievementFlawlessTrio;
      case 'achievementPerfectFive': return l10n.achievementPerfectFive;
      case 'achievementPerfectTen': return l10n.achievementPerfectTen;
      case 'achievementPerfectMaster': return l10n.achievementPerfectMaster;
      case 'achievementDailyPlayer': return l10n.achievementDailyPlayer;
      case 'achievementCommitted': return l10n.achievementCommitted;
      case 'achievementWeeklyWarrior': return l10n.achievementWeeklyWarrior;
      case 'achievementTwoWeeks': return l10n.achievementTwoWeeks;
      case 'achievementMonthlyMaster': return l10n.achievementMonthlyMaster;
      case 'achievementInfiniteBeginner': return l10n.achievementInfiniteBeginner;
      case 'achievementInfiniteExplorer': return l10n.achievementInfiniteExplorer;
      case 'achievementInfiniteWarrior': return l10n.achievementInfiniteWarrior;
      case 'achievementInfiniteMaster': return l10n.achievementInfiniteMaster;
      case 'achievementNightOwl': return l10n.achievementNightOwl;
      case 'achievementEarlyBird': return l10n.achievementEarlyBird;
      case 'achievementWeekendWarrior': return l10n.achievementWeekendWarrior;
      case 'achievementLuckySeven': return l10n.achievementLuckySeven;
      default: return nameKey;
    }
  }

  // ✅ Méthode pour obtenir la description traduite
  String getLocalizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (descriptionKey) {
      case 'achievementFirstStepsDesc': return l10n.achievementFirstStepsDesc;
      case 'achievementGettingStartedDesc': return l10n.achievementGettingStartedDesc;
      case 'achievementOnTrackDesc': return l10n.achievementOnTrackDesc;
      case 'achievementBeginnerDesc': return l10n.achievementBeginnerDesc;
      case 'achievementLearnerDesc': return l10n.achievementLearnerDesc;
      case 'achievementStudentDesc': return l10n.achievementStudentDesc;
      case 'achievementSkilledDesc': return l10n.achievementSkilledDesc;
      case 'achievementExpertDesc': return l10n.achievementExpertDesc;
      case 'achievementMasterDesc': return l10n.achievementMasterDesc;
      case 'achievementChampionDesc': return l10n.achievementChampionDesc;
      case 'achievementLegendDesc': return l10n.achievementLegendDesc;
      case 'achievementPerfectionistDesc': return l10n.achievementPerfectionistDesc;
      case 'achievementFlawlessTrioDesc': return l10n.achievementFlawlessTrioDesc;
      case 'achievementPerfectFiveDesc': return l10n.achievementPerfectFiveDesc;
      case 'achievementPerfectTenDesc': return l10n.achievementPerfectTenDesc;
      case 'achievementPerfectMasterDesc': return l10n.achievementPerfectMasterDesc;
      case 'achievementDailyPlayerDesc': return l10n.achievementDailyPlayerDesc;
      case 'achievementCommittedDesc': return l10n.achievementCommittedDesc;
      case 'achievementWeeklyWarriorDesc': return l10n.achievementWeeklyWarriorDesc;
      case 'achievementTwoWeeksDesc': return l10n.achievementTwoWeeksDesc;
      case 'achievementMonthlyMasterDesc': return l10n.achievementMonthlyMasterDesc;
      case 'achievementInfiniteBeginnerDesc': return l10n.achievementInfiniteBeginnerDesc;
      case 'achievementInfiniteExplorerDesc': return l10n.achievementInfiniteExplorerDesc;
      case 'achievementInfiniteWarriorDesc': return l10n.achievementInfiniteWarriorDesc;
      case 'achievementInfiniteMasterDesc': return l10n.achievementInfiniteMasterDesc;
      case 'achievementNightOwlDesc': return l10n.achievementNightOwlDesc;
      case 'achievementEarlyBirdDesc': return l10n.achievementEarlyBirdDesc;
      case 'achievementWeekendWarriorDesc': return l10n.achievementWeekendWarriorDesc;
      case 'achievementLuckySevenDesc': return l10n.achievementLuckySevenDesc;
      default: return descriptionKey;
    }
  }

  // ✅ Helper pour backward compatibility
  int get livesReward => 0;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nameKey': nameKey,
      'descriptionKey': descriptionKey,
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
      nameKey: data['nameKey'] as String,
      descriptionKey: data['descriptionKey'] as String,
      icon: data['icon'] as String,
      type: AchievementType.values.firstWhere(
            (e) => e.toString() == data['type'],
      ),
      targetValue: data['targetValue'] as int,
      gemsReward: data['gemsReward'] as int? ?? 10,
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
        nameKey: 'achievementFirstSteps',
        descriptionKey: 'achievementFirstStepsDesc',
        icon: '👶',
        type: AchievementType.exercisesCompleted,
        targetValue: 1,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'getting_started',
        nameKey: 'achievementGettingStarted',
        descriptionKey: 'achievementGettingStartedDesc',
        icon: '🚀',
        type: AchievementType.exercisesCompleted,
        targetValue: 5,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'on_track',
        nameKey: 'achievementOnTrack',
        descriptionKey: 'achievementOnTrackDesc',
        icon: '🛤️',
        type: AchievementType.exercisesCompleted,
        targetValue: 15,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),

      // 📚 SÉRIE : APPRENTISSAGE (Medium - 20 gems)
      Achievement(
        id: 'beginner',
        nameKey: 'achievementBeginner',
        descriptionKey: 'achievementBeginnerDesc',
        icon: '📚',
        type: AchievementType.exercisesCompleted,
        targetValue: 25,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'learner',
        nameKey: 'achievementLearner',
        descriptionKey: 'achievementLearnerDesc',
        icon: '📖',
        type: AchievementType.exercisesCompleted,
        targetValue: 50,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'student',
        nameKey: 'achievementStudent',
        descriptionKey: 'achievementStudentDesc',
        icon: '🎓',
        type: AchievementType.exercisesCompleted,
        targetValue: 75,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),

      // 🏆 SÉRIE : MAÎTRISE (Hard - 30 gems)
      Achievement(
        id: 'skilled',
        nameKey: 'achievementSkilled',
        descriptionKey: 'achievementSkilledDesc',
        icon: '🎖️',
        type: AchievementType.exercisesCompleted,
        targetValue: 100,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'expert',
        nameKey: 'achievementExpert',
        descriptionKey: 'achievementExpertDesc',
        icon: '🥇',
        type: AchievementType.exercisesCompleted,
        targetValue: 150,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'master',
        nameKey: 'achievementMaster',
        descriptionKey: 'achievementMasterDesc',
        icon: '👑',
        type: AchievementType.exercisesCompleted,
        targetValue: 200,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'champion',
        nameKey: 'achievementChampion',
        descriptionKey: 'achievementChampionDesc',
        icon: '🏆',
        type: AchievementType.exercisesCompleted,
        targetValue: 300,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'legend',
        nameKey: 'achievementLegend',
        descriptionKey: 'achievementLegendDesc',
        icon: '⭐',
        type: AchievementType.exercisesCompleted,
        targetValue: 500,
        gemsReward: 50,
        difficulty: AchievementDifficulty.hard,
      ),

      // ✨ SÉRIE : PERFECTION (Easy/Medium)
      Achievement(
        id: 'perfectionist',
        nameKey: 'achievementPerfectionist',
        descriptionKey: 'achievementPerfectionistDesc',
        icon: '✨',
        type: AchievementType.perfectScore,
        targetValue: 1,
        gemsReward: 10,
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'flawless_trio',
        nameKey: 'achievementFlawlessTrio',
        descriptionKey: 'achievementFlawlessTrioDesc',
        icon: '💎',
        type: AchievementType.perfectScore,
        targetValue: 3,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'perfect_five',
        nameKey: 'achievementPerfectFive',
        descriptionKey: 'achievementPerfectFiveDesc',
        icon: '🌟',
        type: AchievementType.perfectScore,
        targetValue: 5,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'perfect_ten',
        nameKey: 'achievementPerfectTen',
        descriptionKey: 'achievementPerfectTenDesc',
        icon: '💫',
        type: AchievementType.perfectScore,
        targetValue: 10,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'perfect_master',
        nameKey: 'achievementPerfectMaster',
        descriptionKey: 'achievementPerfectMasterDesc',
        icon: '🎯',
        type: AchievementType.perfectScore,
        targetValue: 20,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),

      // 🔥 SÉRIE : STREAK (Easy/Medium/Hard)
      Achievement(
        id: 'daily_player',
        nameKey: 'achievementDailyPlayer',
        descriptionKey: 'achievementDailyPlayerDesc',
        icon: '📅',
        type: AchievementType.streak,
        targetValue: 3,
        gemsReward: 15,
        difficulty: AchievementDifficulty.easy,
      ),
      Achievement(
        id: 'committed',
        nameKey: 'achievementCommitted',
        descriptionKey: 'achievementCommittedDesc',
        icon: '🔥',
        type: AchievementType.streak,
        targetValue: 5,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'weekly_warrior',
        nameKey: 'achievementWeeklyWarrior',
        descriptionKey: 'achievementWeeklyWarriorDesc',
        icon: '⚔️',
        type: AchievementType.streak,
        targetValue: 7,
        gemsReward: 50,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'two_weeks',
        nameKey: 'achievementTwoWeeks',
        descriptionKey: 'achievementTwoWeeksDesc',
        icon: '💪',
        type: AchievementType.streak,
        targetValue: 14,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'monthly_master',
        nameKey: 'achievementMonthlyMaster',
        descriptionKey: 'achievementMonthlyMasterDesc',
        icon: '🌙',
        type: AchievementType.streak,
        targetValue: 30,
        gemsReward: 100,
        difficulty: AchievementDifficulty.hard,
      ),

      // ♾️ SÉRIE : MODE INFINI (Medium/Hard)
      Achievement(
        id: 'infinite_beginner',
        nameKey: 'achievementInfiniteBeginner',
        descriptionKey: 'achievementInfiniteBeginnerDesc',
        icon: '♾️',
        type: AchievementType.infiniteMode,
        targetValue: 25,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'infinite_explorer',
        nameKey: 'achievementInfiniteExplorer',
        descriptionKey: 'achievementInfiniteExplorerDesc',
        icon: '🌌',
        type: AchievementType.infiniteMode,
        targetValue: 50,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
      ),
      Achievement(
        id: 'infinite_warrior',
        nameKey: 'achievementInfiniteWarrior',
        descriptionKey: 'achievementInfiniteWarriorDesc',
        icon: '⚡',
        type: AchievementType.infiniteMode,
        targetValue: 100,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),
      Achievement(
        id: 'infinite_master',
        nameKey: 'achievementInfiniteMaster',
        descriptionKey: 'achievementInfiniteMasterDesc',
        icon: '🎆',
        type: AchievementType.infiniteMode,
        targetValue: 200,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
      ),

      // 🌙 SÉRIE : ACHIEVEMENTS SECRETS (Medium/Hard)
      Achievement(
        id: 'night_owl',
        nameKey: 'achievementNightOwl',
        descriptionKey: 'achievementNightOwlDesc',
        icon: '🦉',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
        isSecret: true,
      ),
      Achievement(
        id: 'early_bird',
        nameKey: 'achievementEarlyBird',
        descriptionKey: 'achievementEarlyBirdDesc',
        icon: '🦅',
        type: AchievementType.exercisesCompleted,
        targetValue: 10,
        gemsReward: 20,
        difficulty: AchievementDifficulty.medium,
        isSecret: true,
      ),
      Achievement(
        id: 'weekend_warrior',
        nameKey: 'achievementWeekendWarrior',
        descriptionKey: 'achievementWeekendWarriorDesc',
        icon: '🎮',
        type: AchievementType.exercisesCompleted,
        targetValue: 20,
        gemsReward: 30,
        difficulty: AchievementDifficulty.hard,
        isSecret: true,
      ),
      Achievement(
        id: 'lucky_seven',
        nameKey: 'achievementLuckySeven',
        descriptionKey: 'achievementLuckySevenDesc',
        icon: '🍀',
        type: AchievementType.exercisesCompleted,
        targetValue: 777,
        gemsReward: 77,
        difficulty: AchievementDifficulty.hard,
        isSecret: true,
      ),
    ];
  }
}