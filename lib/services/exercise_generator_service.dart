import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';

/// Service de génération dynamique d'exercices mathématiques
/// Utilise l'API Groq pour générer des exercices intelligents et variés
class ExerciseGeneratorService {
  final Random _random = Random();


  // 🆕 NOUVELLE MÉTHODE : Normaliser le thème pour toutes les langues
  String _normalizeTheme(String theme, String language) {
    // Convertir en minuscules pour comparaison
    final themeLower = theme.toLowerCase();

    // Mapping des thèmes vers leur forme normalisée
    final Map<String, String> themeMapping = {
      // Français
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

      // Anglais
      'subtraction': 'subtraction',
      'geometry': 'geometry',
      'relative numbers': 'relative_numbers',
      'algebra': 'algebra',
      'powers': 'powers',
      'theorems': 'theorems',
      'statistics': 'statistics',

      // Espagnol
      'adición': 'addition',
      'sustracción': 'subtraction',
      'multiplicación': 'multiplication',
      'división': 'division',
      'geometría': 'geometry',
      'números relativos': 'relative_numbers',
      'fracciones': 'fractions',
      'álgebra': 'algebra',
      'potencias': 'powers',
      'teoremas': 'theorems',
      'estadísticas': 'statistics',

      // Chinois (pinyin normalisé)
      '加法': 'addition',
      '减法': 'subtraction',
      '乘法': 'multiplication',
      '除法': 'division',
      '几何': 'geometry',
      '相对数': 'relative_numbers',
      '分数': 'fractions',
      '代数': 'algebra',
      '幂': 'powers',
      '定理': 'theorems',
      '统计': 'statistics',
    };

    // Retourner le thème normalisé ou le thème original en minuscules
    return themeMapping[themeLower] ?? themeLower;
  }

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

    print('🎯 Génération d\'exercices: level=$level, theme=$theme, count=$count, language=$language');

    // Vérifier le cache
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.length >= count) {
      print('✅ Utilisation du cache pour $cacheKey');
      return _cache[cacheKey]!.take(count).toList();
    }

    try {
      List<Exercise> exercises;

      if (useAI && count > 10) {
        // Utiliser l'IA pour les grandes séries
        print('🤖 Utilisation de l\'IA pour générer les exercices');
        exercises = await _generateWithAI(level, theme, count, language);
      } else {
        // Génération locale pour les petites séries
        print('💻 Génération locale des exercices');
        exercises = _generateLocally(level, theme, count, language);
      }

      // Mettre en cache
      _updateCache(cacheKey, exercises);

      print('✅ ${exercises.length} exercices générés avec succès');
      return exercises;
    } catch (e) {
      print('⚠️ Erreur génération AI, fallback local: $e');
      return _generateLocally(level, theme, count, language);
    }
  }

  /// Génération avec l'API Groq (IA)
  Future<List<Exercise>> _generateWithAI(String level, String theme, int count, String language) async {
    try {
      final prompt = _buildPrompt(level, theme, count, language);

      print('📝 Envoi du prompt à l\'API Groq (langue: $language)');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer ${_getApiKey(language)}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(language),
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
        print('✅ Réponse reçue de l\'API Groq');
        return _parseAIResponse(content);
      } else {
        print('❌ Erreur API: ${response.statusCode} - ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur API Groq: $e');
      rethrow;
    }
  }

  /// 🆕 NOUVEAU : Obtenir le system prompt selon la langue
  String _getSystemPrompt(String language) {
    switch (language) {
      case 'en':
        return 'You are a math education expert. You generate exercises adapted to school levels in English.';
      case 'es':
        return 'Eres un experto en educación matemática. Generas ejercicios adaptados a los niveles escolares en español.';
      case 'zh':
        return '你是数学教育专家。你用中文生成适应学校水平的练习。';
      default:
        return 'Tu es un expert en pédagogie mathématique. Tu génères des exercices adaptés au niveau scolaire en français.';
    }
  }

  /// Construit le prompt pour l'IA
  String _buildPrompt(String level, String theme, int count, String language) {
    switch (language) {
      case 'en':
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
9. ALL TEXT MUST BE IN ENGLISH

Specific theme: $theme
Level: $level

Return only the JSON, without additional text.
''';

      case 'es':
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
9. TODO EL TEXTO DEBE ESTAR EN ESPAÑOL

Tema específico: $theme
Nivel: $level

Devuelve solo el JSON, sin texto adicional.
''';

      case 'zh':
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
9. 所有文本必须是中文

具体主题：$theme
级别：$level

只返回 JSON，没有额外文本。
''';

      default: // Français
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
9. TOUT LE TEXTE DOIT ÊTRE EN FRANÇAIS

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
      print('Contenu reçu: $content');
      rethrow;
    }
  }

  /// Génération locale (fallback et petites séries)
  List<Exercise> _generateLocally(String level, String theme, int count, String language) {
    print('💻 Génération locale: theme=$theme, language=$language');

    // 🆕 Normaliser le thème pour supporter toutes les langues
    final normalizedTheme = _normalizeTheme(theme, language);
    print('🔄 Thème normalisé: $normalizedTheme');

    switch (normalizedTheme) {
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
      case 'relative_numbers':
        return _generateRelativeNumbersExercises(level, count, language);
      case 'fractions':
        return _generateFractionsExercises(level, count, language);
      case 'algebra':
        return _generateAlgebraExercises(level, count, language);
      case 'powers':
        return _generatePowersExercises(level, count, language);
      case 'theorems':
        return _generateTheoremExercises(level, count, language);
      case 'statistics':
        return _generateStatisticsExercises(level, count, language);
      default:
        print('⚠️ Thème non reconnu: $normalizedTheme, fallback vers addition');
        return _generateAdditionExercises(level, count, language);
    }
  }

  // ========== GÉNÉRATEURS D'EXERCICES PAR THÈME ==========

  List<Exercise> _generateAdditionExercises(String level, int count, String language) {
    List<Exercise> exercises = [];
    final range = _getRangeForLevel(level);

    for (int i = 0; i < count; i++) {
      final num1 = _random.nextInt(range) + 1;
      final num2 = _random.nextInt(range) + 1;
      final correctAnswer = num1 + num2;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: 1,
        max: range * 2,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);

      exercises.add(Exercise(
        question: '$num1 + $num2 = ?',
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer.toString()),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateSubtractionExercises(String level, int count, String language) {
    List<Exercise> exercises = [];
    final range = _getRangeForLevel(level);

    for (int i = 0; i < count; i++) {
      final num1 = _random.nextInt(range) + range ~/ 2;
      final num2 = _random.nextInt(num1);
      final correctAnswer = num1 - num2;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: 0,
        max: num1,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);

      exercises.add(Exercise(
        question: '$num1 - $num2 = ?',
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer.toString()),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateMultiplicationExercises(String level, int count, String language) {
    List<Exercise> exercises = [];
    final range = _getMultiplicationRange(level);

    for (int i = 0; i < count; i++) {
      final num1 = _random.nextInt(range) + 1;
      final num2 = _random.nextInt(range) + 1;
      final correctAnswer = num1 * num2;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: 1,
        max: range * range,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);

      // 🆕 Symbole de multiplication adapté à la langue
      final multiplySymbol = language == 'en' ? '×' : 'x';

      exercises.add(Exercise(
        question: '$num1 $multiplySymbol $num2 = ?',
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer.toString()),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateDivisionExercises(String level, int count, String language) {
    List<Exercise> exercises = [];
    final range = _getMultiplicationRange(level);

    for (int i = 0; i < count; i++) {
      final divisor = _random.nextInt(range - 1) + 2;
      final quotient = _random.nextInt(range) + 1;
      final dividend = divisor * quotient;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        quotient,
        min: 1,
        max: range * 2,
      );

      final allOptions = [quotient.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);

      exercises.add(Exercise(
        question: '$dividend ÷ $divisor = ?',
        options: allOptions,
        correctAnswer: allOptions.indexOf(quotient.toString()),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateGeometryExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    // 🆕 Questions adaptées à la langue
    final geometryQuestions = _getGeometryQuestions(language);

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

  List<Map<String, dynamic>> _getGeometryQuestions(String language) {
    switch (language) {
      case 'en':
        return [
          {'q': 'How many sides does a triangle have?', 'a': '3', 'w': ['2', '4', '5']},
          {'q': 'How many sides does a square have?', 'a': '4', 'w': ['3', '5', '6']},
          {'q': 'How many right angles does a square have?', 'a': '4', 'w': ['2', '3', '1']},
        ];
      case 'es':
        return [
          {'q': '¿Cuántos lados tiene un triángulo?', 'a': '3', 'w': ['2', '4', '5']},
          {'q': '¿Cuántos lados tiene un cuadrado?', 'a': '4', 'w': ['3', '5', '6']},
          {'q': '¿Cuántos ángulos rectos tiene un cuadrado?', 'a': '4', 'w': ['2', '3', '1']},
        ];
      case 'zh':
        return [
          {'q': '三角形有几条边？', 'a': '3', 'w': ['2', '4', '5']},
          {'q': '正方形有几条边？', 'a': '4', 'w': ['3', '5', '6']},
          {'q': '正方形有几个直角？', 'a': '4', 'w': ['2', '3', '1']},
        ];
      default: // Français
        return [
          {'q': 'Combien de côtés a un triangle ?', 'a': '3', 'w': ['2', '4', '5']},
          {'q': 'Combien de côtés a un carré ?', 'a': '4', 'w': ['3', '5', '6']},
          {'q': 'Combien d\'angles droits a un carré ?', 'a': '4', 'w': ['2', '3', '1']},
        ];
    }
  }

  // Les autres méthodes de génération suivent le même pattern...
  // (Je les inclus pour la complétude)

  List<Exercise> _generateRelativeNumbersExercises(String level, int count, String language) {
    List<Exercise> exercises = [];
    final range = _getRangeForLevel(level);

    for (int i = 0; i < count; i++) {
      final num1 = _random.nextInt(range) - (range ~/ 2);
      final num2 = _random.nextInt(range) - (range ~/ 2);
      final correctAnswer = num1 + num2;

      final wrongAnswers = _generatePlausibleWrongAnswers(
        correctAnswer,
        min: -range,
        max: range,
      );

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);

      exercises.add(Exercise(
        question: '($num1) + ($num2) = ?',
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer.toString()),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateFractionsExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final numerator = _random.nextInt(9) + 1;
      final denominator = _random.nextInt(9) + 2;
      final gcd = _gcd(numerator, denominator);
      final simplifiedNum = numerator ~/ gcd;
      final simplifiedDen = denominator ~/ gcd;

      final wrongAnswers = [
        '${numerator + 1}/$denominator',
        '$numerator/${denominator + 1}',
        '${simplifiedNum + 1}/${simplifiedDen + 1}',
      ];

      final correctAnswer = '$simplifiedNum/$simplifiedDen';
      final allOptions = [correctAnswer, ...wrongAnswers];
      allOptions.shuffle(_random);

      final questionText = language == 'en'
          ? 'Simplify $numerator/$denominator'
          : language == 'es'
          ? 'Simplifica $numerator/$denominator'
          : language == 'zh'
          ? '简化 $numerator/$denominator'
          : 'Simplifie $numerator/$denominator';

      exercises.add(Exercise(
        question: questionText,
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateAlgebraExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final a = _random.nextInt(9) + 1;
      final b = _random.nextInt(9) + 1;
      final x = _random.nextInt(9) + 1;
      final correctAnswer = a * x + b;

      final wrongAnswers = [
        (correctAnswer + 1).toString(),
        (correctAnswer - 1).toString(),
        (a + b).toString(),
      ];

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);

      final questionText = language == 'en'
          ? 'If x = $x, what is ${a}x + $b?'
          : language == 'es'
          ? 'Si x = $x, ¿cuánto es ${a}x + $b?'
          : language == 'zh'
          ? '如果 x = $x，${a}x + $b 等于多少？'
          : 'Si x = $x, combien vaut ${a}x + $b ?';

      exercises.add(Exercise(
        question: questionText,
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer.toString()),
      ));
    }

    return exercises;
  }

  List<Exercise> _generatePowersExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
      final base = _random.nextInt(5) + 2;
      final exponent = _random.nextInt(3) + 2;
      final correctAnswer = pow(base, exponent).toInt();

      final wrongAnswers = [
        (base * exponent).toString(),
        (correctAnswer + 1).toString(),
        (correctAnswer - 1).toString(),
      ];

      final allOptions = [correctAnswer.toString(), ...wrongAnswers];
      allOptions.shuffle(_random);

      exercises.add(Exercise(
        question: '$base^$exponent = ?',
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer.toString()),
      ));
    }

    return exercises;
  }

  List<Exercise> _generateTheoremExercises(String level, int count, String language) {
    final theoremQuestions = _getTheoremQuestions(language);
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

  List<Map<String, dynamic>> _getTheoremQuestions(String language) {
    switch (language) {
      case 'en':
        return [
          {'q': 'In a right triangle, which theorem helps calculate the hypotenuse?', 'a': 'Pythagoras', 'w': ['Thales', 'Euclid', 'Fermat']},
          {'q': 'The sum of angles in a triangle equals?', 'a': '180°', 'w': ['360°', '90°', '270°']},
        ];
      case 'es':
        return [
          {'q': 'En un triángulo rectángulo, ¿qué teorema ayuda a calcular la hipotenusa?', 'a': 'Pitágoras', 'w': ['Tales', 'Euclides', 'Fermat']},
          {'q': '¿La suma de los ángulos en un triángulo es igual a?', 'a': '180°', 'w': ['360°', '90°', '270°']},
        ];
      case 'zh':
        return [
          {'q': '在直角三角形中，哪个定理帮助计算斜边？', 'a': '勾股定理', 'w': ['泰勒斯', '欧几里得', '费马']},
          {'q': '三角形的内角和等于？', 'a': '180°', 'w': ['360°', '90°', '270°']},
        ];
      default:
        return [
          {'q': 'Dans un triangle rectangle, quel théorème permet de calculer l\'hypoténuse ?', 'a': 'Pythagore', 'w': ['Thalès', 'Euclide', 'Fermat']},
          {'q': 'La somme des angles d\'un triangle vaut ?', 'a': '180°', 'w': ['360°', '90°', '270°']},
        ];
    }
  }

  List<Exercise> _generateStatisticsExercises(String level, int count, String language) {
    List<Exercise> exercises = [];

    for (int i = 0; i < count; i++) {
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
          ? 'Mean of ${values.join(', ')}?'
          : language == 'es'
          ? 'Promedio de ${values.join(', ')}?'
          : language == 'zh'
          ? '${values.join(', ')} 的平均值是多少？'
          : 'Moyenne de ${values.join(', ')} ?';

      exercises.add(Exercise(
        question: questionText,
        options: allOptions,
        correctAnswer: allOptions.indexOf(correctAnswer),
      ));
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