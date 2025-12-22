import 'package:flutter/material.dart';
import 'package:mathscool/screens/exercise_screen.dart';
import 'package:mathscool/utils/colors.dart';

import '../services/sound_service.dart';

class ThemeSelectionScreen extends StatelessWidget {
  final String level;

  const ThemeSelectionScreen({super.key, required this.level});

  bool get isCollege => ['6ème', '5ème', '4ème', '3ème'].contains(level);

  // --- LOGIQUE DE NAVIGATION ---

  void _startExercises(BuildContext context, String theme, {required bool isInfinite}) {
    // ✅ AJOUTER ICI
    SoundService().playStartChallenge();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseScreen(
          level: level,
          theme: theme,
          isInfiniteMode: isInfinite,
        ),
      ),
    );
  }

  // --- WIDGETS DU SÉLECTEUR DE MODE ---

  Widget _buildModeSelector(BuildContext context, String theme) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header du sélecteur
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choisis ton mode',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Comment veux-tu t\'entraîner ?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Options de mode
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildModeOption(
                  context,
                  icon: Icons.star_border_rounded,
                  label: 'Mode Normal',
                  subtitle: '20 exercices progressifs',
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _startExercises(context, theme, isInfinite: false);
                  },
                ),
                const SizedBox(height: 16),
                _buildModeOption(
                  context,
                  icon: Icons.all_inclusive_rounded,
                  label: 'Mode Infini',
                  subtitle: 'Entraînement illimité',
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.purple.shade600],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _startExercises(context, theme, isInfinite: true);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String subtitle,
        required Gradient gradient,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- DONNÉES ---

  List<Map<String, dynamic>> _getThemes() {
    if (isCollege) {
      return const [
        {
          'name': 'Nombres Relatifs',
          'symbolText': '±',
          'color': Colors.indigo
        },
        {
          'name': 'Fractions',
          'symbolText': '½',
          'color': Colors.teal
        },
        {
          'name': 'Algèbre',
          'symbolText': 'x=y',
          'color': Colors.deepOrange
        },
        {
          'name': 'Puissances',
          'symbolText': 'x²',
          'color': Colors.purpleAccent
        },
        {
          'name': 'Théorèmes',
          'icon': Icons.change_history,
          'color': Colors.brown
        },
        {
          'name': 'Statistiques',
          'icon': Icons.bar_chart,
          'color': Colors.blueGrey
        },
      ];
    } else {
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

  // --- BUILD UI ---

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentThemes = _getThemes();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B6B),
              Color(0xFFD32F2F),
              Colors.red,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),

              // Illustration avec effet
              Hero(
                tag: 'maths_illustration',
                child: Container(
                  height: size.height * 0.18,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/maths.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Titre section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.grid_view_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sélectionne un thème',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Grille des thèmes
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: currentThemes.length,
                    itemBuilder: (context, index) {
                      return _buildThemeCard(context, currentThemes[index], index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD32F2F)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  level,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  '${_getThemes().length} thèmes disponibles',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, Map<String, dynamic> theme, int index) {
    final disabledThemesCI = ['Multiplication', 'Division', 'Géométrie'];

    bool isDisabled = false;
    if (level == 'CI' && disabledThemesCI.contains(theme['name'])) {
      isDisabled = true;
    }

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value.clamp(0.0, 1.0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () {
          // ✅ AJOUTER ICI
          SoundService().playButtonClick();
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => _buildModeSelector(context, theme['name']),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDisabled
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : [
                theme['color'],
                theme['color'].withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: isDisabled
                    ? Colors.grey.withOpacity(0.3)
                    : theme['color'].withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Motif décoratif en arrière-plan
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Contenu
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: theme.containsKey('symbolText')
                          ? Text(
                        theme['symbolText'],
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.white60 : Colors.white,
                        ),
                      )
                          : Icon(
                        theme['icon'],
                        size: 36,
                        color: isDisabled ? Colors.white60 : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        theme['name'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.white60 : Colors.white,
                          fontFamily: 'ComicNeue',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDisabled)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Bientôt',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}