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
  List<Map<String, String>> _customNotifications = [];
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de formulaire
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isRepeating = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
    _loadCustomNotifications();
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadNotificationSettings() async {
    final enabled = await _notificationService.areNotificationsEnabled();
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _loadCustomNotifications() async {
    final notifications = await _notificationService.getCustomNotifications();
    setState(() {
      _customNotifications = notifications;
    });
  }

  void _showAddNotificationDialog() {
    // Créer une copie locale de _isRepeating pour le dialogue
    bool dialogIsRepeating = _isRepeating;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // Utiliser StatefulBuilder
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Programmer une notification',
            style: TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hourController,
                          decoration: const InputDecoration(
                            labelText: 'Heure (0-23)',
                            hintText: '14',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Obligatoire';
                            }
                            final hour = int.tryParse(value);
                            if (hour == null || hour < 0 || hour > 23) {
                              return 'Heure invalide';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _minuteController,
                          decoration: const InputDecoration(
                            labelText: 'Minute (0-59)',
                            hintText: '30',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Obligatoire';
                            }
                            final minute = int.tryParse(value);
                            if (minute == null || minute < 0 || minute > 59) {
                              return 'Minute invalide';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(
                      'Répéter chaque jour',
                      style: TextStyle(fontFamily: 'ComicNeue'),
                    ),
                    value: dialogIsRepeating,
                    onChanged: (value) {
                      setDialogState(() { // Utiliser setDialogState au lieu de setState
                        dialogIsRepeating = value;
                      });
                      setState(() {
                        _isRepeating = value; // Mettre à jour aussi la variable de classe
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _isRepeating = dialogIsRepeating; // S'assurer que la valeur est mise à jour
                _addCustomNotification();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Programmer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCustomNotification() async {
    if (_formKey.currentState!.validate()) {
      final hour = int.parse(_hourController.text);
      final minute = int.parse(_minuteController.text);
      final message = _messageController.text.isEmpty ? null : _messageController.text;

      // Générer un ID unique basé sur l'heure et la minute
      final id = hour * 100 + minute;

      await _notificationService.scheduleCustomNotification(
        userName: widget.userName,
        hour: hour,
        minute: minute,
        id: id,
        isRepeating: _isRepeating,
        customMessage: message,
      );

      // Réinitialiser les champs
      _hourController.clear();
      _minuteController.clear();
      _messageController.clear();

      // Fermer le dialogue
      if (mounted) Navigator.pop(context);

      // Rafraîchir la liste
      await _loadCustomNotifications();

      // Afficher une confirmation
      _showSnackBar('Notification programmée pour ${hour}h${minute.toString().padLeft(2, '0')} ! ⏰', Colors.green);
    }
  }

  Future<void> _removeCustomNotification(String id) async {
    await _notificationService.removeCustomNotification(int.parse(id));
    await _loadCustomNotifications();
    _showSnackBar('Notification supprimée', Colors.orange);
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNotificationDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
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
            _buildSettingsCard(),
            const SizedBox(height: 16),
            if (_customNotifications.isNotEmpty) _buildCustomNotificationsCard(),
            const SizedBox(height: 16),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Activer les notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    await _notificationService.setNotificationsEnabled(value);
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    _showSnackBar(
                      value ? 'Notifications activées ! 📱' : 'Notifications désactivées',
                      value ? Colors.green : Colors.orange,
                    );
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNotificationsCard() {
    return Card(
      elevation: 4,
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
                  'Sessions programmées',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._customNotifications.map((notification) {
              final hour = int.parse(notification['hour']!);
              final minute = int.parse(notification['minute']!);
              final isRepeating = notification['isRepeating'] == 'true';
              final message = notification['message'];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(
                    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontFamily: 'ComicNeue',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRepeating ? 'Se répète chaque jour' : 'Une seule fois',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      if (message != null)
                        Text(
                          message,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _removeCustomNotification(notification['id']!),
                  ),
                ),
              );
            }).toList(),
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
                  'Astuce',
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
              'Programmez vos sessions d\'apprentissage aux heures qui vous conviennent le mieux ! '
                  'Vous pouvez créer autant de rappels que vous le souhaitez.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'ComicNeue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}