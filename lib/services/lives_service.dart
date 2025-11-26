import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/lives_model.dart';
import 'notification_service.dart';

class LivesService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LivesData? _livesData;
  LivesData? get livesData => _livesData;

  // Stream pour écouter les changements en temps réel
  Stream<LivesData> watchLives(String userId) {
    return _firestore
        .collection('lives')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return LivesData.fromFirestore(snapshot.data()!);
      }
      return LivesData.initial();
    });
  }

  // Chargement avec synchronisation et calcul du temps passé hors ligne
  Future<LivesData> loadLives(String userId) async {
    try {
      final doc = await _firestore.collection('lives').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        // 1. Charger les données brutes
        LivesData rawData = LivesData.fromFirestore(doc.data()!);

        // 2. Calculer la régénération (si le temps a passé hors ligne)
        _livesData = rawData.regenerate();

        // 3. Si des vies ont été régénérées (et qu'on n'est pas en illimité), on met à jour la BDD
        if (_livesData!.currentLives != rawData.currentLives) {
          _saveLives(userId, _livesData!);
        }

        // 4. Si les vies sont pleines ou illimitées, on annule les notifs de rappel
        if (_livesData!.isUnlimited || _livesData!.currentLives >= LivesData.MAX_LIVES) {
          await NotificationService().cancelLivesRefilledNotification();
        }
      } else {
        // Première utilisation : initialisation
        _livesData = LivesData.initial();
        await _saveLives(userId, _livesData!);
      }

      notifyListeners();
      return _livesData!;
    } catch (e) {
      if (kDebugMode) print('⚠️ ERREUR CRITIQUE chargement vies: $e');
      // En cas d'erreur, on initialise par défaut pour ne pas bloquer l'utilisateur
      _livesData ??= LivesData.initial();
      return _livesData!;
    }
  }

  // Méthode interne de sauvegarde
  Future<void> _saveLives(String userId, LivesData data) async {
    try {
      await _firestore
          .collection('lives')
          .doc(userId)
          .set(data.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('Erreur sauvegarde vies: $e');
    }
  }

  // Perdre une vie (avec gestion de l'illimité)
  Future<bool> loseLife(String userId, {String userName = 'Champion'}) async {
    if (_livesData == null) {
      await loadLives(userId);
    }

    // --- 1. VÉRIFICATION ILLIMITÉ ---
    // Si la semaine illimitée est active, on ne perd rien !
    if (_livesData!.isUnlimited) {
      if (kDebugMode) print('Vies illimitées actives ! Aucune perte.');
      return true;
    }

    // --- 2. LOGIQUE STANDARD ---
    // On s'assure d'être à jour avant de retirer une vie
    _livesData = _livesData!.regenerate();

    final available = _livesData!.availableLives;
    if (available <= 0) return false; // Bloque le jeu si 0 vies

    // Retirer une vie et reset du timer
    _livesData = _livesData!.copyWith(
      currentLives: available - 1,
      lastLossTime: DateTime.now(),
    );

    // Sauvegarder
    await _saveLives(userId, _livesData!);
    notifyListeners();

    // --- 3. NOTIFICATION ---
    // Programmer la notification de recharge si besoin
    int livesMissing = LivesData.MAX_LIVES - _livesData!.currentLives;
    if (livesMissing > 0) {
      // Temps total pour récupérer TOUTES les vies manquantes
      final timeToFullRefill = Duration(
          minutes: livesMissing * LivesData.REGENERATION_TIME.inMinutes
      );

      if (kDebugMode) {
        print('Vies manquantes: $livesMissing, Notification dans: ${timeToFullRefill.inMinutes} min');
      }

      await NotificationService().scheduleLivesRefilledNotification(
        userName: userName,
        timeRemaining: timeToFullRefill,
      );
    }

    return true;
  }

  // Recharger complètement les vies (Achat Consommable)
  Future<void> refillLives(String userId) async {
    if (_livesData == null) await loadLives(userId);

    _livesData = _livesData!.copyWith(
      currentLives: LivesData.MAX_LIVES,
      lastLossTime: DateTime.now(),
      totalLivesBought: _livesData!.totalLivesBought + 1,
    );

    await _saveLives(userId, _livesData!);
    notifyListeners();

    // Annuler la notification car on est plein
    await NotificationService().cancelLivesRefilledNotification();
  }

  // Activer la semaine illimitée (Achat Abonnement)
  Future<void> activateUnlimitedWeek(String userId) async {
    if (_livesData == null) await loadLives(userId);

    // On ajoute 7 jours à partir de maintenant
    final expiryDate = DateTime.now().add(const Duration(days: 7));

    _livesData = _livesData!.copyWith(
      currentLives: LivesData.MAX_LIVES, // On remplit aussi les cœurs pour l'esthétique
      unlimitedUntil: expiryDate,        // On définit la date de fin
      totalLivesBought: _livesData!.totalLivesBought + 1,
    );

    await _saveLives(userId, _livesData!);
    notifyListeners();

    // On annule les notifs de rappel puisqu'on est tranquille pour une semaine
    await NotificationService().cancelLivesRefilledNotification();
  }

  // Vérifier si l'utilisateur peut jouer
  Future<bool> canPlay(String userId) async {
    if (_livesData == null) await loadLives(userId);
    return _livesData!.canPlay; // Le modèle gère déjà le cas illimité -> canPlay renverra true
  }

  // Formatter le temps restant pour l'affichage UI
  String getFormattedTimeUntilNextLife() {
    if (_livesData == null) return '--:--';

    // Le modèle renvoie Duration.zero si illimité ou complet
    final duration = _livesData!.timeUntilNextLife;
    if (duration == Duration.zero) {
      return _livesData!.isUnlimited ? 'Illimité' : 'Complet';
    }

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}