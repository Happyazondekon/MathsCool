import 'package:flutter/material.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';

class ThemeBadge extends StatelessWidget {
  final String theme;
  final String level;
  final bool obtained;
  final double progress;

  const ThemeBadge({
    Key? key,
    required this.theme,
    required this.level,
    required this.obtained,
    required this.progress,
  }) : super(key: key);

  String getThemeDisplayName(BuildContext context, String theme) {
    final loc = AppLocalizations.of(context)!;
    switch (theme.toLowerCase()) {
      case 'addition': return loc.themeAddition;
      case 'soustraction': return loc.themeSubtraction;
      case 'multiplication': return loc.themeMultiplication;
      case 'division': return loc.themeDivision;
      case 'géométrie': return loc.themeGeometry;
      case 'nombres relatifs': return loc.themeRelativeNumbers;
      case 'fractions': return loc.themeFractions;
      case 'algèbre': return loc.themeAlgebra;
      case 'puissances': return loc.themePowers;
      case 'théorèmes': return loc.themeTheorems;
      case 'statistiques': return loc.themeStatistics;
      default: return theme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = _getBadgeThemeColors(theme);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Cercle externe avec effet glow
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: obtained
                    ? RadialGradient(
                  colors: [
                    themeColors['light']!,
                    themeColors['medium']!,
                    themeColors['dark']!,
                  ],
                  center: Alignment.topLeft,
                  radius: 1.2,
                )
                    : null,
                color: obtained ? null : Colors.grey.shade300,
                boxShadow: obtained
                    ? [
                  BoxShadow(
                    color: themeColors['dark']!.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),

            // Cercle interne blanc
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: obtained ? Colors.white : Colors.grey.shade200,
                border: Border.all(
                  color: obtained ? themeColors['medium']! : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Center(
                child: _getBadgeContent(theme),
              ),
            ),

            // Barre de progression circulaire pour badges non obtenus
            if (!obtained && progress > 0)
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(progress),
                  ),
                ),
              ),

            // Étoiles pour badges obtenus (effet confetti)
            if (obtained) ...[
              Positioned(
                top: 5,
                right: 10,
                child: _buildStar(15),
              ),
              Positioned(
                top: 15,
                right: 2,
                child: _buildStar(12),
              ),
              Positioned(
                top: 25,
                left: 5,
                child: _buildStar(13),
              ),
            ],

            // Badge de niveau
            if (level.isNotEmpty)
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: obtained
                        ? LinearGradient(
                      colors: [themeColors['medium']!, themeColors['dark']!],
                    )
                        : null,
                    color: obtained ? null : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.themeBadgeLevel(level),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
              ),

            // Icône de verrouillage pour badges non obtenus sans progression
            if (!obtained && progress == 0)
              Positioned(
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Nom du thème
        Container(
          width: 85,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            gradient: obtained
                ? LinearGradient(
              colors: [
                themeColors['light']!.withOpacity(0.3),
                themeColors['medium']!.withOpacity(0.3),
              ],
            )
                : null,
            color: obtained ? null : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: obtained ? themeColors['medium']! : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            getThemeDisplayName(context, theme),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: obtained ? themeColors['dark'] : Colors.grey.shade600,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),

        // Pourcentage
        if (obtained)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [themeColors['medium']!, themeColors['dark']!],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: themeColors['dark']!.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
          )
        else if (progress > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getProgressColor(progress).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _getProgressColor(progress),
                width: 1,
              ),
            ),
            child: Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: _getProgressColor(progress),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicNeue',
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              AppLocalizations.of(context)!.themeBadgeLocked,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicNeue',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStar(double size) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value.clamp(0.0, 1.0),
          child: Icon(
            Icons.star_rounded,
            size: size,
            color: Colors.yellow.shade600,
            shadows: [
              Shadow(
                color: Colors.orange.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgeText(String text, {double fontSize = 26}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey.shade500,
        fontFamily: 'ComicNeue',
      ),
    );
  }

  Widget _getBadgeContent(String theme) {
    final iconColor = obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey.shade500;

    switch (theme.toLowerCase()) {
    // PRIMAIRE
      case 'addition':
        return _buildBadgeText('➕', fontSize: 32);
      case 'soustraction':
        return _buildBadgeText('➖', fontSize: 32);
      case 'multiplication':
        return _buildBadgeText('✖️', fontSize: 32);
      case 'division':
        return _buildBadgeText('➗', fontSize: 32);
      case 'géométrie':
        return _buildBadgeText('📐', fontSize: 32);

    // COLLÈGE
      case 'nombres relatifs':
        return _buildBadgeText('±', fontSize: 30);
      case 'fractions':
        return _buildBadgeText('½', fontSize: 30);
      case 'algèbre':
        return _buildBadgeText('x=y', fontSize: 20);
      case 'puissances':
        return _buildBadgeText('x²', fontSize: 26);
      case 'théorèmes':
        return Icon(
          Icons.change_history,
          size: 34,
          color: iconColor,
        );
      case 'statistiques':
        return Icon(
          Icons.bar_chart_rounded,
          size: 34,
          color: iconColor,
        );

      default:
        return Icon(
          Icons.star_rounded,
          size: 38,
          color: iconColor,
        );
    }
  }

  Map<String, Color> _getBadgeThemeColors(String theme) {
    switch (theme.toLowerCase()) {
    // PRIMAIRE
      case 'addition':
        return {
          'light': Colors.green.shade200,
          'medium': Colors.green.shade400,
          'dark': Colors.green.shade700,
        };
      case 'soustraction':
        return {
          'light': Colors.red.shade200,
          'medium': Colors.red.shade400,
          'dark': Colors.red.shade700,
        };
      case 'multiplication':
        return {
          'light': Colors.blue.shade200,
          'medium': Colors.blue.shade400,
          'dark': Colors.blue.shade700,
        };
      case 'division':
        return {
          'light': Colors.orange.shade200,
          'medium': Colors.orange.shade400,
          'dark': Colors.orange.shade700,
        };
      case 'géométrie':
        return {
          'light': Colors.purple.shade200,
          'medium': Colors.purple.shade400,
          'dark': Colors.purple.shade700,
        };

    // COLLÈGE
      case 'nombres relatifs':
        return {
          'light': Colors.indigo.shade200,
          'medium': Colors.indigo.shade500,
          'dark': Colors.indigo.shade800,
        };
      case 'fractions':
        return {
          'light': Colors.teal.shade200,
          'medium': Colors.teal.shade400,
          'dark': Colors.teal.shade800,
        };
      case 'algèbre':
        return {
          'light': Colors.deepOrange.shade200,
          'medium': Colors.deepOrange.shade400,
          'dark': Colors.deepOrange.shade800,
        };
      case 'puissances':
        return {
          'light': Colors.purpleAccent.shade100,
          'medium': Colors.purple.shade400,
          'dark': Colors.purple.shade800,
        };
      case 'théorèmes':
        return {
          'light': Colors.brown.shade200,
          'medium': Colors.brown.shade400,
          'dark': Colors.brown.shade700,
        };
      case 'statistiques':
        return {
          'light': Colors.blueGrey.shade200,
          'medium': Colors.blueGrey.shade400,
          'dark': Colors.blueGrey.shade700,
        };

      default:
        return {
          'light': Colors.teal.shade200,
          'medium': Colors.teal.shade400,
          'dark': Colors.teal.shade700,
        };
    }
  }

  Color _getProgressColor(double value) {
    if (value < 0.4) return Colors.red.shade500;
    if (value < 0.7) return Colors.orange.shade500;
    return Colors.green.shade500;
  }
}