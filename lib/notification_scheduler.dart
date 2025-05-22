import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import 'notification_messages.dart';

class NotificationScheduler {
  static final NotificationScheduler _instance = NotificationScheduler._internal();
  factory NotificationScheduler() => _instance;
  NotificationScheduler._internal();

  final NotificationService _notificationService = NotificationService();
  Timer? _schedulerTimer;
  bool _isInitialized = false;

  // Keys for SharedPreferences
  static const String _lastScheduledKey = 'last_scheduled_date';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _preferredTimeSlot1Key = 'preferred_time_slot_1'; // Morning
  static const String _preferredTimeSlot2Key = 'preferred_time_slot_2'; // Evening

  // Initialize scheduler
  Future<void> initialize() async {
    if (_isInitialized) {
      print('📱 NotificationScheduler déjà initialisé');
      return;
    }

    try {
      await _notificationService.initialize();
      await _checkAndScheduleNotifications();
      _startPeriodicCheck();
      _isInitialized = true;
      print('✅ NotificationScheduler initialisé avec succès');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation du scheduler: $e');
      rethrow;
    }
  }

  // Start periodic check every hour to reschedule if needed
  void _startPeriodicCheck() {
    _schedulerTimer?.cancel();
    _schedulerTimer = Timer.periodic(const Duration(hours: 1), (timer) async {
      try {
        await _checkAndScheduleNotifications();
      } catch (e) {
        print('❌ Erreur lors de la vérification périodique: $e');
      }
    });
  }

  // Check if we need to schedule new notifications
  Future<void> _checkAndScheduleNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_notificationsEnabledKey) ?? true;

      if (!isEnabled) {
        print('🔕 Notifications désactivées');
        return;
      }

      final lastScheduled = prefs.getString(_lastScheduledKey);
      final now = DateTime.now();

      // Check if we need to schedule new notifications
      bool needsScheduling = false;

      if (lastScheduled == null) {
        needsScheduling = true;
        print('📅 Première planification des notifications');
      } else {
        try {
          final lastScheduledDate = DateTime.parse(lastScheduled);
          final daysSinceLastScheduled = now.difference(lastScheduledDate).inDays;

          // Reschedule every 5 days to keep notifications coming
          if (daysSinceLastScheduled >= 5) {
            needsScheduling = true;
            print('📅 Replanification des notifications (${daysSinceLastScheduled} jours)');
          }
        } catch (e) {
          print('❌ Erreur de parsing de la date: $e');
          needsScheduling = true;
        }
      }

      if (needsScheduling) {
        await scheduleSmartNotifications();
        await prefs.setString(_lastScheduledKey, now.toIso8601String());
      }
    } catch (e) {
      print('❌ Erreur lors de la vérification des notifications: $e');
    }
  }

  // Schedule smart notifications based on user preferences and usage patterns
  Future<void> scheduleSmartNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();

      final prefs = await SharedPreferences.getInstance();

      // Get preferred time slots (default: 9 AM and 7 PM)
      final morningHour = prefs.getInt(_preferredTimeSlot1Key) ?? 9;
      final eveningHour = prefs.getInt(_preferredTimeSlot2Key) ?? 19;

      final now = DateTime.now();
      final random = Random();
      int scheduledCount = 0;

      print('📋 Planification des notifications...');
      print('🌅 Heure du matin: ${morningHour}h');
      print('🌆 Heure du soir: ${eveningHour}h');

      // Schedule notifications for the next 14 days
      for (int day = 0; day < 14; day++) {
        final targetDate = now.add(Duration(days: day));

        // Skip if it's the current day and we're past the morning time
        if (day == 0 && now.hour >= morningHour) {
          print('⏰ Saut de la notification du matin (heure dépassée)');
          continue;
        }

        // Morning notification with some randomness (±30 minutes)
        try {
          final morningMinuteOffset = random.nextInt(61) - 30; // -30 to +30 minutes
          final morningTime = DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
            morningHour,
            0,
          ).add(Duration(minutes: morningMinuteOffset.abs()));

          if (morningTime.isAfter(now)) {
            await _scheduleSmartNotification(
              id: 3000 + (day * 2),
              scheduledTime: morningTime,
              isEvening: false,
              dayIndex: day,
            );
            scheduledCount++;
          }
        } catch (e) {
          print('❌ Erreur notification matin jour $day: $e');
        }

        // Evening notification with randomness (±45 minutes)
        try {
          final eveningMinuteOffset = random.nextInt(91) - 45; // -45 to +45 minutes
          final eveningTime = DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
            eveningHour,
            0,
          ).add(Duration(minutes: eveningMinuteOffset.abs()));

          if (eveningTime.isAfter(now) &&
              eveningTime.isAfter(DateTime(targetDate.year, targetDate.month, targetDate.day, morningHour + 8))) {
            await _scheduleSmartNotification(
              id: 3000 + (day * 2) + 1,
              scheduledTime: eveningTime,
              isEvening: true,
              dayIndex: day,
            );
            scheduledCount++;
          }
        } catch (e) {
          print('❌ Erreur notification soir jour $day: $e');
        }
      }

      print('✅ $scheduledCount notifications programmées pour les 14 prochains jours');
    } catch (e) {
      print('❌ Erreur lors de la planification intelligente: $e');
      rethrow;
    }
  }

  // Schedule a smart notification with context
  Future<void> _scheduleSmartNotification({
    required int id,
    required DateTime scheduledTime,
    required bool isEvening,
    required int dayIndex,
  }) async {
    try {
      String title;
      String body;

      // Determine title based on time and day
      if (scheduledTime.weekday == DateTime.saturday || scheduledTime.weekday == DateTime.sunday) {
        title = "MathsCool Weekend! 🎉";
        body = NotificationMessages.getSpecificMessage(MessageType.weekend);
      } else if (isEvening) {
        title = "MathsCool Bonsoir! 🌙";
        body = NotificationMessages.getSpecificMessage(MessageType.evening);
      } else {
        title = "MathsCool Bonjour! ☀️";
        body = NotificationMessages.getSpecificMessage(MessageType.motivational);
      }

      await _notificationService.scheduleNotification(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTime,
        payload: 'smart_${isEvening ? 'evening' : 'morning'}_$dayIndex',
      );
    } catch (e) {
      print('❌ Erreur planification notification ID $id: $e');
    }
  }

  // Enable/disable notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsEnabledKey, enabled);

      if (enabled) {
        print('🔔 Activation des notifications');
        await scheduleSmartNotifications();
      } else {
        print('🔕 Désactivation des notifications');
        await _notificationService.cancelAllNotifications();
      }
    } catch (e) {
      print('❌ Erreur lors du changement d\'état des notifications: $e');
      rethrow;
    }
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationsEnabledKey) ?? true;
    } catch (e) {
      print('❌ Erreur lors de la vérification de l\'état: $e');
      return true; // Par défaut, activé
    }
  }

  // Set preferred time slots
  Future<void> setPreferredTimeSlots({
    required int morningHour,
    required int eveningHour,
  }) async {
    try {
      // Validation des heures
      if (morningHour < 0 || morningHour > 23 || eveningHour < 0 || eveningHour > 23) {
        throw ArgumentError('Les heures doivent être entre 0 et 23');
      }

      if (morningHour == eveningHour) {
        throw ArgumentError('Les heures du matin et du soir doivent être différentes');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_preferredTimeSlot1Key, morningHour);
      await prefs.setInt(_preferredTimeSlot2Key, eveningHour);

      print('⏰ Nouveaux créneaux: ${morningHour}h et ${eveningHour}h');

      // Reschedule with new times
      if (await areNotificationsEnabled()) {
        await scheduleSmartNotifications();
      }
    } catch (e) {
      print('❌ Erreur lors de la définition des créneaux: $e');
      rethrow;
    }
  }

  // Get preferred time slots
  Future<Map<String, int>> getPreferredTimeSlots() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'morning': prefs.getInt(_preferredTimeSlot1Key) ?? 9,
        'evening': prefs.getInt(_preferredTimeSlot2Key) ?? 19,
      };
    } catch (e) {
      print('❌ Erreur lors de la récupération des créneaux: $e');
      return {'morning': 9, 'evening': 19};
    }
  }


  // Get notification statistics
  Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pending = await _notificationService.getPendingNotifications();
      final lastScheduled = prefs.getString(_lastScheduledKey);

      return {
        'pending_count': pending.length,
        'is_enabled': await areNotificationsEnabled(),
        'last_scheduled': lastScheduled,
        'preferred_times': await getPreferredTimeSlots(),
        'is_initialized': _isInitialized,
      };
    } catch (e) {
      print('❌ Erreur lors de la récupération des stats: $e');
      return {
        'pending_count': 0,
        'is_enabled': false,
        'last_scheduled': null,
        'preferred_times': {'morning': 9, 'evening': 19},
        'is_initialized': _isInitialized,
      };
    }
  }

  // Cancel all notifications and stop scheduler
  Future<void> dispose() async {
    try {
      _schedulerTimer?.cancel();
      await _notificationService.cancelAllNotifications();
      _isInitialized = false;
      print('🧹 NotificationScheduler nettoyé');
    } catch (e) {
      print('❌ Erreur lors du nettoyage: $e');
    }
  }



  // Force reschedule all notifications
  Future<void> forceReschedule() async {
    try {
      print('🔄 Replanification forcée des notifications...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastScheduledKey);
      await _checkAndScheduleNotifications();
      print('✅ Replanification forcée terminée');
    } catch (e) {
      print('❌ Erreur lors de la replanification forcée: $e');
      rethrow;
    }
  }
}