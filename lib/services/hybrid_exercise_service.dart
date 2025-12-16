import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/exercise_model.dart';
import '../data/static_exercises.dart';
import 'exercise_generator_service.dart';

/// Service hybride qui combine exercices statiques et générés dynamiquement (IA/Algo)
class HybridExerciseService {
  final ExerciseGeneratorService _generator = ExerciseGeneratorService();
  final Connectivity _connectivity = Connectivity();

  // Cache pour éviter de vérifier la connexion à chaque appel
  bool? _lastConnectionStatus;
  DateTime? _lastConnectionCheck;
  static const _connectionCheckInterval = Duration(seconds: 10);

  /// Récupère les exercices selon la disponibilité de connexion
  ///
  /// Stratégies :
  /// - ONLINE: 50% static + 50% generated (mélange pour varier)
  /// - OFFLINE: 100% static (fallback sécurisé)
  Future<List<Exercise>> getExercises({
    required String level,
    required String theme,
    int count = 20,
    bool forceGenerated = false,
  }) async {
    final hasConnection = await _checkConnection();

    if (forceGenerated && hasConnection) {
      // Mode "Entraînement Infini" forcé
      // MODIFICATION : Ajout de await car la génération est maintenant asynchrone
      return await _generator.generateExercises(
        level: level,
        theme: theme,
        count: count,
      );
    }

    if (hasConnection) {
      // STRATÉGIE HYBRIDE : Mélange intelligent
      return await _getMixedExercises(level, theme, count);
    } else {
      // FALLBACK : Uniquement statique
      return _getStaticExercises(level, theme, count);
    }
  }

  /// Vérifie la connexion internet avec cache
  Future<bool> _checkConnection() async {
    // Cache de 10 secondes pour éviter les appels réseau répétés
    if (_lastConnectionStatus != null &&
        _lastConnectionCheck != null &&
        DateTime.now().difference(_lastConnectionCheck!) < _connectionCheckInterval) {
      return _lastConnectionStatus!;
    }

    try {
      final result = await _connectivity.checkConnectivity();
      // On considère connecté si on a du mobile, du wifi ou ethernet
      _lastConnectionStatus = !result.contains(ConnectivityResult.none);
      _lastConnectionCheck = DateTime.now();
      return _lastConnectionStatus!;
    } catch (e) {
      print('⚠️ Erreur vérification connexion: $e');
      return false; // En cas d'erreur, on assume offline
    }
  }

  /// Stratégie de mélange : 50% static + 50% generated
  Future<List<Exercise>> _getMixedExercises(
      String level,
      String theme,
      int totalCount,
      ) async {
    try {
      final staticExercises = _getStaticExercises(level, theme, totalCount ~/ 2);
      final generatedCount = totalCount - staticExercises.length;

      List<Exercise> generatedExercises = [];
      if (generatedCount > 0) {
        // MODIFICATION : Ajout de await
        generatedExercises = await _generator.generateExercises(
          level: level,
          theme: theme,
          count: generatedCount,
        );
      }

      // Mélange aléatoire des deux types
      final mixed = [...staticExercises, ...generatedExercises];
      mixed.shuffle(Random());

      print('✅ Exercices hybrides: ${staticExercises.length} static + ${generatedExercises.length} generated');
      return mixed;
    } catch (e) {
      print('⚠️ Erreur mélange, fallback vers static: $e');
      return _getStaticExercises(level, theme, totalCount);
    }
  }

  /// Récupère les exercices statiques du fichier local
  List<Exercise> _getStaticExercises(String level, String theme, int count) {
    // Typage explicite pour éviter les erreurs de type dynamique
    final List<Exercise> allStatic = staticExercises[level]?[theme] ?? <Exercise>[];

    if (allStatic.isEmpty) {
      print('⚠️ Aucun exercice statique pour $level - $theme');
      return [];
    }

    // Si on demande plus que disponible, on duplique et mélange
    if (count > allStatic.length) {
      final copies = (count / allStatic.length).ceil();

      // Utilisation de List.generate suivie de expand pour aplatir la liste de listes
      final duplicated = List.generate(
        copies,
            (_) => allStatic,
      ).expand((e) => e).toList();

      duplicated.shuffle(Random());
      return duplicated.take(count).toList();
    }

    // Sinon, on prend un échantillon aléatoire
    final shuffled = List<Exercise>.from(allStatic)..shuffle(Random());
    return shuffled.take(count).toList();
  }

  /// Stream pour écouter les changements de connexion en temps réel
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((result) {
      final isConnected = !result.contains(ConnectivityResult.none);
      _lastConnectionStatus = isConnected;
      _lastConnectionCheck = DateTime.now();
      return isConnected;
    });
  }

  /// Statistiques pour debug/analytics
  Future<Map<String, dynamic>> getExerciseStats(String level, String theme) async {
    final hasConnection = await _checkConnection();
    final staticCount = (staticExercises[level]?[theme] ?? []).length;

    return {
      'hasConnection': hasConnection,
      'staticAvailable': staticCount,
      'canGenerate': hasConnection, // La génération dépend maintenant de la connexion pour l'IA
      'recommendedMode': hasConnection ? 'hybrid' : 'static',
    };
  }

  /// Précharge les exercices pour une meilleure UX
  Future<void> preloadExercises({
    required String level,
    required String theme,
  }) async {
    // Charge en arrière-plan sans bloquer l'UI
    await getExercises(level: level, theme: theme, count: 20);
  }

  /// Vérifie si des exercices sont disponibles pour ce niveau/thème
  Future<bool> hasExercisesAvailable(String level, String theme) async {
    final hasConnection = await _checkConnection();
    final staticCount = (staticExercises[level]?[theme] ?? []).length;

    // Disponible si : exercices statiques OU connexion pour génération
    return staticCount > 0 || hasConnection;
  }

  /// Mode "Entraînement Infini" : Génération pure en streaming
  Stream<List<Exercise>> infiniteExerciseStream({
    required String level,
    required String theme,
    int batchSize = 20,
  }) async* {
    while (true) {
      final hasConnection = await _checkConnection();

      if (hasConnection) {
        // MODIFICATION : Ajout de await pour le stream
        yield await _generator.generateExercises(
          level: level,
          theme: theme,
          count: batchSize,
        );
      } else {
        // En mode infini sans connexion, on recycle les statiques
        yield _getStaticExercises(level, theme, batchSize);
      }

      // Attente pour éviter la surcharge (optionnel)
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Obtenir un mix personnalisé selon les préférences
  Future<List<Exercise>> getCustomMix({
    required String level,
    required String theme,
    required int count,
    double staticRatio = 0.5, // 50% par défaut
  }) async {
    final hasConnection = await _checkConnection();

    if (!hasConnection) {
      return _getStaticExercises(level, theme, count);
    }

    final staticCount = (count * staticRatio).round();
    final generatedCount = count - staticCount;

    final staticExs = _getStaticExercises(level, theme, staticCount);

    // MODIFICATION : Ajout de await
    final generatedExs = await _generator.generateExercises(
      level: level,
      theme: theme,
      count: generatedCount,
    );

    final mixed = [...staticExs, ...generatedExs];
    mixed.shuffle(Random());
    return mixed;
  }
}