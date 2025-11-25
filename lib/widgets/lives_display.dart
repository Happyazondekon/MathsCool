import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lives_model.dart';
import '../services/lives_service.dart';
import '../screens/store_screen.dart';

class LivesDisplay extends StatefulWidget {
  final bool showTimer;
  final VoidCallback? onTap;

  const LivesDisplay({
    Key? key,
    this.showTimer = true,
    this.onTap,
  }) : super(key: key);

  @override
  State<LivesDisplay> createState() => _LivesDisplayState();
}

class _LivesDisplayState extends State<LivesDisplay> {
  @override
  Widget build(BuildContext context) {
    final livesService = Provider.of<LivesService>(context);
    final livesData = livesService.livesData;

    if (livesData == null) {
      return const SizedBox.shrink();
    }

    final availableLives = livesData.availableLives;
    final maxLives = LivesData.MAX_LIVES;

    return GestureDetector(
      onTap: widget.onTap ?? () {
        // Ouvrir la boutique par défaut
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StoreScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade400,
              Colors.pink.shade400,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône cœur
            Icon(
              availableLives > 0 ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 6),

            // Nombre de vies
            Text(
              '$availableLives/$maxLives',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'ComicNeue',
              ),
            ),

            // Timer de régénération
            if (widget.showTimer && availableLives < maxLives) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        return Text(
                          livesService.getFormattedTimeUntilNextLife(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],

            // Icône "+"
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.red.shade400,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}