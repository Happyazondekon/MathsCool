// lib/services/username_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UsernameService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _cachedUsername;
  String? get cachedUsername => _cachedUsername;

  /// Récupérer le nom d'utilisateur depuis Firestore
  Future<String> getUsername(String userId) async {
    try {
      // Vérifier le cache d'abord
      if (_cachedUsername != null) {
        return _cachedUsername!;
      }

      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final username = doc.data()!['username'] as String?;
        _cachedUsername = username ?? 'MathKid';
        return _cachedUsername!;
      }

      // Créer un username par défaut si le document n'existe pas
      _cachedUsername = 'MathKid';
      await _createDefaultUsername(userId);
      return _cachedUsername!;

    } catch (e) {
      if (kDebugMode) print('❌ Erreur récupération username: $e');
      return 'MathKid';
    }
  }

  /// Créer un username par défaut lors de la première connexion
  Future<void> _createDefaultUsername(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'username': 'MathKid',
        'createdAt': FieldValue.serverTimestamp(),
        'usernameUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('❌ Erreur création username par défaut: $e');
    }
  }

  /// Mettre à jour le nom d'utilisateur
  Future<bool> updateUsername(String userId, String newUsername) async {
    try {
      // Validation
      final validation = validateUsername(newUsername);
      if (!validation['valid']) {
        throw Exception(validation['error']);
      }

      // Vérifier si le username est déjà pris
      final isAvailable = await isUsernameAvailable(newUsername, userId);
      if (!isAvailable) {
        throw Exception('Ce nom est déjà utilisé');
      }

      // Mettre à jour dans Firestore
      await _firestore.collection('users').doc(userId).set({
        'username': newUsername.trim(),
        'usernameUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Mettre à jour le cache
      _cachedUsername = newUsername.trim();
      notifyListeners();

      // Mettre à jour le leaderboard si l'utilisateur y est présent
      await _updateLeaderboardUsername(userId, newUsername.trim());

      if (kDebugMode) print('✅ Username mis à jour: $newUsername');
      return true;

    } catch (e) {
      if (kDebugMode) print('❌ Erreur mise à jour username: $e');
      rethrow;
    }
  }

  /// Mettre à jour le username dans le leaderboard
  Future<void> _updateLeaderboardUsername(String userId, String newUsername) async {
    try {
      final leaderboardDoc = await _firestore.collection('leaderboard').doc(userId).get();

      if (leaderboardDoc.exists) {
        await _firestore.collection('leaderboard').doc(userId).update({
          'userName': newUsername,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        if (kDebugMode) print('✅ Leaderboard mis à jour avec le nouveau username');
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur mise à jour leaderboard: $e');
      // Ne pas faire échouer la fonction si le leaderboard n'existe pas encore
    }
  }

  /// Vérifier si un username est disponible
  Future<bool> isUsernameAvailable(String username, String currentUserId) async {
    try {
      final normalizedUsername = username.trim().toLowerCase();

      // Rechercher si un autre utilisateur utilise déjà ce nom
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.trim())
          .get();

      // Si aucun résultat, le username est disponible
      if (query.docs.isEmpty) {
        return true;
      }

      // Si le seul résultat est l'utilisateur actuel, c'est OK
      if (query.docs.length == 1 && query.docs.first.id == currentUserId) {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) print('❌ Erreur vérification disponibilité: $e');
      return false;
    }
  }

  /// Valider un username
  Map<String, dynamic> validateUsername(String username) {
    final trimmed = username.trim();

    // Vérifier la longueur
    if (trimmed.isEmpty) {
      return {'valid': false, 'error': 'Le nom ne peut pas être vide'};
    }

    if (trimmed.length < 3) {
      return {'valid': false, 'error': 'Le nom doit contenir au moins 3 caractères'};
    }

    if (trimmed.length > 20) {
      return {'valid': false, 'error': 'Le nom ne peut pas dépasser 20 caractères'};
    }

    // Vérifier les caractères autorisés (lettres, chiffres, espaces, tirets, underscores)
    final validPattern = RegExp(r'^[a-zA-ZÀ-ÿ0-9\s\-_]+$');
    if (!validPattern.hasMatch(trimmed)) {
      return {
        'valid': false,
        'error': 'Seuls les lettres, chiffres, espaces et tirets sont autorisés'
      };
    }

    // Vérifier les mots interdits
    final forbiddenWords = [
      'admin', 'moderator', 'mathscool', 'support',
      'bot', 'system', 'null', 'undefined'
    ];

    final lowerUsername = trimmed.toLowerCase();
    for (final word in forbiddenWords) {
      if (lowerUsername.contains(word)) {
        return {'valid': false, 'error': 'Ce nom contient un mot interdit'};
      }
    }

    return {'valid': true};
  }

  /// Générer des suggestions de username
  Future<List<String>> generateUsernameSuggestions(String baseUsername) async {
    List<String> suggestions = [];
    final base = baseUsername.trim();

    if (base.isEmpty) {
      suggestions = [
        'MathKid${_randomNumber()}',
        'MathPro${_randomNumber()}',
        'SuperMath${_randomNumber()}',
      ];
    } else {
      suggestions = [
        '$base${_randomNumber()}',
        '${base}Pro',
        '${base}_${_randomNumber()}',
      ];
    }

    return suggestions;
  }

  int _randomNumber() {
    return DateTime.now().millisecondsSinceEpoch % 1000;
  }

  /// Stream pour écouter les changements de username
  Stream<String> watchUsername(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final username = snapshot.data()!['username'] as String?;
        _cachedUsername = username ?? 'MathKid';
        return _cachedUsername!;
      }
      return 'MathKid';
    });
  }

  /// Réinitialiser le cache (utile lors de la déconnexion)
  void clearCache() {
    _cachedUsername = null;
    notifyListeners();
  }
}