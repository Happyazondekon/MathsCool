import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/lives_model.dart';
import 'notification_service.dart'; // NOUVEAU : Import du service de notification

class LivesService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LivesData? _livesData;
  LivesData? get livesData => _livesData;

  // Stream pour écouter les changements
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

  // Chargement avec synchronisation
  Future<LivesData> loadLives(String userId) async {
    try {
      final doc = await _firestore.collection('lives').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        // 1. Charger les données brutes
        LivesData rawData = LivesData.fromFirestore(doc.data()!);

        // 2. Calculer la régénération (temps passé hors ligne)
        _livesData = rawData.regenerate();

        // 3. Si des vies ont été régénérées, on met à jour la base de données
        if (_livesData!.currentLives != rawData.currentLives) {
          _saveLives(userId, _livesData!);
        }

        // 4. Si les vies sont pleines, on annule les notifications de rappel (car l'utilisateur est là)
        if (_livesData!.currentLives >= LivesData.MAX_LIVES) {
          await NotificationService().cancelLivesRefilledNotification();
        }
      } else {
        // Première utilisation
        _livesData = LivesData.initial();
        await _saveLives(userId, _livesData!);
      }

      notifyListeners();
      return _livesData!;
    } catch (e) {
      if (kDebugMode) print('⚠️ ERREUR CRITIQUE chargement vies: $e');
      _livesData ??= LivesData.initial();
      return _livesData!;
    }
  }

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

  // MODIFIÉ : Ajout du paramètre optionnel userName pour la notification
  Future<bool> loseLife(String userId, {String userName = 'Champion'}) async {
    if (_livesData == null) {
      await loadLives(userId);
    }

    // On s'assure d'être à jour avant de retirer une vie
    _livesData = _livesData!.regenerate();

    final available = _livesData!.availableLives;
    if (available <= 0) return false;

    // Mettre à jour les données
    _livesData = _livesData!.copyWith(
      currentLives: available - 1,
      lastLossTime: DateTime.now(), // Le timer redémarre maintenant
    );

    // Sauvegarde
    await _saveLives(userId, _livesData!);
    notifyListeners();

    // --- NOUVEAU : Programmer la notification de recharge ---
    // Calcul du temps total pour récupérer TOUTES les vies manquantes
    // Comme lastLossTime vient d'être reset à now(), le calcul est simple.
    int livesMissing = LivesData.MAX_LIVES - _livesData!.currentLives;
    if (livesMissing > 0) {
      final timeToFullRefill = Duration(
          minutes: livesMissing * LivesData.REGENERATION_TIME.inMinutes
      );

      print('Vies manquantes: $livesMissing, Notification dans: ${timeToFullRefill.inMinutes} min');

      await NotificationService().scheduleLivesRefilledNotification(
        userName: userName,
        timeRemaining: timeToFullRefill,
      );
    }
    // -------------------------------------------------------

    return true;
  }

  Future<void> refillLives(String userId) async {
    if (_livesData == null) await loadLives(userId);

    _livesData = _livesData!.copyWith(
      currentLives: LivesData.MAX_LIVES,
      lastLossTime: DateTime.now(),
      totalLivesBought: _livesData!.totalLivesBought + 1,
    );

    await _saveLives(userId, _livesData!);
    notifyListeners();

    // --- NOUVEAU : Annuler la notification car on est plein ---
    await NotificationService().cancelLivesRefilledNotification();
  }

  Future<bool> canPlay(String userId) async {
    if (_livesData == null) await loadLives(userId);
    return _livesData!.canPlay;
  }

  String getFormattedTimeUntilNextLife() {
    if (_livesData == null) return '--:--';

    final duration = _livesData!.timeUntilNextLife;
    if (duration == Duration.zero) return 'Complet';

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}