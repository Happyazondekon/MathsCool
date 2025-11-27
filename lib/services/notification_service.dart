import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const String _notificationEnabledKey = 'notifications_enabled';
  static const String _customNotificationsKey = 'custom_notifications';
  static const String _lastNotificationKey = 'last_notification_time';

  // ID pour la notif de vies
  static const int _livesRefillNotificationId = 8888;
  // --- NOUVEAU : ID pour le rappel d'achievements ---
  static const int _achievementReminderId = 9001;

  // Messages motivationnels classiques
  final List<String> _motivationalMessages = [
    "Il est temps de faire des mathématiques magiques ! ✨",
    "Tes amis les chiffres t'attendent ! 🔢",
    "Viens découvrir de nouveaux défis mathématiques ! 🎯",
    "C'est l'heure de devenir un super héros des maths ! 🦸‍♂️",
    "Les équations t'appellent ! Prêt(e) à jouer ? 🎮",
    "Transforme-toi en génie des mathématiques ! 🧠",
    "Une nouvelle aventure mathématique t'attend ! 🌟",
    "Viens montrer tes talents de mathématicien ! 💪",
    "C'est parti pour une session de maths amusante ! 🎉",
    "Tes neurones ont envie de calculer ! 🧮",
    "Les nombres ont préparé des surprises pour toi ! 🎁",
    "Prêt(e) à résoudre des mystères mathématiques ? 🔍",
    "Il est temps de faire briller ton cerveau ! ✨",
    "Viens collectionner de nouveaux succès ! 🏆",
    "Une dose de maths pour bien commencer ! ☀️",
    "Une nouvelle leçon t'attend ! 🌟",
    "Prêt(e) pour ta session d'apprentissage ? 💫"
  ];

  // --- NOUVEAU : Messages spécifiques pour les Achievements ---
  final List<String> _achievementMessages = [
    "🏆 Psst... Un nouveau trophée t'attend peut-être !",
    "🥇 Viens débloquer ton prochain badge Expert !",
    "🚀 Tu es proche du but ! Viens progresser dans tes succès.",
    "🔥 Garde le rythme ! De nouvelles récompenses sont disponibles.",
    "👑 Deviens le Roi de la catégorie aujourd'hui !",
    "🎯 Objectif en vue : Viens compléter tes missions !",
    "🌟 Tes badges se sentent seuls... Viens en gagner d'autres !",
    "💪 Montre-nous tes talents et gagne des vies !",
  ];

  /// Initialisation du service de notifications
  Future<void> initialize() async {
    try {
      // Initialiser les fuseaux horaires
      tz.initializeTimeZones();

      // Configuration Android
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuration iOS
      const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Demander les permissions
      await _requestPermissions();

      print('Service de notifications initialisé avec succès');
    } catch (e) {
      print('Erreur lors de l\'initialisation du service de notifications: $e');
      rethrow;
    }
  }

  /// Demander les permissions nécessaires
  Future<bool> _requestPermissions() async {
    try {
      final notificationStatus = await Permission.notification.request();

      if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
        return false;
      }

      if (await Permission.scheduleExactAlarm.isDenied) {
        final result = await Permission.scheduleExactAlarm.request();
        if (result.isDenied || result.isPermanentlyDenied) {
          return false;
        }
      }
      return true;
    } catch (e) {
      print('Erreur lors de la demande de permissions: $e');
      return false;
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print('Notification tapped: ${notificationResponse.payload}');
  }

  tz.Location _getDeviceTimeZone() {
    try {
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final localNow = tz.TZDateTime.now(tz.local);
      if (localNow.timeZoneOffset == offset) {
        return tz.local;
      }
      for (final location in tz.timeZoneDatabase.locations.values) {
        final locationTime = tz.TZDateTime.now(location);
        if (locationTime.timeZoneOffset == offset) {
          return location;
        }
      }
      return tz.local;
    } catch (e) {
      return tz.local;
    }
  }

  // --- NOUVEAU : Programmer un rappel quotidien pour les achievements ---
  Future<bool> scheduleDailyAchievementReminder() async {
    try {
      if (!await areNotificationsEnabled() || !await _hasRequiredPermissions()) {
        return false;
      }

      // Configuration de l'heure : 17h30 (Heure idéale après l'école/devoirs)
      // Vous pouvez changer l'heure ici (hour: 17, minute: 30)
      final now = DateTime.now();
      var scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        17, // 17h
        30, // 30min
      );

      // Si l'heure est passée, on commence demain
      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      final deviceTimeZone = _getDeviceTimeZone();
      final scheduledDate = tz.TZDateTime.from(scheduledDateTime, deviceTimeZone);

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'mathscool_achievements', // Canal dédié
        'Rappels de Trophées',
        channelDescription: 'Rappels pour débloquer les succès et badges',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFFFFD700), // Couleur Or pour les trophées
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        sound: 'default',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Utilisation de zonedSchedule avec DateTimeComponents.time
      // Cela fait répéter la notification chaque jour à la même heure
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        _achievementReminderId,
        "Nouveaux succès disponibles ! 🏆",
        _getRandomAchievementMessage(), // Message aléatoire
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Répétition quotidienne
        payload: 'mathscool_achievement_reminder',
      );

      print('Rappel quotidien d\'achievements programmé pour : $scheduledDate');
      return true;

    } catch (e) {
      print('Erreur lors de la programmation du rappel d\'achievements : $e');
      return false;
    }
  }

  String _getRandomAchievementMessage() {
    final random = Random();
    return _achievementMessages[random.nextInt(_achievementMessages.length)];
  }

  /// Programmer une notification personnalisée (CODE EXISTANT CONSERVÉ)
  Future<bool> scheduleCustomNotification({
    required String userName,
    required int hour,
    required int minute,
    required int id,
    required bool isRepeating,
    String? customMessage,
  }) async {
    try {
      if (!await areNotificationsEnabled() || !await _hasRequiredPermissions()) {
        return false;
      }

      final now = DateTime.now();
      var scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      final deviceTimeZone = _getDeviceTimeZone();
      final scheduledDate = tz.TZDateTime.from(scheduledDateTime, deviceTimeZone);
      final message = customMessage ?? _getRandomMotivationalMessage();

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'mathscool_custom',
        'Sessions personnalisées',
        channelDescription: 'Notifications pour les sessions personnalisées',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFF34A853),
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "Hey $userName! 📚",
        message,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: isRepeating ? DateTimeComponents.time : null,
        payload: 'mathscool_custom_session',
      );

      await _saveCustomNotification(id, hour, minute, isRepeating, customMessage);
      return true;

    } catch (e) {
      print('Erreur programmation custom: $e');
      return false;
    }
  }

  Future<bool> _hasRequiredPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    return notificationStatus.isGranted && (exactAlarmStatus.isGranted);
  }

  Future<void> _saveCustomNotification(
      int id,
      int hour,
      int minute,
      bool isRepeating,
      String? message,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customNotifications = prefs.getStringList(_customNotificationsKey) ?? [];

      final notificationData = {
        'id': id.toString(),
        'hour': hour.toString(),
        'minute': minute.toString(),
        'isRepeating': isRepeating.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        if (message != null) 'message': message,
      };

      customNotifications.add(_encodeNotification(notificationData));
      await prefs.setStringList(_customNotificationsKey, customNotifications);
    } catch (e) {
      print('Erreur sauvegarde: $e');
    }
  }

  String _encodeNotification(Map<String, String> data) {
    return data.entries.map((e) => '${e.key}:${e.value.replaceAll(':', '|')}').join(',');
  }

  Map<String, String> _decodeNotification(String encoded) {
    try {
      final pairs = encoded.split(',');
      return Map.fromEntries(
        pairs.map((pair) {
          final parts = pair.split(':');
          if (parts.length >= 2) {
            final key = parts[0];
            final value = parts.sublist(1).join(':').replaceAll('|', ':');
            return MapEntry(key, value);
          }
          return MapEntry('', '');
        }).where((entry) => entry.key.isNotEmpty),
      );
    } catch (e) {
      return {};
    }
  }

  Future<List<Map<String, String>>> getCustomNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_customNotificationsKey) ?? [];
      return encoded.map((e) => _decodeNotification(e)).where((map) => map.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> removeCustomNotification(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList(_customNotificationsKey) ?? [];
      notifications.removeWhere((encoded) {
        final data = _decodeNotification(encoded);
        return data['id'] == id.toString();
      });
      await prefs.setStringList(_customNotificationsKey, notifications);
      await _flutterLocalNotificationsPlugin.cancel(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> restoreCustomNotifications(String userName) async {
    try {
      final notifications = await getCustomNotifications();
      int restoredCount = 0;
      for (final notification in notifications) {
        try {
          final success = await scheduleCustomNotification(
            userName: userName,
            hour: int.parse(notification['hour'] ?? '0'),
            minute: int.parse(notification['minute'] ?? '0'),
            id: int.parse(notification['id'] ?? '0'),
            isRepeating: notification['isRepeating'] == 'true',
            customMessage: notification['message'],
          );
          if (success) restoredCount++;
        } catch (e) {
          print('Erreur restauration notif ${notification['id']}: $e');
        }
      }
      return restoredCount;
    } catch (e) {
      return 0;
    }
  }

  String _getRandomMotivationalMessage() {
    final random = Random();
    return _motivationalMessages[random.nextInt(_motivationalMessages.length)];
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationEnabledKey, enabled);
      if (!enabled) {
        await cancelAllNotifications();
      }
    } catch (e) {
      print('Erreur enable/disable: $e');
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationEnabledKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> _saveLastNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastNotificationKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Erreur save timestamp: $e');
    }
  }

  Future<DateTime?> getLastNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastNotificationKey);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> shouldSendNotificationNow() async {
    try {
      final lastTime = await getLastNotificationTime();
      if (lastTime == null) return true;
      final now = DateTime.now();
      return now.difference(lastTime).inHours >= 12;
    } catch (e) {
      return true;
    }
  }

  Future<bool> sendImmediateNotification({
    required String userName,
    required String title,
    required String message,
    int? id,
  }) async {
    try {
      if (!await areNotificationsEnabled()) return false;

      final notificationId = id ?? Random().nextInt(10000);
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'mathscool_immediate',
        'Notifications immédiates',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFF34A853),
      );

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        message,
        const NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()),
        payload: 'mathscool_immediate',
      );

      await _saveLastNotificationTime();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      final customNotifications = await getCustomNotifications();
      final pendingNotifications = await getPendingNotifications();
      final lastNotificationTime = await getLastNotificationTime();
      final notificationsEnabled = await areNotificationsEnabled();

      return {
        'customCount': customNotifications.length,
        'pendingCount': pendingNotifications.length,
        'lastNotificationTime': lastNotificationTime?.toIso8601String(),
        'enabled': notificationsEnabled,
        'permissions': await _hasRequiredPermissions(),
      };
    } catch (e) {
      return {};
    }
  }

  Future<int> cleanupOldNotifications() async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      int cleanedCount = 0;
      final prefs = await SharedPreferences.getInstance();
      final customNotifications = prefs.getStringList(_customNotificationsKey) ?? [];

      customNotifications.removeWhere((encoded) {
        final data = _decodeNotification(encoded);
        final timestampStr = data['timestamp'];
        if (timestampStr != null) {
          try {
            final timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(timestampStr));
            if (timestamp.isBefore(thirtyDaysAgo)) {
              cleanedCount++;
              return true;
            }
          } catch (e) {
            cleanedCount++;
            return true;
          }
        }
        return false;
      });

      await prefs.setStringList(_customNotificationsKey, customNotifications);
      return cleanedCount;
    } catch (e) {
      return 0;
    }
  }

  /// Programmer une notification quand les vies sont rechargées (CODE EXISTANT)
  Future<bool> scheduleLivesRefilledNotification({
    required String userName,
    required Duration timeRemaining,
  }) async {
    try {
      if (!await areNotificationsEnabled() || !await _hasRequiredPermissions()) {
        return false;
      }

      final now = DateTime.now();
      final scheduledDateTime = now.add(timeRemaining);
      final deviceTimeZone = _getDeviceTimeZone();
      final scheduledDate = tz.TZDateTime.from(scheduledDateTime, deviceTimeZone);

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'mathscool_lives',
        'Vies Rechargées',
        channelDescription: 'Notifications quand les vies sont complètes',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFFE91E63),
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        _livesRefillNotificationId,
        "Vies au max ! ❤️",
        "Hey $userName, tes vies sont rechargées ! Viens jouer ! 🎮",
        scheduledDate,
        const NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'mathscool_lives_refill',
      );

      print('Notification de vies programmée pour : $scheduledDate');
      return true;
    } catch (e) {
      print('Erreur programmation vies: $e');
      return false;
    }
  }

  /// Annuler la notification de vies
  Future<void> cancelLivesRefilledNotification() async {
    await cancelNotification(_livesRefillNotificationId);
  }
}