import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final themeColors = _getBadgeThemeColors(theme);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Cercle externe du badge
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: obtained
                    ? RadialGradient(
                  colors: [themeColors['light']!, themeColors['dark']!],
                  center: Alignment.topLeft,
                  radius: 1.5,
                )
                    : null,
                color: obtained ? null : Colors.grey[300],
                boxShadow: obtained
                    ? [
                  BoxShadow(
                    color: themeColors['dark']!.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ]
                    : null,
              ),
            ),

            // Cercle interne avec l'icône
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: obtained ? Colors.white.withOpacity(0.85) : Colors.grey[200],
              ),
              child: Center(
                child: _getBadgeContent(theme),
              ),
            ),

            // Indicateur de progression pour les badges non obtenus
            if (progress > 0 && !obtained)
              Positioned(
                bottom: 5,
                child: Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(progress),
                      ),
                    ),
                  ),
                ),
              ),

            // Étoiles pour les badges obtenus
            if (obtained)
              ...List.generate(3, (index) {
                return Positioned(
                  top: index * 25.0,
                  right: index * 10.0 - 15.0,
                  child: Icon(
                    Icons.star,
                    size: 15,
                    color: Colors.yellow[700],
                  ),
                );
              }),

            // Badge de niveau
            if (level.isNotEmpty)
              Positioned(
                top: 0,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: obtained ? themeColors['dark'] : Colors.grey[400],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: obtained ? themeColors['light'] : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            theme,
            style: TextStyle(
              color: obtained ? themeColors['dark'] : Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Comic Sans MS',
            ),
          ),
        ),
        if (obtained)
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: themeColors['dark'],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _getBadgeContent(String theme) {
    // Utiliser des emojis ou des icônes selon votre préférence
    switch (theme.toLowerCase()) {
      case 'addition':
        return Text(
          '➕',
          style: TextStyle(
            fontSize: 28,
            color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
          ),
        );
      case 'soustraction':
        return Text(
          '➖',
          style: TextStyle(
            fontSize: 28,
            color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
          ),
        );
      case 'multiplication':
        return Text(
          '✖️',
          style: TextStyle(
            fontSize: 28,
            color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
          ),
        );
      case 'division':
        return Text(
          '➗',
          style: TextStyle(
            fontSize: 28,
            color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
          ),
        );
      case 'géométrie':
        return Text(
          '📐',
          style: TextStyle(
            fontSize: 28,
            color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
          ),
        );
      default:
        return Icon(
          Icons.star,
          size: 35,
          color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
        );
    }
  }

  Map<String, Color> _getBadgeThemeColors(String theme) {
    switch (theme.toLowerCase()) {
      case 'addition':
        return {'light': Colors.green[300]!, 'dark': Colors.green[700]!};
      case 'soustraction':
        return {'light': Colors.red[300]!, 'dark': Colors.red[700]!};
      case 'multiplication':
        return {'light': Colors.blue[300]!, 'dark': Colors.blue[700]!};
      case 'division':
        return {'light': Colors.orange[300]!, 'dark': Colors.orange[700]!};
      case 'géométrie':
        return {'light': Colors.purple[300]!, 'dark': Colors.purple[700]!};
      default:
        return {'light': Colors.teal[300]!, 'dark': Colors.teal[700]!};
    }
  }

  Color _getProgressColor(double value) {
    if (value < 0.4) return Colors.red[400]!;
    if (value < 0.7) return Colors.orange[400]!;
    return Colors.green[400]!;
  }
}