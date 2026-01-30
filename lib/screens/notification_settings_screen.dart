import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mathscool/services/notification_service.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final String userName;

  const NotificationSettingsScreen({
    super.key,
    required this.userName,
  });

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with TickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = true;
  List<Map<String, String>> _customNotifications = [];
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isRepeating = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _loadNotificationSettings();
    _loadCustomNotifications();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  Future<void> _checkAndRequestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
      final result = await Permission.scheduleExactAlarm.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        _showSnackBar('Veuillez autoriser les alarmes exactes dans vos paramètres.', AppColors.error);
        openAppSettings();
      }
    }

    await _loadNotificationSettings();
  }

  void _showAddNotificationDialog() {
    bool dialogIsRepeating = _isRepeating;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background,
                  AppColors.surface,
                ],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.alarm_add,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Programmer une notification',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Heure de rappel',
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimeField(
                                    controller: _hourController,
                                    label: 'Heure',
                                    hint: '14',
                                    max: 23,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTimeField(
                                    controller: _minuteController,
                                    label: 'Minute',
                                    hint: '30',
                                    max: 59,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.repeat, color: AppColors.success, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Répéter chaque jour',
                                style: TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                            Switch.adaptive(
                              value: dialogIsRepeating,
                              onChanged: (value) {
                                setDialogState(() {
                                  dialogIsRepeating = value;
                                });
                                setState(() {
                                  _isRepeating = value;
                                });
                              },
                              activeColor: AppColors.success,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'ComicNeue',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          _isRepeating = dialogIsRepeating;
                          _addCustomNotification();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textLight,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.alarm_on, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Programmer',
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int max,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(12),
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Requis';
        }
        final number = int.tryParse(value);
        if (number == null || number < 0 || number > max) {
          return 'Invalide';
        }
        return null;
      },
    );
  }

  Future<void> _addCustomNotification() async {
    if (_formKey.currentState!.validate()) {
      final hour = int.parse(_hourController.text);
      final minute = int.parse(_minuteController.text);
      final message = _messageController.text.isEmpty ? null : _messageController.text;
      final id = hour * 100 + minute;

      await _notificationService.scheduleCustomNotification(
        userName: widget.userName,
        hour: hour,
        minute: minute,
        id: id,
        isRepeating: _isRepeating,
        customMessage: message,
      );

      _hourController.clear();
      _minuteController.clear();
      _messageController.clear();

      if (mounted) Navigator.pop(context);
      await _loadCustomNotifications();

      _showSnackBar('Notification programmée pour ${hour}h${minute.toString().padLeft(2, '0')} ! ⏰', AppColors.success);
    }
  }

  Future<void> _removeCustomNotification(String id) async {
    await _notificationService.removeCustomNotification(int.parse(id));
    await _loadCustomNotifications();
    _showSnackBar('Notification supprimée', AppColors.warning);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == AppColors.success ? Icons.check_circle : Icons.info,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Notifications',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNotificationDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        icon: const Icon(Icons.add_alarm),
        label: const Text(
          'Nouveau rappel',
          style: TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold),
        ),
        elevation: 8,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bgc_math.png'),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gradientStart.withOpacity(0.8),
                    AppColors.gradientMiddle.withOpacity(0.7),
                    AppColors.gradientEnd.withOpacity(0.6),
                    AppColors.background.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 16),
                  _buildMainToggleCard(),
                  const SizedBox(height: 20),
                  if (_customNotifications.isNotEmpty) ...[
                    _buildSectionTitle('Rappels programmés', Icons.schedule, '${_customNotifications.length}'),
                    const SizedBox(height: 12),
                    _buildNotificationsList(),
                    const SizedBox(height: 20),
                  ],
                  _buildStatsCard(),
                  const SizedBox(height: 16),
                  _buildTipsCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helloUser(widget.userName),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Configure tes rappels pour ne jamais oublier tes sessions de maths !',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'ComicNeue',
                    color: AppColors.textLight.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainToggleCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _notificationsEnabled
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.disabled.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                color: _notificationsEnabled ? AppColors.success : AppColors.disabled,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _notificationsEnabled ? 'Notifications activées' : 'Notifications désactivées',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _notificationsEnabled
                        ? 'Je recevrai des rappels'
                        : 'Aucun rappel ne sera envoyé',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'ComicNeue',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
                  value ? AppColors.success : AppColors.warning,
                );
              },
              activeColor: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, String? badge) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textLight, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
            color: AppColors.textLight,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'ComicNeue',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationsList() {
    return Column(
      children: _customNotifications.map((notification) {
        final hour = int.parse(notification['hour']!);
        final minute = int.parse(notification['minute']!);
        final isRepeating = notification['isRepeating'] == 'true';
        final message = notification['message'];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
                    Icons.access_time,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ComicNeue',
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isRepeating ? Icons.repeat : Icons.schedule,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isRepeating ? 'Quotidien' : 'Une fois',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontFamily: 'ComicNeue',
                            ),
                          ),
                        ],
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppColors.info,
                            fontFamily: 'ComicNeue',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: () => _removeCustomNotification(notification['id']!),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.info.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: AppColors.info, size: 24),
              const SizedBox(width: 8),
              Text(
                'Statistiques',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: AppColors.surface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Rappels actifs',
                  '${_customNotifications.length}',
                  Icons.alarm_on,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Quotidiens',
                  '${_customNotifications.where((n) => n['isRepeating'] == 'true').length}',
                  Icons.repeat,
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'ComicNeue',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFamily: 'ComicNeue',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.warning.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.yellowAccent, size: 24),
              const SizedBox(width: 8),
              Text(
                'Conseils pour bien utiliser tes rappels',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...const [
            '🕐 Programme tes sessions aux moments où tu es le plus concentré',
            '🔄 Active les rappels quotidiens pour créer une routine',
          ].map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'ComicNeue',
                color: AppColors.textSecondary,
              ),
            ),
          )),
        ],
      ),
    );
  }
}