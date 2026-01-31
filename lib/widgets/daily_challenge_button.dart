// lib/widgets/daily_challenge_button.dart
import 'package:flutter/material.dart';
import '../screens/daily_challenge_screen.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';

class DailyChallengeButton extends StatefulWidget {
  const DailyChallengeButton({Key? key}) : super(key: key);

  @override
  State<DailyChallengeButton> createState() => _DailyChallengeButtonState();
}

class _DailyChallengeButtonState extends State<DailyChallengeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
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
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DailyChallengeScreen(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30), // Augmenté la marge pour qu'il soit moins large
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Réduit le padding (était à 20)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade400,
                Colors.deepOrange.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(20), // Un peu moins arrondi pour la nouvelle taille
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none, // Pour que le badge "NOUVEAU" ne soit pas coupé
            children: [
              Row(
                children: [
                  // Icône réduite
                  Container(
                    padding: const EdgeInsets.all(10), // Réduit (était 14)
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 26, // Réduit (était 36)
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Texte réduit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dailyChallengeButtonTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                            SizedBox(width: 4),
                            Text('🎯', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Text(
                          AppLocalizations.of(context)!.dailyChallengeButtonSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 18, // Réduit (était 24)
                  ),
                ],
              ),

              // Badge NOUVEAU plus petit
              Positioned(
                top: -18,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.red, Colors.pink]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.dailyChallengeButtonNew,
                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}