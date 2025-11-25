import 'package:cloud_firestore/cloud_firestore.dart';

class LivesData {
  final int currentLives;       // Vies stockées
  final DateTime lastLossTime;  // Date de référence
  final int totalLivesBought;

  static const int MAX_LIVES = 5; // Tu peux mettre 4 ici si tu préfères comme dit plus tôt
  // CHANGEMENT ICI : 5 minutes au lieu de 10
  static const Duration REGENERATION_TIME = Duration(minutes: 5);

  LivesData({
    required this.currentLives,
    required this.lastLossTime,
    this.totalLivesBought = 0,
  });

  // Calcul dynamique pour l'affichage
  int get availableLives {
    if (currentLives >= MAX_LIVES) return MAX_LIVES;

    final now = DateTime.now();
    final timeSinceLoss = now.difference(lastLossTime);
    // Protection contre les dates futures ou incohérentes
    if (timeSinceLoss.isNegative) return currentLives;

    final regeneratedLives = timeSinceLoss.inMinutes ~/ REGENERATION_TIME.inMinutes;

    return (currentLives + regeneratedLives).clamp(0, MAX_LIVES);
  }

  // Temps restant avant la prochaine vie
  Duration get timeUntilNextLife {
    if (availableLives >= MAX_LIVES) return Duration.zero;

    final now = DateTime.now();
    final timeSinceLoss = now.difference(lastLossTime);
    final minutesSinceLoss = timeSinceLoss.inMinutes;

    // Calcul précis du temps restant
    final minutesToNextLife = REGENERATION_TIME.inMinutes - (minutesSinceLoss % REGENERATION_TIME.inMinutes);
    final secondsToNextLife = 60 - (timeSinceLoss.inSeconds % 60);

    return Duration(minutes: minutesToNextLife - (secondsToNextLife == 60 ? 0 : 1), seconds: secondsToNextLife == 60 ? 0 : secondsToNextLife);
  }

  bool get canPlay => availableLives > 0;

  // NOUVELLE MÉTHODE : Pour mettre à jour l'objet proprement après régénération
  LivesData regenerate() {
    if (availableLives == currentLives) return this; // Rien à changer

    final now = DateTime.now();
    final timeSinceLoss = now.difference(lastLossTime);
    final livesToGain = timeSinceLoss.inMinutes ~/ REGENERATION_TIME.inMinutes;

    if (livesToGain <= 0) return this;

    final newLives = (currentLives + livesToGain).clamp(0, MAX_LIVES);

    // Si on est plein, on reset la date. Sinon, on avance la date du temps consommé.
    DateTime newDate;
    if (newLives >= MAX_LIVES) {
      newDate = now;
    } else {
      // On avance la date de référence pour garder le "crédit" des minutes écoulées
      final timeConsumed = Duration(minutes: livesToGain * REGENERATION_TIME.inMinutes);
      newDate = lastLossTime.add(timeConsumed);
    }

    return copyWith(
      currentLives: newLives,
      lastLossTime: newDate,
    );
  }

  factory LivesData.initial() {
    return LivesData(
      currentLives: MAX_LIVES,
      lastLossTime: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'currentLives': currentLives,
      'lastLossTime': Timestamp.fromDate(lastLossTime),
      'totalLivesBought': totalLivesBought,
    };
  }

  factory LivesData.fromFirestore(Map<String, dynamic> data) {
    return LivesData(
      currentLives: data['currentLives'] as int? ?? MAX_LIVES,
      lastLossTime: (data['lastLossTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalLivesBought: data['totalLivesBought'] as int? ?? 0,
    );
  }

  LivesData copyWith({
    int? currentLives,
    DateTime? lastLossTime,
    int? totalLivesBought,
  }) {
    return LivesData(
      currentLives: currentLives ?? this.currentLives,
      lastLossTime: lastLossTime ?? this.lastLossTime,
      totalLivesBought: totalLivesBought ?? this.totalLivesBought,
    );
  }
}