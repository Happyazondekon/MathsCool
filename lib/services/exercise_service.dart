import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_model.dart';

class ExerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Exercise>> getExercisesByLevel(String level) {
    return _firestore
        .collection('exercises')
        .where('level', isEqualTo: level)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Exercise.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<List<String>> getThemesByLevel(String level) async {
    final snapshot = await _firestore
        .collection('exercises')
        .where('level', isEqualTo: level)
        .get();

    final themes = snapshot.docs
        .map((doc) => doc.data()['theme'] as String)
        .toSet()
        .toList();

    return themes;
  }
}