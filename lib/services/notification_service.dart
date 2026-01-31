import 'dart:ui';
import 'package:flutter/material.dart'; // ✅ AJOUTÉ
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart'; // ✅ AJOUTÉ
import 'package:firebase_messaging/firebase_messaging.dart'; // 🆕 AJOUTÉ POUR FIREBASE MESSAGING
import 'fcm_topics.dart'; // 🆕 AJOUTÉ POUR LA CONFIGURATION DES TOPICS

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // 🆕 Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static const String _notificationEnabledKey = 'notifications_enabled';
  static const String _customNotificationsKey = 'custom_notifications';
  static const String _lastNotificationKey = 'last_notification_time';

  // IDs pour les différentes notifications
  static const int _livesRefillNotificationId = 8888;
  static const int _achievementReminderId = 9001;
  static const int _dailyChallengeReminderId = 9002;
  // IDs multiples pour les rappels de classement (3 par jour)
  static const int _leaderboardReminderId1 = 9003;
  static const int _leaderboardReminderId2 = 9004;
  static const int _leaderboardReminderId3 = 9005;

  // ✅ MODIFIÉ : Les listes hardcodées sont remplacées par des méthodes
  // Noms aléatoires pour les messages compétitifs (inchangés - noms universels)
  final List<String> _randomCompetitorNames = [
    "Emma", "Lucas", "Chloé", "Nathan", "Léa", "Tom",
    "Inès", "Happy", "Jade", "Arthur", "Mékis", "Louis",
    "Zoé", "Ethan", "Lina", "Mathis", "Sarah", "Noah",
    "Camille", "Gabriel", "Lily", "Delali", "Alice", "Adam"
  ];

  // ✅ NOUVEAU : Méthodes pour obtenir les messages traduits
  List<String> _getMotivationalMessages(AppLocalizations l10n) {
    return [
      l10n.notifMotivational1,
      l10n.notifMotivational2,
      l10n.notifMotivational3,
      l10n.notifMotivational4,
      l10n.notifMotivational5,
      l10n.notifMotivational6,
      l10n.notifMotivational7,
      l10n.notifMotivational8,
      l10n.notifMotivational9,
      l10n.notifMotivational10,
      l10n.notifMotivational11,
      l10n.notifMotivational12,
      l10n.notifMotivational13,
      l10n.notifMotivational14,
      l10n.notifMotivational15,
      l10n.notifMotivational16,
      l10n.notifMotivational17,
    ];
  }

  List<String> _getAchievementMessages(AppLocalizations l10n) {
    return [
      l10n.notifAchievement1,
      l10n.notifAchievement2,
      l10n.notifAchievement3,
      l10n.notifAchievement4,
      l10n.notifAchievement5,
      l10n.notifAchievement6,
      l10n.notifAchievement7,
      l10n.notifAchievement8,
    ];
  }

  List<String> _getDailyChallengeMessages(AppLocalizations l10n) {
    return [
      l10n.notifDailyChallenge1,
      l10n.notifDailyChallenge2,
      l10n.notifDailyChallenge3,
      l10n.notifDailyChallenge4,
      l10n.notifDailyChallenge5,
      l10n.notifDailyChallenge6,
      l10n.notifDailyChallenge7,
      l10n.notifDailyChallenge8,
      l10n.notifDailyChallenge9,
      l10n.notifDailyChallenge10,
    ];
  }

  List<String> _getLeaderboardMessages(AppLocalizations l10n) {
    final generators = [
      l10n.notifLeaderboard1,
      l10n.notifLeaderboard2,
      l10n.notifLeaderboard3,
      l10n.notifLeaderboard4,
      l10n.notifLeaderboard5,
      l10n.notifLeaderboard6,
      l10n.notifLeaderboard7,
      l10n.notifLeaderboard8,
      l10n.notifLeaderboard9,
      l10n.notifLeaderboard10,
    ];

    return List.generate(
      generators.length,
          (index) => generators[index](_randomCompetitorNames[index]),
    );
  }


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

      // 🆕 Initialiser Firebase Messaging
      await _initializeFirebaseMessaging();

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

  /// 🆕 Initialiser Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    try {
      // Demander la permission pour les notifications push
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('Firebase Messaging permission status: ${settings.authorizationStatus}');

      // Obtenir le token FCM
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        // Sauvegarder le token pour l'utiliser plus tard
        await _saveFCMToken(token);
      }

      // Gérer les messages en arrière-plan
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Gérer les messages au premier plan
      FirebaseMessaging.onMessage.listen(_onMessage);

      // Gérer l'ouverture de l'app via notification
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

      // Vérifier si l'app a été ouverte via une notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage);
      }

      print('Firebase Messaging initialisé avec succès');
    } catch (e) {
      print('Erreur lors de l\'initialisation de Firebase Messaging: $e');
    }
  }

  /// 🆕 Gestionnaire de messages en arrière-plan
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Message reçu en arrière-plan: ${message.messageId}');
    // Ici, vous pouvez afficher une notification locale si nécessaire
  }

  /// 🆕 Gestionnaire de messages au premier plan
  void _onMessage(RemoteMessage message) {
    print('Message reçu au premier plan: ${message.messageId}');

    // Afficher une notification locale pour les messages reçus au premier plan
    if (message.notification != null) {
      _showLocalNotificationFromFCM(message);
    }
  }

  /// 🆕 Gestionnaire d'ouverture d'app via notification
  void _onMessageOpenedApp(RemoteMessage message) {
    print('App ouverte via notification: ${message.messageId}');
    _handleMessage(message);
  }

  /// 🆕 Afficher une notification locale depuis FCM
  Future<void> _showLocalNotificationFromFCM(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'fcm_channel',
      'Firebase Messages',
      channelDescription: 'Notifications from Firebase Cloud Messaging',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode, // ID unique
      message.notification?.title ?? 'MathsCool',
      message.notification?.body ?? 'Nouvelle notification',
      details,
      payload: message.data.toString(),
    );
  }

  /// 🆕 Gérer le message (navigation, actions, etc.)
  void _handleMessage(RemoteMessage message) {
    print('Handling message: ${message.data}');

    // Ici, vous pouvez implémenter la logique de navigation ou d'actions
    // basée sur les données du message
    if (message.data.containsKey('screen')) {
      final screen = message.data['screen'];
      print('Naviguer vers l\'écran: $screen');
      // Implémenter la navigation selon vos besoins
    }
  }

  /// 🆕 Sauvegarder le token FCM
  Future<void> _saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      print('FCM Token sauvegardé');
    } catch (e) {
      print('Erreur sauvegarde FCM Token: $e');
    }
  }

  /// 🆕 Récupérer le token FCM sauvegardé
  Future<String?> getFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('fcm_token');
    } catch (e) {
      print('Erreur récupération FCM Token: $e');
      return null;
    }
  }

  /// 🆕 S'abonner à un topic pour les campagnes ciblées
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('Abonné au topic: $topic');
    } catch (e) {
      print('Erreur abonnement topic: $e');
    }
  }

  /// 🆕 Se désabonner d'un topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('Désabonné du topic: $topic');
    } catch (e) {
      print('Erreur désabonnement topic: $e');
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

  // ========== MÉTHODES POUR OBTENIR DES MESSAGES ALÉATOIRES ==========

  // ✅ MODIFIÉ : Accepte maintenant BuildContext pour les traductions
  String _getRandomAchievementMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messages = _getAchievementMessages(l10n);
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  String _getRandomDailyChallengeMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messages = _getDailyChallengeMessages(l10n);
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  String _getRandomLeaderboardMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messages = _getLeaderboardMessages(l10n);
    final random = Random();
    final name = _randomCompetitorNames[random.nextInt(_randomCompetitorNames.length)];
    final message = messages[random.nextInt(messages.length)];
    return message.replaceAll('{name}', name);
  }

  String _getRandomMotivationalMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messages = _getMotivationalMessages(l10n);
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  // ========== NOTIFICATIONS AUTOMATIQUES (ACHIEVEMENTS, DÉFIS, CLASSEMENTS) ==========

  /// Programmer un rappel quotidien pour les achievements (17h30)
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<bool> scheduleDailyAchievementReminder(BuildContext context) async {
    try {
      if (!await areNotificationsEnabled() || !await _hasRequiredPermissions()) {
        return false;
      }

      final now = DateTime.now();
      var scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        18, // 17h
        30, // 30min
      );

      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      final deviceTimeZone = _getDeviceTimeZone();
      final scheduledDate = tz.TZDateTime.from(scheduledDateTime, deviceTimeZone);

      // ✅ MODIFIÉ : Utilisation de l10n pour les textes
      final l10n = AppLocalizations.of(context)!;

      final androidDetails = AndroidNotificationDetails(
        'mathscool_achievements',
        l10n.notifChannelAchievements,
        channelDescription: l10n.notifChannelAchievementsDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFFFFD700),
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

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        _achievementReminderId,
        l10n.notifTitleAchievements, // ✅ MODIFIÉ
        _getRandomAchievementMessage(context), // ✅ MODIFIÉ
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'mathscool_achievement_reminder',
      );

      print('Rappel quotidien d\'achievements programmé pour : $scheduledDate');
      return true;

    } catch (e) {
      print('Erreur lors de la programmation du rappel d\'achievements : $e');
      return false;
    }
  }

  /// Programmer un rappel quotidien pour le défi du jour (18h00)
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<bool> scheduleDailyChallengeReminder(BuildContext context) async {
    try {
      print('🟡 DEBUG: Début de scheduleDailyChallengeReminder');

      if (!await areNotificationsEnabled() || !await _hasRequiredPermissions()) {
        print('❌ DEBUG: Notifications désactivées ou permissions manquantes pour daily challenge');
        return false;
      }

      print('🟢 DEBUG: Permissions OK pour daily challenge');

      final now = DateTime.now();
      var scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        19, // 18h
        19,  // 00min
      );

      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      final deviceTimeZone = _getDeviceTimeZone();
      final scheduledDate = tz.TZDateTime.from(scheduledDateTime, deviceTimeZone);

      // ✅ MODIFIÉ : Utilisation de l10n
      final l10n = AppLocalizations.of(context)!;

      final androidDetails = AndroidNotificationDetails(
        'mathscool_daily_challenge',
        l10n.notifChannelDailyChallenge,
        channelDescription: l10n.notifChannelDailyChallengeDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFF6366F1),
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

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        _dailyChallengeReminderId,
        l10n.notifTitleDailyChallenge, // ✅ MODIFIÉ
        _getRandomDailyChallengeMessage(context), // ✅ MODIFIÉ
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'mathscool_daily_challenge',
      );

      print('✅ Rappel quotidien du défi programmé pour : $scheduledDate');
      return true;

    } catch (e) {
      print('❌ Erreur lors de la programmation du rappel de défi : $e');
      return false;
    }
  }

  /// Programmer plusieurs rappels quotidiens pour le classement (11h, 15h, 19h)
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<Map<String, bool>> scheduleLeaderboardReminders(BuildContext context) async {
    Map<String, bool> results = {};

    try {
      print('🟡 DEBUG: Début de scheduleLeaderboardReminders');

      if (!await areNotificationsEnabled() || !await _hasRequiredPermissions()) {
        print('❌ DEBUG: Notifications désactivées ou permissions manquantes pour leaderboard');
        return {
          'morning': false,
          'afternoon': false,
          'evening': false,
        };
      }

      print('🟢 DEBUG: Permissions OK pour leaderboard');

      // Horaires des 3 rappels quotidiens
      final schedules = [
        {'hour': 11, 'minute': 0, 'id': _leaderboardReminderId1, 'name': 'morning'},
        {'hour': 15, 'minute': 0, 'id': _leaderboardReminderId2, 'name': 'afternoon'},
        {'hour': 19, 'minute': 24, 'id': _leaderboardReminderId3, 'name': 'evening'},
      ];

      final deviceTimeZone = _getDeviceTimeZone();
      final now = DateTime.now();

      print('📅 DEBUG: Programmation des rappels de classement - Heure actuelle: $now');

      // ✅ MODIFIÉ : Obtenir l10n une seule fois
      final l10n = AppLocalizations.of(context)!;

      for (final schedule in schedules) {
        try {
          var scheduledDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            schedule['hour'] as int,
            schedule['minute'] as int,
          );

          if (scheduledDateTime.isBefore(now)) {
            scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
          }

          final scheduledDate = tz.TZDateTime.from(scheduledDateTime, deviceTimeZone);

          // ✅ MODIFIÉ : Utilisation de l10n
          final androidDetails = AndroidNotificationDetails(
            'mathscool_leaderboard',
            l10n.notifChannelLeaderboard,
            channelDescription: l10n.notifChannelLeaderboardDesc,
            importance: Importance.high,
            priority: Priority.high,
            icon: 'baseline_calculate_white_36',
            color: Color(0xFF6366F1),
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

          final NotificationDetails platformDetails = NotificationDetails(
            android: androidDetails,
            iOS: iosDetails,
          );

          await _flutterLocalNotificationsPlugin.zonedSchedule(
            schedule['id'] as int,
            l10n.notifTitleLeaderboard, // ✅ MODIFIÉ
            _getRandomLeaderboardMessage(context), // ✅ MODIFIÉ
            scheduledDate,
            platformDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: 'mathscool_leaderboard',
          );

          results[schedule['name'] as String] = true;
          print('✅ Rappel de classement (${schedule['name']}) programmé pour : $scheduledDate');
        } catch (e) {
          print('❌ Erreur programmation rappel ${schedule['name']}: $e');
          results[schedule['name'] as String] = false;
        }
      }

      return results;
    } catch (e) {
      print('❌ Erreur lors de la programmation des rappels de classement : $e');
      return {
        'morning': false,
        'afternoon': false,
        'evening': false,
      };
    }
  }

  /// Programmer toutes les notifications automatiques en une seule fois
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<Map<String, dynamic>> scheduleAllAutomaticReminders(
      BuildContext context,
      String userName
      ) async {
    print('🚀 DEBUG: Début de scheduleAllAutomaticReminders pour $userName');

    try {
      // Vérifier d'abord les permissions et l'état
      final hasPermissions = await _hasRequiredPermissions();
      final notificationsEnabled = await areNotificationsEnabled();

      print('📋 DEBUG: État des notifications:');
      print('   - Permissions: $hasPermissions');
      print('   - Activées: $notificationsEnabled');

      if (!notificationsEnabled || !hasPermissions) {
        print('❌ DEBUG: Notifications désactivées ou permissions manquantes');
        return {
          'achievements': false,
          'dailyChallenge': false,
          'leaderboard': {},
        };
      }

      print('\n📅 DEBUG: Programmation des notifications:');

      // 1. Achievements
      print('   1. Achievements...');
      final achievementResult = await scheduleDailyAchievementReminder(context); // ✅ MODIFIÉ
      print('      → $achievementResult');

      // 2. Daily Challenge
      print('   2. Daily Challenge...');
      final dailyChallengeResult = await scheduleDailyChallengeReminder(context); // ✅ MODIFIÉ
      print('      → $dailyChallengeResult');

      // 3. Leaderboard
      print('   3. Leaderboard...');
      final leaderboardResults = await scheduleLeaderboardReminders(context); // ✅ MODIFIÉ
      print('      → $leaderboardResults');

      print('\n✅ DEBUG: Toutes les notifications ont été programmées');

      return {
        'achievements': achievementResult,
        'dailyChallenge': dailyChallengeResult,
        'leaderboard': leaderboardResults,
      };
    } catch (e) {
      print('❌ Erreur dans scheduleAllAutomaticReminders: $e');
      return {
        'achievements': false,
        'dailyChallenge': false,
        'leaderboard': {},
      };
    }
  }

  /// Annuler toutes les notifications automatiques
  Future<void> cancelAllAutomaticReminders() async {
    await cancelNotification(_achievementReminderId);
    await cancelNotification(_dailyChallengeReminderId);
    await cancelNotification(_leaderboardReminderId1);
    await cancelNotification(_leaderboardReminderId2);
    await cancelNotification(_leaderboardReminderId3);
  }

  /// Annuler le rappel des achievements
  Future<void> cancelAchievementReminder() async {
    await cancelNotification(_achievementReminderId);
  }

  /// Annuler le rappel du défi quotidien
  Future<void> cancelDailyChallengeReminder() async {
    await cancelNotification(_dailyChallengeReminderId);
  }

  /// Annuler tous les rappels de classement
  Future<void> cancelLeaderboardReminders() async {
    await cancelNotification(_leaderboardReminderId1);
    await cancelNotification(_leaderboardReminderId2);
    await cancelNotification(_leaderboardReminderId3);
  }

  // ========== NOTIFICATIONS PERSONNALISÉES ==========

  /// Programmer une notification personnalisée
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<bool> scheduleCustomNotification({
    required BuildContext context,
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

      // ✅ MODIFIÉ : Utilisation de l10n
      final l10n = AppLocalizations.of(context)!;

      final androidDetails = AndroidNotificationDetails(
        'mathscool_custom',
        l10n.notifChannelImmediate, // ✅ MODIFIÉ
        importance: Importance.high,
        priority: Priority.high,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFF34A853),
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "MathsCool 🎓",
        customMessage ?? _getRandomMotivationalMessage(context), // ✅ MODIFIÉ
        scheduledDate,
        NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: isRepeating ? DateTimeComponents.time : null,
        payload: 'mathscool_custom',
      );

      // Sauvegarder les détails de la notification personnalisée
      await _saveCustomNotification(
        id: id,
        hour: hour,
        minute: minute,
        isRepeating: isRepeating,
        message: customMessage ?? '',
      );

      return true;
    } catch (e) {
      print('Erreur programmation notification personnalisée: $e');
      return false;
    }
  }

  /// Sauvegarder les détails d'une notification personnalisée
  Future<void> _saveCustomNotification({
    required int id,
    required int hour,
    required int minute,
    required bool isRepeating,
    required String message,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customNotifications = prefs.getStringList(_customNotificationsKey) ?? [];

      final notificationData = {
        'id': id.toString(),
        'hour': hour.toString(),
        'minute': minute.toString(),
        'isRepeating': isRepeating.toString(),
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final encoded = notificationData.entries
          .map((e) => '${e.key}:${e.value}')
          .join('|');

      customNotifications.add(encoded);
      await prefs.setStringList(_customNotificationsKey, customNotifications);
    } catch (e) {
      print('Erreur sauvegarde notification: $e');
    }
  }

  /// Récupérer toutes les notifications personnalisées sauvegardées
  Future<List<Map<String, String>>> getCustomNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customNotifications = prefs.getStringList(_customNotificationsKey) ?? [];

      return customNotifications.map((encoded) {
        return _decodeNotification(encoded);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, String> _decodeNotification(String encoded) {
    final Map<String, String> data = {};
    final pairs = encoded.split('|');

    for (final pair in pairs) {
      final keyValue = pair.split(':');
      if (keyValue.length == 2) {
        data[keyValue[0]] = keyValue[1];
      }
    }

    return data;
  }

  /// Annuler et supprimer une notification personnalisée
  Future<void> removeCustomNotification(int id) async {
    try {
      await cancelNotification(id);

      final prefs = await SharedPreferences.getInstance();
      final customNotifications = prefs.getStringList(_customNotificationsKey) ?? [];

      customNotifications.removeWhere((encoded) {
        final data = _decodeNotification(encoded);
        return data['id'] == id.toString();
      });

      await prefs.setStringList(_customNotificationsKey, customNotifications);
    } catch (e) {
      print('Erreur suppression notification: $e');
    }
  }

  /// Restaurer toutes les notifications personnalisées après un redémarrage
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<int> restoreCustomNotifications(BuildContext context, String userName) async {
    try {
      final notifications = await getCustomNotifications();
      int restoredCount = 0;

      for (final notification in notifications) {
        try {
          final id = int.parse(notification['id'] ?? '0');
          final hour = int.parse(notification['hour'] ?? '0');
          final minute = int.parse(notification['minute'] ?? '0');

          final success = await scheduleCustomNotification(
            context: context, // ✅ MODIFIÉ
            userName: userName,
            hour: hour,
            minute: minute,
            id: id,
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

  // ========== NOTIFICATIONS DE VIES ==========

  Future<bool> scheduleLivesRefilledNotification({
    BuildContext? context,
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

      // ✅ MODIFIÉ : Utilisation de l10n ou défaut
      final l10n = context != null ? AppLocalizations.of(context)! : null;

      final title = l10n?.notifTitleLivesRefilled ?? 'Lives Refilled!';
      final body = l10n?.notifBodyLivesRefilled(userName) ?? 'Your lives have been refilled, $userName! Ready to play?';
      final channelName = l10n?.notifChannelLives ?? 'Lives';
      final channelDesc = l10n?.notifChannelLivesDesc ?? 'Notifications about lives refill';

      final androidDetails = AndroidNotificationDetails(
        'mathscool_lives',
        channelName,
        channelDescription: channelDesc,
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
        title,
        body,
        scheduledDate,
        NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()),
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

  // ========== GESTION GÉNÉRALE DES NOTIFICATIONS ==========

  Future<bool> _hasRequiredPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    return notificationStatus.isGranted && (exactAlarmStatus.isGranted);
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

  // ========== NOTIFICATIONS IMMÉDIATES ==========

  /// ✅ MODIFIÉ : Accepte BuildContext optionnel
  Future<bool> sendImmediateNotification({
    BuildContext? context,
    required String userName,
    required String title,
    required String message,
    int? id,
  }) async {
    try {
      if (!await areNotificationsEnabled()) return false;

      final notificationId = id ?? Random().nextInt(10000);

      // Si context est fourni, on peut utiliser les traductions
      final channelName = context != null
          ? AppLocalizations.of(context)!.notifChannelImmediate
          : 'Notifications immédiates';

      final androidDetails = AndroidNotificationDetails(
        'mathscool_immediate',
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFF34A853),
      );

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        message,
        NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()),
        payload: 'mathscool_immediate',
      );

      await _saveLastNotificationTime();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ========== STATISTIQUES ET UTILITAIRES ==========

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

  /// Méthode de test pour vérifier chaque type de notification
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<void> testAllNotifications(BuildContext context) async {
    print('🧪 DEBUG: Test de toutes les notifications');

    // Test 1: Achievements
    print('\n1. Test Achievements:');
    final achievementResult = await scheduleDailyAchievementReminder(context);
    print('   Résultat: $achievementResult');

    // Test 2: Daily Challenge
    print('\n2. Test Daily Challenge:');
    final dailyResult = await scheduleDailyChallengeReminder(context);
    print('   Résultat: $dailyResult');

    // Test 3: Leaderboard
    print('\n3. Test Leaderboard:');
    final leaderboardResult = await scheduleLeaderboardReminders(context);
    print('   Résultat: $leaderboardResult');

    // Vérification des permissions
    print('\n4. Vérification permissions:');
    final hasPerm = await _hasRequiredPermissions();
    final enabled = await areNotificationsEnabled();
    print('   Permissions: $hasPerm');
    print('   Notifications activées: $enabled');
  }

  /// Reprogrammer toutes les notifications (utile pour débogage)
  /// ✅ MODIFIÉ : Accepte BuildContext
  Future<Map<String, dynamic>> rescheduleAllNotifications(
      BuildContext context,
      String userName
      ) async {
    try {
      print('🔄 DEBUG: Reprogrammation de toutes les notifications');

      // Annuler toutes les notifications existantes
      await cancelAllAutomaticReminders();

      // Attendre un court instant
      await Future.delayed(Duration(milliseconds: 500));

      // Reprogrammer toutes les notifications
      return await scheduleAllAutomaticReminders(context, userName);
    } catch (e) {
      print('❌ Erreur lors de la reprogrammation : $e');
      return {
        'achievements': false,
        'dailyChallenge': false,
        'leaderboard': {},
      };
    }
  }

  // ========== CAMPAGNES ET NOTIFICATIONS CIBLÉES ==========

  /// S'abonner aux topics selon le profil utilisateur
  Future<void> subscribeToUserTopics(String userId, String level, String language) async {
    try {
      // Topics de base
      await subscribeToTopic(FCMTopics.allUsers);
      await subscribeToTopic(FCMTopics.getLevelTopic(level));
      await subscribeToTopic(FCMTopics.getLanguageTopic(language));

      // Topics spécifiques selon l'utilisateur
      if (userId.isNotEmpty) {
        await subscribeToTopic('user_$userId');
      }

      print('Abonné aux topics utilisateur: ${FCMTopics.allUsers}, ${FCMTopics.getLevelTopic(level)}, ${FCMTopics.getLanguageTopic(language)}, user_$userId');
    } catch (e) {
      print('Erreur abonnement topics utilisateur: $e');
    }
  }

  /// Se désabonner de tous les topics utilisateur
  Future<void> unsubscribeFromAllTopics() async {
    try {
      // Note: Firebase ne permet pas de récupérer la liste des topics,
      // donc on se désabonne des topics courants connus
      await unsubscribeFromTopic('all_users');
      // Les autres topics seront gérés dynamiquement
      print('Désabonné de tous les topics');
    } catch (e) {
      print('Erreur désabonnement topics: $e');
    }
  }

  /// Envoyer une notification de test FCM (pour débogage)
  Future<void> sendTestFCMNotification() async {
    try {
      String? token = await getFCMToken();
      if (token != null) {
        print('Token FCM pour test: $token');
        // Ici, vous pouvez implémenter l'envoi de test via votre serveur
      } else {
        print('Aucun token FCM disponible');
      }
    } catch (e) {
      print('Erreur envoi notification test FCM: $e');
    }
  }

  /// S'abonner aux topics premium (pour utilisateurs payants)
  Future<void> subscribeToPremiumTopics() async {
    try {
      await subscribeToTopic(FCMTopics.premiumUsers);
      print('Abonné aux topics premium');
    } catch (e) {
      print('Erreur abonnement topics premium: $e');
    }
  }

  /// Se désabonner des topics premium
  Future<void> unsubscribeFromPremiumTopics() async {
    try {
      await unsubscribeFromTopic(FCMTopics.premiumUsers);
      print('Désabonné des topics premium');
    } catch (e) {
      print('Erreur désabonnement topics premium: $e');
    }
  }

  /// S'abonner à une campagne saisonnière
  Future<void> subscribeToCampaign(String campaignTopic) async {
    try {
      await subscribeToTopic(campaignTopic);
      print('Abonné à la campagne: $campaignTopic');
    } catch (e) {
      print('Erreur abonnement campagne: $e');
    }
  }

  /// Se désabonner d'une campagne saisonnière
  Future<void> unsubscribeFromCampaign(String campaignTopic) async {
    try {
      await unsubscribeFromTopic(campaignTopic);
      print('Désabonné de la campagne: $campaignTopic');
    } catch (e) {
      print('Erreur désabonnement campagne: $e');
    }
  }
}