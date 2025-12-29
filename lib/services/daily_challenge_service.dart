// lib/services/daily_challenge_service.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mathscool/services/username_service.dart';
import '../models/daily_challenge_model.dart';

class DailyChallengeService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thèmes disponibles pour rotation
  static const List<String> _themes = [
    'Addition',
    'Soustraction',
    'Multiplication',
    'Division',
    'Géométrie',
    'Nombres Relatifs',
    'Fractions',
    'Algèbre',
    'Puissances',
  ];

  static const List<String> _levels = [
    'CI', 'CP', 'CE1', 'CE2', 'CM1', 'CM2',
    '6ème', '5ème', '4ème', '3ème'
  ];

  /// Récupère le défi du jour (créé automatiquement si inexistant)
  Future<DailyChallenge> getTodayChallenge(String userLevel) async {
    try {
      final today = DateTime.now();

      // CORRECTION : Générer l'ID avec le niveau
      final todayId = _getChallengeId(today, userLevel);

      if (kDebugMode) {
        print('🔍 Recherche du défi: $todayId');
      }

      // Vérifier si le défi existe déjà
      final doc = await _firestore
          .collection('dailyChallenges')
          .doc(todayId)
          .get();

      if (doc.exists && doc.data() != null) {
        if (kDebugMode) {
          print('✅ Défi trouvé: ${doc.data()!['theme']}');
        }
        return DailyChallenge.fromFirestore(doc.data()!);
      }

      // Si le défi n'existe pas, on crée un défi fallback
      if (kDebugMode) {
        print('⚠️ Défi non trouvé, création d\'un nouveau...');
      }

      final newChallenge = _generateDailyChallenge(today, userLevel);

      // Sauvegarder le nouveau défi
      await _firestore
          .collection('dailyChallenges')
          .doc(todayId)
          .set(newChallenge.toFirestore());

      if (kDebugMode) {
        print('✅ Nouveau défi créé: ${newChallenge.theme}');
      }

      return newChallenge;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération défi: $e');
      }
      rethrow;
    }
  }

  /// Génère un ID unique basé sur la date ET le niveau
  String _getChallengeId(DateTime date, String level) {
    return 'challenge_${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}_$level';
  }

  /// Génère un nouveau défi quotidien
  DailyChallenge _generateDailyChallenge(DateTime date, String userLevel) {
    // Utiliser la date comme seed pour avoir le même thème pour tous les utilisateurs
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    final theme = _themes[random.nextInt(_themes.length)];
    final id = _getChallengeId(date, userLevel);

    return DailyChallenge(
      id: id,
      level: userLevel,
      theme: theme,
      date: DateTime(date.year, date.month, date.day), // Minuit
      totalQuestions: 10,
      difficulty: 3,
    );
  }

  /// Vérifie si l'utilisateur a complété le défi du jour
  Future<bool> hasTodayChallengeCompleted(String userId) async {
    try {
      final today = DateTime.now();

      // IMPORTANT : Chercher TOUS les défis du jour (tous niveaux)
      // car on ne connaît pas encore le niveau de l'user ici
      final todayPrefix = 'challenge_${today.year}_${today.month.toString().padLeft(2, '0')}_${today.day.toString().padLeft(2, '0')}';

      if (kDebugMode) {
        print('🔍 Vérification completion pour: $todayPrefix');
      }

      // Chercher les résultats qui commencent par le préfixe du jour
      final results = await _firestore
          .collection('dailyChallengeResults')
          .where('userId', isEqualTo: userId)
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(
        DateTime(today.year, today.month, today.day),
      ))
          .limit(1)
          .get();

      if (kDebugMode) {
        print('📊 Résultats trouvés: ${results.docs.length}');
      }

      return results.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur vérification completion: $e');
      }
      return false;
    }
  }

  /// Sauvegarde le résultat d'un utilisateur
  Future<void> saveResult(DailyChallengeResult result) async {
    try {
      final docId = '${result.userId}_${result.challengeId}';

      if (kDebugMode) {
        print('💾 Sauvegarde résultat: $docId');
      }

      // Sauvegarder le résultat
      await _firestore
          .collection('dailyChallengeResults')
          .doc(docId)
          .set(result.toFirestore());

      // Mettre à jour le leaderboard
      await _updateLeaderboard(result);

      if (kDebugMode) {
        print('✅ Résultat sauvegardé avec succès');
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur sauvegarde résultat: $e');
      }
      rethrow;
    }
  }

  /// Met à jour le classement de l'utilisateur
  Future<void> _updateLeaderboard(DailyChallengeResult result) async {
    try {
      final leaderboardRef = _firestore
          .collection('leaderboard')
          .doc(result.userId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(leaderboardRef);

        // Récupérer le vrai username depuis UsernameService
        String userName = 'MathKid';
        try {
          final usernameService = UsernameService();
          userName = await usernameService.getUsername(result.userId);
        } catch (e) {
          print('⚠️ Erreur récupération username: $e');
        }

        if (!doc.exists) {
          // Créer une nouvelle entrée avec le vrai username
          final newEntry = LeaderboardEntry(
            userId: result.userId,
            userName: userName, // Utiliser le vrai username
            totalScore: result.score,
            challengesCompleted: 1,
            currentStreak: 1,
            bestStreak: 1,
            totalStars: result.stars,
            lastPlayed: result.completedAt,
          );
          transaction.set(leaderboardRef, newEntry.toFirestore());

          if (kDebugMode) {
            print('✅ Nouvelle entrée leaderboard créée avec username: $userName');
          }
        } else {
          // Reste du code inchangé...
          final data = doc.data()!;
          final entry = LeaderboardEntry.fromFirestore(data);

          final lastPlayed = entry.lastPlayed;
          final daysDifference = result.completedAt.difference(lastPlayed).inDays;

          int newStreak = entry.currentStreak;
          if (daysDifference == 1) {
            newStreak = entry.currentStreak + 1;
          } else if (daysDifference > 1) {
            newStreak = 1;
          }

          final updatedEntry = entry.copyWith(
            userName: userName, // Mettre à jour le username à chaque fois
            totalScore: entry.totalScore + result.score,
            challengesCompleted: entry.challengesCompleted + 1,
            currentStreak: newStreak,
            bestStreak: max(entry.bestStreak, newStreak),
            totalStars: entry.totalStars + result.stars,
            lastPlayed: result.completedAt,
          );

          transaction.update(leaderboardRef, updatedEntry.toFirestore());

          if (kDebugMode) {
            print('✅ Leaderboard mis à jour - Username: $userName, Streak: $newStreak');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur mise à jour leaderboard: $e');
      }
    }
  }
  /// Récupère le top 10 du classement
  Future<List<LeaderboardEntry>> getTopLeaderboard({int limit = 10}) async {
    try {
      if (kDebugMode) {
        print('🏆 Récupération du top $limit');
      }

      final snapshot = await _firestore
          .collection('leaderboard')
          .orderBy('totalScore', descending: true)
          .limit(limit)
          .get();

      if (kDebugMode) {
        print('📊 Top joueurs trouvés: ${snapshot.docs.length}');
      }

      return snapshot.docs
          .map((doc) => LeaderboardEntry.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération leaderboard: $e');
      }
      return [];
    }
  }

  /// Récupère les stats de l'utilisateur
  Future<LeaderboardEntry?> getUserStats(String userId) async {
    try {
      final doc = await _firestore
          .collection('leaderboard')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return LeaderboardEntry.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération stats: $e');
      }
      return null;
    }
  }

  /// Récupère l'historique des défis de l'utilisateur
  Future<List<DailyChallengeResult>> getUserHistory(String userId, {int limit = 7}) async {
    try {
      final snapshot = await _firestore
          .collection('dailyChallengeResults')
          .where('userId', isEqualTo: userId)
          .orderBy('completedAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => DailyChallengeResult.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération historique: $e');
      }
      return [];
    }
  }

  /// Réinitialise les classements chaque mois (à appeler via Cloud Function)
  Future<void> resetMonthlyLeaderboard() async {
    try {
      final batch = _firestore.batch();

      final snapshot = await _firestore
          .collection('leaderboard')
          .get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {
          'totalScore': 0,
          'challengesCompleted': 0,
          'totalStars': 0,
        });
      }

      await batch.commit();
      notifyListeners();

      if (kDebugMode) {
        print('✅ Leaderboard mensuel réinitialisé');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur reset leaderboard: $e');
      }
    }
  }
}