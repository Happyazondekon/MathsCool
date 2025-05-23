import 'package:flutter/material.dart';
import 'package:mathscool/services/notification_service.dart';
import 'package:mathscool/utils/colors.dart';

class NotificationBadge extends StatefulWidget {
  final String userName;
  final VoidCallback? onTap;

  const NotificationBadge({
    super.key,
    required this.userName,
    this.onTap,
  });

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge>
    with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = true;
  int _pendingNotificationsCount = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Configuration des animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Démarrer l'animation
    _animationController.repeat(reverse: true);

    // Charger l'état des notifications
    _loadNotificationStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadNotificationStatus() async {
    try {
      final enabled = await _notificationService.areNotificationsEnabled();
      final pending = await _notificationService.getPendingNotifications();

      if (mounted) {
        setState(() {
          _notificationsEnabled = enabled;
          _pendingNotificationsCount = pending.length;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement du statut des notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _notificationsEnabled ? _scaleAnimation.value : 1.0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _notificationsEnabled
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Icône principale
                  Icon(
                    _notificationsEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: _notificationsEnabled ? Colors.white : Colors.grey[400],
                    size: 20,
                  ),

                  // Badge avec le nombre de notifications
                  if (_notificationsEnabled && _pendingNotificationsCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            _pendingNotificationsCount > 9
                                ? '9+'
                                : _pendingNotificationsCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ComicNeue',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                  // Indicateur d'état (point coloré)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _notificationsEnabled
                            ? Colors.green
                            : Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget pour afficher un aperçu rapide des notifications
class NotificationPreview extends StatelessWidget {
  final String userName;
  final bool isEnabled;
  final int pendingCount;

  const NotificationPreview({
    super.key,
    required this.userName,
    required this.isEnabled,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: isEnabled ? AppColors.primary : Colors.grey,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnabled ? 'Notifications activées' : 'Notifications désactivées',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                if (isEnabled) ...[
                  Text(
                    pendingCount > 0
                        ? '$pendingCount notification(s) programmée(s)'
                        : 'Aucune notification programmée',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ] else ...[
                  Text(
                    'Activez pour recevoir des rappels',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Statut
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isEnabled ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}