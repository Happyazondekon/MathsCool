import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('fr'); // Default to French

  Locale get currentLocale => _currentLocale;

  LocalizationService() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (savedLanguage != null) {
      // Utiliser la langue sauvegardée
      _currentLocale = Locale(savedLanguage);
    } else {
      // 🆕 Première utilisation : détecter automatiquement la langue de l'appareil
      _currentLocale = _getDeviceLanguage();
      // Sauvegarder pour les futures sessions
      await prefs.setString(_languageKey, _currentLocale.languageCode);
    }

    notifyListeners();
  }

  /// 🆕 Détecter automatiquement la langue de l'appareil
  Locale _getDeviceLanguage() {
    final deviceLanguage = ui.window.locale.languageCode;

    // Mapper vers nos langues supportées
    switch (deviceLanguage) {
      case 'fr':
        return const Locale('fr');
      case 'en':
        return const Locale('en');
      case 'es':
        return const Locale('es');
      case 'zh':
        return const Locale('zh');
      default:
        // Pour les autres langues, vérifier si c'est une variante
        if (deviceLanguage.startsWith('zh')) {
          return const Locale('zh'); // Chinois
        }
        // Défaut : Français
        return const Locale('fr');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  /// 🆕 Remettre à zéro et détecter automatiquement la langue de l'appareil
  Future<void> resetToDeviceLanguage() async {
    _currentLocale = _getDeviceLanguage();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _currentLocale.languageCode);
    notifyListeners();
  }

  // 🆕 Méthodes de vérification pour les 4 langues
  bool isFrench() => _currentLocale.languageCode == 'fr';
  bool isEnglish() => _currentLocale.languageCode == 'en';
  bool isChinese() => _currentLocale.languageCode == 'zh';
  bool isSpanish() => _currentLocale.languageCode == 'es'; // 🆕 NOUVEAU

  // 🆕 Méthode helper pour obtenir le nom de la langue
  String getLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'es':
        return 'Español'; // 🆕 NOUVEAU
      default:
        return 'Français';
    }
  }

  // 🆕 Méthode helper pour obtenir le drapeau
  String getLanguageFlag() {
    switch (_currentLocale.languageCode) {
      case 'fr':
        return '🇫🇷';
      case 'en':
        return '🇬🇧';
      case 'zh':
        return '🇨🇳';
      case 'es':
        return '🇪🇸'; // 🆕 NOUVEAU
      default:
        return '🇫🇷';
    }
  }
}