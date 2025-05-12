import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestorePopulator {
  static Future<void> populateExercises() async {
    try {
      // Initialiser Firebase si ce n'est pas déjà fait
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      // Exercices de CP - Addition
      final cpAdditionExercises = [
        {
          'level': 'CP',
          'theme': 'Addition',
          'question': '2 + 3 = ?',
          'options': ['4', '5', '6', '7'],
          'correctAnswer': 1,
        },
        {
          'level': 'CP',
          'theme': 'Addition',
          'question': '5 + 4 = ?',
          'options': ['8', '9', '10', '11'],
          'correctAnswer': 2,
        },
        {
          'level': 'CP',
          'theme': 'Addition',
          'question': '1 + 6 = ?',
          'options': ['5', '6', '7', '8'],
          'correctAnswer': 2,
        }
      ];

      // Exercices de CP - Soustraction
      final cpSoustractionExercises = [
        {
          'level': 'CP',
          'theme': 'Soustraction',
          'question': '7 - 3 = ?',
          'options': ['3', '4', '5', '6'],
          'correctAnswer': 1,
        },
        {
          'level': 'CP',
          'theme': 'Soustraction',
          'question': '9 - 5 = ?',
          'options': ['2', '3', '4', '5'],
          'correctAnswer': 2,
        }
      ];

      // Ajout des exercices
      for (var exercise in [...cpAdditionExercises, ...cpSoustractionExercises]) {
        final docRef = firestore.collection('exercises').doc();
        batch.set(docRef, exercise);
      }

      // Ajout des thèmes
      final themes = [
        {
          'level': 'CP',
          'name': 'Addition',
          'description': 'Apprends à additionner',
          'difficulty': 1
        },
        {
          'level': 'CP',
          'name': 'Soustraction',
          'description': 'Apprends à soustraire',
          'difficulty': 1
        }
      ];

      for (var theme in themes) {
        final docRef = firestore.collection('themes').doc();
        batch.set(docRef, theme);
      }

      // Ajout des badges
      final badges = [
        {
          'name': 'Champion des Additions',
          'description': 'Maîtrise parfaitement les additions',
          'icon': 'add',
          'requiredProgress': 0.8,
          'level': 'CP'
        },
        {
          'name': 'Maître des Soustractions',
          'description': 'Expert en soustraction',
          'icon': 'remove',
          'requiredProgress': 0.7,
          'level': 'CP'
        }
      ];

      for (var badge in badges) {
        final docRef = firestore.collection('badges').doc();
        batch.set(docRef, badge);
      }

      // Commit du batch
      await batch.commit();
      debugPrint('Données ajoutées avec succès à Firestore !');
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout des données : $e');
    }
  }

  // Méthode pour vérifier les données
  static Future<void> checkPopulatedData() async {
    final firestore = FirebaseFirestore.instance;

    // Vérifier les exercices
    final exercisesQuery = await firestore.collection('exercises').get();
    debugPrint('Nombre d\'exercices : ${exercisesQuery.docs.length}');

    // Vérifier les thèmes
    final themesQuery = await firestore.collection('themes').get();
    debugPrint('Nombre de thèmes : ${themesQuery.docs.length}');

    // Vérifier les badges
    final badgesQuery = await firestore.collection('badges').get();
    debugPrint('Nombre de badges : ${badgesQuery.docs.length}');
  }
}

// Exemple d'utilisation dans une application Flutter
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Peupler Firestore
  await FirestorePopulator.populateExercises();

  // Vérifier les données
  await FirestorePopulator.checkPopulatedData();
}