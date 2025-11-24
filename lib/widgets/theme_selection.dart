import 'package:flutter/material.dart';
import 'package:mathscool/screens/exercise_screen.dart';
import 'package:mathscool/utils/colors.dart';

class ThemeSelectionScreen extends StatelessWidget {
  final String level;

  const ThemeSelectionScreen({super.key, required this.level});

  // Détection si c'est le niveau collège
  bool get isCollege => ['6ème', '5ème', '4ème', '3ème'].contains(level);

  // Liste dynamique des thèmes
  List<Map<String, dynamic>> _getThemes() {
    if (isCollege) {
      // --- THÈMES COLLÈGE (6ème à 3ème) ---
      return const [
        {
          'name': 'Nombres Relatifs',
          'symbolText': '±', // Signes plus et moins
          'color': Colors.indigo
        },
        {
          'name': 'Fractions',
          'symbolText': '½',
          'color': Colors.teal
        },
        {
          'name': 'Algèbre',
          'symbolText': 'x=y', // Équations
          'color': Colors.deepOrange
        },
        {
          'name': 'Puissances',
          'symbolText': 'x²',
          'color': Colors.purpleAccent
        },
        {
          'name': 'Théorèmes', // Pythagore, Thalès
          'icon': Icons.change_history, // Triangle
          'color': Colors.brown
        },
        {
          'name': 'Statistiques',
          'icon': Icons.bar_chart,
          'color': Colors.blueGrey
        },
      ];
    } else {
      // --- THÈMES PRIMAIRE (CI à CM2) ---
      return const [
        {'name': 'Addition', 'icon': Icons.add, 'color': Colors.orange},
        {'name': 'Soustraction', 'icon': Icons.remove, 'color': Colors.blue},
        {'name': 'Multiplication', 'icon': Icons.close, 'color': Colors.green},
        {
          'name': 'Division',
          'symbolText': '÷',
          'color': Colors.purple
        },
        {'name': 'Géométrie', 'icon': Icons.square_foot, 'color': Colors.red},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentThemes = _getThemes(); // On récupère la bonne liste

    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.christ, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),

                // Illustration
                Center(
                  child: Container(
                    height: size.height * 0.20, // Légèrement réduit
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/maths.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Grille des thèmes
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1, // Cartes un peu moins hautes
                      ),
                      itemCount: currentThemes.length,
                      itemBuilder: (context, index) {
                        return _buildThemeCard(context, currentThemes[index]);
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
        color: AppColors.christ,
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
              'Thèmes : $level', // Titre simplifié
              style: const TextStyle(
                fontSize: 22,
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
    // Liste des thèmes désactivés pour le niveau CI (reste inchangé pour le primaire)
    final disabledThemesCI = ['Multiplication', 'Division', 'Géométrie'];

    // Vérifie si le thème est désactivé
    bool isDisabled = false;
    if (level == 'CI' && disabledThemesCI.contains(theme['name'])) {
      isDisabled = true;
    }

    return GestureDetector(
      onTap: isDisabled
          ? null
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
              ? Colors.grey[400]
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
            if (theme.containsKey('symbolText'))
              Text(
                theme['symbolText'],
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: isDisabled ? Colors.white54 : Colors.white,
                ),
              )
            else
              Icon(
                theme['icon'],
                size: 40,
                color: isDisabled ? Colors.white54 : Colors.white,
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                theme['name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDisabled ? Colors.white54 : Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}