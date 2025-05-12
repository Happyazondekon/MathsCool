import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathscool/models/user_model.dart';

import '../auth/auth_service.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> recordExerciseAttempt({
    required String level,
    required String theme,
    required bool isCorrect,
  }) async {
    final user = AuthService().currentUser;
    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);
    final progressPath = 'progress.$level.$theme';

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);

      final currentData = doc.data()?['progress']?[level]?[theme] ?? {
        'correct': 0,
        'total': 0,
      };

      transaction.update(userRef, {
        '$progressPath.correct': isCorrect
            ? currentData['correct'] + 1
            : currentData['correct'],
        '$progressPath.total': currentData['total'] + 1,
      });
    });
  }

  Future<Map<String, dynamic>> getUserProgress(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['progress'] ?? {};
  }
}