import 'package:flutter/material.dart';
import 'package:mathscool/screens/theme_selection.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';

import '../services/sound_service.dart';
import '../widgets/theme_selection.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  final List<String> levels = const [
    'CI', 'CP', 'CE1', 'CE2', 'CM1', 'CM2',
    '6ème', '5ème', '4ème', '3ème'
  ];

  List<String> _getDescriptions(BuildContext context) {
    return [
      AppLocalizations.of(context)!.levelForBeginners,
      AppLocalizations.of(context)!.levelFirstCalculations,
      AppLocalizations.of(context)!.levelMathBasics,
      AppLocalizations.of(context)!.levelIntermediate,
      AppLocalizations.of(context)!.levelAdvanced,
      AppLocalizations.of(context)!.levelExpert,
      AppLocalizations.of(context)!.levelCollegeEntry,
      AppLocalizations.of(context)!.levelCentral,
      AppLocalizations.of(context)!.levelDeepening,
      AppLocalizations.of(context)!.levelBrevetPrep,
    ];
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
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
      ),
    )
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.levelSelectionTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.warning],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.levelSelectionHint,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
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
    final List<List<Color>> gradientColors = [
      [AppColors.accent, AppColors.warning],                    // CI
      [AppColors.info, AppColors.secondary],                    // CP
      [AppColors.success, Color(0xFF059669)],                   // CE1
      [AppColors.gradientEnd, Color(0xFFEC4899)],               // CE2
      [AppColors.secondary, Color(0xFF7C3AED)],                 // CM1
      [AppColors.error, Color(0xFFDC2626)],                     // CM2
      [Color(0xFF06B6D4), Color(0xFF0891B2)],                   // 6ème
      [Color(0xFF14B8A6), Color(0xFF0D9488)],                   // 5ème
      [AppColors.warning, Color(0xFFF97316)],                   // 4ème
      [Color(0xFF64748B), Color(0xFF475569)],                   // 3ème
    ];

    final List<IconData> icons = [
      Icons.child_care_rounded,
      Icons.emoji_people_rounded,
      Icons.school_rounded,
      Icons.psychology_rounded,
      Icons.emoji_objects_rounded,
      Icons.workspace_premium_rounded,
      Icons.menu_book_rounded,
      Icons.calculate_rounded,
      Icons.architecture_rounded,
      Icons.history_edu_rounded,
    ];

    final bool isCollege = index >= 6;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 80)),
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
        onTap: () {
          SoundService().playButtonClick();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThemeSelectionScreen(level: levels[index]),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors[index],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: gradientColors[index][1].withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Motif décoratif
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
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

              // Badge collège
              if (isCollege)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.levelCollegeBadge,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: gradientColors[index][1],
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                ),

              // Contenu principal
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        icons[index],
                        size: 44,
                        color: gradientColors[index][1],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      levels[index],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        fontFamily: 'ComicNeue',
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        _getDescriptions(context)[index],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'ComicNeue',
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