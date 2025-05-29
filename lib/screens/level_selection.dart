import 'package:flutter/material.dart';
import 'package:mathscool/screens/theme_selection.dart';
import 'package:mathscool/utils/colors.dart';

import '../widgets/theme_selection.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  final List<String> levels = const ['CI', 'CP', 'CE1', 'CE2', 'CM1', 'CM2'];
  final List<String> descriptions = const [
    'Pour les débutants',
    'Premiers calculs',
    'Bases de mathématiques',
    'Niveau intermédiaire',
    'Niveau avancé',
    'Expert'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec motif mathématique
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  Color.lerp(AppColors.primary, Colors.white, 0.3)!,
                  Color.lerp(AppColors.primary, Colors.white, 0.6)!,
                  Colors.white,
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),


          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: levels.length,
                      itemBuilder: (context, index) {
                        return _buildLevelCard(context, index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Choisis ton niveau',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Pour équilibrer l'en-tête
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, color: AppColors.accent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Choisis le niveau qui correspond à ta classe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, int index) {
    final List<Color> cardColors = [
      const Color(0xFFFFF3E0), // Amber very light
      const Color(0xFFE3F2FD), // Blue very light
      const Color(0xFFE8F5E9), // Green very light
      const Color(0xFFFCE4EC), // Pink very light
      const Color(0xFFEDE7F6), // Purple very light
      const Color(0xFFFFEBEE), // Red very light
    ];

    final List<Color> textColors = [
      Colors.amber[800]!,
      Colors.blue[800]!,
      Colors.green[800]!,
      Colors.pink[800]!,
      Colors.purple[800]!,
      Colors.red[800]!,
    ];

    final List<IconData> icons = [
      Icons.child_care,
      Icons.emoji_people,
      Icons.school,
      Icons.psychology,
      Icons.emoji_objects,
      Icons.workspace_premium,
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThemeSelectionScreen(level: levels[index]),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColors[index],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: textColors[index].withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: textColors[index].withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(icons[index], size: 50, color: textColors[index]),
            ),
            const SizedBox(height: 16),
            Text(
              levels[index],
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColors[index],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                descriptions[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textColors[index].withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}