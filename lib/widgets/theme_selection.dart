import 'package:flutter/material.dart';
import 'package:mathscool/screens/exercise_screen.dart';
import 'package:mathscool/utils/colors.dart';

class ThemeSelectionScreen extends StatelessWidget {
  final String level;
  final List<Map<String, dynamic>> themes = const [
    {'name': 'Addition', 'icon': Icons.add, 'color': Colors.orange},
    {'name': 'Soustraction', 'icon': Icons.remove, 'color': Colors.blue},
    {'name': 'Multiplication', 'icon': Icons.close, 'color': Colors.green},
    {'name': 'Division', 'icon': Icons.percent, 'color': Colors.purple},
    {'name': 'Géométrie', 'icon': Icons.square_foot, 'color': Colors.red},
  ];

  const ThemeSelectionScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),

                // Illustration globale bien visible
                Center(
                  child: Container(
                    height: size.height * 0.25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/maths.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Grille des thèmes
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: themes.length,
                      itemBuilder: (context, index) {
                        return _buildThemeCard(context, themes[index]);
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
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Choisissez un thème pour $level',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, Map<String, dynamic> theme) {
    // Liste des thèmes désactivés pour le niveau CI
    final disabledThemes = ['Multiplication', 'Division', 'Géométrie'];

    // Vérifie si le thème est désactivé pour le niveau CI
    final isDisabled = level == 'CI' && disabledThemes.contains(theme['name']);

    return GestureDetector(
      onTap: isDisabled
          ? null // Désactiver l'interaction si le thème est désactivé
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseScreen(
              level: level,
              theme: theme['name'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey[400] // Couleur grisée pour les thèmes désactivés
              : theme['color'].withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme['color'].withOpacity(isDisabled ? 0.3 : 0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              theme['icon'],
              size: 50,
              color: isDisabled ? Colors.white54 : Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              theme['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDisabled ? Colors.white54 : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}