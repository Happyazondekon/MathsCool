import 'package:flutter/material.dart';
import 'package:mathscool/screens/exercise_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';
import '../services/sound_service.dart';

class ThemeSelectionScreen extends StatelessWidget {
  final String level;

  const ThemeSelectionScreen({super.key, required this.level});

  bool get isCollege => ['6ème', '5ème', '4ème', '3ème'].contains(level);

  void _startExercises(BuildContext context, String theme, {required bool isInfinite}) {
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

  Widget _buildModeSelector(BuildContext context, String theme) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                colors: [AppColors.primary, AppColors.secondary],
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
                  child: Icon(
                    Icons.emoji_events,
                    color: AppColors.textLight,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.chooseMode,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.howToTrain,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textLight.withOpacity(0.9),
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
                  label: AppLocalizations.of(context)!.normalMode,
                  subtitle: AppLocalizations.of(context)!.progressiveExercises,
                  gradient: LinearGradient(
                    colors: [AppColors.info, AppColors.secondary],
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
                  label: AppLocalizations.of(context)!.infiniteMode,
                  subtitle: AppLocalizations.of(context)!.unlimitedTraining,
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
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
                child: Icon(icon, color: AppColors.textLight, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textLight,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getThemes(BuildContext context) {
    if (isCollege) {
      return [
        {
          'name': AppLocalizations.of(context)!.themeRelativeNumbers,
          'symbolText': '±',
          'color': AppColors.primary
        },
        {
          'name': AppLocalizations.of(context)!.themeFractions,
          'symbolText': '½',
          'color': Color(0xFF14B8A6)
        },
        {
          'name': AppLocalizations.of(context)!.themeAlgebra,
          'symbolText': 'x=y',
          'color': Color(0xFFF97316)
        },
        {
          'name': AppLocalizations.of(context)!.themePowers,
          'symbolText': 'x²',
          'color': AppColors.secondary
        },
        {
          'name': AppLocalizations.of(context)!.themeTheorems,
          'icon': Icons.change_history,
          'color': Color(0xFF78350F)
        },
        {
          'name': AppLocalizations.of(context)!.themeStatistics,
          'icon': Icons.bar_chart,
          'color': Color(0xFF475569)
        },
      ];
    } else {
      return [
        {'name': AppLocalizations.of(context)!.themeAddition, 'icon': Icons.add, 'color': AppColors.warning},
        {'name': AppLocalizations.of(context)!.themeSubtraction, 'icon': Icons.remove, 'color': AppColors.info},
        {'name': AppLocalizations.of(context)!.themeMultiplication, 'icon': Icons.close, 'color': AppColors.success},
        {
          'name': AppLocalizations.of(context)!.themeDivision,
          'symbolText': '÷',
          'color': AppColors.secondary
        },
        {'name': AppLocalizations.of(context)!.themeGeometry, 'icon': Icons.square_foot, 'color': AppColors.error},
      ];
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentThemes = _getThemes(context);


    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgc_math.png'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientStart.withOpacity(0.8),
                  AppColors.gradientMiddle.withOpacity(0.7),
                  AppColors.gradientEnd.withOpacity(0.6),
                  AppColors.background.withOpacity(0.5),
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
                      child: Icon(
                        Icons.grid_view_rounded,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.selectTheme,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        color: AppColors.textLight,
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
    )
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  level,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.themesAvailable(_getThemes(context).length),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
    final disabledThemesCI = [AppLocalizations.of(context)!.themeMultiplication, AppLocalizations.of(context)!.themeDivision, AppLocalizations.of(context)!.themeGeometry];

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
                  ? [AppColors.disabled, AppColors.border]
                  : [
                theme['color'] as Color,
                (theme['color'] as Color).withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: isDisabled
                    ? AppColors.disabled.withOpacity(0.3)
                    : (theme['color'] as Color).withOpacity(0.4),
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
                          color: isDisabled
                              ? Colors.white60
                              : AppColors.textLight,
                        ),
                      )
                          : Icon(
                        theme['icon'],
                        size: 36,
                        color: isDisabled
                            ? Colors.white60
                            : AppColors.textLight,
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
                          color: isDisabled
                              ? Colors.white60
                              : AppColors.textLight,
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
                        child: Text(
                          AppLocalizations.of(context)!.comingSoon,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLight,
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