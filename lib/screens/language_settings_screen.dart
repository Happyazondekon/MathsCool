import 'package:flutter/material.dart';
import 'package:mathscool/services/localization_service.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final localizationService = Provider.of<LocalizationService>(context, listen: false);
    _selectedLanguage = localizationService.currentLocale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);
    final l10n = AppLocalizations.of(context)!;

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
                _buildHeader(context, l10n),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView( // 🆕 Ajout du scroll pour 4 langues
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.selectLanguage,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),


                        // 🇫🇷 FRANÇAIS
                        _buildLanguageOption(
                          context,
                          'Français',
                          'fr',
                          localizationService.isFrench(),
                          '🇫🇷',
                        ),
                        const SizedBox(height: 20),

                        // 🇬🇧 ANGLAIS
                        _buildLanguageOption(
                          context,
                          'English',
                          'en',
                          localizationService.isEnglish(),
                          '🇬🇧',
                        ),
                        const SizedBox(height: 20),

                        // 🇪🇸 ESPAGNOL 🆕 NOUVEAU
                        _buildLanguageOption(
                          context,
                          'Español',
                          'es',
                          localizationService.isSpanish(),
                          '🇪🇸',
                        ),
                        const SizedBox(height: 20),

                        // 🇨🇳 CHINOIS
                        _buildLanguageOption(
                          context,
                          '中文',
                          'zh',
                          localizationService.isChinese(),
                          '🇨🇳',
                        ),
                        const SizedBox(height: 20),

                        // 🆕 SECTION LANGUES À VENIR


                        // 🆕 LANGUES À VENIR
                        _buildComingSoonLanguage(
                          context,
                          'Deutsch',
                          '🇩🇪',
                          'Bald verfügbar', // "Coming Soon" en allemand
                        ),
                        const SizedBox(height: 20),

                        _buildComingSoonLanguage(
                          context,
                          'Italiano',
                          '🇮🇹',
                          'Presto disponibile', // "Coming Soon" en italien
                        ),
                        const SizedBox(height: 20),

                        _buildComingSoonLanguage(
                          context,
                          'Português',
                          '🇵🇹',
                          'Em breve', // "Coming Soon" en portugais
                        ),
                        const SizedBox(height: 20),

                        _buildComingSoonLanguage(
                          context,
                          'العربية',
                          '🇸🇦',
                          'قريباً', // "Coming Soon" en arabe
                        ),
                        const SizedBox(height: 20),

                        _buildComingSoonLanguage(
                          context,
                          'हिन्दी',
                          '🇮🇳',
                          'जल्द आ रहा है', // "Coming Soon" en hindi
                        ),
                        const SizedBox(height: 20),

                        _buildComingSoonLanguage(
                          context,
                          '日本語',
                          '🇯🇵',
                          '近日公開', // "Coming Soon" en japonais
                        ),
                        const SizedBox(height: 20),

                        _buildComingSoonLanguage(
                          context,
                          '한국어',
                          '🇰🇷',
                          '곧 출시', // "Coming Soon" en coréen
                        ),
                        const SizedBox(height: 20),

                        _buildComingSoonLanguage(
                          context,
                          'Русский',
                          '🇷🇺',
                          'Скоро', // "Coming Soon" en russe
                        ),
                        const SizedBox(height: 40), // Espace en bas
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
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
                  l10n.language,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  l10n.chooseYourLanguage,
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

  Widget _buildLanguageOption(
      BuildContext context,
      String languageName,
      String languageCode,
      bool isSelected,
      String flag,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () async {
        final localizationService = Provider.of<LocalizationService>(context, listen: false);
        await localizationService.setLanguage(languageCode);
        setState(() {
          _selectedLanguage = languageCode;
        });
        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.language} $languageName ${l10n.save.toLowerCase()}'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.25)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.6)
                : Colors.white.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  flag,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonLanguage(
      BuildContext context,
      String languageName,
      String flag,
      String comingSoonText,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                flag,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    comingSoonText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}