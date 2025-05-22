import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'notification_messages.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(response);
      },
    );

    // Request permissions
    await _requestPermissions();
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API level 33+)
      await Permission.notification.request();
      
      // For exact alarms (Android 12+)
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } else if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  // Handle notification tap
  void _handleNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // You can navigate to specific screens or perform actions here
  }

  // Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'mathscool_channel',
      'MathsCool Notifications',
      channelDescription: 'Deviens un MathKid',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF34A853),
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'mathscool_scheduled_channel',
      'MathsCool Scheduled',
      channelDescription: 'Notifications programmées pour MathsCool',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2196F3),
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Schedule repeating notifications every 10-12 hours
  Future<void> scheduleRepeatingNotifications() async {
    // Cancel any existing notifications first
    await cancelAllNotifications();

    final now = DateTime.now();
    
    // Schedule morning notification (9 AM)
    DateTime morningTime = DateTime(now.year, now.month, now.day, 9, 0);
    if (morningTime.isBefore(now)) {
      morningTime = morningTime.add(const Duration(days: 1));
    }

    // Schedule evening notification (7 PM - 10 hours later)
    DateTime eveningTime = DateTime(now.year, now.month, now.day, 19, 0);
    if (eveningTime.isBefore(now)) {
      eveningTime = eveningTime.add(const Duration(days: 1));
    }

    // Schedule the first batch of notifications for the next 7 days
    for (int i = 0; i < 7; i++) {
      final morningDate = morningTime.add(Duration(days: i));
      final eveningDate = eveningTime.add(Duration(days: i));

      // Morning notification
      await scheduleNotification(
        id: 1000 + (i * 2), // Unique ID for morning notifications
        title: "MathsCool 🌟",
        body: NotificationMessages.getRandomMessage(),
        scheduledDate: morningDate,
        payload: 'morning_${i}',
      );

      // Evening notification
      await scheduleNotification(
        id: 1000 + (i * 2) + 1, // Unique ID for evening notifications
        title: "MathsCool 🌙",
        body: NotificationMessages.getSpecificMessage(MessageType.evening),
        scheduledDate: eveningDate,
        payload: 'evening_${i}',
      );
    }

    print('Notifications programmées pour les 7 prochains jours');
  }

  // Schedule random interval notifications (10-12 hours)
  Future<void> scheduleRandomIntervalNotifications() async {
    await cancelAllNotifications();

    final now = DateTime.now();
    DateTime nextNotification = now.add(const Duration(hours: 10));

    // Schedule notifications for the next 30 days with random intervals
    for (int i = 0; i < 60; i++) { // 60 notifications over 30 days (2 per day average)
      await scheduleNotification(
        id: 2000 + i,
        title: "MathsCool 🎯",
        body: NotificationMessages.getRandomMessage(),
        scheduledDate: nextNotification,
        payload: 'random_$i',
      );

      // Add random interval between 10-12 hours (600-720 minutes)
      final randomMinutes = 600 + (120 * (DateTime.now().millisecond % 100) / 100).round();
      nextNotification = nextNotification.add(Duration(minutes: randomMinutes));
    }

    print('Notifications aléatoires programmées pour les 30 prochains jours');
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      return await Permission.notification.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.notification.status;
      return status == PermissionStatus.granted;
    }
    return false;
  }

  // Show a test notification
  Future<void> showTestNotification() async {
    await showNotification(
      id: 999,
      title: "Test MathsCool! 🧪",
      body: NotificationMessages.getRandomMessage(),
      payload: 'test',
    );
  }
}