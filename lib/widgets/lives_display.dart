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
    // On écoute le service pour les mises à jour en temps réel
    final livesService = Provider.of<LivesService>(context);
    final livesData = livesService.livesData;

    if (livesData == null) {
      return const SizedBox.shrink();
    }

    final availableLives = livesData.availableLives;
    final maxLives = LivesData.MAX_LIVES;

    // Vérifier si le mode illimité est actif
    final bool isUnlimited = livesData.isUnlimited;

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
          // Changement de couleur si illimité (Violet vs Rouge)
          gradient: LinearGradient(
            colors: isUnlimited
                ? [Colors.purple.shade400, Colors.deepPurple.shade400]
                : [Colors.red.shade400, Colors.pink.shade400],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isUnlimited ? Colors.purple : Colors.red).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône cœur (ou infini si tu préfères, mais le cœur reste sympa)
            Icon(
              isUnlimited
                  ? Icons.all_inclusive
                  : (availableLives > 0 ? Icons.favorite : Icons.favorite_border),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 6),

            // Nombre de vies ou Symbole Infini
            Text(
              isUnlimited ? '∞' : '$availableLives/$maxLives',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isUnlimited ? 20 : 16, // Plus gros pour l'infini
                fontFamily: 'ComicNeue',
              ),
            ),

            // Timer de régénération
            // On ne l'affiche que si :
            // 1. On a demandé à l'afficher (widget.showTimer)
            // 2. Ce n'est PAS illimité (!isUnlimited)
            // 3. Les vies ne sont pas pleines (availableLives < maxLives)
            if (widget.showTimer && !isUnlimited && availableLives < maxLives) ...[
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

            // Icône "+" (Petit bouton d'ajout)
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                // Couleur de l'icône + adaptée au fond
                color: isUnlimited ? Colors.purple.shade400 : Colors.red.shade400,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}