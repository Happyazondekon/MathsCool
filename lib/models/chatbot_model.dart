// [file name]: chatbot_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotUsage {
  final int freeRequestsUsed;
  final bool hasSubscription;
  final DateTime? subscriptionUntil;
  final DateTime lastResetDate;

  static const int MAX_FREE_REQUESTS = 3;

  ChatbotUsage({
    required this.freeRequestsUsed,
    required this.hasSubscription,
    this.subscriptionUntil,
    required this.lastResetDate,
  });

  bool get canUseFreeRequests => freeRequestsUsed < MAX_FREE_REQUESTS;
  bool get hasActiveSubscription =>
      hasSubscription && subscriptionUntil != null && subscriptionUntil!.isAfter(DateTime.now());

  bool get canUseChatbot => canUseFreeRequests || hasActiveSubscription;

  int get remainingFreeRequests => MAX_FREE_REQUESTS - freeRequestsUsed;

  factory ChatbotUsage.initial() {
    return ChatbotUsage(
      freeRequestsUsed: 0,
      hasSubscription: false,
      lastResetDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'freeRequestsUsed': freeRequestsUsed,
      'hasSubscription': hasSubscription,
      'subscriptionUntil': subscriptionUntil != null
          ? Timestamp.fromDate(subscriptionUntil!)
          : null,
      'lastResetDate': Timestamp.fromDate(lastResetDate),
    };
  }

  factory ChatbotUsage.fromFirestore(Map<String, dynamic> data) {
    return ChatbotUsage(
      freeRequestsUsed: data['freeRequestsUsed'] as int? ?? 0,
      hasSubscription: data['hasSubscription'] as bool? ?? false,
      subscriptionUntil: (data['subscriptionUntil'] as Timestamp?)?.toDate(),
      lastResetDate: (data['lastResetDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  ChatbotUsage copyWith({
    int? freeRequestsUsed,
    bool? hasSubscription,
    DateTime? subscriptionUntil,
    DateTime? lastResetDate,
  }) {
    return ChatbotUsage(
      freeRequestsUsed: freeRequestsUsed ?? this.freeRequestsUsed,
      hasSubscription: hasSubscription ?? this.hasSubscription,
      subscriptionUntil: subscriptionUntil ?? this.subscriptionUntil,
      lastResetDate: lastResetDate ?? this.lastResetDate,
    );
  }
}

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory ChatMessage.fromFirestore(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'] as String,
      content: data['content'] as String,
      isUser: data['isUser'] as bool? ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}