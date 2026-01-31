/// Configuration des topics Firebase Cloud Messaging pour les campagnes ciblées
class FCMTopics {
  // Topics généraux
  static const String allUsers = 'all_users';

  // Topics par langue
  static const String french = 'lang_fr';
  static const String english = 'lang_en';
  static const String spanish = 'lang_es';
  static const String chinese = 'lang_zh';

  // Topics par niveau scolaire
  static const String primaryCI = 'level_CI';
  static const String primaryCP = 'level_CP';
  static const String primaryCE1 = 'level_CE1';
  static const String primaryCE2 = 'level_CE2';
  static const String primaryCM1 = 'level_CM1';
  static const String primaryCM2 = 'level_CM2';
  static const String middle6eme = 'level_6ème';
  static const String middle5eme = 'level_5ème';
  static const String middle4eme = 'level_4ème';
  static const String middle3eme = 'level_3ème';

  // Topics par thème mathématique
  static const String addition = 'theme_addition';
  static const String subtraction = 'theme_subtraction';
  static const String multiplication = 'theme_multiplication';
  static const String division = 'theme_division';
  static const String geometry = 'theme_geometry';
  static const String fractions = 'theme_fractions';
  static const String algebra = 'theme_algebra';
  static const String powers = 'theme_powers';

  // Topics pour fonctionnalités spéciales
  static const String premiumUsers = 'premium_users';
  static const String freeUsers = 'free_users';
  static const String activeUsers = 'active_users';
  static const String inactiveUsers = 'inactive_users';

  // Topics pour campagnes saisonnières
  static const String backToSchool = 'campaign_back_to_school';
  static const String holidaySpecial = 'campaign_holiday_special';
  static const String summerChallenge = 'campaign_summer_challenge';
  static const String winterBreak = 'campaign_winter_break';

  /// Obtenir le topic de langue selon le code de langue
  static String getLanguageTopic(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return french;
      case 'en':
        return english;
      case 'es':
        return spanish;
      case 'zh':
        return chinese;
      default:
        return french; // Défaut français
    }
  }

  /// Obtenir le topic de niveau selon le niveau scolaire
  static String getLevelTopic(String level) {
    switch (level) {
      case 'CI':
        return primaryCI;
      case 'CP':
        return primaryCP;
      case 'CE1':
        return primaryCE1;
      case 'CE2':
        return primaryCE2;
      case 'CM1':
        return primaryCM1;
      case 'CM2':
        return primaryCM2;
      case '6ème':
        return middle6eme;
      case '5ème':
        return middle5eme;
      case '4ème':
        return middle4eme;
      case '3ème':
        return middle3eme;
      default:
        return primaryCI; // Défaut CI
    }
  }

  /// Liste de tous les topics disponibles
  static List<String> get allTopics => [
    allUsers,
    french, english, spanish, chinese,
    primaryCI, primaryCP, primaryCE1, primaryCE2, primaryCM1, primaryCM2,
    middle6eme, middle5eme, middle4eme, middle3eme,
    addition, subtraction, multiplication, division, geometry,
    fractions, algebra, powers,
    premiumUsers, freeUsers, activeUsers, inactiveUsers,
    backToSchool, holidaySpecial, summerChallenge, winterBreak,
  ];
}