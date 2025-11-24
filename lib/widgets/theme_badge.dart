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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: obtained ? themeColors['dark'] : Colors.grey[700],
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Comic Sans MS',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

  // Helper pour créer le texte du badge afin d'éviter la répétition
  Widget _buildBadgeText(String text, {double fontSize = 26}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
      ),
    );
  }

  Widget _getBadgeContent(String theme) {
    switch (theme.toLowerCase()) {
    // --- PRIMAIRE ---
      case 'addition':
        return _buildBadgeText('➕', fontSize: 28);
      case 'soustraction':
        return _buildBadgeText('➖', fontSize: 28);
      case 'multiplication':
        return _buildBadgeText('✖️', fontSize: 28);
      case 'division':
        return _buildBadgeText('➗', fontSize: 28);
      case 'géométrie':
        return _buildBadgeText('📐', fontSize: 28);

    // --- COLLÈGE (Nouveaux) ---
      case 'nombres relatifs':
        return _buildBadgeText('±');
      case 'fractions':
        return _buildBadgeText('½');
      case 'algèbre':
        return _buildBadgeText('x=y', fontSize: 22);
      case 'puissances':
        return _buildBadgeText('x²');
      case 'théorèmes':
        return Icon(
          Icons.change_history,
          size: 30,
          color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
        );
      case 'statistiques':
        return Icon(
          Icons.bar_chart,
          size: 30,
          color: obtained ? _getBadgeThemeColors(theme)['dark'] : Colors.grey,
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
    // --- PRIMAIRE ---
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

    // --- COLLÈGE (Nouveaux) ---
      case 'nombres relatifs':
        return {'light': Colors.indigo[200]!, 'dark': Colors.indigo[800]!};
      case 'fractions':
        return {'light': Colors.teal[200]!, 'dark': Colors.teal[800]!};
      case 'algèbre':
        return {
          'light': Colors.deepOrange[200]!,
          'dark': Colors.deepOrange[800]!
        };
      case 'puissances':
        return {
          'light': Colors.purpleAccent[100]!,
          'dark': Colors.purple[800]!
        };
      case 'théorèmes':
        return {'light': Colors.brown[300]!, 'dark': Colors.brown[700]!};
      case 'statistiques':
        return {'light': Colors.blueGrey[200]!, 'dark': Colors.blueGrey[700]!};

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