import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notification_scheduler.dart';
import 'package:mathscool/utils/colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _notificationsEnabled = true;
  int _morningHour = 9;
  int _eveningHour = 19;
  Map<String, dynamic>? _notificationStats;
  late NotificationScheduler _scheduler;

  @override
  void initState() {
    super.initState();
    _scheduler = Provider.of<NotificationScheduler>(context, listen: false);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final enabled = await _scheduler.areNotificationsEnabled();
      final timeSlots = await _scheduler.getPreferredTimeSlots();
      final stats = await _scheduler.getNotificationStats();

      setState(() {
        _notificationsEnabled = enabled;
        _morningHour = timeSlots['morning'] ?? 9;
        _eveningHour = timeSlots['evening'] ?? 19;
        _notificationStats = stats;
      });
    } catch (e) {
      print('Erreur lors du chargement des paramètres: $e');
    }
  }

  Future<void> _updateNotificationSettings() async {
    try {
      await _scheduler.setNotificationsEnabled(_notificationsEnabled);
      if (_notificationsEnabled) {
        await _scheduler.setPreferredTimeSlots(
          morningHour: _morningHour,
          eveningHour: _eveningHour,
        );
      }
      _showSuccessMessage('Paramètres mis à jour avec succès! 🎉');
      _loadSettings(); // Recharger les statistiques
    } catch (e) {
      _showErrorMessage('Erreur lors de la mise à jour: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.secondary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildWelcomeCard(),
                      const SizedBox(height: 20),
                      _buildNotificationToggleCard(),
                      const SizedBox(height: 20),
                      if (_notificationsEnabled) ...[
                        _buildTimeSettingsCard(),
                        const SizedBox(height: 20),
                        if (_notificationStats != null)
                          _buildStatsCard(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Text(
            'Rappels',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 48), // Pour équilibrer avec le bouton retour
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.notifications_active,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Restez motivé(e) avec MathsCool!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Configurez vos rappels pour ne jamais manquer une session de maths',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggleCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SwitchListTile(
        title: const Text(
          'Activer les notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Recevez des rappels motivants pour faire des maths'),
        value: _notificationsEnabled,
        activeColor: AppColors.secondary,
        onChanged: (value) {
          setState(() {
            _notificationsEnabled = value;
          });
          _updateNotificationSettings();
        },
        secondary: Icon(
          _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
          color: _notificationsEnabled ? AppColors.secondary : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTimeSettingsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horaires préférés',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Heure du matin
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.orange),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Notification du matin',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      value: _morningHour,
                      dropdownColor: Color(0xFF34A853),
                      underline: Container(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      items: List.generate(24, (index) => index)
                          .map((hour) => DropdownMenuItem(
                        value: hour,
                        child: Text('${hour.toString().padLeft(2, '0')}:00'),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _morningHour = value;
                          });
                          _updateNotificationSettings();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Heure du soir
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.brightness_3, color: Colors.indigo),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Notification du soir',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      value: _eveningHour,
                      dropdownColor: Color(0xFF34A853),
                      underline: Container(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      items: List.generate(24, (index) => index)
                          .map((hour) => DropdownMenuItem(
                        value: hour,
                        child: Text('${hour.toString().padLeft(2, '0')}:00'),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _eveningHour = value;
                          });
                          _updateNotificationSettings();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Notifications programmées: ${_notificationStats!['pending_count']}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _notificationStats!['is_enabled']
                    ? AppColors.secondary.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _notificationStats!['is_enabled'] ? Icons.check_circle : Icons.cancel,
                    color: _notificationStats!['is_enabled'] ? AppColors.secondary : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Statut: ${_notificationStats!['is_enabled'] ? 'Activées' : 'Désactivées'}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}