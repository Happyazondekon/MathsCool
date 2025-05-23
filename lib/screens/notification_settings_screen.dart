import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mathscool/services/notification_service.dart';
import 'package:mathscool/utils/colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final String userName;

  const NotificationSettingsScreen({
    super.key,
    required this.userName,
  });

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = true;
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
    _loadPendingNotifications();
  }

  Future<void> _loadNotificationSettings() async {
    final enabled = await _notificationService.areNotificationsEnabled();
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _loadPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    setState(() {
      _pendingNotifications = pending;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });

    await _notificationService.setNotificationsEnabled(value);

    if (value) {
      // Programmer les notifications
      await _notificationService.scheduleRecurringNotifications(widget.userName);
      _showSnackBar('Notifications activées ! 📱', Colors.green);
    } else {
      _showSnackBar('Notifications désactivées', Colors.orange);
    }

    // Recharger les notifications en attente
    await _loadPendingNotifications();
  }

  Future<void> _testNotification() async {
    await _notificationService.showImmediateNotification(widget.userName);
    _showSnackBar('Notification de test envoyée ! 🔔', Colors.blue);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section principale
            _buildSettingsCard(
              title: 'Rappels quotidiens',
              subtitle: 'Recevoir des rappels pour jouer',
              icon: Icons.notifications_active,
              child: Switch.adaptive(
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                activeColor: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            // Section informations
            _buildInfoCard(),

            const SizedBox(height: 16),

            // Section test
            _buildTestCard(),

            const SizedBox(height: 16),

            // Section notifications programmées
            if (_pendingNotifications.isNotEmpty) _buildPendingNotificationsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Comment ça marche ?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem('🌅', 'Rappel du matin à 9h00'),
            _buildInfoItem('🌙', 'Rappel du soir à 21h00'),
            _buildInfoItem('🎯', 'Messages motivants personnalisés'),
            _buildInfoItem('🔔', 'Notifications adaptées aux enfants'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'ComicNeue',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.bug_report,
                  color: AppColors.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Test des notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Teste une notification pour voir à quoi elle ressemble',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'ComicNeue',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _testNotification,
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text(
                'Envoyer un test',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingNotificationsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Notifications programmées',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${_pendingNotifications.length} notification(s) en attente',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'ComicNeue',
              ),
            ),
            const SizedBox(height: 8),
            ...(_pendingNotifications.take(3).map((notification) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.notifications, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notification.title ?? 'Notification MathsCool',
                      style: const TextStyle(fontSize: 12, fontFamily: 'ComicNeue'),
                    ),
                  ),
                ],
              ),
            ))),
          ],
        ),
      ),
    );
  }
}
