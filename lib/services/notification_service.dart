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
  // Messages attrayants pour les enfants
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
    "Une dose de maths pour bien commencer ! ☀️"
    "Tes amis les chiffres t'attendent ! 🔢",
    "Viens découvrir de nouveaux défis mathématiques ! 🎯",
    "C'est l'heure de devenir un super héros des maths ! 🦸‍♂️",
    "Les équations t'appellent ! Prêt(e) à jouer ? 🎮",
    "Une nouvelle leçon t'attend ! 🌟",
    "Prêt(e) pour ta session d'apprentissage ? 💫"
  ];

  // Initialisation du service de notifications
  Future<void> initialize() async {
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
  }

  // Demander les permissions nécessaires
  Future<void> _requestPermissions() async {
    // Permission pour les notifications
    await Permission.notification.request();

    // Permission spécifique Android 13+
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  // Gérer le tap sur la notification
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    // Ici on peut naviguer vers une page spécifique
    // ou exécuter une action particulière
    print('Notification tapped: ${notificationResponse.payload}');
  }

  // Programmer les notifications récurrentes toutes les 12 heures
  Future<void> scheduleRecurringNotifications(String userName) async {
    // Vérifier si les notifications sont activées
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_notificationEnabledKey) ?? true;

    if (!isEnabled) return;

    // Annuler les notifications existantes
    await cancelAllNotifications();


    print('Notifications programmées pour $userName');
  }

  // Programmer une notification à une heure spécifique
  Future<void> _scheduleNotificationAt({
    required int id,
    required int hour,
    required int minute,
    required String userName,
    required String title,
  }) async {
    final random = Random();
    final message = _motivationalMessages[random.nextInt(_motivationalMessages.length)];

    // Créer la date/heure pour la prochaine occurrence
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Si l'heure est déjà passée aujourd'hui, programmer pour demain
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'mathscool_reminders',
      'Rappels MathsCool',
      channelDescription: 'Notifications de rappel pour jouer à MathsCool',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2196F3),
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      message,
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Répéter quotidiennement
      payload: 'mathscool_reminder',
    );
  }



  // Nouvelle méthode pour programmer une notification personnalisée
  Future<void> scheduleCustomNotification({
    required String userName,
    required int hour,
    required int minute,
    required int id,
    required bool isRepeating,
    String? customMessage,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Si l'heure est déjà passée aujourd'hui, programmer pour demain
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final message = customMessage ?? _getRandomMotivationalMessage();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'mathscool_custom',
      'Sessions personnalisées',
      channelDescription: 'Notifications pour les sessions personnalisées',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2196F3),
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

    // Sauvegarder la notification personnalisée
    await _saveCustomNotification(id, hour, minute, isRepeating, customMessage);
  }

  // Sauvegarder une notification personnalisée
  Future<void> _saveCustomNotification(
      int id,
      int hour,
      int minute,
      bool isRepeating,
      String? message,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final customNotifications = prefs.getStringList(_customNotificationsKey) ?? [];

    final notificationData = {
      'id': id.toString(),
      'hour': hour.toString(),
      'minute': minute.toString(),
      'isRepeating': isRepeating.toString(),
      if (message != null) 'message': message,
    };

    customNotifications.add(encodedNotification(notificationData));
    await prefs.setStringList(_customNotificationsKey, customNotifications);
  }

  // Encoder les données de notification
  String encodedNotification(Map<String, String> data) {
    return data.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  // Décoder les données de notification
  Map<String, String> decodeNotification(String encoded) {
    final pairs = encoded.split(',');
    return Map.fromEntries(
      pairs.map((pair) {
        final parts = pair.split(':');
        return MapEntry(parts[0], parts[1]);
      }),
    );
  }

  // Obtenir toutes les notifications personnalisées
  Future<List<Map<String, String>>> getCustomNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_customNotificationsKey) ?? [];
    return encoded.map((e) => decodeNotification(e)).toList();
  }

  // Supprimer une notification personnalisée
  Future<void> removeCustomNotification(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList(_customNotificationsKey) ?? [];

    notifications.removeWhere((encoded) {
      final data = decodeNotification(encoded);
      return data['id'] == id.toString();
    });

    await prefs.setStringList(_customNotificationsKey, notifications);
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Restaurer toutes les notifications personnalisées (à appeler au démarrage)
  Future<void> restoreCustomNotifications(String userName) async {
    final notifications = await getCustomNotifications();

    for (final notification in notifications) {
      await scheduleCustomNotification(
        userName: userName,
        hour: int.parse(notification['hour']!),
        minute: int.parse(notification['minute']!),
        id: int.parse(notification['id']!),
        isRepeating: notification['isRepeating'] == 'true',
        customMessage: notification['message'],
      );
    }
  }

  String _getRandomMotivationalMessage() {
    final random = Random();
    return _motivationalMessages[random.nextInt(_motivationalMessages.length)];
  }

  // Activer/Désactiver les notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);

    if (!enabled) {
      await cancelAllNotifications();
    }
  }

  // Vérifier si les notifications sont activées
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? true;
  }

  // Annuler toutes les notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Annuler une notification spécifique
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Obtenir les notifications en attente
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Enregistrer le timestamp de la dernière notification
  Future<void> _saveLastNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastNotificationKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Obtenir le timestamp de la dernière notification
  Future<DateTime?> getLastNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastNotificationKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // Vérifier si il faut envoyer une notification maintenant
  Future<bool> shouldSendNotificationNow() async {
    final lastTime = await getLastNotificationTime();
    if (lastTime == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastTime);
    return difference.inHours >= 12;
  }
}