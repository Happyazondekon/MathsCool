import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserResults {
  // Stockage des réponses de l'utilisateur
  Map<String, int> _results = {};

  // Récupérer les résultats de l'utilisateur
  Future<void> loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('userResults');
    _results = jsonString != null ? Map<String, int>.from(json.decode(jsonString)) : {};
  }

  // Sauvegarder les résultats de l'utilisateur
  Future<void> saveResults() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userResults', json.encode(_results));
  }

  // Mettre à jour la réponse de l'utilisateur pour une question
  void updateResult(String question, int answerIndex) {
    _results[question] = answerIndex;
    saveResults();
  }

  // Obtenir la réponse de l'utilisateur pour une question
  int? getAnswer(String question) {
    return _results[question];
  }

  // Obtenir tous les résultats
  Map<String, int> getAllResults() {
    return _results;
  }
}