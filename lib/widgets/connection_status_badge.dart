import 'package:flutter/material.dart';

/// Widget badge pour afficher le statut de connexion et le mode
class ConnectionStatusBadge extends StatefulWidget {
  final String status;
  final bool isInfiniteMode;

  const ConnectionStatusBadge({
    super.key,
    required this.status,
    this.isInfiniteMode = false,
  });

  @override
  State<ConnectionStatusBadge> createState() => _ConnectionStatusBadgeState();
}

class _ConnectionStatusBadgeState extends State<ConnectionStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = widget.status.contains('📴') || widget.status.contains('⚠️');
    final isInfinite = widget.isInfiniteMode || widget.status.contains('♾️');

    Color backgroundColor;
    Color textColor;

    if (isInfinite) {
      backgroundColor = Colors.purple.withOpacity(0.9);
      textColor = Colors.white;
    } else if (isOffline) {
      backgroundColor = Colors.orange.withOpacity(0.85);
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.green.withOpacity(0.85);
      textColor = Colors.white;
    }

    return ScaleTransition(
      scale: isInfinite ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isInfinite)
              const Icon(Icons.all_inclusive, color: Colors.white, size: 14),
            if (!isInfinite && !isOffline)
              const Icon(Icons.cloud_done, color: Colors.white, size: 14),
            if (isOffline && !isInfinite)
              const Icon(Icons.cloud_off, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              widget.status,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicNeue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}