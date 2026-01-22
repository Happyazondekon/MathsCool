import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/gems_model.dart';
import 'dart:async';

class GemsService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GemsData? _gemsData;
  GemsData? get gemsData => _gemsData;

  int get currentGems => _gemsData?.currentGems ?? 0;

  // ✅ AJOUT : Stream subscription pour écouter Firestore
  StreamSubscription<DocumentSnapshot>? _gemsSubscription;
  String? _currentUserId;

  @override
  void dispose() {
    _gemsSubscription?.cancel();
    super.dispose();
  }

  // ========== ✅ NOUVELLE MÉTHODE : SYNCHRONISATION EN TEMPS RÉEL ==========

  /// Démarrer l'écoute des changements Firestore
  void startListening(String userId) {
    // Annuler l'ancien listener si l'utilisateur change
    if (_currentUserId != userId) {
      _gemsSubscription?.cancel();
      _currentUserId = userId;
    }

    _gemsSubscription = _firestore
        .collection('gems')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        _gemsData = GemsData.fromFirestore(snapshot.data()!);
      } else {
        _gemsData = GemsData.initial();
      }
      notifyListeners();
      if (kDebugMode) print('💎 Gems synchronisés: ${_gemsData?.currentGems}');
    }, onError: (error) {
      if (kDebugMode) print('❌ Erreur stream gems: $error');
    });
  }

  /// Arrêter l'écoute (déconnexion)
  void stopListening() {
    _gemsSubscription?.cancel();
    _gemsSubscription = null;
    _currentUserId = null;
    _gemsData = null;
    notifyListeners();
  }

  // ========== CHARGEMENT INITIAL ==========

  /// Charger les gems de l'utilisateur (initial load + start listening)
  Future<GemsData> loadGems(String userId) async {
    try {
      // ✅ Démarrer l'écoute en temps réel
      startListening(userId);

      final doc = await _firestore.collection('gems').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        _gemsData = GemsData.fromFirestore(doc.data()!);
      } else {
        // Première utilisation : Cadeau de bienvenue
        _gemsData = GemsData.initial();
        await _saveGems(userId);

        // Enregistrer la transaction
        await _logTransaction(
          userId: userId,
          action: GemsAction.earned,
          amount: GemsPricing.WELCOME_BONUS,
          source: 'welcome_bonus',
        );
      }

      notifyListeners();
      return _gemsData!;
    } catch (e) {
      if (kDebugMode) print('❌ Erreur chargement gems: $e');
      _gemsData = GemsData.initial();
      return _gemsData!;
    }
  }

  /// ✅ MODIFIÉ : Sauvegarder avec transaction atomique
  Future<void> _saveGems(String userId) async {
    if (_gemsData == null) return;

    try {
      // ✅ Utiliser une transaction Firestore pour éviter les race conditions
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('gems').doc(userId);

        // Lire la dernière valeur
        final snapshot = await transaction.get(docRef);

        // Écrire la nouvelle valeur
        transaction.set(
          docRef,
          _gemsData!.toFirestore(),
          SetOptions(merge: true),
        );
      });

      if (kDebugMode) print('✅ Gems sauvegardés: ${_gemsData!.currentGems}');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur sauvegarde gems: $e');
      rethrow;
    }
  }

  // ========== GAINS DE GEMS (Gratuits) ==========

  /// Ajouter des gems (récompenses gratuites)
  Future<void> addGems(
      String userId,
      int amount, {
        required String source,
        Map<String, dynamic>? metadata,
      }) async {
    if (_gemsData == null) await loadGems(userId);

    try {
      // ✅ Utiliser une transaction atomique
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('gems').doc(userId);
        final snapshot = await transaction.get(docRef);

        GemsData currentData;
        if (snapshot.exists && snapshot.data() != null) {
          currentData = GemsData.fromFirestore(snapshot.data()!);
        } else {
          currentData = GemsData.initial();
        }

        // Mettre à jour les totaux
        final updatedEarnedFrom = Map<String, int>.from(currentData.earnedFrom);
        updatedEarnedFrom[source] = (updatedEarnedFrom[source] ?? 0) + amount;

        final updatedData = currentData.copyWith(
          currentGems: currentData.currentGems + amount,
          totalGemsEarned: currentData.totalGemsEarned + amount,
          lastUpdated: DateTime.now(),
          earnedFrom: updatedEarnedFrom,
        );

        transaction.set(docRef, updatedData.toFirestore(), SetOptions(merge: true));

        // ✅ Mettre à jour l'état local (le listener mettra à jour aussi)
        _gemsData = updatedData;
      });

      notifyListeners();

      // Logger la transaction
      await _logTransaction(
        userId: userId,
        action: GemsAction.earned,
        amount: amount,
        source: source,
        metadata: metadata,
      );

      if (kDebugMode) print('💎 +$amount gems (source: $source)');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur ajout gems: $e');
      rethrow;
    }
  }

  /// Récompense quotidienne
  Future<void> claimDailyReward(String userId) async {
    await addGems(
      userId,
      GemsPricing.DAILY_LOGIN_REWARD,
      source: 'daily_login',
    );
  }

  /// Récompense pour score parfait
  Future<void> rewardPerfectScore(String userId) async {
    await addGems(
      userId,
      GemsPricing.PERFECT_SCORE_REWARD,
      source: 'perfect_score',
    );
  }

  /// Récompense pour streak
  Future<void> rewardStreak(String userId, int streakDays) async {
    int reward = 0;

    if (streakDays >= 7) {
      reward = GemsPricing.STREAK_7_DAYS_REWARD;
    } else if (streakDays >= 3) {
      reward = GemsPricing.STREAK_3_DAYS_REWARD;
    }

    if (reward > 0) {
      await addGems(
        userId,
        reward,
        source: 'streak_$streakDays',
        metadata: {'streak_days': streakDays},
      );
    }
  }

  /// Récompense pour achievement
  Future<void> rewardAchievement(
      String userId,
      String achievementId,
      int gemsAmount,
      ) async {
    await addGems(
      userId,
      gemsAmount,
      source: 'achievement',
      metadata: {'achievement_id': achievementId},
    );
  }

  /// Récompense pour défi quotidien
  Future<void> rewardDailyChallenge(String userId) async {
    await addGems(
      userId,
      GemsPricing.DAILY_CHALLENGE_REWARD,
      source: 'daily_challenge',
    );
  }

  // ========== DÉPENSES DE GEMS ==========

  /// ✅ MODIFIÉ : Dépenser des gems avec transaction atomique
  Future<bool> spendGems(
      String userId,
      int amount, {
        required String purpose,
        Map<String, dynamic>? metadata,
      }) async {
    if (_gemsData == null) await loadGems(userId);

    try {
      bool success = false;

      // ✅ Transaction atomique pour éviter les dépenses simultanées
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('gems').doc(userId);
        final snapshot = await transaction.get(docRef);

        GemsData currentData;
        if (snapshot.exists && snapshot.data() != null) {
          currentData = GemsData.fromFirestore(snapshot.data()!);
        } else {
          currentData = GemsData.initial();
        }

        // Vérifier si on peut se permettre
        if (!currentData.canAfford(amount)) {
          if (kDebugMode) {
            print('❌ Pas assez de gems: ${currentData.currentGems} < $amount');
          }
          success = false;
          return;
        }

        // Mettre à jour les totaux
        final updatedSpentOn = Map<String, int>.from(currentData.spentOn);
        updatedSpentOn[purpose] = (updatedSpentOn[purpose] ?? 0) + amount;

        final updatedData = currentData.copyWith(
          currentGems: currentData.currentGems - amount,
          totalGemsSpent: currentData.totalGemsSpent + amount,
          lastUpdated: DateTime.now(),
          spentOn: updatedSpentOn,
        );

        transaction.set(docRef, updatedData.toFirestore(), SetOptions(merge: true));

        _gemsData = updatedData;
        success = true;
      });

      if (success) {
        notifyListeners();

        // Logger la transaction
        await _logTransaction(
          userId: userId,
          action: GemsAction.spent,
          amount: amount,
          source: purpose,
          metadata: metadata,
        );

        if (kDebugMode) print('💸 -$amount gems (purpose: $purpose)');
      }

      return success;

    } catch (e) {
      if (kDebugMode) print('❌ Erreur dépense gems: $e');
      return false;
    }
  }

  /// Recharge rapide des vies (50 gems)
  Future<bool> buyFastRefill(String userId) async {
    return await spendGems(
      userId,
      GemsPricing.FAST_REFILL_COST,
      purpose: 'fast_refill',
    );
  }

  /// Acheter un hint (20 gems)
  Future<bool> buyHint(String userId) async {
    return await spendGems(
      userId,
      GemsPricing.HINT_COST,
      purpose: 'hint',
    );
  }

  /// Skip une question difficile (30 gems)
  Future<bool> skipQuestion(String userId) async {
    return await spendGems(
      userId,
      GemsPricing.SKIP_QUESTION_COST,
      purpose: 'skip_question',
    );
  }

  /// Débloquer un thème premium (100 gems)
  Future<bool> unlockTheme(String userId, String themeId) async {
    final success = await spendGems(
      userId,
      GemsPricing.THEME_UNLOCK_COST,
      purpose: 'unlock_theme',
      metadata: {'theme_id': themeId},
    );

    if (success) {
      await _firestore.collection('unlockedThemes').doc(userId).set({
        themeId: true,
        'unlockedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return success;
  }

  /// Débloquer un avatar (75 gems)
  Future<bool> unlockAvatar(String userId, String avatarId) async {
    final success = await spendGems(
      userId,
      GemsPricing.UNLOCK_AVATAR_COST,
      purpose: 'unlock_avatar',
      metadata: {'avatar_id': avatarId},
    );

    if (success) {
      await _firestore.collection('unlockedAvatars').doc(userId).set({
        avatarId: true,
        'unlockedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return success;
  }

  /// Boost XP x2 pendant 1h (40 gems)
  Future<bool> activateXPBoost(String userId) async {
    final success = await spendGems(
      userId,
      GemsPricing.BOOST_XP_COST,
      purpose: 'xp_boost',
    );

    if (success) {
      final expiryTime = DateTime.now().add(const Duration(hours: 1));
      await _firestore.collection('activeBoosts').doc(userId).set({
        'xp_boost': true,
        'expiryTime': Timestamp.fromDate(expiryTime),
      }, SetOptions(merge: true));
    }

    return success;
  }

  // ========== ACHATS IN-APP ==========

  /// Acheter un pack de gems (In-App Purchase)
  Future<void> purchaseGemsPack(String userId, String packId) async {
    if (_gemsData == null) await loadGems(userId);

    final totalGems = GemsPricing.getTotalGems(packId);
    final pack = GemsPricing.GEMS_PACKS[packId];

    if (pack == null) return;

    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('gems').doc(userId);
        final snapshot = await transaction.get(docRef);

        GemsData currentData;
        if (snapshot.exists && snapshot.data() != null) {
          currentData = GemsData.fromFirestore(snapshot.data()!);
        } else {
          currentData = GemsData.initial();
        }

        final updatedData = currentData.copyWith(
          currentGems: currentData.currentGems + totalGems,
          totalGemsEarned: currentData.totalGemsEarned + totalGems,
          lastUpdated: DateTime.now(),
        );

        transaction.set(docRef, updatedData.toFirestore(), SetOptions(merge: true));
        _gemsData = updatedData;
      });

      notifyListeners();

      // Logger la transaction
      await _logTransaction(
        userId: userId,
        action: GemsAction.purchased,
        amount: totalGems,
        source: packId,
        metadata: {
          'price': pack['price'],
          'base_gems': pack['gems'],
          'bonus_gems': pack['bonus'],
        },
      );

      if (kDebugMode) {
        print('💰 Achat de $totalGems gems (pack: $packId)');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Erreur achat gems: $e');
      rethrow;
    }
  }

  // ========== UTILITAIRES ==========

  /// Vérifier si on peut se permettre une action
  bool canAfford(int cost) {
    return _gemsData?.canAfford(cost) ?? false;
  }

  /// Calculer combien de gems manquent
  int getMissingGems(int cost) {
    return _gemsData?.getMissingGems(cost) ?? cost;
  }

  /// ✅ MODIFIÉ : Stream déjà géré par startListening()
  Stream<GemsData> watchGems(String userId) {
    return _firestore.collection('gems').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return GemsData.fromFirestore(snapshot.data()!);
      }
      return GemsData.initial();
    });
  }

  /// Obtenir l'historique des transactions (limité aux 50 dernières)
  Future<List<GemsTransaction>> getTransactionHistory(
      String userId, {
        int limit = 50,
      }) async {
    try {
      final snapshot = await _firestore
          .collection('gemsTransactions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => GemsTransaction.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) print('❌ Erreur récupération historique: $e');
      return [];
    }
  }

  /// Logger une transaction
  Future<void> _logTransaction({
    required String userId,
    required GemsAction action,
    required int amount,
    required String source,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final transaction = GemsTransaction(
        id: _firestore.collection('gemsTransactions').doc().id,
        userId: userId,
        action: action,
        amount: amount,
        source: source,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      await _firestore
          .collection('gemsTransactions')
          .doc(transaction.id)
          .set(transaction.toFirestore());
    } catch (e) {
      if (kDebugMode) print('❌ Erreur log transaction: $e');
    }
  }

  /// Obtenir les statistiques des gems
  Map<String, dynamic> getGemsStats() {
    if (_gemsData == null) {
      return {
        'current': 0,
        'earned': 0,
        'spent': 0,
        'topEarnSource': null,
        'topSpendPurpose': null,
      };
    }

    String? topEarnSource;
    int maxEarned = 0;
    _gemsData!.earnedFrom.forEach((source, amount) {
      if (amount > maxEarned) {
        maxEarned = amount;
        topEarnSource = source;
      }
    });

    String? topSpendPurpose;
    int maxSpent = 0;
    _gemsData!.spentOn.forEach((purpose, amount) {
      if (amount > maxSpent) {
        maxSpent = amount;
        topSpendPurpose = purpose;
      }
    });

    return {
      'current': _gemsData!.currentGems,
      'earned': _gemsData!.totalGemsEarned,
      'spent': _gemsData!.totalGemsSpent,
      'topEarnSource': topEarnSource,
      'topSpendPurpose': topSpendPurpose,
    };
  }

  /// Réinitialiser les gems (pour tests)
  Future<void> resetGems(String userId) async {
    _gemsData = GemsData.initial();
    await _saveGems(userId);
    notifyListeners();
  }
}