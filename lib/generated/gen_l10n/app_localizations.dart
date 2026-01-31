import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MathsCool'**
  String get appTitle;

  /// No description provided for @helloChampion.
  ///
  /// In en, this message translates to:
  /// **'Hello champion! 👋'**
  String get helloChampion;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}!'**
  String helloUser(Object name);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}!'**
  String goodMorning(Object name);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @iAmMathKid.
  ///
  /// In en, this message translates to:
  /// **'I am MathKid, your personal math assistant!'**
  String get iAmMathKid;

  /// No description provided for @askMeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask me a question'**
  String get askMeQuestion;

  /// No description provided for @aboutAnyMathTopic.
  ///
  /// In en, this message translates to:
  /// **'About any math topic!'**
  String get aboutAnyMathTopic;

  /// No description provided for @simpleExplanations.
  ///
  /// In en, this message translates to:
  /// **'Simple explanations'**
  String get simpleExplanations;

  /// No description provided for @iExplainComplex.
  ///
  /// In en, this message translates to:
  /// **'I explain complex concepts simply'**
  String get iExplainComplex;

  /// No description provided for @usernameAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'This name is already used'**
  String get usernameAlreadyUsed;

  /// No description provided for @usernameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your name has been updated! 🎉'**
  String get usernameUpdated;

  /// No description provided for @usernameTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Username'**
  String get usernameTitle;

  /// No description provided for @chooseAppearance.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to appear'**
  String get chooseAppearance;

  /// No description provided for @usernameExample.
  ///
  /// In en, this message translates to:
  /// **'Ex: SuperMath123'**
  String get usernameExample;

  /// No description provided for @usernameInfo.
  ///
  /// In en, this message translates to:
  /// **'3-20 characters • Visible by all'**
  String get usernameInfo;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'💡 Suggestions :'**
  String get suggestions;

  /// No description provided for @generateSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Generate suggestions'**
  String get generateSuggestions;

  /// No description provided for @chooseMode.
  ///
  /// In en, this message translates to:
  /// **'Choose your mode'**
  String get chooseMode;

  /// No description provided for @howToTrain.
  ///
  /// In en, this message translates to:
  /// **'How do you want to train?'**
  String get howToTrain;

  /// No description provided for @normalMode.
  ///
  /// In en, this message translates to:
  /// **'Normal Mode'**
  String get normalMode;

  /// No description provided for @progressiveExercises.
  ///
  /// In en, this message translates to:
  /// **'20 progressive exercises'**
  String get progressiveExercises;

  /// No description provided for @infiniteMode.
  ///
  /// In en, this message translates to:
  /// **'Infinite Mode'**
  String get infiniteMode;

  /// No description provided for @unlimitedTraining.
  ///
  /// In en, this message translates to:
  /// **'Unlimited training'**
  String get unlimitedTraining;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select a theme'**
  String get selectTheme;

  /// No description provided for @themesAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} themes available'**
  String themesAvailable(Object count);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get comingSoon;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data for the moment'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose your photo'**
  String get choosePhoto;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @timeBonus.
  ///
  /// In en, this message translates to:
  /// **'⏰ +5 seconds added! (-5 💎)'**
  String get timeBonus;

  /// No description provided for @themeRelativeNumbers.
  ///
  /// In en, this message translates to:
  /// **'Relative Numbers'**
  String get themeRelativeNumbers;

  /// No description provided for @themeFractions.
  ///
  /// In en, this message translates to:
  /// **'Fractions'**
  String get themeFractions;

  /// No description provided for @themeAlgebra.
  ///
  /// In en, this message translates to:
  /// **'Algebra'**
  String get themeAlgebra;

  /// No description provided for @themePowers.
  ///
  /// In en, this message translates to:
  /// **'Powers'**
  String get themePowers;

  /// No description provided for @themeTheorems.
  ///
  /// In en, this message translates to:
  /// **'Theorems'**
  String get themeTheorems;

  /// No description provided for @themeStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get themeStatistics;

  /// No description provided for @themeAddition.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get themeAddition;

  /// No description provided for @themeSubtraction.
  ///
  /// In en, this message translates to:
  /// **'Subtraction'**
  String get themeSubtraction;

  /// No description provided for @themeMultiplication.
  ///
  /// In en, this message translates to:
  /// **'Multiplication'**
  String get themeMultiplication;

  /// No description provided for @themeDivision.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get themeDivision;

  /// No description provided for @themeGeometry.
  ///
  /// In en, this message translates to:
  /// **'Geometry'**
  String get themeGeometry;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MathsCool'**
  String get welcomeTitle;

  /// No description provided for @connectToContinue.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue'**
  String get connectToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @min6Chars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get min6Chars;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @newToMathsCool.
  ///
  /// In en, this message translates to:
  /// **'New to MathsCool? '**
  String get newToMathsCool;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountTitle;

  /// No description provided for @joinMathsCool.
  ///
  /// In en, this message translates to:
  /// **'Join MathsCool to get started'**
  String get joinMathsCool;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @noLivesTitle.
  ///
  /// In en, this message translates to:
  /// **'No more lives!'**
  String get noLivesTitle;

  /// No description provided for @needRestOrBoost.
  ///
  /// In en, this message translates to:
  /// **'You need rest or a boost! 💖'**
  String get needRestOrBoost;

  /// No description provided for @waitForRechargeOrVisitStore.
  ///
  /// In en, this message translates to:
  /// **'Wait for them to recharge or visit the store.'**
  String get waitForRechargeOrVisitStore;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @startPlaying.
  ///
  /// In en, this message translates to:
  /// **'Start playing'**
  String get startPlaying;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email sent!'**
  String get emailSent;

  /// No description provided for @checkEmailReset.
  ///
  /// In en, this message translates to:
  /// **'Check your email to reset your password.'**
  String get checkEmailReset;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordTitle;

  /// No description provided for @enterEmailReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get enterEmailReset;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get sendLink;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent. Check your inbox and spam folder.'**
  String get verificationEmailSent;

  /// No description provided for @errorSendingEmail.
  ///
  /// In en, this message translates to:
  /// **'Error sending email: '**
  String get errorSendingEmail;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your Email'**
  String get verifyYourEmail;

  /// No description provided for @verificationLinkSent.
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to {email}.'**
  String verificationLinkSent(Object email);

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmail;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(Object seconds);

  /// No description provided for @useAnotherAccount.
  ///
  /// In en, this message translates to:
  /// **'Use another account'**
  String get useAnotherAccount;

  /// No description provided for @requestLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Request limit reached'**
  String get requestLimitReached;

  /// No description provided for @sorryCantRespond.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I can\'t respond right now. 🤖\nTry rephrasing your question!'**
  String get sorryCantRespond;

  /// No description provided for @pauseNeeded.
  ///
  /// In en, this message translates to:
  /// **'Pause needed! ⏸️'**
  String get pauseNeeded;

  /// No description provided for @usedFreeQuestions.
  ///
  /// In en, this message translates to:
  /// **'You have used your 3 free questions for today.'**
  String get usedFreeQuestions;

  /// No description provided for @seeUnlimitedOffers.
  ///
  /// In en, this message translates to:
  /// **'See unlimited offers 🚀'**
  String get seeUnlimitedOffers;

  /// No description provided for @comeBackTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow'**
  String get comeBackTomorrow;

  /// No description provided for @mathKidAssistant.
  ///
  /// In en, this message translates to:
  /// **'MathKid Assistant'**
  String get mathKidAssistant;

  /// No description provided for @alwaysReadyToHelp.
  ///
  /// In en, this message translates to:
  /// **'Always ready to help you!'**
  String get alwaysReadyToHelp;

  /// No description provided for @concreteExamples.
  ///
  /// In en, this message translates to:
  /// **'Concrete examples'**
  String get concreteExamples;

  /// No description provided for @withRealLifeExamples.
  ///
  /// In en, this message translates to:
  /// **'With real life examples'**
  String get withRealLifeExamples;

  /// No description provided for @mathKidThinking.
  ///
  /// In en, this message translates to:
  /// **'MathKid is thinking...'**
  String get mathKidThinking;

  /// No description provided for @askMathQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask your math question...'**
  String get askMathQuestion;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String hoursAgo(Object hours);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error;

  /// No description provided for @rewardClaimed.
  ///
  /// In en, this message translates to:
  /// **'Reward claimed! 🎉'**
  String get rewardClaimed;

  /// No description provided for @gemsEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get gemsEarned;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome! 🎉'**
  String get awesome;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @collectRewards.
  ///
  /// In en, this message translates to:
  /// **'Collect your rewards! 🏆'**
  String get collectRewards;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @toClaim.
  ///
  /// In en, this message translates to:
  /// **'To claim'**
  String get toClaim;

  /// No description provided for @gemsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Gems avail.'**
  String get gemsAvailable;

  /// No description provided for @overallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall progress'**
  String get overallProgress;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noAchievementsToClaim.
  ///
  /// In en, this message translates to:
  /// **'No achievements to claim'**
  String get noAchievementsToClaim;

  /// No description provided for @noCompletedAchievements.
  ///
  /// In en, this message translates to:
  /// **'No completed achievements'**
  String get noCompletedAchievements;

  /// No description provided for @startPlayingToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Start playing to unlock!'**
  String get startPlayingToUnlock;

  /// No description provided for @keepPlayingToEarn.
  ///
  /// In en, this message translates to:
  /// **'Keep playing to earn more!'**
  String get keepPlayingToEarn;

  /// No description provided for @achievementsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Achievements will appear here'**
  String get achievementsWillAppearHere;

  /// No description provided for @secretAchievement.
  ///
  /// In en, this message translates to:
  /// **'???'**
  String get secretAchievement;

  /// No description provided for @secretAchievementDescription.
  ///
  /// In en, this message translates to:
  /// **'Secret achievement to discover...'**
  String get secretAchievementDescription;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'RESULT'**
  String get resultTitle;

  /// No description provided for @fantastic.
  ///
  /// In en, this message translates to:
  /// **'🎉 FANTASTIC ! 🎉'**
  String get fantastic;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'YOUR SCORE'**
  String get yourScore;

  /// No description provided for @pts.
  ///
  /// In en, this message translates to:
  /// **'PTS'**
  String get pts;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'PERFORMANCE'**
  String get performance;

  /// No description provided for @starsOutOfThree.
  ///
  /// In en, this message translates to:
  /// **'{stars}/3 stars'**
  String starsOutOfThree(Object stars);

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @viewLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'VIEW LEADERBOARD'**
  String get viewLeaderboard;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get back;

  /// No description provided for @wellPlayed.
  ///
  /// In en, this message translates to:
  /// **'💪 WELL PLAYED ! 💪'**
  String get wellPlayed;

  /// No description provided for @notEnoughGems.
  ///
  /// In en, this message translates to:
  /// **'Not enough gems!'**
  String get notEnoughGems;

  /// No description provided for @dailyChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge 🎯'**
  String get dailyChallengeTitle;

  /// No description provided for @dailyChallengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your daily challenge!'**
  String get dailyChallengeSubtitle;

  /// No description provided for @dailyChallengeSelectLevel.
  ///
  /// In en, this message translates to:
  /// **'Choose your level'**
  String get dailyChallengeSelectLevel;

  /// No description provided for @dailyChallengeForBeginners.
  ///
  /// In en, this message translates to:
  /// **'For beginners'**
  String get dailyChallengeForBeginners;

  /// No description provided for @dailyChallengeFirstCalculations.
  ///
  /// In en, this message translates to:
  /// **'First calculations'**
  String get dailyChallengeFirstCalculations;

  /// No description provided for @dailyChallengeMathBasics.
  ///
  /// In en, this message translates to:
  /// **'Math basics'**
  String get dailyChallengeMathBasics;

  /// No description provided for @dailyChallengeIntermediateLevel.
  ///
  /// In en, this message translates to:
  /// **'Intermediate level'**
  String get dailyChallengeIntermediateLevel;

  /// No description provided for @dailyChallengeAdvancedLevel.
  ///
  /// In en, this message translates to:
  /// **'Advanced level'**
  String get dailyChallengeAdvancedLevel;

  /// No description provided for @dailyChallengeExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get dailyChallengeExpert;

  /// No description provided for @dailyChallengeCollegeEntry.
  ///
  /// In en, this message translates to:
  /// **'Middle school entry'**
  String get dailyChallengeCollegeEntry;

  /// No description provided for @dailyChallengeCentralLevel.
  ///
  /// In en, this message translates to:
  /// **'Central level'**
  String get dailyChallengeCentralLevel;

  /// No description provided for @dailyChallengeDeepening.
  ///
  /// In en, this message translates to:
  /// **'Deepening'**
  String get dailyChallengeDeepening;

  /// No description provided for @dailyChallengeBrevetPrep.
  ///
  /// In en, this message translates to:
  /// **'Diploma preparation'**
  String get dailyChallengeBrevetPrep;

  /// No description provided for @dailyChallengeCollege.
  ///
  /// In en, this message translates to:
  /// **'Middle school'**
  String get dailyChallengeCollege;

  /// No description provided for @dailyChallengeNotEnoughGems.
  ///
  /// In en, this message translates to:
  /// **'Not enough gems! 💎'**
  String get dailyChallengeNotEnoughGems;

  /// No description provided for @dailyChallengeNeedGems.
  ///
  /// In en, this message translates to:
  /// **'You need 5 gems to add 5 seconds.'**
  String get dailyChallengeNeedGems;

  /// No description provided for @dailyChallengeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dailyChallengeCancel;

  /// No description provided for @dailyChallengeStore.
  ///
  /// In en, this message translates to:
  /// **'Store 💎'**
  String get dailyChallengeStore;

  /// No description provided for @dailyChallengeAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add time ⏰'**
  String get dailyChallengeAddTime;

  /// No description provided for @dailyChallengeConfirmAddTime.
  ///
  /// In en, this message translates to:
  /// **'Do you want to use 5 gems to add 5 seconds?'**
  String get dailyChallengeConfirmAddTime;

  /// No description provided for @dailyChallengeCurrentGems.
  ///
  /// In en, this message translates to:
  /// **'Current gems:'**
  String get dailyChallengeCurrentGems;

  /// No description provided for @dailyChallengeNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get dailyChallengeNo;

  /// No description provided for @dailyChallengeYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get dailyChallengeYes;

  /// No description provided for @dailyChallengeTimeAdded.
  ///
  /// In en, this message translates to:
  /// **'⏰ +5 seconds added! (-5 💎)'**
  String get dailyChallengeTimeAdded;

  /// No description provided for @dailyChallengeTimeUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up! ⏰'**
  String get dailyChallengeTimeUp;

  /// No description provided for @dailyChallengeTimeUpMessage.
  ///
  /// In en, this message translates to:
  /// **'The 5 minutes are over!'**
  String get dailyChallengeTimeUpMessage;

  /// No description provided for @dailyChallengeTimeUpScore.
  ///
  /// In en, this message translates to:
  /// **'Score obtained: {score} points'**
  String dailyChallengeTimeUpScore(Object score);

  /// No description provided for @dailyChallengeFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get dailyChallengeFinish;

  /// No description provided for @dailyChallengeQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get dailyChallengeQuit;

  /// No description provided for @dailyChallengeQuitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to quit?'**
  String get dailyChallengeQuitConfirm;

  /// No description provided for @dailyChallengeQuitWarning.
  ///
  /// In en, this message translates to:
  /// **'You will lose your current progress.'**
  String get dailyChallengeQuitWarning;

  /// No description provided for @dailyChallengeStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get dailyChallengeStay;

  /// No description provided for @dailyChallengeLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get dailyChallengeLeave;

  /// No description provided for @dailyChallengeLostLife.
  ///
  /// In en, this message translates to:
  /// **'Oops! 💔'**
  String get dailyChallengeLostLife;

  /// No description provided for @dailyChallengeLostLifeMessage.
  ///
  /// In en, this message translates to:
  /// **'You lost a life!'**
  String get dailyChallengeLostLifeMessage;

  /// No description provided for @dailyChallengeLivesRemaining.
  ///
  /// In en, this message translates to:
  /// **'Lives remaining: {lives}'**
  String dailyChallengeLivesRemaining(Object lives);

  /// No description provided for @dailyChallengeGameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over! 💔'**
  String get dailyChallengeGameOver;

  /// No description provided for @dailyChallengeNoMoreLives.
  ///
  /// In en, this message translates to:
  /// **'You have no more lives!'**
  String get dailyChallengeNoMoreLives;

  /// No description provided for @dailyChallengeWaitForLives.
  ///
  /// In en, this message translates to:
  /// **'Wait for your lives to recharge or get some from the store.'**
  String get dailyChallengeWaitForLives;

  /// No description provided for @dailyChallengeRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get dailyChallengeRetry;

  /// No description provided for @dailyChallengeOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dailyChallengeOk;

  /// No description provided for @dailyChallengeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Challenge already completed today! 🎉'**
  String get dailyChallengeCompleted;

  /// No description provided for @dailyChallengeCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have already completed today\'s challenge!'**
  String get dailyChallengeCompletedMessage;

  /// No description provided for @dailyChallengeCompletedScore.
  ///
  /// In en, this message translates to:
  /// **'Score obtained: {score} points'**
  String dailyChallengeCompletedScore(Object score);

  /// No description provided for @dailyChallengeCompletedTime.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String dailyChallengeCompletedTime(Object time);

  /// No description provided for @dailyChallengeComeBackTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow for a new challenge!'**
  String get dailyChallengeComeBackTomorrow;

  /// No description provided for @dailyChallengeBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get dailyChallengeBackToHome;

  /// No description provided for @dailyChallengeScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String dailyChallengeScore(Object score);

  /// No description provided for @dailyChallengeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question {current}/{total}'**
  String dailyChallengeQuestion(Object current, Object total);

  /// No description provided for @dailyChallengeNoExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises available for this level'**
  String get dailyChallengeNoExercises;

  /// No description provided for @dailyChallengeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading challenge...'**
  String get dailyChallengeLoading;

  /// No description provided for @dailyChallengeReportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug 🐛'**
  String get dailyChallengeReportBug;

  /// No description provided for @dailyChallengeReportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thanks! The bug has been reported. 🙏'**
  String get dailyChallengeReportSuccess;

  /// No description provided for @dailyChallengeCheckAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get dailyChallengeCheckAnswer;

  /// No description provided for @dailyChallengeNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get dailyChallengeNext;

  /// No description provided for @dailyChallengeSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get dailyChallengeSaving;

  /// No description provided for @dailyChallengeGoodAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer! 🎉'**
  String get dailyChallengeGoodAnswer;

  /// No description provided for @dailyChallengeWrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer'**
  String get dailyChallengeWrongAnswer;

  /// No description provided for @dailyChallengeCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer: {answer}'**
  String dailyChallengeCorrectAnswer(Object answer);

  /// No description provided for @dailyChallengeButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallengeButtonTitle;

  /// No description provided for @dailyChallengeButtonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'10 exercises • Win stars!'**
  String get dailyChallengeButtonSubtitle;

  /// No description provided for @dailyChallengeButtonNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get dailyChallengeButtonNew;

  /// No description provided for @levelSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your level'**
  String get levelSelectionTitle;

  /// No description provided for @levelSelectionHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the level that matches your class'**
  String get levelSelectionHint;

  /// No description provided for @levelForBeginners.
  ///
  /// In en, this message translates to:
  /// **'For beginners'**
  String get levelForBeginners;

  /// No description provided for @levelFirstCalculations.
  ///
  /// In en, this message translates to:
  /// **'First calculations'**
  String get levelFirstCalculations;

  /// No description provided for @levelMathBasics.
  ///
  /// In en, this message translates to:
  /// **'Math basics'**
  String get levelMathBasics;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate level'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced level'**
  String get levelAdvanced;

  /// No description provided for @levelExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get levelExpert;

  /// No description provided for @levelCollegeEntry.
  ///
  /// In en, this message translates to:
  /// **'Middle school entry'**
  String get levelCollegeEntry;

  /// No description provided for @levelCentral.
  ///
  /// In en, this message translates to:
  /// **'Central level'**
  String get levelCentral;

  /// No description provided for @levelDeepening.
  ///
  /// In en, this message translates to:
  /// **'Deepening'**
  String get levelDeepening;

  /// No description provided for @levelBrevetPrep.
  ///
  /// In en, this message translates to:
  /// **'Diploma preparation'**
  String get levelBrevetPrep;

  /// No description provided for @levelCollegeBadge.
  ///
  /// In en, this message translates to:
  /// **'Middle school'**
  String get levelCollegeBadge;

  /// No description provided for @generatingInfinite.
  ///
  /// In en, this message translates to:
  /// **'Generating infinite...'**
  String get generatingInfinite;

  /// No description provided for @preparingExercises.
  ///
  /// In en, this message translates to:
  /// **'Preparing exercises...'**
  String get preparingExercises;

  /// No description provided for @exercisesInPreparation.
  ///
  /// In en, this message translates to:
  /// **'Exercises in preparation! 🚧'**
  String get exercisesInPreparation;

  /// No description provided for @teacherPreparing.
  ///
  /// In en, this message translates to:
  /// **'The teacher is preparing {theme} subjects'**
  String teacherPreparing(Object theme);

  /// No description provided for @indice.
  ///
  /// In en, this message translates to:
  /// **'Hint 💡'**
  String get indice;

  /// No description provided for @correctAnswerIs.
  ///
  /// In en, this message translates to:
  /// **'The correct answer is: {answer}'**
  String correctAnswerIs(Object answer);

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get understood;

  /// No description provided for @notEnoughGemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough Gems 💎'**
  String get notEnoughGemsTitle;

  /// No description provided for @missingGemsNeed.
  ///
  /// In en, this message translates to:
  /// **'You are missing {missing} gems.\nVisit the store to get some!'**
  String missingGemsNeed(Object missing);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store 🛒'**
  String get store;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offlineMode;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Loading error'**
  String get loadingError;

  /// No description provided for @goodAnswerColl.
  ///
  /// In en, this message translates to:
  /// **'Excellent! Correct answer ✅'**
  String get goodAnswerColl;

  /// No description provided for @goodAnswerPrim.
  ///
  /// In en, this message translates to:
  /// **'Bravo! 🥳 That\'s correct 🎉'**
  String get goodAnswerPrim;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Oops! You lost a life 💔'**
  String get wrongAnswer;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'🎉 Achievement unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @noMoreLives.
  ///
  /// In en, this message translates to:
  /// **'Ouch! No more lives 💔'**
  String get noMoreLives;

  /// No description provided for @usedAllLives.
  ///
  /// In en, this message translates to:
  /// **'You used all your lives for now.'**
  String get usedAllLives;

  /// No description provided for @waitOrRecover.
  ///
  /// In en, this message translates to:
  /// **'You can wait for them to recharge or recover some now!'**
  String get waitOrRecover;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @hintCost.
  ///
  /// In en, this message translates to:
  /// **'Hint ({gems}💎)'**
  String hintCost(Object gems);

  /// No description provided for @skipCost.
  ///
  /// In en, this message translates to:
  /// **'Skip ({gems}💎)'**
  String skipCost(Object gems);

  /// No description provided for @expertTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 You are an Expert! 🎉'**
  String get expertTitle;

  /// No description provided for @goodJobTitle.
  ///
  /// In en, this message translates to:
  /// **'🌟 Good job! 🌟'**
  String get goodJobTitle;

  /// No description provided for @courageTitle.
  ///
  /// In en, this message translates to:
  /// **'🙂 Courage!'**
  String get courageTitle;

  /// No description provided for @mathkidTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 You are a Mathkid! 🎉'**
  String get mathkidTitle;

  /// No description provided for @onRightTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'🌟 You are on the right track! 🌟'**
  String get onRightTrackTitle;

  /// No description provided for @almostMathkidTitle.
  ///
  /// In en, this message translates to:
  /// **'🙂 Almost a Mathkid!'**
  String get almostMathkidTitle;

  /// No description provided for @perfectMastery.
  ///
  /// In en, this message translates to:
  /// **'Perfect! You master perfectly! 🎯'**
  String get perfectMastery;

  /// No description provided for @excellentWork.
  ///
  /// In en, this message translates to:
  /// **'Excellent work! Keep it up! 💪'**
  String get excellentWork;

  /// No description provided for @askForHelp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t hesitate to ask for help to improve! 📚'**
  String get askForHelp;

  /// No description provided for @seeMyProgress.
  ///
  /// In en, this message translates to:
  /// **'See my progress'**
  String get seeMyProgress;

  /// No description provided for @consultManual.
  ///
  /// In en, this message translates to:
  /// **'Consult the Manual'**
  String get consultManual;

  /// No description provided for @returnn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnn;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String question(Object number);

  /// No description provided for @dailyChallengeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm ✨'**
  String get dailyChallengeConfirm;

  /// No description provided for @dailyChallengeSeeResult.
  ///
  /// In en, this message translates to:
  /// **'See the result'**
  String get dailyChallengeSeeResult;

  /// No description provided for @dailyChallengeQuitText.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get dailyChallengeQuitText;

  /// No description provided for @dailyChallengeYourGems.
  ///
  /// In en, this message translates to:
  /// **'Your gems: {gems}'**
  String dailyChallengeYourGems(Object gems);

  /// No description provided for @dailyChallengeErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading challenge'**
  String get dailyChallengeErrorLoading;

  /// No description provided for @dailyChallengeNoData.
  ///
  /// In en, this message translates to:
  /// **'No challenge data available'**
  String get dailyChallengeNoData;

  /// No description provided for @dailyChallengeAlreadyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Challenge already completed today! 🎉'**
  String get dailyChallengeAlreadyCompleted;

  /// No description provided for @dailyChallengeAlreadyCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow for a new challenge!'**
  String get dailyChallengeAlreadyCompletedMessage;

  /// No description provided for @dailyChallengeBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get dailyChallengeBack;

  /// No description provided for @dailyChallengeBrilliantSuccess.
  ///
  /// In en, this message translates to:
  /// **'You brilliantly succeeded in this challenge!'**
  String get dailyChallengeBrilliantSuccess;

  /// No description provided for @dailyChallengeKeepProgressing.
  ///
  /// In en, this message translates to:
  /// **'Keep going, you\'re making progress every day!'**
  String get dailyChallengeKeepProgressing;

  /// No description provided for @dailyChallengePoints.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get dailyChallengePoints;

  /// No description provided for @dailyChallengeSeconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get dailyChallengeSeconds;

  /// No description provided for @dailyChallengeViewLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'VIEW LEADERBOARD'**
  String get dailyChallengeViewLeaderboard;

  /// No description provided for @dailyChallengeResultBack.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get dailyChallengeResultBack;

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'LEADERBOARD'**
  String get leaderboardTitle;

  /// No description provided for @leaderboardWelcomeChampion.
  ///
  /// In en, this message translates to:
  /// **'Welcome Champion!'**
  String get leaderboardWelcomeChampion;

  /// No description provided for @leaderboardToAppearInRanking.
  ///
  /// In en, this message translates to:
  /// **'To appear in the ranking'**
  String get leaderboardToAppearInRanking;

  /// No description provided for @leaderboardChooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Choose your username!'**
  String get leaderboardChooseUsername;

  /// No description provided for @leaderboardNameVisibleToAll.
  ///
  /// In en, this message translates to:
  /// **'Your name will be visible to all'**
  String get leaderboardNameVisibleToAll;

  /// No description provided for @leaderboardLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get leaderboardLater;

  /// No description provided for @leaderboardChooseMyName.
  ///
  /// In en, this message translates to:
  /// **'Choose my name'**
  String get leaderboardChooseMyName;

  /// No description provided for @leaderboardLoading.
  ///
  /// In en, this message translates to:
  /// **'🏆 Loading leaderboard...'**
  String get leaderboardLoading;

  /// No description provided for @leaderboardTabTop.
  ///
  /// In en, this message translates to:
  /// **'🏅 TOP 20'**
  String get leaderboardTabTop;

  /// No description provided for @leaderboardTabMe.
  ///
  /// In en, this message translates to:
  /// **'👤 ME'**
  String get leaderboardTabMe;

  /// No description provided for @leaderboardTabStats.
  ///
  /// In en, this message translates to:
  /// **'📊 STATS'**
  String get leaderboardTabStats;

  /// No description provided for @leaderboardNoChampions.
  ///
  /// In en, this message translates to:
  /// **'🎯 No champions yet'**
  String get leaderboardNoChampions;

  /// No description provided for @leaderboardBeTheFirst.
  ///
  /// In en, this message translates to:
  /// **'Be the first to take up the challenge!'**
  String get leaderboardBeTheFirst;

  /// No description provided for @leaderboardYourHistory.
  ///
  /// In en, this message translates to:
  /// **'📜 Your History'**
  String get leaderboardYourHistory;

  /// No description provided for @leaderboardYourLegendsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Your legendary feats will appear here!'**
  String get leaderboardYourLegendsWillAppear;

  /// No description provided for @leaderboardNoStatsYet.
  ///
  /// In en, this message translates to:
  /// **'📊 No stats yet'**
  String get leaderboardNoStatsYet;

  /// No description provided for @leaderboardUnlockStats.
  ///
  /// In en, this message translates to:
  /// **'Complete your first challenge to unlock your statistics!'**
  String get leaderboardUnlockStats;

  /// No description provided for @leaderboardCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'🔥 Current Streak'**
  String get leaderboardCurrentStreak;

  /// No description provided for @leaderboardConsecutiveDays.
  ///
  /// In en, this message translates to:
  /// **'consecutive days'**
  String get leaderboardConsecutiveDays;

  /// No description provided for @leaderboardTotalStars.
  ///
  /// In en, this message translates to:
  /// **'⭐ Total Stars'**
  String get leaderboardTotalStars;

  /// No description provided for @leaderboardStarsCollected.
  ///
  /// In en, this message translates to:
  /// **'stars collected'**
  String get leaderboardStarsCollected;

  /// No description provided for @leaderboardPersonalRecord.
  ///
  /// In en, this message translates to:
  /// **'🏆 Personal Record'**
  String get leaderboardPersonalRecord;

  /// No description provided for @leaderboardDaysYourBest.
  ///
  /// In en, this message translates to:
  /// **'days - your best'**
  String get leaderboardDaysYourBest;

  /// No description provided for @leaderboardPoints.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get leaderboardPoints;

  /// No description provided for @leaderboardStars.
  ///
  /// In en, this message translates to:
  /// **'stars'**
  String get leaderboardStars;

  /// No description provided for @leaderboardYou.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get leaderboardYou;

  /// No description provided for @leaderboardEmptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get leaderboardEmptyStateTitle;

  /// No description provided for @leaderboardEmptyStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Challenge yourself to appear here!'**
  String get leaderboardEmptyStateMessage;

  /// No description provided for @progressScreen_title.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get progressScreen_title;

  /// No description provided for @progressScreen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your evolution! 📊'**
  String get progressScreen_subtitle;

  /// No description provided for @progressScreen_loadingError.
  ///
  /// In en, this message translates to:
  /// **'Error while loading'**
  String get progressScreen_loadingError;

  /// No description provided for @progressChart_byCategory.
  ///
  /// In en, this message translates to:
  /// **'Progress by category'**
  String get progressChart_byCategory;

  /// No description provided for @progressChart_byGrade.
  ///
  /// In en, this message translates to:
  /// **'Progress by grade level'**
  String get progressChart_byGrade;

  /// No description provided for @progressScreen_byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get progressScreen_byCategory;

  /// No description provided for @progressScreen_byGrade.
  ///
  /// In en, this message translates to:
  /// **'By grade level'**
  String get progressScreen_byGrade;

  /// No description provided for @mathKidBadge_title.
  ///
  /// In en, this message translates to:
  /// **'🎯 MATHKID 🎯'**
  String get mathKidBadge_title;

  /// No description provided for @mathKidBadge_champion.
  ///
  /// In en, this message translates to:
  /// **'Super Champion!'**
  String get mathKidBadge_champion;

  /// No description provided for @badgesSection_title.
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get badgesSection_title;

  /// No description provided for @badgesSection_count.
  ///
  /// In en, this message translates to:
  /// **'{earned}/{total} badges earned'**
  String badgesSection_count(Object earned, Object total);

  /// No description provided for @badgesSection_allUnlocked.
  ///
  /// In en, this message translates to:
  /// **'🎉 All badges unlocked! Champion!'**
  String get badgesSection_allUnlocked;

  /// No description provided for @badgesSection_continueToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Continue to unlock {remaining} badge{plural}!'**
  String badgesSection_continueToUnlock(Object plural, Object remaining);

  /// No description provided for @badgesSection_startPlaying.
  ///
  /// In en, this message translates to:
  /// **'Start solving exercises to earn your first badges!'**
  String get badgesSection_startPlaying;

  /// No description provided for @badgesSection_awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome! Keep going to unlock all badges!'**
  String get badgesSection_awesome;

  /// No description provided for @badgesSection_champion.
  ///
  /// In en, this message translates to:
  /// **'Bravo! You are a true champion! 🌟'**
  String get badgesSection_champion;

  /// No description provided for @badgesSection_tipStart.
  ///
  /// In en, this message translates to:
  /// **'Start solving exercises to earn your first badges!'**
  String get badgesSection_tipStart;

  /// No description provided for @badgesSection_tipKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Awesome! Keep going to unlock all badges!'**
  String get badgesSection_tipKeepGoing;

  /// No description provided for @badgesSection_tipChampion.
  ///
  /// In en, this message translates to:
  /// **'Bravo! You are a true champion! 🌟'**
  String get badgesSection_tipChampion;

  /// No description provided for @badge.
  ///
  /// In en, this message translates to:
  /// **'badge'**
  String get badge;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'badges'**
  String get badges;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'earned'**
  String get earned;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @profileManageInfo.
  ///
  /// In en, this message translates to:
  /// **'Manage your information and access your statistics'**
  String get profileManageInfo;

  /// No description provided for @profileMenu.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get profileMenu;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileFirstnamePseudo.
  ///
  /// In en, this message translates to:
  /// **'First Name / Username'**
  String get profileFirstnamePseudo;

  /// No description provided for @profileClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get profileClass;

  /// No description provided for @profileSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get profileSchool;

  /// No description provided for @profileMottoHobby.
  ///
  /// In en, this message translates to:
  /// **'Motto or Hobby'**
  String get profileMottoHobby;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccess;

  /// No description provided for @profileError.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get profileError;

  /// No description provided for @profileChoosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose your photo'**
  String get profileChoosePhoto;

  /// No description provided for @profileGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profileGallery;

  /// No description provided for @profileSchoolInfo.
  ///
  /// In en, this message translates to:
  /// **'School Information'**
  String get profileSchoolInfo;

  /// No description provided for @profileInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get profileInstitution;

  /// No description provided for @profileStudentNumber.
  ///
  /// In en, this message translates to:
  /// **'Student N°'**
  String get profileStudentNumber;

  /// No description provided for @profileSchoolYear.
  ///
  /// In en, this message translates to:
  /// **'School Year'**
  String get profileSchoolYear;

  /// No description provided for @profileMotto.
  ///
  /// In en, this message translates to:
  /// **'Motto'**
  String get profileMotto;

  /// No description provided for @profileLevelNotDefined.
  ///
  /// In en, this message translates to:
  /// **'Level not defined'**
  String get profileLevelNotDefined;

  /// No description provided for @profileFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get profileFieldRequired;

  /// No description provided for @profileLeaderboards.
  ///
  /// In en, this message translates to:
  /// **'Leaderboards'**
  String get profileLeaderboards;

  /// No description provided for @profileMyProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get profileMyProgress;

  /// No description provided for @profileStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get profileStore;

  /// No description provided for @profileHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profileHelpCenter;

  /// No description provided for @profileSoundMusic.
  ///
  /// In en, this message translates to:
  /// **'Sound & Music'**
  String get profileSoundMusic;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get profileBackHome;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Notifications'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationConfigureReminders.
  ///
  /// In en, this message translates to:
  /// **'Configure your reminders to never miss your math sessions!'**
  String get notificationConfigureReminders;

  /// No description provided for @notificationScheduleReminder.
  ///
  /// In en, this message translates to:
  /// **'Schedule a reminder'**
  String get notificationScheduleReminder;

  /// No description provided for @notificationReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get notificationReminderTime;

  /// No description provided for @notificationHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get notificationHour;

  /// No description provided for @notificationMinute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get notificationMinute;

  /// No description provided for @notificationRepeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Repeat daily'**
  String get notificationRepeatDaily;

  /// No description provided for @notificationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get notificationSchedule;

  /// No description provided for @notificationScheduledAt.
  ///
  /// In en, this message translates to:
  /// **'Notification scheduled at {hour}h{minute} ! ⏰'**
  String notificationScheduledAt(Object hour, Object minute);

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// No description provided for @iWillReceiveReminders.
  ///
  /// In en, this message translates to:
  /// **'I will receive reminders'**
  String get iWillReceiveReminders;

  /// No description provided for @noRemindersWillBeSent.
  ///
  /// In en, this message translates to:
  /// **'No reminders will be sent'**
  String get noRemindersWillBeSent;

  /// No description provided for @notificationsActivated.
  ///
  /// In en, this message translates to:
  /// **'Notifications activated ! 📱'**
  String get notificationsActivated;

  /// No description provided for @notificationsDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Notifications deactivated'**
  String get notificationsDeactivated;

  /// No description provided for @pleaseAllowExactAlarms.
  ///
  /// In en, this message translates to:
  /// **'Please allow exact alarms in your settings.'**
  String get pleaseAllowExactAlarms;

  /// No description provided for @scheduledReminders.
  ///
  /// In en, this message translates to:
  /// **'Scheduled reminders'**
  String get scheduledReminders;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @activeReminders.
  ///
  /// In en, this message translates to:
  /// **'Active reminders'**
  String get activeReminders;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dailyReminders;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @tipsForUsingReminders.
  ///
  /// In en, this message translates to:
  /// **'Tips for using your reminders'**
  String get tipsForUsingReminders;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'🕐 Schedule your sessions when you\'re most focused'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'🔄 Activate daily reminders to create a routine'**
  String get tip2;

  /// No description provided for @newReminder.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get newReminder;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @fieldInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get fieldInvalid;

  /// No description provided for @programNotification.
  ///
  /// In en, this message translates to:
  /// **'Schedule a notification'**
  String get programNotification;

  /// No description provided for @soundSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Settings 🎵'**
  String get soundSettingsTitle;

  /// No description provided for @soundSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your sounds'**
  String get soundSettingsSubtitle;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get soundEffects;

  /// No description provided for @soundEffectsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get soundEffectsActive;

  /// No description provided for @soundEffectsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get soundEffectsDisabled;

  /// No description provided for @backgroundMusic.
  ///
  /// In en, this message translates to:
  /// **'Background music'**
  String get backgroundMusic;

  /// No description provided for @backgroundMusicActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get backgroundMusicActive;

  /// No description provided for @backgroundMusicDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get backgroundMusicDisabled;

  /// No description provided for @sfxVolume.
  ///
  /// In en, this message translates to:
  /// **'Effects volume'**
  String get sfxVolume;

  /// No description provided for @musicVolume.
  ///
  /// In en, this message translates to:
  /// **'Music volume'**
  String get musicVolume;

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'🏪 STORE'**
  String get storeTitle;

  /// No description provided for @storeTabLives.
  ///
  /// In en, this message translates to:
  /// **'Lives'**
  String get storeTabLives;

  /// No description provided for @storeTabGems.
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get storeTabGems;

  /// No description provided for @unlimitedLivesWeek.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Week ! ♾️'**
  String get unlimitedLivesWeek;

  /// No description provided for @unlimitedLivesDescription.
  ///
  /// In en, this message translates to:
  /// **'Enjoy 7 days without losing lives!'**
  String get unlimitedLivesDescription;

  /// No description provided for @chatbotActivated.
  ///
  /// In en, this message translates to:
  /// **'Assistant Activated! 🤖'**
  String get chatbotActivated;

  /// No description provided for @chatbotReadyToHelp.
  ///
  /// In en, this message translates to:
  /// **'MathKid is ready to help you!'**
  String get chatbotReadyToHelp;

  /// No description provided for @gemsReceived.
  ///
  /// In en, this message translates to:
  /// **'Gems Received! {icon}'**
  String gemsReceived(Object icon);

  /// No description provided for @gemsReceivedCount.
  ///
  /// In en, this message translates to:
  /// **'You received {count} gems!'**
  String gemsReceivedCount(Object count);

  /// No description provided for @livesRefilled.
  ///
  /// In en, this message translates to:
  /// **'Lives refilled! 🎉'**
  String get livesRefilled;

  /// No description provided for @readyToContinue.
  ///
  /// In en, this message translates to:
  /// **'You\'re ready to continue the adventure!'**
  String get readyToContinue;

  /// No description provided for @storeError.
  ///
  /// In en, this message translates to:
  /// **'Oops: {error}'**
  String storeError(Object error);

  /// No description provided for @storeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get storeSuccess;

  /// No description provided for @storeUnlimitedLives.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Lives!'**
  String get storeUnlimitedLives;

  /// No description provided for @storeMyLives.
  ///
  /// In en, this message translates to:
  /// **'My Lives'**
  String get storeMyLives;

  /// No description provided for @storeUnlimitedDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'re invincible this week! 🦸'**
  String get storeUnlimitedDescription;

  /// No description provided for @storeNextLife.
  ///
  /// In en, this message translates to:
  /// **'Next life: {time}'**
  String storeNextLife(Object time);

  /// No description provided for @storeSectionLivesBoosts.
  ///
  /// In en, this message translates to:
  /// **'💖 Lives & Boosts'**
  String get storeSectionLivesBoosts;

  /// No description provided for @storeSectionGemPacks.
  ///
  /// In en, this message translates to:
  /// **'💎 Gem Packs'**
  String get storeSectionGemPacks;

  /// No description provided for @storeNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products available...'**
  String get storeNoProducts;

  /// No description provided for @storeTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get storeTryAgain;

  /// No description provided for @storeInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get storeInfoTitle;

  /// No description provided for @storeMaxLives.
  ///
  /// In en, this message translates to:
  /// **'Max {count} lives stored'**
  String storeMaxLives(Object count);

  /// No description provided for @storeLifeRegeneration.
  ///
  /// In en, this message translates to:
  /// **'1 life regenerated every {minutes} minutes'**
  String storeLifeRegeneration(Object minutes);

  /// No description provided for @storeUnlimitedMode.
  ///
  /// In en, this message translates to:
  /// **'Unlimited mode = No life loss!'**
  String get storeUnlimitedMode;

  /// No description provided for @storeGemsInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What are Gems for?'**
  String get storeGemsInfoTitle;

  /// No description provided for @storeHintCost.
  ///
  /// In en, this message translates to:
  /// **'Hint: {gems} gems'**
  String storeHintCost(Object gems);

  /// No description provided for @storeSkipQuestionCost.
  ///
  /// In en, this message translates to:
  /// **'Skip a question: {gems} gems'**
  String storeSkipQuestionCost(Object gems);

  /// No description provided for @storeFastRechargeCost.
  ///
  /// In en, this message translates to:
  /// **'Fast life recharge: {gems} gems'**
  String storeFastRechargeCost(Object gems);

  /// No description provided for @storeUnlockThemesCost.
  ///
  /// In en, this message translates to:
  /// **'Unlock themes: {gems} gems'**
  String storeUnlockThemesCost(Object gems);

  /// No description provided for @storeBadgePopular.
  ///
  /// In en, this message translates to:
  /// **'Popular 🔥'**
  String get storeBadgePopular;

  /// No description provided for @storeBadgeBestOffer.
  ///
  /// In en, this message translates to:
  /// **'Best Offer 🌟'**
  String get storeBadgeBestOffer;

  /// No description provided for @storeBadgeNew.
  ///
  /// In en, this message translates to:
  /// **'New 🤖'**
  String get storeBadgeNew;

  /// No description provided for @storeBadgeBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value 💎'**
  String get storeBadgeBestValue;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required! 🚀'**
  String get updateRequiredTitle;

  /// No description provided for @updateNewVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get updateNewVersionAvailable;

  /// No description provided for @updateAppImproving.
  ///
  /// In en, this message translates to:
  /// **'MathsCool is improving!'**
  String get updateAppImproving;

  /// No description provided for @updateDescription.
  ///
  /// In en, this message translates to:
  /// **'To enjoy the latest features and continue your math adventure, update the app now!'**
  String get updateDescription;

  /// No description provided for @updateWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new:'**
  String get updateWhatsNew;

  /// No description provided for @updateFeatureInfiniteMode.
  ///
  /// In en, this message translates to:
  /// **'♾️ Infinite Mode'**
  String get updateFeatureInfiniteMode;

  /// No description provided for @updateFeatureAchievements.
  ///
  /// In en, this message translates to:
  /// **'🏆 60+ Achievements'**
  String get updateFeatureAchievements;

  /// No description provided for @updateFeatureModernDesign.
  ///
  /// In en, this message translates to:
  /// **'🎨 Modern design'**
  String get updateFeatureModernDesign;

  /// No description provided for @updateFeatureAIAssistant.
  ///
  /// In en, this message translates to:
  /// **'🤖 AI Assistant'**
  String get updateFeatureAIAssistant;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateButton;

  /// No description provided for @updateVersionRequired.
  ///
  /// In en, this message translates to:
  /// **'Version {version} required'**
  String updateVersionRequired(Object version);

  /// No description provided for @updateDontMissFeatures.
  ///
  /// In en, this message translates to:
  /// **'✨ Don\'t miss the new features! ✨'**
  String get updateDontMissFeatures;

  /// No description provided for @chatbotLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit reached! 🚀'**
  String get chatbotLimitReached;

  /// No description provided for @chatbotFreeQuestionsUsed.
  ///
  /// In en, this message translates to:
  /// **'You have used your 3 free questions for today!'**
  String get chatbotFreeQuestionsUsed;

  /// No description provided for @chatbotSubscribePrompt.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to ask as many questions as you want to MathKid! 🚀'**
  String get chatbotSubscribePrompt;

  /// No description provided for @chatbotLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get chatbotLater;

  /// No description provided for @chatbotDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover ✨'**
  String get chatbotDiscover;

  /// No description provided for @gemsMyGems.
  ///
  /// In en, this message translates to:
  /// **'My Gems'**
  String get gemsMyGems;

  /// No description provided for @gemsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get gemsCurrent;

  /// No description provided for @gemsSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get gemsSpent;

  /// No description provided for @progressChartTitle.
  ///
  /// In en, this message translates to:
  /// **'My progress'**
  String get progressChartTitle;

  /// No description provided for @progressNoData.
  ///
  /// In en, this message translates to:
  /// **'No data for the moment'**
  String get progressNoData;

  /// No description provided for @themeBadgeLevel.
  ///
  /// In en, this message translates to:
  /// **'Niv.{level}'**
  String themeBadgeLevel(Object level);

  /// No description provided for @themeBadgeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get themeBadgeLocked;

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language 🌍'**
  String get chooseYourLanguage;

  /// No description provided for @questionSkipped.
  ///
  /// In en, this message translates to:
  /// **'Question skipped! ⏭️'**
  String get questionSkipped;

  /// No description provided for @storeHintLabel.
  ///
  /// In en, this message translates to:
  /// **'Hint 💡'**
  String get storeHintLabel;

  /// No description provided for @achievementFirstSteps.
  ///
  /// In en, this message translates to:
  /// **'First steps'**
  String get achievementFirstSteps;

  /// No description provided for @achievementFirstStepsDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve your first exercise'**
  String get achievementFirstStepsDesc;

  /// No description provided for @achievementGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started!'**
  String get achievementGettingStarted;

  /// No description provided for @achievementGettingStartedDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 5 exercises'**
  String get achievementGettingStartedDesc;

  /// No description provided for @achievementOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get achievementOnTrack;

  /// No description provided for @achievementOnTrackDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 15 exercises'**
  String get achievementOnTrackDesc;

  /// No description provided for @achievementBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get achievementBeginner;

  /// No description provided for @achievementBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 25 exercises'**
  String get achievementBeginnerDesc;

  /// No description provided for @achievementLearner.
  ///
  /// In en, this message translates to:
  /// **'Learner'**
  String get achievementLearner;

  /// No description provided for @achievementLearnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 50 exercises'**
  String get achievementLearnerDesc;

  /// No description provided for @achievementStudent.
  ///
  /// In en, this message translates to:
  /// **'Studious student'**
  String get achievementStudent;

  /// No description provided for @achievementStudentDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 75 exercises'**
  String get achievementStudentDesc;

  /// No description provided for @achievementSkilled.
  ///
  /// In en, this message translates to:
  /// **'Skilled'**
  String get achievementSkilled;

  /// No description provided for @achievementSkilledDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 100 exercises'**
  String get achievementSkilledDesc;

  /// No description provided for @achievementExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get achievementExpert;

  /// No description provided for @achievementExpertDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 150 exercises'**
  String get achievementExpertDesc;

  /// No description provided for @achievementMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get achievementMaster;

  /// No description provided for @achievementMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 200 exercises'**
  String get achievementMasterDesc;

  /// No description provided for @achievementChampion.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get achievementChampion;

  /// No description provided for @achievementChampionDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 300 exercises'**
  String get achievementChampionDesc;

  /// No description provided for @achievementLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get achievementLegend;

  /// No description provided for @achievementLegendDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 500 exercises'**
  String get achievementLegendDesc;

  /// No description provided for @achievementPerfectionist.
  ///
  /// In en, this message translates to:
  /// **'Perfectionist'**
  String get achievementPerfectionist;

  /// No description provided for @achievementPerfectionistDesc.
  ///
  /// In en, this message translates to:
  /// **'Get a perfect score'**
  String get achievementPerfectionistDesc;

  /// No description provided for @achievementFlawlessTrio.
  ///
  /// In en, this message translates to:
  /// **'Perfect trio'**
  String get achievementFlawlessTrio;

  /// No description provided for @achievementFlawlessTrioDesc.
  ///
  /// In en, this message translates to:
  /// **'Get 3 perfect scores'**
  String get achievementFlawlessTrioDesc;

  /// No description provided for @achievementPerfectFive.
  ///
  /// In en, this message translates to:
  /// **'Perfect hand'**
  String get achievementPerfectFive;

  /// No description provided for @achievementPerfectFiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Get 5 perfect scores'**
  String get achievementPerfectFiveDesc;

  /// No description provided for @achievementPerfectTen.
  ///
  /// In en, this message translates to:
  /// **'Absolute perfection'**
  String get achievementPerfectTen;

  /// No description provided for @achievementPerfectTenDesc.
  ///
  /// In en, this message translates to:
  /// **'Get 10 perfect scores'**
  String get achievementPerfectTenDesc;

  /// No description provided for @achievementPerfectMaster.
  ///
  /// In en, this message translates to:
  /// **'Perfect master'**
  String get achievementPerfectMaster;

  /// No description provided for @achievementPerfectMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Get 20 perfect scores'**
  String get achievementPerfectMasterDesc;

  /// No description provided for @achievementDailyPlayer.
  ///
  /// In en, this message translates to:
  /// **'Daily player'**
  String get achievementDailyPlayer;

  /// No description provided for @achievementDailyPlayerDesc.
  ///
  /// In en, this message translates to:
  /// **'Play 3 days in a row'**
  String get achievementDailyPlayerDesc;

  /// No description provided for @achievementCommitted.
  ///
  /// In en, this message translates to:
  /// **'Committed'**
  String get achievementCommitted;

  /// No description provided for @achievementCommittedDesc.
  ///
  /// In en, this message translates to:
  /// **'Play 5 days in a row'**
  String get achievementCommittedDesc;

  /// No description provided for @achievementWeeklyWarrior.
  ///
  /// In en, this message translates to:
  /// **'Weekly warrior'**
  String get achievementWeeklyWarrior;

  /// No description provided for @achievementWeeklyWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Play 7 days in a row'**
  String get achievementWeeklyWarriorDesc;

  /// No description provided for @achievementTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'Fortnight fighter'**
  String get achievementTwoWeeks;

  /// No description provided for @achievementTwoWeeksDesc.
  ///
  /// In en, this message translates to:
  /// **'Play 14 days in a row'**
  String get achievementTwoWeeksDesc;

  /// No description provided for @achievementMonthlyMaster.
  ///
  /// In en, this message translates to:
  /// **'Monthly master'**
  String get achievementMonthlyMaster;

  /// No description provided for @achievementMonthlyMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Play 30 days in a row'**
  String get achievementMonthlyMasterDesc;

  /// No description provided for @achievementInfiniteBeginner.
  ///
  /// In en, this message translates to:
  /// **'Infinite beginner'**
  String get achievementInfiniteBeginner;

  /// No description provided for @achievementInfiniteBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 25 infinite mode exercises'**
  String get achievementInfiniteBeginnerDesc;

  /// No description provided for @achievementInfiniteExplorer.
  ///
  /// In en, this message translates to:
  /// **'Infinite explorer'**
  String get achievementInfiniteExplorer;

  /// No description provided for @achievementInfiniteExplorerDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 50 infinite mode exercises'**
  String get achievementInfiniteExplorerDesc;

  /// No description provided for @achievementInfiniteWarrior.
  ///
  /// In en, this message translates to:
  /// **'Infinite warrior'**
  String get achievementInfiniteWarrior;

  /// No description provided for @achievementInfiniteWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 100 infinite mode exercises'**
  String get achievementInfiniteWarriorDesc;

  /// No description provided for @achievementInfiniteMaster.
  ///
  /// In en, this message translates to:
  /// **'Master of infinity'**
  String get achievementInfiniteMaster;

  /// No description provided for @achievementInfiniteMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 200 infinite mode exercises'**
  String get achievementInfiniteMasterDesc;

  /// No description provided for @achievementNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night owl'**
  String get achievementNightOwl;

  /// No description provided for @achievementNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Play between midnight and 6 AM'**
  String get achievementNightOwlDesc;

  /// No description provided for @achievementEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early bird'**
  String get achievementEarlyBird;

  /// No description provided for @achievementEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Play between 5 AM and 7 AM'**
  String get achievementEarlyBirdDesc;

  /// No description provided for @achievementWeekendWarrior.
  ///
  /// In en, this message translates to:
  /// **'Weekend warrior'**
  String get achievementWeekendWarrior;

  /// No description provided for @achievementWeekendWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Play every weekend for a month'**
  String get achievementWeekendWarriorDesc;

  /// No description provided for @achievementLuckySeven.
  ///
  /// In en, this message translates to:
  /// **'Lucky seven'**
  String get achievementLuckySeven;

  /// No description provided for @achievementLuckySevenDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve 777 exercises'**
  String get achievementLuckySevenDesc;

  /// No description provided for @notifMotivational1.
  ///
  /// In en, this message translates to:
  /// **'Time to make some mathematical magic! ✨'**
  String get notifMotivational1;

  /// No description provided for @notifMotivational2.
  ///
  /// In en, this message translates to:
  /// **'Your number friends are waiting for you! 🔢'**
  String get notifMotivational2;

  /// No description provided for @notifMotivational3.
  ///
  /// In en, this message translates to:
  /// **'Come discover new math challenges! 🎯'**
  String get notifMotivational3;

  /// No description provided for @notifMotivational4.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to become a math superhero! 🦸‍♂️'**
  String get notifMotivational4;

  /// No description provided for @notifMotivational5.
  ///
  /// In en, this message translates to:
  /// **'The equations are calling! Ready to play? 🎮'**
  String get notifMotivational5;

  /// No description provided for @notifMotivational6.
  ///
  /// In en, this message translates to:
  /// **'Transform yourself into a math genius! 🧠'**
  String get notifMotivational6;

  /// No description provided for @notifMotivational7.
  ///
  /// In en, this message translates to:
  /// **'A new math adventure awaits you! 🌟'**
  String get notifMotivational7;

  /// No description provided for @notifMotivational8.
  ///
  /// In en, this message translates to:
  /// **'Come show your math talents! 💪'**
  String get notifMotivational8;

  /// No description provided for @notifMotivational9.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go for a fun math session! 🎉'**
  String get notifMotivational9;

  /// No description provided for @notifMotivational10.
  ///
  /// In en, this message translates to:
  /// **'Your neurons want to calculate! 🧮'**
  String get notifMotivational10;

  /// No description provided for @notifMotivational11.
  ///
  /// In en, this message translates to:
  /// **'Numbers have prepared surprises for you! 🎁'**
  String get notifMotivational11;

  /// No description provided for @notifMotivational12.
  ///
  /// In en, this message translates to:
  /// **'Ready to solve math mysteries? 🔍'**
  String get notifMotivational12;

  /// No description provided for @notifMotivational13.
  ///
  /// In en, this message translates to:
  /// **'Time to make your brain shine! ✨'**
  String get notifMotivational13;

  /// No description provided for @notifMotivational14.
  ///
  /// In en, this message translates to:
  /// **'Come collect new achievements! 🏆'**
  String get notifMotivational14;

  /// No description provided for @notifMotivational15.
  ///
  /// In en, this message translates to:
  /// **'A dose of math to start well! ☀️'**
  String get notifMotivational15;

  /// No description provided for @notifMotivational16.
  ///
  /// In en, this message translates to:
  /// **'A new lesson awaits you! 🌟'**
  String get notifMotivational16;

  /// No description provided for @notifMotivational17.
  ///
  /// In en, this message translates to:
  /// **'Ready for your learning session? 💫'**
  String get notifMotivational17;

  /// No description provided for @notifAchievement1.
  ///
  /// In en, this message translates to:
  /// **'🏆 Psst... A new trophy might be waiting for you!'**
  String get notifAchievement1;

  /// No description provided for @notifAchievement2.
  ///
  /// In en, this message translates to:
  /// **'🥇 Come unlock your next Expert badge!'**
  String get notifAchievement2;

  /// No description provided for @notifAchievement3.
  ///
  /// In en, this message translates to:
  /// **'🚀 You\'re close to the goal! Come progress in your achievements.'**
  String get notifAchievement3;

  /// No description provided for @notifAchievement4.
  ///
  /// In en, this message translates to:
  /// **'🔥 Keep the pace! New rewards are available.'**
  String get notifAchievement4;

  /// No description provided for @notifAchievement5.
  ///
  /// In en, this message translates to:
  /// **'👑 Become the King of the category today!'**
  String get notifAchievement5;

  /// No description provided for @notifAchievement6.
  ///
  /// In en, this message translates to:
  /// **'🎯 Objective in sight: Come complete your missions!'**
  String get notifAchievement6;

  /// No description provided for @notifAchievement7.
  ///
  /// In en, this message translates to:
  /// **'🌟 Your badges feel lonely... Come earn more!'**
  String get notifAchievement7;

  /// No description provided for @notifAchievement8.
  ///
  /// In en, this message translates to:
  /// **'💪 Show us your talents and earn lives!'**
  String get notifAchievement8;

  /// No description provided for @notifDailyChallenge1.
  ///
  /// In en, this message translates to:
  /// **'⏰ Today\'s challenge expires soon! Don\'t miss it!'**
  String get notifDailyChallenge1;

  /// No description provided for @notifDailyChallenge2.
  ///
  /// In en, this message translates to:
  /// **'🎯 A crispy challenge awaits you today!'**
  String get notifDailyChallenge2;

  /// No description provided for @notifDailyChallenge3.
  ///
  /// In en, this message translates to:
  /// **'🔥 Your daily challenge is ready! Come conquer it!'**
  String get notifDailyChallenge3;

  /// No description provided for @notifDailyChallenge4.
  ///
  /// In en, this message translates to:
  /// **'⭐ Earn stars with today\'s challenge!'**
  String get notifDailyChallenge4;

  /// No description provided for @notifDailyChallenge5.
  ///
  /// In en, this message translates to:
  /// **'🚀 Today\'s challenge will boost your ranking!'**
  String get notifDailyChallenge5;

  /// No description provided for @notifDailyChallenge6.
  ///
  /// In en, this message translates to:
  /// **'💎 A unique challenge for you today! Go!'**
  String get notifDailyChallenge6;

  /// No description provided for @notifDailyChallenge7.
  ///
  /// In en, this message translates to:
  /// **'🎪 Today\'s challenge is here! Your turn to play!'**
  String get notifDailyChallenge7;

  /// No description provided for @notifDailyChallenge8.
  ///
  /// In en, this message translates to:
  /// **'⚡ Flash challenge: Show what you\'re worth today!'**
  String get notifDailyChallenge8;

  /// No description provided for @notifDailyChallenge9.
  ///
  /// In en, this message translates to:
  /// **'🎁 Today\'s gift: A super challenge just for you!'**
  String get notifDailyChallenge9;

  /// No description provided for @notifDailyChallenge10.
  ///
  /// In en, this message translates to:
  /// **'🌟 Complete the challenge and shine on the leaderboard!'**
  String get notifDailyChallenge10;

  /// No description provided for @notifLeaderboard1.
  ///
  /// In en, this message translates to:
  /// **'🏆 Don\'t let {name} beat your record!'**
  String notifLeaderboard1(Object name);

  /// No description provided for @notifLeaderboard2.
  ///
  /// In en, this message translates to:
  /// **'👑 {name} is ahead of you! Catch up!'**
  String notifLeaderboard2(Object name);

  /// No description provided for @notifLeaderboard3.
  ///
  /// In en, this message translates to:
  /// **'⚔️ Duel at the top with {name}! Who will be #1?'**
  String notifLeaderboard3(Object name);

  /// No description provided for @notifLeaderboard4.
  ///
  /// In en, this message translates to:
  /// **'🥇 {name} got a perfect score! Your turn to do better!'**
  String notifLeaderboard4(Object name);

  /// No description provided for @notifLeaderboard5.
  ///
  /// In en, this message translates to:
  /// **'📈 {name} is climbing fast! Defend your position!'**
  String notifLeaderboard5(Object name);

  /// No description provided for @notifLeaderboard6.
  ///
  /// In en, this message translates to:
  /// **'💪 {name} is just ahead of you! Surpass them!'**
  String notifLeaderboard6(Object name);

  /// No description provided for @notifLeaderboard7.
  ///
  /// In en, this message translates to:
  /// **'🎯 {name} is aiming for the podium, and you?'**
  String notifLeaderboard7(Object name);

  /// No description provided for @notifLeaderboard8.
  ///
  /// In en, this message translates to:
  /// **'🔥 {name} earned 3 stars! Match their score!'**
  String notifLeaderboard8(Object name);

  /// No description provided for @notifLeaderboard9.
  ///
  /// In en, this message translates to:
  /// **'⭐ {name} shines on the leaderboard! Show your talent!'**
  String notifLeaderboard9(Object name);

  /// No description provided for @notifLeaderboard10.
  ///
  /// In en, this message translates to:
  /// **'🚀 {name} is launched! Don\'t get left behind!'**
  String notifLeaderboard10(Object name);

  /// No description provided for @notifChannelAchievements.
  ///
  /// In en, this message translates to:
  /// **'Trophy Reminders'**
  String get notifChannelAchievements;

  /// No description provided for @notifChannelAchievementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders to unlock achievements and badges'**
  String get notifChannelAchievementsDesc;

  /// No description provided for @notifChannelDailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get notifChannelDailyChallenge;

  /// No description provided for @notifChannelDailyChallengeDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders for the daily challenge'**
  String get notifChannelDailyChallengeDesc;

  /// No description provided for @notifChannelLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get notifChannelLeaderboard;

  /// No description provided for @notifChannelLeaderboardDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders to climb the leaderboard'**
  String get notifChannelLeaderboardDesc;

  /// No description provided for @notifChannelLives.
  ///
  /// In en, this message translates to:
  /// **'Lives Refilled'**
  String get notifChannelLives;

  /// No description provided for @notifChannelLivesDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications when lives are full'**
  String get notifChannelLivesDesc;

  /// No description provided for @notifChannelImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediate notifications'**
  String get notifChannelImmediate;

  /// No description provided for @notifTitleAchievements.
  ///
  /// In en, this message translates to:
  /// **'New achievements available! 🏆'**
  String get notifTitleAchievements;

  /// No description provided for @notifTitleDailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge available! 🎯'**
  String get notifTitleDailyChallenge;

  /// No description provided for @notifTitleLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Climb the leaderboard! 🏅'**
  String get notifTitleLeaderboard;

  /// No description provided for @notifTitleLivesRefilled.
  ///
  /// In en, this message translates to:
  /// **'Lives at max! ❤️'**
  String get notifTitleLivesRefilled;

  /// No description provided for @notifBodyLivesRefilled.
  ///
  /// In en, this message translates to:
  /// **'Hey {name}, your lives are refilled! Come play! 🎮'**
  String notifBodyLivesRefilled(Object name);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
