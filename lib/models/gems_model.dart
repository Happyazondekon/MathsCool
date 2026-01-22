import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour les Gems de l'utilisateur
class GemsData {
  final int currentGems;
  final int totalGemsEarned;
  final int totalGemsSpent;
  final DateTime lastUpdated;
  final Map<String, int> earnedFrom; // Tracking d'où viennent les gems
  final Map<String, int> spentOn; // Tracking où vont les gems

  GemsData({
    required this.currentGems,
    required this.totalGemsEarned,
    required this.totalGemsSpent,
    required this.lastUpdated,
    required this.earnedFrom,
    required this.spentOn,
  });

  /// Créer une instance initiale
  factory GemsData.initial() {
    return GemsData(
      currentGems: 50, // Cadeau de bienvenue
      totalGemsEarned: 50,
      totalGemsSpent: 0,
      lastUpdated: DateTime.now(),
      earnedFrom: {'welcome_bonus': 50},
      spentOn: {},
    );
  }

  /// Depuis Firestore
  factory GemsData.fromFirestore(Map<String, dynamic> data) {
    return GemsData(
      currentGems: data['currentGems'] as int? ?? 0,
      totalGemsEarned: data['totalGemsEarned'] as int? ?? 0,
      totalGemsSpent: data['totalGemsSpent'] as int? ?? 0,
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      earnedFrom: Map<String, int>.from(data['earnedFrom'] ?? {}),
      spentOn: Map<String, int>.from(data['spentOn'] ?? {}),
    );
  }

  /// Vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'currentGems': currentGems,
      'totalGemsEarned': totalGemsEarned,
      'totalGemsSpent': totalGemsSpent,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'earnedFrom': earnedFrom,
      'spentOn': spentOn,
    };
  }

  /// Copier avec modifications
  GemsData copyWith({
    int? currentGems,
    int? totalGemsEarned,
    int? totalGemsSpent,
    DateTime? lastUpdated,
    Map<String, int>? earnedFrom,
    Map<String, int>? spentOn,
  }) {
    return GemsData(
      currentGems: currentGems ?? this.currentGems,
      totalGemsEarned: totalGemsEarned ?? this.totalGemsEarned,
      totalGemsSpent: totalGemsSpent ?? this.totalGemsSpent,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      earnedFrom: earnedFrom ?? this.earnedFrom,
      spentOn: spentOn ?? this.spentOn,
    );
  }

  /// Vérifier si on peut se permettre un achat
  bool canAfford(int cost) => currentGems >= cost;

  /// Calculer combien de gems manquent
  int getMissingGems(int cost) {
    return currentGems < cost ? (cost - currentGems) : 0;
  }
}

/// Constantes pour les prix et récompenses
class GemsPricing {
  // ===== COÛTS (Dépenses) =====
  static const int FAST_REFILL_COST = 50; // Recharge instantanée de vies
  static const int HINT_COST = 20; // Indice pour une question
  static const int SKIP_QUESTION_COST = 30; // Sauter une question difficile
  static const int THEME_UNLOCK_COST = 100; // Débloquer un thème premium
  static const int UNLOCK_AVATAR_COST = 75; // Débloquer un avatar
  static const int BOOST_XP_COST = 40; // Doubler l'XP pendant 1h

  // ===== RÉCOMPENSES (Gains gratuits) =====
  static const int WELCOME_BONUS = 50; // Cadeau de bienvenue
  static const int DAILY_LOGIN_REWARD = 5; // Connexion quotidienne
  static const int PERFECT_SCORE_REWARD = 10; // Score parfait
  static const int STREAK_3_DAYS_REWARD = 15; // 3 jours de suite
  static const int STREAK_7_DAYS_REWARD = 50; // 7 jours de suite
  static const int ACHIEVEMENT_EASY_REWARD = 10; // Achievement facile
  static const int ACHIEVEMENT_MEDIUM_REWARD = 20; // Achievement moyen
  static const int ACHIEVEMENT_HARD_REWARD = 30; // Achievement difficile
  static const int DAILY_CHALLENGE_REWARD = 25; // Défi quotidien complété
  static const int REFERRAL_REWARD = 100; // Parrainage d'un ami

  // ===== PACKS D'ACHAT (In-App Purchase) =====
  static const Map<String, Map<String, dynamic>> GEMS_PACKS = {
    'gems_pack_small': {
      'gems': 100,
      'bonus': 0,
      'price': 0.99,
      'productId': 'gems_pack_small',
      'label': 'Petit Sac',
      'icon': '💰',
    },
    'gems_pack_medium': {
      'gems': 500,
      'bonus': 50, // +10% bonus
      'price': 3.99,
      'productId': 'gems_pack_medium',
      'label': 'Sac Moyen',
      'icon': '💎',
      'popular': true,
    },
    'gems_pack_large': {
      'gems': 1200,
      'bonus': 200, // +16% bonus
      'price': 7.99,
      'productId': 'gems_pack_large',
      'label': 'Gros Sac',
      'icon': '💍',
    },
    'gems_pack_mega': {
      'gems': 3000,
      'bonus': 700, // +23% bonus
      'price': 14.99,
      'productId': 'gems_pack_mega',
      'label': 'Coffre au Trésor',
      'icon': '🏆',
      'bestValue': true,
    },
  };

  /// Obtenir le total de gems d'un pack (base + bonus)
  static int getTotalGems(String packId) {
    final pack = GEMS_PACKS[packId];
    if (pack == null) return 0;
    return (pack['gems'] as int) + (pack['bonus'] as int);
  }

  /// Obtenir le pourcentage de bonus
  static int getBonusPercentage(String packId) {
    final pack = GEMS_PACKS[packId];
    if (pack == null) return 0;
    final base = pack['gems'] as int;
    final bonus = pack['bonus'] as int;
    if (base == 0) return 0;
    return ((bonus / base) * 100).round();
  }
}

/// Type d'action pour le tracking
enum GemsAction {
  earned,
  spent,
  purchased,
}

/// Historique des transactions de gems
class GemsTransaction {
  final String id;
  final String userId;
  final GemsAction action;
  final int amount;
  final String source; // 'daily_login', 'achievement', 'purchase', etc.
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  GemsTransaction({
    required this.id,
    required this.userId,
    required this.action,
    required this.amount,
    required this.source,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'action': action.toString(),
      'amount': amount,
      'source': source,
      'timestamp': Timestamp.fromDate(timestamp),
      'metadata': metadata,
    };
  }

  factory GemsTransaction.fromFirestore(Map<String, dynamic> data) {
    return GemsTransaction(
      id: data['id'] as String,
      userId: data['userId'] as String,
      action: GemsAction.values.firstWhere(
            (e) => e.toString() == data['action'],
        orElse: () => GemsAction.earned,
      ),
      amount: data['amount'] as int,
      source: data['source'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }
}