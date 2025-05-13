import '../data/static_exercises.dart';
import '../models/exercise_model.dart';

class ExerciseService {
  // Obtenir les exercices par niveau et thème
  Stream<List<Exercise>> getExercisesByLevelAndTheme(String level, String theme) async* {
    final exercises = staticExercises[level]?[theme] ?? [];
    yield exercises;
  }

  // Obtenir les thèmes disponibles pour un niveau donné
  Future<List<String>> getThemesByLevel(String level) async {
    final themes = staticExercises[level]?.keys.toList() ?? [];
    return themes;
  }
}