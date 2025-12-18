// lib/models/daily_challenge_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour le défi quotidien
class DailyChallenge {
  final String id;
  final String level; // Niveau scolaire
  final String theme; // Thème mathématique
  final DateTime date; // Date du défi (unique par jour)
  final int totalQuestions; // Nombre d'exercices (par défaut 10)
  final int difficulty; // 1-5 (facultatif pour l'évolution)

  DailyChallenge({
    required this.id,
    required this.level,
    required this.theme,
    required this.date,
    this.totalQuestions = 10,
    this.difficulty = 3,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'level': level,
      'theme': theme,
      'date': Timestamp.fromDate(date),
      'totalQuestions': totalQuestions,
      'difficulty': difficulty,
    };
  }

  factory DailyChallenge.fromFirestore(Map<String, dynamic> data) {
    return DailyChallenge(
      id: data['id'] as String,
      level: data['level'] as String,
      theme: data['theme'] as String,
      date: (data['date'] as Timestamp).toDate(),
      totalQuestions: data['totalQuestions'] as int? ?? 10,
      difficulty: data['difficulty'] as int? ?? 3,
    );
  }
}

/// Modèle pour le résultat d'un utilisateur sur un défi
class DailyChallengeResult {
  final String userId;
  final String challengeId;
  final int score; // Score sur 10 (nombre de bonnes réponses)
  final int timeSeconds; // Temps mis en secondes
  final DateTime completedAt;
  final Map<String, bool> answers; // Question -> isCorrect
  final int stars; // 1-3 étoiles selon performance

  DailyChallengeResult({
    required this.userId,
    required this.challengeId,
    required this.score,
    required this.timeSeconds,
    required this.completedAt,
    required this.answers,
    required this.stars,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'challengeId': challengeId,
      'score': score,
      'timeSeconds': timeSeconds,
      'completedAt': Timestamp.fromDate(completedAt),
      'answers': answers,
      'stars': stars,
    };
  }

  factory DailyChallengeResult.fromFirestore(Map<String, dynamic> data) {
    return DailyChallengeResult(
      userId: data['userId'] as String,
      challengeId: data['challengeId'] as String,
      score: data['score'] as int,
      timeSeconds: data['timeSeconds'] as int,
      completedAt: (data['completedAt'] as Timestamp).toDate(),
      answers: Map<String, bool>.from(data['answers'] ?? {}),
      stars: data['stars'] as int,
    );
  }

  // Calcul des étoiles automatique
  static int calculateStars(int score, int total) {
    final percentage = (score / total) * 100;
    if (percentage >= 90) return 3; // ⭐⭐⭐
    if (percentage >= 70) return 2; // ⭐⭐
    if (percentage >= 50) return 1; // ⭐
    return 0;
  }
}

/// Modèle pour le classement (leaderboard)
class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int totalScore; // Score cumulé du mois
  final int challengesCompleted; // Nombre de défis terminés
  final int currentStreak; // Jours consécutifs
  final int bestStreak; // Record personnel
  final int totalStars; // Total d'étoiles gagnées
  final DateTime lastPlayed;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.totalScore,
    required this.challengesCompleted,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalStars,
    required this.lastPlayed,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'totalScore': totalScore,
      'challengesCompleted': challengesCompleted,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalStars': totalStars,
      'lastPlayed': Timestamp.fromDate(lastPlayed),
    };
  }

  factory LeaderboardEntry.fromFirestore(Map<String, dynamic> data) {
    return LeaderboardEntry(
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      avatarUrl: data['avatarUrl'] as String?,
      totalScore: data['totalScore'] as int,
      challengesCompleted: data['challengesCompleted'] as int,
      currentStreak: data['currentStreak'] as int,
      bestStreak: data['bestStreak'] as int,
      totalStars: data['totalStars'] as int,
      lastPlayed: (data['lastPlayed'] as Timestamp).toDate(),
    );
  }

  LeaderboardEntry copyWith({
    String? userId,
    String? userName,
    String? avatarUrl,
    int? totalScore,
    int? challengesCompleted,
    int? currentStreak,
    int? bestStreak,
    int? totalStars,
    DateTime? lastPlayed,
  }) {
    return LeaderboardEntry(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalScore: totalScore ?? this.totalScore,
      challengesCompleted: challengesCompleted ?? this.challengesCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalStars: totalStars ?? this.totalStars,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }
}