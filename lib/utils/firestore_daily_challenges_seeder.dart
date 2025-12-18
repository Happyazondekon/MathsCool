// lib/utils/firestore_daily_challenges_seeder.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script pour peupler Firestore avec les défis quotidiens
/// À exécuter UNE SEULE FOIS pour initialiser la base de données
class FirestoreDailyChallengesSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thèmes disponibles par niveau
  static const Map<String, List<String>> _themesByLevel = {
    // PRIMAIRE
    'CI': ['Addition', 'Soustraction', 'Géométrie'],
    'CP': ['Addition', 'Soustraction', 'Géométrie'],
    'CE1': ['Addition', 'Soustraction', 'Multiplication', 'Géométrie'],
    'CE2': ['Addition', 'Soustraction', 'Multiplication', 'Division', 'Géométrie'],
    'CM1': ['Addition', 'Soustraction', 'Multiplication', 'Division', 'Géométrie'],
    'CM2': ['Addition', 'Soustraction', 'Multiplication', 'Division', 'Géométrie'],

    // COLLÈGE
    '6ème': ['Nombres Relatifs', 'Fractions', 'Géométrie', 'Multiplication', 'Division'],
    '5ème': ['Nombres Relatifs', 'Fractions', 'Algèbre', 'Géométrie'],
    '4ème': ['Nombres Relatifs', 'Fractions', 'Algèbre', 'Puissances', 'Théorèmes'],
    '3ème': ['Nombres Relatifs', 'Fractions', 'Algèbre', 'Puissances', 'Théorèmes', 'Statistiques'],
  };

  static const List<String> _allLevels = [
    'CI', 'CP', 'CE1', 'CE2', 'CM1', 'CM2',
    '6ème', '5ème', '4ème', '3ème'
  ];

  /// Méthode principale : Génère tous les défis jusqu'au 1er janvier 2026
  Future<void> seedDailyChallenges({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final start = startDate ?? DateTime.now();
      final end = endDate ?? DateTime(2026, 1, 1);

      if (kDebugMode) {
        print('🚀 Début du seeding des défis quotidiens...');
        print('📅 Du ${_formatDate(start)} au ${_formatDate(end)}');
      }

      int totalCreated = 0;
      DateTime currentDate = DateTime(start.year, start.month, start.day);

      // Boucle sur chaque jour
      while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
        // Créer un défi pour CHAQUE niveau
        for (String level in _allLevels) {
          await _createDailyChallengeForDate(currentDate, level);
          totalCreated++;
        }

        if (kDebugMode && totalCreated % 50 == 0) {
          print('✅ $totalCreated défis créés...');
        }

        // Passer au jour suivant
        currentDate = currentDate.add(const Duration(days: 1));
      }

      if (kDebugMode) {
        print('🎉 Seeding terminé ! $totalCreated défis créés.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors du seeding: $e');
      }
      rethrow;
    }
  }

  /// Crée un défi pour une date et un niveau spécifiques
  Future<void> _createDailyChallengeForDate(DateTime date, String level) async {
    try {
      // Générer l'ID unique (même logique que DailyChallengeService)
      final challengeId = _getChallengeId(date, level);

      // Vérifier si le défi existe déjà
      final exists = await _challengeExists(challengeId);
      if (exists) {
        if (kDebugMode) {
          print('⚠️ Défi $challengeId existe déjà, ignoré.');
        }
        return;
      }

      // Choisir un thème de manière déterministe (même pour tous les users)
      final theme = _selectThemeForDate(date, level);

      // Créer le document
      final challenge = {
        'id': challengeId,
        'level': level,
        'theme': theme,
        'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
        'totalQuestions': 10,
        'difficulty': _getDifficultyForLevel(level),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('dailyChallenges')
          .doc(challengeId)
          .set(challenge);

      if (kDebugMode) {
        print('✅ Créé: $challengeId ($level - $theme)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur création défi: $e');
      }
    }
  }

  /// Génère un ID de défi basé sur la date et le niveau
  String _getChallengeId(DateTime date, String level) {
    return 'challenge_${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}_$level';
  }

  /// Vérifie si un défi existe déjà
  Future<bool> _challengeExists(String challengeId) async {
    final doc = await _firestore
        .collection('dailyChallenges')
        .doc(challengeId)
        .get();
    return doc.exists;
  }

  /// Sélectionne un thème de manière déterministe basée sur la date
  String _selectThemeForDate(DateTime date, String level) {
    final availableThemes = _themesByLevel[level] ?? ['Addition'];

    // Utiliser la date comme seed pour avoir le même résultat à chaque fois
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);

    return availableThemes[random.nextInt(availableThemes.length)];
  }

  /// Retourne la difficulté en fonction du niveau
  int _getDifficultyForLevel(String level) {
    switch (level) {
      case 'CI':
      case 'CP':
        return 1;
      case 'CE1':
      case 'CE2':
        return 2;
      case 'CM1':
      case 'CM2':
        return 3;
      case '6ème':
      case '5ème':
        return 4;
      case '4ème':
      case '3ème':
        return 5;
      default:
        return 3;
    }
  }

  /// Formate une date pour l'affichage
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Supprime tous les défis (utile pour reset complet)
  Future<void> deleteAllChallenges() async {
    try {
      if (kDebugMode) {
        print('🗑️ Suppression de tous les défis...');
      }

      final snapshot = await _firestore
          .collection('dailyChallenges')
          .get();

      // Batch delete (par lot de 500 max)
      final batch = _firestore.batch();
      int count = 0;

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
        count++;

        // Firestore limite à 500 opérations par batch
        if (count % 500 == 0) {
          await batch.commit();
          if (kDebugMode) {
            print('🗑️ $count défis supprimés...');
          }
        }
      }

      // Commit des derniers
      await batch.commit();

      if (kDebugMode) {
        print('✅ $count défis supprimés au total.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur suppression: $e');
      }
      rethrow;
    }
  }

  /// Statistiques sur les défis créés
  Future<Map<String, dynamic>> getChallengeStats() async {
    try {
      final snapshot = await _firestore
          .collection('dailyChallenges')
          .get();

      final total = snapshot.docs.length;
      final byLevel = <String, int>{};
      final byTheme = <String, int>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final level = data['level'] as String;
        final theme = data['theme'] as String;

        byLevel[level] = (byLevel[level] ?? 0) + 1;
        byTheme[theme] = (byTheme[theme] ?? 0) + 1;
      }

      return {
        'total': total,
        'byLevel': byLevel,
        'byTheme': byTheme,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur stats: $e');
      }
      return {};
    }
  }

  /// Génère des défis pour un mois spécifique
  Future<void> seedMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // Dernier jour du mois

    if (kDebugMode) {
      print('📅 Génération des défis pour $month/$year');
    }

    await seedDailyChallenges(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Génère les défis pour l'année complète
  Future<void> seedYear(int year) async {
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);

    if (kDebugMode) {
      print('📅 Génération des défis pour l\'année $year');
    }

    await seedDailyChallenges(
      startDate: startDate,
      endDate: endDate,
    );
  }
}