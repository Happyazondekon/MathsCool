import 'package:flutter/material.dart';
import 'package:mathscool/services/localization_service.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(
        title: Text(l10n.language),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
              const SizedBox(height: 30),
              _buildLanguageOption(
                context,
                'Français',
                'fr',
                localizationService.isFrench(),
              ),
              const SizedBox(height: 20),
              _buildLanguageOption(
                context,
                'English',
                'en',
                localizationService.isEnglish(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageName, String languageCode, bool isSelected) {
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
            content: Text('${l10n.language} ${languageName.toLowerCase()} ${l10n.save.toLowerCase()}'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withOpacity(0.8) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.language,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 30,
            ),
            const SizedBox(width: 20),
            Text(
              languageName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}