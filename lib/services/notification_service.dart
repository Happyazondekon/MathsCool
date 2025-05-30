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

  // Messages motivationnels pour les enfants
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

  /// Initialisation du service de notifications
  Future<void> initialize() async {
    try {
      // Initialiser les fuseaux horaires
      tz.initializeTimeZones();

      // Debug des fuseaux horaires
      final String currentTimeZone = DateTime.now().timeZoneName;
      final String currentOffset = DateTime.now().timeZoneOffset.toString();
      print('Fuseau horaire de l\'appareil: $currentTimeZone');
      print('Offset système: $currentOffset');
      print('Fuseau timezone package: ${tz.local}');

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
      // Permission pour les notifications
      final notificationStatus = await Permission.notification.request();

      if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
        print("Permission pour les notifications refusée.");
        return false;
      }

      // Permission spécifique Android 12+ pour les alarmes exactes
      if (await Permission.scheduleExactAlarm.isDenied) {
        final result = await Permission.scheduleExactAlarm.request();

        if (result.isDenied || result.isPermanentlyDenied) {
          print("Permission pour les alarmes exactes refusée.");
          // Optionnel: rediriger vers les paramètres
          // await openAppSettings();
          return false;
        }
      }

      print("Toutes les permissions nécessaires sont accordées.");
      return true;
    } catch (e) {
      print('Erreur lors de la demande de permissions: $e');
      return false;
    }
  }

  /// Gérer le tap sur la notification
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print('Notification tapped: ${notificationResponse.payload}');
    // Ici vous pouvez ajouter la logique de navigation
    // Par exemple: naviguer vers une page spécifique de l'app
  }

  /// Obtenir le fuseau horaire correct de l'appareil
  tz.Location _getDeviceTimeZone() {
    try {
      // Récupérer l'offset système actuel
      final now = DateTime.now();
      final offset = now.timeZoneOffset;

      // Si l'offset correspond à tz.local, l'utiliser
      final localNow = tz.TZDateTime.now(tz.local);
      if (localNow.timeZoneOffset == offset) {
        return tz.local;
      }

      // Sinon, essayer de trouver un fuseau correspondant
      final offsetHours = offset.inHours;
      final offsetMinutes = offset.inMinutes % 60;

      // Chercher un fuseau avec le même offset
      for (final location in tz.timeZoneDatabase.locations.values) {
        final locationTime = tz.TZDateTime.now(location);
        if (locationTime.timeZoneOffset == offset) {
          print('Fuseau trouvé: ${location.name}');
          return location;
        }
      }

      // Fallback: utiliser tz.local
      print('Utilisation du fuseau par défaut: ${tz.local}');
      return tz.local;

    } catch (e) {
      print('Erreur lors de la détection du fuseau horaire: $e');
      return tz.local;
    }
  }

  /// Programmer une notification personnalisée
  Future<bool> scheduleCustomNotification({
    required String userName,
    required int hour,
    required int minute,
    required int id,
    required bool isRepeating,
    String? customMessage,
  }) async {
    try {
      // Vérifier si les notifications sont activées
      if (!await areNotificationsEnabled()) {
        print('Notifications désactivées');
        return false;
      }

      // Vérifier les permissions
      if (!await _hasRequiredPermissions()) {
        print('Permissions insuffisantes');
        return false;
      }

      // SOLUTION CORRIGÉE: Utiliser l'heure système puis convertir
      final now = DateTime.now(); // Heure système locale de l'appareil
      var scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // Si l'heure est déjà passée aujourd'hui, programmer pour demain
      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      // Convertir en TZDateTime en utilisant le fuseau de l'appareil
      final deviceTimeZone = _getDeviceTimeZone();
      final scheduledDate = tz.TZDateTime.from(scheduledDateTime, deviceTimeZone);

      final message = customMessage ?? _getRandomMotivationalMessage();

      // Configuration des détails de notification
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
        channelShowBadge: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        sound: 'default',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Programmer la notification
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

      // Debug: Afficher les informations pour vérification
      print('═══ NOTIFICATION PROGRAMMÉE ═══');
      print('Heure système: ${DateTime.now()}');
      print('Heure programmée (système): $scheduledDateTime');
      print('Heure programmée (TZ): $scheduledDate');
      print('Fuseau utilisé: ${deviceTimeZone.name}');
      print('ID: $id, Répétitive: $isRepeating');
      print('Message: $message');
      print('═══════════════════════════════');

      return true;

    } catch (e) {
      print('Erreur lors de la programmation de la notification: $e');
      return false;
    }
  }

  /// Vérifier si les permissions requises sont accordées
  Future<bool> _hasRequiredPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;

    return notificationStatus.isGranted &&
        (exactAlarmStatus.isGranted);
  }

  /// Sauvegarder une notification personnalisée
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
      print('Notification sauvegardée: ID $id à ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
    } catch (e) {
      print('Erreur lors de la sauvegarde: $e');
    }
  }

  /// Encoder les données de notification
  String _encodeNotification(Map<String, String> data) {
    return data.entries.map((e) => '${e.key}:${e.value.replaceAll(':', '|')}').join(',');
  }

  /// Décoder les données de notification
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
      print('Erreur lors du décodage: $e');
      return {};
    }
  }

  /// Obtenir toutes les notifications personnalisées
  Future<List<Map<String, String>>> getCustomNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_customNotificationsKey) ?? [];
      return encoded.map((e) => _decodeNotification(e)).where((map) => map.isNotEmpty).toList();
    } catch (e) {
      print('Erreur lors de la récupération des notifications: $e');
      return [];
    }
  }

  /// Supprimer une notification personnalisée
  Future<bool> removeCustomNotification(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList(_customNotificationsKey) ?? [];

      final initialLength = notifications.length;
      notifications.removeWhere((encoded) {
        final data = _decodeNotification(encoded);
        return data['id'] == id.toString();
      });

      await prefs.setStringList(_customNotificationsKey, notifications);
      await _flutterLocalNotificationsPlugin.cancel(id);

      final removed = initialLength > notifications.length;
      print('Notification ID $id ${removed ? 'supprimée' : 'non trouvée'}');
      return removed;
    } catch (e) {
      print('Erreur lors de la suppression: $e');
      return false;
    }
  }

  /// Restaurer toutes les notifications personnalisées (à appeler au démarrage)
  Future<int> restoreCustomNotifications(String userName) async {
    try {
      final notifications = await getCustomNotifications();
      int restoredCount = 0;

      print('Restauration de ${notifications.length} notifications...');

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
          print('Erreur lors de la restauration de la notification ${notification['id']}: $e');
        }
      }

      print('$restoredCount notifications restaurées sur ${notifications.length}');
      return restoredCount;
    } catch (e) {
      print('Erreur lors de la restauration: $e');
      return 0;
    }
  }

  /// Obtenir un message motivationnel aléatoire
  String _getRandomMotivationalMessage() {
    final random = Random();
    return _motivationalMessages[random.nextInt(_motivationalMessages.length)];
  }

  /// Activer/Désactiver les notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationEnabledKey, enabled);

      if (!enabled) {
        await cancelAllNotifications();
        print('Toutes les notifications ont été désactivées et annulées');
      } else {
        print('Notifications activées');
      }
    } catch (e) {
      print('Erreur lors du changement d\'état des notifications: $e');
    }
  }

  /// Vérifier si les notifications sont activées
  Future<bool> areNotificationsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationEnabledKey) ?? true;
    } catch (e) {
      print('Erreur lors de la vérification de l\'état: $e');
      return true; // Par défaut activé
    }
  }

  /// Annuler toutes les notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print('Toutes les notifications ont été annulées');
    } catch (e) {
      print('Erreur lors de l\'annulation: $e');
    }
  }

  /// Annuler une notification spécifique
  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      print('Notification ID $id annulée');
    } catch (e) {
      print('Erreur lors de l\'annulation de la notification $id: $e');
    }
  }

  /// Obtenir les notifications en attente
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print('${pending.length} notifications en attente');
      return pending;
    } catch (e) {
      print('Erreur lors de la récupération des notifications en attente: $e');
      return [];
    }
  }

  /// Enregistrer le timestamp de la dernière notification
  Future<void> _saveLastNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastNotificationKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Erreur lors de la sauvegarde du timestamp: $e');
    }
  }

  /// Obtenir le timestamp de la dernière notification
  Future<DateTime?> getLastNotificationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastNotificationKey);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      print('Erreur lors de la récupération du timestamp: $e');
      return null;
    }
  }

  /// Vérifier si il faut envoyer une notification maintenant
  Future<bool> shouldSendNotificationNow() async {
    try {
      final lastTime = await getLastNotificationTime();
      if (lastTime == null) return true;

      final now = DateTime.now();
      final difference = now.difference(lastTime);
      return difference.inHours >= 12;
    } catch (e) {
      print('Erreur lors de la vérification: $e');
      return true;
    }
  }

  /// Envoyer une notification immédiate
  Future<bool> sendImmediateNotification({
    required String userName,
    required String title,
    required String message,
    int? id,
  }) async {
    try {
      if (!await areNotificationsEnabled()) {
        return false;
      }

      final notificationId = id ?? Random().nextInt(10000);

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'mathscool_immediate',
        'Notifications immédiates',
        channelDescription: 'Notifications envoyées immédiatement',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'baseline_calculate_white_36',
        color: Color(0xFF34A853),
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

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        message,
        platformDetails,
        payload: 'mathscool_immediate',
      );

      await _saveLastNotificationTime();
      print('Notification immédiate envoyée: $title');
      return true;

    } catch (e) {
      print('Erreur lors de l\'envoi de la notification immédiate: $e');
      return false;
    }
  }

  /// Obtenir des statistiques sur les notifications
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
      print('Erreur lors de la récupération des statistiques: $e');
      return {};
    }
  }

  /// Nettoyer les anciennes notifications (utilitaire de maintenance)
  Future<int> cleanupOldNotifications() async {
    try {
      final notifications = await getCustomNotifications();
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
            // Si on ne peut pas parser le timestamp, supprimer la notification
            cleanedCount++;
            return true;
          }
        }
        return false;
      });

      await prefs.setStringList(_customNotificationsKey, customNotifications);
      print('$cleanedCount anciennes notifications nettoyées');
      return cleanedCount;

    } catch (e) {
      print('Erreur lors du nettoyage: $e');
      return 0;
    }
  }
}