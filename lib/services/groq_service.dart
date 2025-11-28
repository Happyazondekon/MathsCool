// [file name]: groq_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  static const String _apiKey = '';
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> getMathExplanation(String question, String level) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content': '''
              Tu es MathKid, un assistant pédagogique amical et encourageant pour les enfants de niveau $level.
              Ta mission est d'expliquer les concepts mathématiques de manière simple, ludique et engageante.
              Utilise des exemples concrets, des métaphores amusantes et un langage adapté aux enfants.
              Sois positif, encourageant et célèbre chaque petite victoire !
              Réponds en français avec des emojis appropriés et un ton chaleureux.
              '''
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
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Erreur Groq API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}