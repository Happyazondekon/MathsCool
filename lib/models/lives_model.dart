import 'package:cloud_firestore/cloud_firestore.dart';

class LivesData {
  final int currentLives;       // Vies stockées
  final DateTime lastLossTime;  // Date de référence pour la régénération
  final int totalLivesBought;   // Stats (optionnel)
  final DateTime? unlimitedUntil; // NOUVEAU : Date de fin de l'illimité

  static const int MAX_LIVES = 5;
  static const Duration REGENERATION_TIME = Duration(minutes: 5);

  LivesData({
    required this.currentLives,
    required this.lastLossTime,
    this.totalLivesBought = 0,
    this.unlimitedUntil, // NOUVEAU
  });

  // NOUVEAU : Vérifie si la période de vies illimitées est active
  bool get isUnlimited {
    if (unlimitedUntil == null) return false;
    return unlimitedUntil!.isAfter(DateTime.now());
  }

  // Calcul dynamique pour l'affichage
  int get availableLives {
    // Si illimité, on a toujours le max de vies
    if (isUnlimited) return MAX_LIVES;

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
    // Si illimité ou vies pleines, pas de timer
    if (isUnlimited || availableLives >= MAX_LIVES) return Duration.zero;

    final now = DateTime.now();
    final timeSinceLoss = now.difference(lastLossTime);
    final minutesSinceLoss = timeSinceLoss.inMinutes;

    // Calcul précis du temps restant
    final minutesToNextLife = REGENERATION_TIME.inMinutes - (minutesSinceLoss % REGENERATION_TIME.inMinutes);
    final secondsToNextLife = 60 - (timeSinceLoss.inSeconds % 60);

    return Duration(minutes: minutesToNextLife - (secondsToNextLife == 60 ? 0 : 1), seconds: secondsToNextLife == 60 ? 0 : secondsToNextLife);
  }

  bool get canPlay => availableLives > 0;

  // Pour mettre à jour l'objet proprement après régénération
  LivesData regenerate() {
    // Si illimité, pas besoin de recalculer la régénération
    if (isUnlimited) return this;

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
      unlimitedUntil: null,
    );
  }

  // Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'currentLives': currentLives,
      'lastLossTime': Timestamp.fromDate(lastLossTime),
      'totalLivesBought': totalLivesBought,
      // On convertit le DateTime en Timestamp Firestore si il existe
      'unlimitedUntil': unlimitedUntil != null ? Timestamp.fromDate(unlimitedUntil!) : null,
    };
  }

  // Création depuis Firestore
  factory LivesData.fromFirestore(Map<String, dynamic> data) {
    return LivesData(
      currentLives: data['currentLives'] as int? ?? MAX_LIVES,
      lastLossTime: (data['lastLossTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalLivesBought: data['totalLivesBought'] as int? ?? 0,
      // On récupère le Timestamp et on le convertit en DateTime
      unlimitedUntil: (data['unlimitedUntil'] as Timestamp?)?.toDate(),
    );
  }

  LivesData copyWith({
    int? currentLives,
    DateTime? lastLossTime,
    int? totalLivesBought,
    DateTime? unlimitedUntil,
  }) {
    return LivesData(
      currentLives: currentLives ?? this.currentLives,
      lastLossTime: lastLossTime ?? this.lastLossTime,
      totalLivesBought: totalLivesBought ?? this.totalLivesBought,
      unlimitedUntil: unlimitedUntil ?? this.unlimitedUntil,
    );
  }
}