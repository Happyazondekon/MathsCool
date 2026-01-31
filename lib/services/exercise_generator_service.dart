import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';

/// Service de génération dynamique d'exercices mathématiques
/// Utilise l'API Groq pour générer des exercices intelligents et variés
class ExerciseGeneratorService {
  final Random _random = Random();


  // Méthode pour sélectionner la clé selon la langue
  String _getApiKey(String language) {
    return (language == 'es' || language == 'zh') ? _apiKeyEsZh : _apiKeyFrEn;
  }

  // Cache pour optimiser les performances
  final Map<String, List<Exercise>> _cache = {};
  static const int _cacheMaxSize = 100;

  /// Génère des exercices selon le niveau et le thème
  Future<List<Exercise>> generateExercises({
    required String level,
    required String theme,
    int count = 20,
    bool useAI = true,
    String language = 'fr', // 🆕 PARAMÈTRE LANGUE
  }) async {
    final cacheKey = '$level-$theme-$count-$language'; // 🆕 Inclure la langue dans la clé

    // Vérifier le cache
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.length >= count) {
      return _cache[cacheKey]!.take(count).toList();
    }

    try {
      List<Exercise> exercises;

      if (useAI && count > 10) {
        // Utiliser l'IA pour les grandes séries
        exercises = await _generateWithAI(level, theme, count, language); // 🆕 Passer la langue
      } else {
        // Génération locale pour les petites séries
        exercises = _generateLocally(level, theme, count, language); // 🆕 Passer la langue
      }

      // Mettre en cache
      _updateCache(cacheKey, exercises);

      return exercises;
    } catch (e) {
      print('⚠️ Erreur génération AI, fallback local: $e');
      return _generateLocally(level, theme, count, language); // 🆕 Passer la langue
    }
  }

  /// Génération avec l'API Groq (IA)
  Future<List<Exercise>> _generateWithAI(String level, String theme, int count, String language) async {
    try {
      final prompt = _buildPrompt(level, theme, count, language); // 🆕 Passer la langue

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer ${_getApiKey(language)}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'mixtral-8x7b-32768',
          'messages': [
            {
              'role': 'system',
              // 🆕 SYSTEM PROMPT ADAPTÉ À LA LANGUE
              'content': language == 'en'
                  ? 'You are a math education expert. You generate exercises adapted to school levels.'
                  : 'Tu es un expert en pédagogie mathématique. Tu génères des exercices adaptés au niveau scolaire.'
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
  String _buildPrompt(String level, String theme, int count, String language) {
    // 🆕 PROMPT MULTILINGUE
    if (language == 'en') {
      return '''
Generate exactly $count math exercises for level "$level" on the theme "$theme".

REQUIRED FORMAT (strict JSON):
[
  {
    "question": "Clear math question",
    "options": ["Answer A", "Answer B", "Answer C", "Answer D"],
    "correctAnswer": 0
  }
]

STRICT RULES:
1. Exactly 4 answer options per question
2. correctAnswer is the INDEX (0, 1, 2 or 3) of the correct answer
3. Questions adapted to level $level
4. Use realistic numerical values
5. Mix the positions of the correct answer
6. Make wrong answers plausible
7. For exponents, use the format: x^2, 3^4, etc.
8. No complicated special symbols

Specific theme: $theme
Level: $level

Return only the JSON, without additional text.
''';
    } else if (language == 'es') {
      return '''
Genera exactamente $count ejercicios de matemáticas para el nivel "$level" en el tema "$theme".

FORMATO REQUERIDO (JSON estricto):
[
  {
    "question": "Pregunta matemática clara",
    "options": ["Respuesta A", "Respuesta B", "Respuesta C", "Respuesta D"],
    "correctAnswer": 0
  }
]

REGLAS ESTRICTAS:
1. Exactamente 4 opciones de respuesta por pregunta
2. correctAnswer es el ÍNDICE (0, 1, 2 o 3) de la respuesta correcta
3. Preguntas adaptadas al nivel $level
4. Usa valores numéricos realistas
5. Mezcla las posiciones de la respuesta correcta
6. Haz que las respuestas incorrectas sean plausibles
7. Para exponentes, usa el formato: x^2, 3^4, etc.
8. Sin símbolos especiales complicados

Tema específico: $theme
Nivel: $level

Devuelve solo el JSON, sin texto adicional.
''';
    } else if (language == 'zh') {
      return '''
为级别 "$level" 的主题 "$theme" 生成正好 $count 个数学练习。

必需格式（严格 JSON）：
[
  {
    "question": "清晰的数学问题",
    "options": ["答案 A", "答案 B", "答案 C", "答案 D"],
    "correctAnswer": 0
  }
]

严格规则：
1. 每个问题正好 4 个答案选项
2. correctAnswer 是正确答案的索引（0、1、2 或 3）
3. 问题适应级别 $level
4. 使用现实的数值
5. 混合正确答案的位置
6. 使错误答案看似合理
7. 对于指数，使用格式：x^2, 3^4 等
8. 没有复杂的特殊符号

具体主题：$theme
级别：$level

只返回 JSON，没有额外文本。
''';
    } else {
      // Par défaut français
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
  List<Exercise> _generateLocally(String level, String theme, int count, String language) {
    // 🆕 Normaliser le thème pour supporter les deux langues
    final normalizedTheme = _normalizeTheme(theme, language);

    switch (normalizedTheme) {
    // === PRIMAIRE ===
      case 'addition':
        return _generateAdditionExercises(level, count, language);
      case 'subtraction':
        return _generateSubtractionExercises(level, count, language);
      case 'multiplication':
        return _generateMultiplicationExercises(level, count, language);
      case 'division':
        return _generateDivisionExercises(level, count, language);
      case 'geometry':
        return _generateGeometryExercises(level, count, language);

    // === COLLÈGE ===
      case 'relative_numbers':
        return _generateRelativeNumbersExercises(level, count, language);
      case 'fractions':
        return _generateFractionsExercises(level, count, language);
      case 'algebra':
        return _generateAlgebraExercises(level, count, language);
      case 'powers':
        return _generatePowerExercises(level, count, language);
      case 'theorems':
        return _generateTheoremExercises(level, count, language);
      case 'statistics':
        return _generateStatisticsExercises(level, count, language);

      default:
        return _generateAdditionExercises(level, count, language);
    }
  }

  // 🆕 FONCTION POUR NORMALISER LES NOMS DE THÈMES
  String _normalizeTheme(String theme, String language) {
    final themeLower = theme.toLowerCase();

    // Map français → anglais normalisé
    final frenchMap = {
      'addition': 'addition',
      'soustraction': 'subtraction',
      'multiplication': 'multiplication',
      'division': 'division',
      'géométrie': 'geometry',
      'nombres relatifs': 'relative_numbers',
      'fractions': 'fractions',
      'algèbre': 'algebra',
      'puissances': 'powers',
      'théorèmes': 'theorems',
      'statistiques': 'statistics',
    };

    // Map anglais → normalisé
    final englishMap = {
      'addition': 'addition',
      'subtraction': 'subtraction',
      'multiplication': 'multiplication',
      'division': 'division',
      'geometry': 'geometry',
      'relative numbers': 'relative_numbers',
      'fractions': 'fractions',
      'algebra': 'algebra',
      'powers': 'powers',
      'theorems': 'theorems',
      'statistics': 'statistics',
    };

    return language == 'en'
        ? (englishMap[themeLower] ?? 'addition')
        : (frenchMap[themeLower] ?? 'addition');
  }

  // ========== PRIMAIRE ==========

  List<Exercise> _generateAdditionExercises(String level, int count, String language) {
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

  List<Exercise> _generateSubtractionExercises(String level, int count, String language) {
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

  List<Exercise> _generateMultiplicationExercises(String level, int count, String language) {
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

  List<Exercise> _generateDivisionExercises(String level, int count, String language) {
    final range = _getRangeForLevel(level);
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final divisor = _random.nextInt(min(range ~/ 2, 12)) + 2;
      final quotient = _random.nextInt(min(range ~/ divisor, 20)) + 1;
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

  List<Exercise> _generateGeometryExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    // 🆕 Questions bilingues
    final geometryQuestions = language == 'en' ? [
      {
        'q': 'How many sides does a triangle have?',
        'a': '3',
        'w': ['4', '5', '6']
      },
      {
        'q': 'How many sides does a square have?',
        'a': '4',
        'w': ['3', '5', '6']
      },
      {
        'q': 'How many angles does a rectangle have?',
        'a': '4',
        'w': ['3', '5', '2']
      },
    ] : [
      {
        'q': 'Combien de côtés a un triangle ?',
        'a': '3',
        'w': ['4', '5', '6']
      },
      {
        'q': 'Combien de côtés a un carré ?',
        'a': '4',
        'w': ['3', '5', '6']
      },
      {
        'q': 'Combien d\'angles a un rectangle ?',
        'a': '4',
        'w': ['3', '5', '2']
      },
    ];

    for (int i = 0; i < count; i++) {
      final q = geometryQuestions[_random.nextInt(geometryQuestions.length)];
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

  // ========== COLLÈGE ==========

  List<Exercise> _generateRelativeNumbersExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final a = _random.nextInt(20) - 10;
      final b = _random.nextInt(20) - 10;
      final type = _random.nextInt(2);

      if (type == 0) {
        final correctAnswer = a + b;
        final wrongAnswers = _generatePlausibleWrongAnswers(
          correctAnswer,
          min: correctAnswer - 5,
          max: correctAnswer + 5,
        );

        final allOptions = [correctAnswer.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '($a) + ($b) = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer.toString()),
        ));
      } else {
        final correctAnswer = a - b;
        final wrongAnswers = _generatePlausibleWrongAnswers(
          correctAnswer,
          min: correctAnswer - 5,
          max: correctAnswer + 5,
        );

        final allOptions = [correctAnswer.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '($a) - ($b) = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer.toString()),
        ));
      }
    }

    return exercises;
  }

  List<Exercise> _generateFractionsExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(3);

      if (type == 0) {
        final num1 = _random.nextInt(9) + 1;
        final den1 = _random.nextInt(9) + 2;
        final num2 = _random.nextInt(9) + 1;
        final den2 = den1;

        final sumNum = num1 + num2;
        final gcd = _gcd(sumNum, den1);
        final simplifiedNum = sumNum ~/ gcd;
        final simplifiedDen = den1 ~/ gcd;

        final correctAnswer = simplifiedDen == 1
            ? simplifiedNum.toString()
            : '$simplifiedNum/$simplifiedDen';

        final wrongAnswers = [
          '$sumNum/$den1',
          '${num1 + num2 + 1}/$den1',
          '${num1 + num2 - 1}/$den1',
        ];

        final allOptions = [correctAnswer, ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$num1/$den1 + $num2/$den2 = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      } else if (type == 1) {
        final num = _random.nextInt(8) + 1;
        final den = _random.nextInt(8) + num + 1;
        final gcd = _gcd(num, den);
        final simplifiedNum = num ~/ gcd;
        final simplifiedDen = den ~/ gcd;

        final correctAnswer = simplifiedDen == 1
            ? simplifiedNum.toString()
            : '$simplifiedNum/$simplifiedDen';

        final wrongAnswers = [
          '$num/$den',
          '${num ~/ 2}/${den ~/ 2}',
          '${num + 1}/${den + 1}',
        ];

        final allOptions = [correctAnswer, ...wrongAnswers];
        allOptions.shuffle(_random);

        final questionText = language == 'en'
            ? 'Simplify $num/$den'
            : 'Simplifie $num/$den';

        exercises.add(Exercise(
          question: questionText,
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      } else {
        final num = _random.nextInt(5) + 1;
        final den = _random.nextInt(5) + 2;
        final mult = _random.nextInt(5) + 2;

        final resultNum = num * mult;
        final resultDen = den;

        final correctAnswer = '$resultNum/$resultDen';

        final wrongAnswers = [
          '${num * mult}/${den * mult}',
          '${num + mult}/$den',
          '$resultNum/${den * mult}',
        ];

        final allOptions = [correctAnswer, ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$num/$den × $mult = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      }
    }

    return exercises;
  }

  List<Exercise> _generateAlgebraExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(3);

      if (type == 0) {
        final a = _random.nextInt(10) + 1;
        final b = _random.nextInt(20) + 1;
        final correctAnswer = b - a;

        final wrongAnswers = _generatePlausibleWrongAnswers(
          correctAnswer,
          min: max(0, correctAnswer - 5),
          max: correctAnswer + 5,
        );

        final allOptions = [correctAnswer.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: 'x + $a = $b, x = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer.toString()),
        ));
      } else if (type == 1) {
        final a = _random.nextInt(5) + 2;
        final x = _random.nextInt(10) + 1;
        final b = a * x;

        final wrongAnswers = _generatePlausibleWrongAnswers(
          x,
          min: max(1, x - 3),
          max: x + 5,
        );

        final allOptions = [x.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '${a}x = $b, x = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(x.toString()),
        ));
      } else {
        final a = _random.nextInt(10) + 1;
        final b = _random.nextInt(10) + 1;
        final c = a + b;

        final wrongAnswers = _generatePlausibleWrongAnswers(
          b,
          min: max(0, b - 5),
          max: b + 5,
        );

        final allOptions = [b.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$a + x = $c, x = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(b.toString()),
        ));
      }
    }

    return exercises;
  }

  List<Exercise> _generatePowerExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(3);

      if (type == 0) {
        final base = _random.nextInt(5) + 2;
        final exp = _random.nextInt(4) + 1;
        final correctAnswer = pow(base, exp).toInt();

        final wrongAnswers = _generatePlausibleWrongAnswers(
          correctAnswer,
          min: max(1, correctAnswer - 10),
          max: correctAnswer + 10,
        );

        final allOptions = [correctAnswer.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$base^$exp = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer.toString()),
        ));
      } else if (type == 1) {
        final base = _random.nextInt(4) + 2;
        final exp1 = _random.nextInt(4) + 1;
        final exp2 = _random.nextInt(4) + 1;
        final correctAnswer = exp1 + exp2;

        final wrongAnswers = [
          (exp1 * exp2).toString(),
          (exp1 + exp2 + 1).toString(),
          (exp1 - exp2).abs().toString(),
        ];

        final allOptions = ['$base^$correctAnswer', ...wrongAnswers.map((e) => '$base^$e')];
        allOptions.shuffle(_random);

        exercises.add(Exercise(
          question: '$base^$exp1 × $base^$exp2 = ?',
          options: allOptions,
          correctAnswer: allOptions.indexOf('$base^$correctAnswer'),
        ));
      } else {
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

  List<Exercise> _generateTheoremExercises(String level, int count, String language) {
    // 🆕 Questions bilingues
    final theoremQuestions = language == 'en' ? [
      {
        'q': 'In a right triangle, which theorem allows you to calculate the hypotenuse?',
        'a': 'Pythagoras',
        'w': ['Thales', 'Euclid', 'Fermat']
      },
      {
        'q': 'The sum of the angles in a triangle equals?',
        'a': '180°',
        'w': ['360°', '90°', '270°']
      },
      {
        'q': 'In triangle ABC right-angled at A, AB² + AC² = ?',
        'a': 'BC²',
        'w': ['AB × AC', '2BC', 'BC']
      },
      {
        'q': 'A triangle with a 90° angle is a triangle?',
        'a': 'Right',
        'w': ['Equilateral', 'Isosceles', 'Scalene']
      },
    ] : [
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

  List<Exercise> _generateStatisticsExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final type = _random.nextInt(3);

      if (type == 0) {
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

        final questionText = language == 'en'
            ? 'Mean of ${values.join(', ')} ?'
            : 'Moyenne de ${values.join(', ')} ?';

        exercises.add(Exercise(
          question: questionText,
          options: allOptions,
          correctAnswer: allOptions.indexOf(correctAnswer),
        ));
      } else if (type == 1) {
        final values = List.generate(5, (_) => _random.nextInt(30) + 1)..sort();
        final median = values[2];

        final wrongAnswers = _generatePlausibleWrongAnswers(
          median,
          min: values.first,
          max: values.last,
        );

        final allOptions = [median.toString(), ...wrongAnswers];
        allOptions.shuffle(_random);

        final questionText = language == 'en'
            ? 'Median of ${values.join(', ')} ?'
            : 'Médiane de ${values.join(', ')} ?';

        exercises.add(Exercise(
          question: questionText,
          options: allOptions,
          correctAnswer: allOptions.indexOf(median.toString()),
        ));
      } else {
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

        final questionText = language == 'en'
            ? 'Range of ${values.join(', ')} ?'
            : 'Étendue de ${values.join(', ')} ?';

        exercises.add(Exercise(
          question: questionText,
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