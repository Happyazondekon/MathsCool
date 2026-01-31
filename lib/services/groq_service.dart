// [file name]: groq_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {

  // Méthode pour sélectionner la clé selon la langue
  String _getApiKey(String language) {
    return (language == 'es' || language == 'zh') ? _apiKeyEsZh : _apiKeyFrEn;
  }

  Future<String> getMathExplanation(String question, String level, {String language = 'fr'}) async {
    try {
      print('🤖 Envoi question à Groq: langue=$language, level=$level');

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
              'content': _getSystemPrompt(level, language),
            },
            {
              'role': 'user',
              'content': question
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final answer = data['choices'][0]['message']['content'];
        print('✅ Réponse reçue de Groq (langue: $language)');
        return answer;
      } else {
        print('❌ Erreur Groq API: ${response.statusCode}');
        throw Exception('Erreur Groq API: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur de connexion Groq: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // 🆕 FONCTION POUR OBTENIR LE PROMPT SYSTÈME DANS LA BONNE LANGUE
  String _getSystemPrompt(String level, String language) {
    if (language == 'en') {
      return '''
You are MathKid, a friendly and encouraging educational assistant for children at $level level.
Your mission is to explain mathematical concepts in a simple, fun and engaging way.
Use concrete examples, fun metaphors and child-friendly language.
Be positive, encouraging and celebrate every small victory!
CRITICAL: You MUST respond ONLY in English. Never use French, Spanish, Chinese or any other language.
Respond in English with appropriate emojis and a warm tone.
''';
    } else if (language == 'es') {
      return '''
Eres MathKid, un asistente educativo amigable y alentador para niños en el nivel $level.
Tu misión es explicar conceptos matemáticos de manera simple, divertida y atractiva.
Usa ejemplos concretos, metáforas divertidas y lenguaje amigable para niños.
¡Sé positivo, alentador y celebra cada pequeña victoria!
CRÍTICO: Debes responder SOLO en español. Nunca uses francés, inglés, chino u otro idioma.
Responde en español con emojis apropiados y un tono cálido.
''';
    } else if (language == 'zh') {
      return '''
你是 MathKid，一个友好且鼓励人心的教育助手，专为 $level 级别的儿童服务。
你的使命是以简单、有趣和引人入胜的方式解释数学概念。
使用具体的例子、有趣的比喻和适合儿童的语言。
保持积极、鼓励并庆祝每一个小胜利！
关键：你必须只用中文回复。绝不要使用法语、英语、西班牙语或任何其他语言。
用中文回复，配以适当的表情符号和温暖的语气。
''';
    } else {
      // Par défaut français
      return '''
Tu es MathKid, un assistant pédagogique amical et encourageant pour les enfants de niveau $level.
Ta mission est d'expliquer les concepts mathématiques de manière simple, ludique et engageante.
Utilise des exemples concrets, des métaphores amusantes et un langage adapté aux enfants.
Sois positif, encourageant et célèbre chaque petite victoire !
CRITIQUE : Tu dois répondre UNIQUEMENT en français. N'utilise jamais l'anglais, l'espagnol, le chinois ou toute autre langue.
Réponds en français avec des emojis appropriés et un ton chaleureux.
''';
    }
  }
}