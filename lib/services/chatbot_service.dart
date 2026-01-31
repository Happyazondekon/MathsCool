// [file name]: chatbot_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathscool/models/user_model.dart';
import '../models/chatbot_model.dart';
import 'groq_service.dart';

class ChatbotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GroqService _groqService = GroqService();

  // Récupérer l'usage du chatbot
  Future<ChatbotUsage> getChatbotUsage(String userId) async {
    try {
      final doc = await _firestore.collection('chatbotUsage').doc(userId).get();
      if (doc.exists) {
        return ChatbotUsage.fromFirestore(doc.data()!);
      } else {
        // Créer un document initial
        final initialUsage = ChatbotUsage.initial();
        await _firestore.collection('chatbotUsage').doc(userId).set(
          initialUsage.toFirestore(),
        );
        return initialUsage;
      }
    } catch (e) {
      print('Erreur récupération usage chatbot: $e');
      return ChatbotUsage.initial();
    }
  }

  // Vérifier si l'utilisateur peut utiliser le chatbot
  Future<bool> canUseChatbot(String userId) async {
    final usage = await getChatbotUsage(userId);
    _checkResetFreeRequests(usage, userId);
    return usage.canUseChatbot;
  }

  // Utiliser une requête gratuite
  Future<void> useFreeRequest(String userId) async {
    final usage = await getChatbotUsage(userId);
    final updatedUsage = usage.copyWith(
      freeRequestsUsed: usage.freeRequestsUsed + 1,
    );
    await _firestore.collection('chatbotUsage').doc(userId).set(
      updatedUsage.toFirestore(),
    );
  }

  // Activer l'abonnement
  Future<void> activateSubscription(String userId, Duration duration) async {
    final subscriptionUntil = DateTime.now().add(duration);
    await _firestore.collection('chatbotUsage').doc(userId).set({
      'hasSubscription': true,
      'subscriptionUntil': Timestamp.fromDate(subscriptionUntil),
    }, SetOptions(merge: true));
  }

  // Obtenir une explication
  Future<String>  getExplanation(
      String question,
      String level,
      String userId, {
        String language = 'fr',  // Paramètre optionnel avec défaut
      }) async {
    final canUse = await canUseChatbot(userId);
    if (!canUse) {
      throw Exception('Limite de requêtes atteinte. Abonnez-vous pour continuer.');
    }

    // Si utilisation gratuite, incrémenter le compteur
    final usage = await getChatbotUsage(userId);
    if (!usage.hasActiveSubscription) {
      await useFreeRequest(userId);
    }
    final groqService = GroqService();
    return await groqService.getMathExplanation(
      question,
      level,
      language: language,  // Passer la langue à Groq
    );
  }

  // Réinitialiser les requêtes gratuites (quotidien)
  void _checkResetFreeRequests(ChatbotUsage usage, String userId) {
    final now = DateTime.now();
    if (now.day != usage.lastResetDate.day) {
      final resetUsage = usage.copyWith(
        freeRequestsUsed: 0,
        lastResetDate: now,
      );
      _firestore.collection('chatbotUsage').doc(userId).set(
        resetUsage.toFirestore(),
      );
    }
  }

  // Sauvegarder l'historique de chat
  Future<void> saveChatMessage(String userId, ChatMessage message) async {
    await _firestore.collection('chatSessions').doc(userId).collection('messages').add(
      message.toFirestore(),
    );
  }

  // Récupérer l'historique de chat
  Stream<List<ChatMessage>> getChatHistory(String userId) {
    return _firestore
        .collection('chatSessions')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessage.fromFirestore(doc.data()))
        .toList()
        .reversed
        .toList());
  }
}