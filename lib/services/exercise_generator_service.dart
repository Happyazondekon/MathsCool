import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';

/// Service de génération dynamique d'exercices mathématiques
/// Utilise l'API Groq pour générer des exercices intelligents et variés
class ExerciseGeneratorService {
  final Random _random = Random();


  // Cache pour optimiser les performances
  final Map<String, List<Exercise>> _cache = {};
  static const int _cacheMaxSize = 100;

  /// Génère des exercices selon le niveau et le thème
  Future<List<Exercise>> generateExercises({
    required String level,
    required String theme,
    int count = 20,
    bool useAI = true,
  }) async {
    final cacheKey = '$level-$theme-$count';

    // Vérifier le cache
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.length >= count) {
      return _cache[cacheKey]!.take(count).toList();
    }

    try {
      List<Exercise> exercises;

      if (useAI && count > 10) {
        // Utiliser l'IA pour les grandes séries
        exercises = await _generateWithAI(level, theme, count);
      } else {
        // Génération locale pour les petites séries
        exercises = _generateLocally(level, theme, count);
      }

      // Mettre en cache
      _updateCache(cacheKey, exercises);

      return exercises;
    } catch (e) {
      print('⚠️ Erreur génération AI, fallback local: $e');
      return _generateLocally(level, theme, count);
    }
  }

  /// Génération avec l'API Groq (IA)
  Future<List<Exercise>> _generateWithAI(String level, String theme, int count) async {
    try {
      final prompt = _buildPrompt(level, theme, count);

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'mixtral-8x7b-32768',
          'messages': [
            {
              'role': 'system',
              'content': 'Tu es un expert en pédagogie mathématique. Tu génères des exercices adaptés au niveau scolaire français.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 4000,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _parseAIResponse(content);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur API Groq: $e');
      rethrow;
    }
  }

  /// Construit le prompt pour l'IA
  String _buildPrompt(String level, String theme, int count) {
    return '''
Génère exactement $count exercices de mathématiques pour le niveau "$level" sur le thème "$theme".

FORMAT OBLIGATOIRE (JSON strict):
[
  {
    "question": "Question mathématique claire",
    "options": ["Réponse A", "Réponse B", "Réponse C", "Réponse D"],
    "correctAnswer": 0
  }
]

RÈGLES STRICTES:
1. Exactement 4 options de réponse par question
2. correctAnswer est l'INDEX (0, 1, 2 ou 3) de la bonne réponse
3. Questions adaptées au niveau $level
4. Utilise des valeurs numériques réalistes
5. Mélange les positions de la bonne réponse
6. Rends les mauvaises réponses plausibles
7. Pour les exposants, utilise le format: x^2, 3^4, etc.
8. Pas de symboles spéciaux compliqués

Thème spécifique: $theme
Niveau: $level

Retourne uniquement le JSON, sans texte additionnel.
''';
  }

  /// Parse la réponse de l'IA
  List<Exercise> _parseAIResponse(String content) {
    try {
      // Nettoyer la réponse
      String cleaned = content
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final List<dynamic> jsonData = json.decode(cleaned);

      return jsonData.map((item) {
        final options = List<String>.from(item['options']);
        if (options.length != 4) {
          throw Exception('Nombre d\'options invalide: ${options.length}');
        }

        return Exercise(
          question: item['question'],
          options: options,
          correctAnswer: item['correctAnswer'],
        );
      }).toList();
    } catch (e) {
      print('❌ Erreur parsing AI: $e');
      rethrow;
    }
  }

  /// Génération locale (fallback et petites séries)
  List<Exercise> _generateLocally(String level, String theme, int count) {
    switch (theme.toLowerCase()) {
    // === PRIMAIRE ===
      case 'addition':
        return _generateAdditionExercises(level, count);
      case 'soustraction':
        return _generateSubtractionExercises(level, count);
      case 'multiplication':
        return _generateMultiplicationExercises(level, count);
      case 'division':
        return _generateDivisionExercises(level, count);
      case 'géométrie':
        return _generateGeometryExercises(level, count);

    // === COLLÈGE ===
      case 'nombres relatifs':
        return _generateRelativeNumbersExercises(level, count);
      case 'fractions':
        return _generateFractionsExercises(level, count);
      case 'algèbre':
        return _generateAlgebraExercises(level, count);
      case 'puissances':
        return _generatePowerExercises(level, count);
      case 'théorèmes':
        return _generateTheoremExercises(level, count);
      case 'statistiques':
        return _generateStatisticsExercises(level, count);

      default:
        return _generateAdditionExercises(level, count);
    }
  }

  // ========== PRIMAIRE ==========

  List<Exercise> _generateAdditionExercises(String level, int count) {
    final range = _getRangeForLevel(level);
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final a = _random.nextInt(range) + 1;
      final b = _random.nextInt(range) + 1;
      final correctAnswer = a + b;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: max(0, correctAnswer - 5),
        max: correctAnswer + 10,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);
      final correctIndex = allOptions.indexOf(correctAnswer.toString());

      exercises.add(Exercise(
        question: '$a + $b = ?',
        options: allOptions,
        correctAnswer: correctIndex,
      ));
    }

    return exercises;
  }

  List<Exercise> _generateSubtractionExercises(String level, int count) {
    final range = _getRangeForLevel(level);
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final a = _random.nextInt(range) + 1;
      final b = _random.nextInt(a + 1);
      final correctAnswer = a - b;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: max(0, correctAnswer - 5),
        max: correctAnswer + 5,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);
      final correctIndex = allOptions.indexOf(correctAnswer.toString());

      exercises.add(Exercise(
        question: '$a - $b = ?',
        options: allOptions,
        correctAnswer: correctIndex,
      ));
    }

    return exercises;
  }

  List<Exercise> _generateMultiplicationExercises(String level, int count) {
    final maxFactor = _getMultiplicationRange(level);
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final a = _random.nextInt(maxFactor) + 1;
      final b = _random.nextInt(maxFactor) + 1;
      final correctAnswer = a * b;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: max(1, correctAnswer - 10),
        max: correctAnswer + 15,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);
      final correctIndex = allOptions.indexOf(correctAnswer.toString());

      exercises.add(Exercise(
        question: '$a × $b = ?',
        options: allOptions,
        correctAnswer: correctIndex,
      ));
    }

    return exercises;
  }

  List<Exercise> _generateDivisionExercises(String level, int count) {
    final maxDivisor = _getMultiplicationRange(level);
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final divisor = _random.nextInt(maxDivisor - 1) + 2;
      final quotient = _random.nextInt(maxDivisor) + 1;
      final dividend = divisor * quotient;
      final correctAnswer = quotient;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: max(1, correctAnswer - 3),
        max: correctAnswer + 5,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);
      final correctIndex = allOptions.indexOf(correctAnswer.toString());

      exercises.add(Exercise(
        question: '$dividend ÷ $divisor = ?',
        options: allOptions,
        correctAnswer: correctIndex,
      ));
    }

    return exercises;
  }

  List<Exercise> _generateGeometryExercises(String level, int count) {
    final geometryQuestions = [
      {'q': 'Combien de côtés a un triangle ?', 'a': '3', 'w': ['4', '5', '2']},
      {'q': 'Combien d\'angles droits a un carré ?', 'a': '4', 'w': ['3', '2', '5']},
      {'q': 'Combien de faces a un cube ?', 'a': '6', 'w': ['8', '12', '4']},
      {'q': 'Un rectangle a combien de côtés ?', 'a': '4', 'w': ['3', '5', '6']},
      {'q': 'Combien de sommets a un hexagone ?', 'a': '6', 'w': ['5', '7', '8']},
      {'q': 'Un cercle a combien de côtés ?', 'a': '0', 'w': ['1', '2', 'Infini']},
      {'q': 'Combien d\'arêtes a un cube ?', 'a': '12', 'w': ['6', '8', '10']},
      {'q': 'Un pentagone a combien de côtés ?', 'a': '5', 'w': ['4', '6', '7']},
    ];

    List<Exercise> exercises = [];
    for (int i = 0; i < count; i++) {
      final q = geometryQuestions[_random.nextInt(geometryQuestions.length)];
      final answer = q['a'] as String;
      final wrong = q['w'] as List<String>;

      final allOptions = [answer, ...wrong];
      allOptions.shuffle(_random);
      final correctIndex = allOptions.indexOf(answer);

      exercises.add(Exercise(
        question: q['q'] as String,
        options: allOptions,
        correctAnswer: correctIndex,
      ));
    }

    return exercises;
  }

  // ========== COLLÈGE ==========

  List<Exercise> _generateRelativeNumbersExercises(String level, int count) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final a = _random.nextInt(30) - 15; // -15 à 14
      final b = _random.nextInt(30) - 15;
      final operation = _random.nextInt(2); // 0: addition, 1: soustraction

      int correctAnswer;
      String operator;

      if (operation == 0) {
        correctAnswer = a + b;
        operator = '+';
      } else {
        correctAnswer = a - b;
        operator = '-';
      }

      final aStr = a < 0 ? '($a)' : '$a';
      final bStr = b < 0 ? '($b)' : '$b';

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: correctAnswer - 8,
        max: correctAnswer + 8,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);
      final correctIndex = allOptions.indexOf(correctAnswer.toString());

      exercises.add(Exercise(
        question: '$aStr $operator $bStr = ?',
        options: allOptions,
        correctAnswer: correctIndex,
      ));
    }

    return exercises;
  }

  List<Exercise> _generateFractionsExercises(String level, int count) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(3);

      if (type == 0) {
        // Simplification
        final num = _random.nextInt(12) + 2;
        final den = _random.nextInt(12) + 3;
        final gcd = _gcd(num, den);
        final simpNum = num ~/ gcd;
        final simpDen = den ~/ gcd;

        final correctAnswer = simpDen == 1 ? '$simpNum' : '$simpNum/$simpDen';
        final wrongAnswers = [
          '$num/$den',
          '${simpNum + 1}/$simpDen',
          '$simpNum/${simpDen + 1}',
        ]..removeWhere((w) => w == correctAnswer);

        final allOptions = [correctAnswer, ...wrongAnswers.take(3)];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: 'Simplifie: $num/$den',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      } else if (type == 1) {
        // Addition de fractions (même dénominateur)
        final den = _random.nextInt(8) + 2;
        final num1 = _random.nextInt(den);
        final num2 = _random.nextInt(den);
        final sumNum = num1 + num2;
        final gcd = _gcd(sumNum, den);
        final simpNum = sumNum ~/ gcd;
        final simpDen = den ~/ gcd;

        final correctAnswer = simpDen == 1 ? '$simpNum' : '$simpNum/$simpDen';
        final wrongAnswers = [
          '$sumNum/$den',
          '${num1 + num2}/${den * 2}',
          '${simpNum + 1}/$simpDen',
        ]..removeWhere((w) => w == correctAnswer);

        final allOptions = [correctAnswer, ...wrongAnswers.take(3)];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$num1/$den + $num2/$den = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      } else {
        // Multiplication de fractions
        final num1 = _random.nextInt(5) + 1;
        final den1 = _random.nextInt(5) + 2;
        final num2 = _random.nextInt(5) + 1;
        final den2 = _random.nextInt(5) + 2;

        final resNum = num1 * num2;
        final resDen = den1 * den2;
        final gcd = _gcd(resNum, resDen);
        final simpNum = resNum ~/ gcd;
        final simpDen = resDen ~/ gcd;

        final correctAnswer = simpDen == 1 ? '$simpNum' : '$simpNum/$simpDen';
        final wrongAnswers = [
          '$resNum/$resDen',
          '${simpNum + 1}/$simpDen',
          '${num1 * den2}/${den1 * num2}',
        ]..removeWhere((w) => w == correctAnswer);

        final allOptions = [correctAnswer, ...wrongAnswers.take(3)];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$num1/$den1 × $num2/$den2 = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      }
    }

    return exercises;
  }

  List<Exercise> _generateAlgebraExercises(String level, int count) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(2);

      if (type == 0) {
        // Équations simples: ax + b = c
        final x = _random.nextInt(10) + 1;
        final a = _random.nextInt(5) + 2;
        final b = _random.nextInt(15) + 1;
        final c = a * x + b;

        final wrongAnswers = _generatePlausibleWrongAnswers(
          x,
          min: max(1, x - 3),
          max: x + 5,
        );

        final allOptions = [x.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: 'Résous: ${a}x + $b = $c',
          options: allOptions,
          correctAnswer: allOptions.indexOf(x.toString()),
        ));
      } else {
        // Développement: a(x + b)
        final a = _random.nextInt(5) + 2;
        final b = _random.nextInt(10) + 1;

        final correctAnswer = '${a}x + ${a * b}';
        final wrongAnswers = [
          '${a}x + $b',
          '${a + 1}x + ${a * b}',
          '${a}x + ${a * b + 1}',
        ];

        final allOptions = [correctAnswer, ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: 'Développe: $a(x + $b)',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      }
    }

    return exercises;
  }

  List<Exercise> _generatePowerExercises(String level, int count) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(3);

      if (type == 0) {
        // Calcul simple: a^b
        final base = _random.nextInt(5) + 2;
        final exp = _random.nextInt(3) + 2;
        final correctAnswer = pow(base, exp).toInt();

        final wrongAnswers = _generatePlausibleWrongAnswers(
          correctAnswer,
          min: max(1, correctAnswer - 10),
          max: correctAnswer + 20,
        );

        final allOptions = [correctAnswer.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$base^$exp = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer.toString()),
        ));
      } else if (type == 1) {
        // Multiplication: a^m × a^n = a^(m+n)
        final base = _random.nextInt(4) + 2;
        final exp1 = _random.nextInt(4) + 1;
        final exp2 = _random.nextInt(4) + 1;
        final correctAnswer = exp1 + exp2;

        final wrongAnswers = [
          (exp1 * exp2).toString(),
          (exp1 + exp2 + 1).toString(),
          (exp1 - exp2).toString(),
        ];

        final allOptions = ['$base^$correctAnswer', ...wrongAnswers.map((e) => '$base^$e')];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$base^$exp1 × $base^$exp2 = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf('$base^$correctAnswer'),
        ));
      } else {
        // Puissance de puissance: (a^m)^n = a^(m×n)
        final base = _random.nextInt(3) + 2;
        final exp1 = _random.nextInt(3) + 2;
        final exp2 = _random.nextInt(3) + 2;
        final correctAnswer = exp1 * exp2;

        final wrongAnswers = [
          (exp1 + exp2).toString(),
          (correctAnswer + 1).toString(),
          (correctAnswer - 1).toString(),
        ];

        final allOptions = ['$base^$correctAnswer', ...wrongAnswers.map((e) => '$base^$e')];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '($base^$exp1)^$exp2 = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf('$base^$correctAnswer'),
        ));
      }
    }

    return exercises;
  }

  List<Exercise> _generateTheoremExercises(String level, int count) {
    final theoremQuestions = [
      {
        'q': 'Dans un triangle rectangle, quel théorème permet de calculer l\'hypoténuse ?',
        'a': 'Pythagore',
        'w': ['Thalès', 'Euclide', 'Fermat']
      },
      {
        'q': 'La somme des angles d\'un triangle vaut ?',
        'a': '180°',
        'w': ['360°', '90°', '270°']
      },
      {
        'q': 'Dans un triangle ABC rectangle en A, AB² + AC² = ?',
        'a': 'BC²',
        'w': ['AB × AC', '2BC', 'BC']
      },
      {
        'q': 'Un triangle avec un angle de 90° est un triangle ?',
        'a': 'Rectangle',
        'w': ['Équilatéral', 'Isocèle', 'Scalène']
      },
      {
        'q': 'Si deux droites sont parallèles à une troisième, elles sont ?',
        'a': 'Parallèles entre elles',
        'w': ['Perpendiculaires', 'Sécantes', 'Confondues']
      },
      {
        'q': 'Le théorème de Thalès concerne des droites ?',
        'a': 'Parallèles',
        'w': ['Perpendiculaires', 'Sécantes', 'Confondues']
      },
    ];

    List<Exercise> exercises = [];
    for (int i = 0; i < count; i++) {
      final q = theoremQuestions[_random.nextInt(theoremQuestions.length)];
      final answer = q['a'] as String;
      final wrong = q['w'] as List<String>;

      final allOptions = [answer, ...wrong];
      allOptions.shuffle(_random);

      exercises.add(Exercise(
        question: q['q'] as String,
        options: allOptions,
        correctAnswer: allOptions.indexOf(answer),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateStatisticsExercises(String level, int count) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(3);

      if (type == 0) {
        // Calcul de moyenne
        final values = List.generate(4, (_) => _random.nextInt(20) + 1);
        final sum = values.reduce((a, b) => a + b);
        final mean = (sum / values.length);
        final correctAnswer = mean.toStringAsFixed(mean == mean.toInt() ? 0 : 1);

        final wrongAnswers = [
          (mean + 1).toStringAsFixed(1),
          (mean - 1).toStringAsFixed(1),
          (sum ~/ 2).toString(),
        ];

        final allOptions = [correctAnswer, ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: 'Moyenne de ${values.join(', ')} ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      } else if (type == 1) {
        // Médiane
        final values = List.generate(5, (_) => _random.nextInt(30) + 1)..sort();
        final median = values[2];

        final wrongAnswers = _generatePlausibleWrongAnswers(
          median,
          min: values.first,
          max: values.last,
        );

        final allOptions = [median.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: 'Médiane de ${values.join(', ')} ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(median.toString()),
        ));
      } else {
        // Étendue
        final values = List.generate(5, (_) => _random.nextInt(30) + 1);
        final min = values.reduce((a, b) => a < b ? a : b);
        final max = values.reduce((a, b) => a > b ? a : b);
        final range = max - min;

        final wrongAnswers = [
          (range + 1).toString(),
          (range - 1).toString(),
          max.toString(),
        ];

        final allOptions = [range.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: 'Étendue de ${values.join(', ')} ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(range.toString()),
        ));
      }
    }

    return exercises;
  }

  // ========== HELPERS ==========

  int _getRangeForLevel(String level) {
    switch (level) {
      case 'CI':
      case 'CP':
        return 10;
      case 'CE1':
        return 20;
      case 'CE2':
        return 50;
      case 'CM1':
        return 100;
      case 'CM2':
        return 200;
      case '6ème':
      case '5ème':
        return 500;
      case '4ème':
      case '3ème':
        return 1000;
      default:
        return 10;
    }
  }

  int _getMultiplicationRange(String level) {
    switch (level) {
      case 'CI':
      case 'CP':
        return 5;
      case 'CE1':
      case 'CE2':
        return 10;
      case 'CM1':
      case 'CM2':
        return 12;
      case '6ème':
      case '5ème':
      case '4ème':
      case '3ème':
        return 15;
      default:
        return 5;
    }
  }

  List<String> _generatePlausibleWrongAnswers(
      int correctAnswer, {
        required int min,
        required int max,
      }) {
    Set<String> wrongAnswers = {};

    while (wrongAnswers.length < 3) {
      final wrong = _random.nextInt(max - min + 1) + min;
      if (wrong != correctAnswer) {
        wrongAnswers.add(wrong.toString());
      }
    }

    return wrongAnswers.toList();
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  void _updateCache(String key, List<Exercise> exercises) {
    if (_cache.length >= _cacheMaxSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = exercises;
  }

  void clearCache() {
    _cache.clear();
  }
}