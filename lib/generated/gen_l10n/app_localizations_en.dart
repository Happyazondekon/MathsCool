// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MathsCool';

  @override
  String get helloChampion => 'Hello champion! 👋';

  @override
  String helloUser(Object name) {
    return 'Hello $name!';
  }

  @override
  String goodMorning(Object name) {
    return 'Hello $name!';
  }

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get iAmMathKid => 'I am MathKid, your personal math assistant!';

  @override
  String get askMeQuestion => 'Ask me a question';

  @override
  String get aboutAnyMathTopic => 'About any math topic!';

  @override
  String get simpleExplanations => 'Simple explanations';

  @override
  String get iExplainComplex => 'I explain complex concepts simply';

  @override
  String get usernameAlreadyUsed => 'This name is already used';

  @override
  String get usernameUpdated => 'Your name has been updated! 🎉';

  @override
  String get usernameTitle => 'Your Username';

  @override
  String get chooseAppearance => 'Choose how you want to appear';

  @override
  String get usernameExample => 'Ex: SuperMath123';

  @override
  String get usernameInfo => '3-20 characters • Visible by all';

  @override
  String get suggestions => '💡 Suggestions :';

  @override
  String get generateSuggestions => 'Generate suggestions';

  @override
  String get chooseMode => 'Choose your mode';

  @override
  String get howToTrain => 'How do you want to train?';

  @override
  String get normalMode => 'Normal Mode';

  @override
  String get progressiveExercises => '20 progressive exercises';

  @override
  String get infiniteMode => 'Infinite Mode';

  @override
  String get unlimitedTraining => 'Unlimited training';

  @override
  String get selectTheme => 'Select a theme';

  @override
  String themesAvailable(Object count) {
    return '$count themes available';
  }

  @override
  String get comingSoon => 'Soon';

  @override
  String get noData => 'No data for the moment';

  @override
  String get retry => 'Retry';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get choosePhoto => 'Choose your photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get timeBonus => '⏰ +5 seconds added! (-5 💎)';

  @override
  String get themeRelativeNumbers => 'Relative Numbers';

  @override
  String get themeFractions => 'Fractions';

  @override
  String get themeAlgebra => 'Algebra';

  @override
  String get themePowers => 'Powers';

  @override
  String get themeTheorems => 'Theorems';

  @override
  String get themeStatistics => 'Statistics';

  @override
  String get themeAddition => 'Addition';

  @override
  String get themeSubtraction => 'Subtraction';

  @override
  String get themeMultiplication => 'Multiplication';

  @override
  String get themeDivision => 'Division';

  @override
  String get themeGeometry => 'Geometry';

  @override
  String get welcomeTitle => 'Welcome to MathsCool';

  @override
  String get connectToContinue => 'Log in to continue';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get min6Chars => 'Minimum 6 characters';

  @override
  String get login => 'Log in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get newToMathsCool => 'New to MathsCool? ';

  @override
  String get createAccount => 'Create an account';

  @override
  String get createAccountTitle => 'Create an account';

  @override
  String get joinMathsCool => 'Join MathsCool to get started';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get noLivesTitle => 'No more lives!';

  @override
  String get needRestOrBoost => 'You need rest or a boost! 💖';

  @override
  String get waitForRechargeOrVisitStore => 'Wait for them to recharge or visit the store.';

  @override
  String get later => 'Later';

  @override
  String get recharge => 'Recharge';

  @override
  String get startPlaying => 'Start playing';

  @override
  String get emailSent => 'Email sent!';

  @override
  String get checkEmailReset => 'Check your email to reset your password.';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get forgotPasswordTitle => 'Forgot password?';

  @override
  String get enterEmailReset => 'Enter your email to receive a reset link';

  @override
  String get sendLink => 'Send link';

  @override
  String get verificationEmailSent => 'Verification email sent. Check your inbox and spam folder.';

  @override
  String get errorSendingEmail => 'Error sending email: ';

  @override
  String get verifyYourEmail => 'Verify your Email';

  @override
  String verificationLinkSent(Object email) {
    return 'A verification link has been sent to $email.';
  }

  @override
  String get resendEmail => 'Resend email';

  @override
  String resendIn(Object seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get useAnotherAccount => 'Use another account';

  @override
  String get requestLimitReached => 'Request limit reached';

  @override
  String get sorryCantRespond => 'Sorry, I can\'t respond right now. 🤖\nTry rephrasing your question!';

  @override
  String get pauseNeeded => 'Pause needed! ⏸️';

  @override
  String get usedFreeQuestions => 'You have used your 3 free questions for today.';

  @override
  String get seeUnlimitedOffers => 'See unlimited offers 🚀';

  @override
  String get comeBackTomorrow => 'Come back tomorrow';

  @override
  String get mathKidAssistant => 'MathKid Assistant';

  @override
  String get alwaysReadyToHelp => 'Always ready to help you!';

  @override
  String get concreteExamples => 'Concrete examples';

  @override
  String get withRealLifeExamples => 'With real life examples';

  @override
  String get mathKidThinking => 'MathKid is thinking...';

  @override
  String get askMathQuestion => 'Ask your math question...';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours h ago';
  }

  @override
  String get error => 'Error: ';

  @override
  String get rewardClaimed => 'Reward claimed! 🎉';

  @override
  String get gemsEarned => 'Earned';

  @override
  String get awesome => 'Awesome! 🎉';

  @override
  String get achievements => 'Achievements';

  @override
  String get collectRewards => 'Collect your rewards! 🏆';

  @override
  String get completed => 'Completed';

  @override
  String get toClaim => 'To claim';

  @override
  String get gemsAvailable => 'Gems avail.';

  @override
  String get overallProgress => 'Overall progress';

  @override
  String get all => 'All';

  @override
  String get noAchievementsToClaim => 'No achievements to claim';

  @override
  String get noCompletedAchievements => 'No completed achievements';

  @override
  String get startPlayingToUnlock => 'Start playing to unlock!';

  @override
  String get keepPlayingToEarn => 'Keep playing to earn more!';

  @override
  String get achievementsWillAppearHere => 'Achievements will appear here';

  @override
  String get secretAchievement => '???';

  @override
  String get secretAchievementDescription => 'Secret achievement to discover...';

  @override
  String get claim => 'Claim';

  @override
  String get resultTitle => 'RESULT';

  @override
  String get fantastic => '🎉 FANTASTIC ! 🎉';

  @override
  String get yourScore => 'YOUR SCORE';

  @override
  String get pts => 'PTS';

  @override
  String get performance => 'PERFORMANCE';

  @override
  String starsOutOfThree(Object stars) {
    return '$stars/3 stars';
  }

  @override
  String get time => 'Time';

  @override
  String get score => 'Score';

  @override
  String get viewLeaderboard => 'VIEW LEADERBOARD';

  @override
  String get back => 'BACK';

  @override
  String get wellPlayed => '💪 WELL PLAYED ! 💪';

  @override
  String get notEnoughGems => 'Not enough gems!';

  @override
  String get dailyChallengeTitle => 'Daily Challenge 🎯';

  @override
  String get dailyChallengeSubtitle => 'Complete your daily challenge!';

  @override
  String get dailyChallengeSelectLevel => 'Choose your level';

  @override
  String get dailyChallengeForBeginners => 'For beginners';

  @override
  String get dailyChallengeFirstCalculations => 'First calculations';

  @override
  String get dailyChallengeMathBasics => 'Math basics';

  @override
  String get dailyChallengeIntermediateLevel => 'Intermediate level';

  @override
  String get dailyChallengeAdvancedLevel => 'Advanced level';

  @override
  String get dailyChallengeExpert => 'Expert';

  @override
  String get dailyChallengeCollegeEntry => 'Middle school entry';

  @override
  String get dailyChallengeCentralLevel => 'Central level';

  @override
  String get dailyChallengeDeepening => 'Deepening';

  @override
  String get dailyChallengeBrevetPrep => 'Diploma preparation';

  @override
  String get dailyChallengeCollege => 'Middle school';

  @override
  String get dailyChallengeNotEnoughGems => 'Not enough gems! 💎';

  @override
  String get dailyChallengeNeedGems => 'You need 5 gems to add 5 seconds.';

  @override
  String get dailyChallengeCancel => 'Cancel';

  @override
  String get dailyChallengeStore => 'Store 💎';

  @override
  String get dailyChallengeAddTime => 'Add time ⏰';

  @override
  String get dailyChallengeConfirmAddTime => 'Do you want to use 5 gems to add 5 seconds?';

  @override
  String get dailyChallengeCurrentGems => 'Current gems:';

  @override
  String get dailyChallengeNo => 'No';

  @override
  String get dailyChallengeYes => 'Yes';

  @override
  String get dailyChallengeTimeAdded => '⏰ +5 seconds added! (-5 💎)';

  @override
  String get dailyChallengeTimeUp => 'Time\'s up! ⏰';

  @override
  String get dailyChallengeTimeUpMessage => 'The 5 minutes are over!';

  @override
  String dailyChallengeTimeUpScore(Object score) {
    return 'Score obtained: $score points';
  }

  @override
  String get dailyChallengeFinish => 'Finish';

  @override
  String get dailyChallengeQuit => 'Quit';

  @override
  String get dailyChallengeQuitConfirm => 'Do you really want to quit?';

  @override
  String get dailyChallengeQuitWarning => 'You will lose your current progress.';

  @override
  String get dailyChallengeStay => 'Stay';

  @override
  String get dailyChallengeLeave => 'Leave';

  @override
  String get dailyChallengeLostLife => 'Oops! 💔';

  @override
  String get dailyChallengeLostLifeMessage => 'You lost a life!';

  @override
  String dailyChallengeLivesRemaining(Object lives) {
    return 'Lives remaining: $lives';
  }

  @override
  String get dailyChallengeGameOver => 'Game Over! 💔';

  @override
  String get dailyChallengeNoMoreLives => 'You have no more lives!';

  @override
  String get dailyChallengeWaitForLives => 'Wait for your lives to recharge or get some from the store.';

  @override
  String get dailyChallengeRetry => 'Retry';

  @override
  String get dailyChallengeOk => 'OK';

  @override
  String get dailyChallengeCompleted => 'Challenge already completed today! 🎉';

  @override
  String get dailyChallengeCompletedMessage => 'You have already completed today\'s challenge!';

  @override
  String dailyChallengeCompletedScore(Object score) {
    return 'Score obtained: $score points';
  }

  @override
  String dailyChallengeCompletedTime(Object time) {
    return 'Time: $time';
  }

  @override
  String get dailyChallengeComeBackTomorrow => 'Come back tomorrow for a new challenge!';

  @override
  String get dailyChallengeBackToHome => 'Back to home';

  @override
  String dailyChallengeScore(Object score) {
    return 'Score: $score';
  }

  @override
  String dailyChallengeQuestion(Object current, Object total) {
    return 'Question $current/$total';
  }

  @override
  String get dailyChallengeNoExercises => 'No exercises available for this level';

  @override
  String get dailyChallengeLoading => 'Loading challenge...';

  @override
  String get dailyChallengeReportBug => 'Report a bug 🐛';

  @override
  String get dailyChallengeReportSuccess => 'Thanks! The bug has been reported. 🙏';

  @override
  String get dailyChallengeCheckAnswer => 'Check';

  @override
  String get dailyChallengeNext => 'Next';

  @override
  String get dailyChallengeSaving => 'Saving...';

  @override
  String get dailyChallengeGoodAnswer => 'Correct answer! 🎉';

  @override
  String get dailyChallengeWrongAnswer => 'Wrong answer';

  @override
  String dailyChallengeCorrectAnswer(Object answer) {
    return 'Answer: $answer';
  }

  @override
  String get dailyChallengeButtonTitle => 'Daily Challenge';

  @override
  String get dailyChallengeButtonSubtitle => '10 exercises • Win stars!';

  @override
  String get dailyChallengeButtonNew => 'NEW';

  @override
  String get levelSelectionTitle => 'Choose your level';

  @override
  String get levelSelectionHint => 'Choose the level that matches your class';

  @override
  String get levelForBeginners => 'For beginners';

  @override
  String get levelFirstCalculations => 'First calculations';

  @override
  String get levelMathBasics => 'Math basics';

  @override
  String get levelIntermediate => 'Intermediate level';

  @override
  String get levelAdvanced => 'Advanced level';

  @override
  String get levelExpert => 'Expert';

  @override
  String get levelCollegeEntry => 'Middle school entry';

  @override
  String get levelCentral => 'Central level';

  @override
  String get levelDeepening => 'Deepening';

  @override
  String get levelBrevetPrep => 'Diploma preparation';

  @override
  String get levelCollegeBadge => 'Middle school';

  @override
  String get generatingInfinite => 'Generating infinite...';

  @override
  String get preparingExercises => 'Preparing exercises...';

  @override
  String get exercisesInPreparation => 'Exercises in preparation! 🚧';

  @override
  String teacherPreparing(Object theme) {
    return 'The teacher is preparing $theme subjects';
  }

  @override
  String get indice => 'Hint 💡';

  @override
  String correctAnswerIs(Object answer) {
    return 'The correct answer is: $answer';
  }

  @override
  String get understood => 'Got it!';

  @override
  String get notEnoughGemsTitle => 'Not enough Gems 💎';

  @override
  String missingGemsNeed(Object missing) {
    return 'You are missing $missing gems.\nVisit the store to get some!';
  }

  @override
  String get close => 'Close';

  @override
  String get store => 'Store 🛒';

  @override
  String get offlineMode => 'Offline mode';

  @override
  String get loadingError => '⚠️ Loading error';

  @override
  String get goodAnswerColl => 'Excellent! Correct answer ✅';

  @override
  String get goodAnswerPrim => 'Bravo! 🥳 That\'s correct 🎉';

  @override
  String get wrongAnswer => 'Oops! You lost a life 💔';

  @override
  String get achievementUnlocked => '🎉 Achievement unlocked!';

  @override
  String get noMoreLives => 'Ouch! No more lives 💔';

  @override
  String get usedAllLives => 'You used all your lives for now.';

  @override
  String get waitOrRecover => 'You can wait for them to recharge or recover some now!';

  @override
  String get quit => 'Quit';

  @override
  String hintCost(Object gems) {
    return 'Hint ($gems💎)';
  }

  @override
  String skipCost(Object gems) {
    return 'Skip ($gems💎)';
  }

  @override
  String get expertTitle => '🎉 You are an Expert! 🎉';

  @override
  String get goodJobTitle => '🌟 Good job! 🌟';

  @override
  String get courageTitle => '🙂 Courage!';

  @override
  String get mathkidTitle => '🎉 You are a Mathkid! 🎉';

  @override
  String get onRightTrackTitle => '🌟 You are on the right track! 🌟';

  @override
  String get almostMathkidTitle => '🙂 Almost a Mathkid!';

  @override
  String get perfectMastery => 'Perfect! You master perfectly! 🎯';

  @override
  String get excellentWork => 'Excellent work! Keep it up! 💪';

  @override
  String get askForHelp => 'Don\'t hesitate to ask for help to improve! 📚';

  @override
  String get seeMyProgress => 'See my progress';

  @override
  String get consultManual => 'Consult the Manual';

  @override
  String get returnn => 'Return';

  @override
  String get replay => 'Replay';

  @override
  String question(Object number) {
    return 'Question $number';
  }

  @override
  String get dailyChallengeConfirm => 'Confirm ✨';

  @override
  String get dailyChallengeSeeResult => 'See the result';

  @override
  String get dailyChallengeQuitText => 'Quit';

  @override
  String dailyChallengeYourGems(Object gems) {
    return 'Your gems: $gems';
  }

  @override
  String get dailyChallengeErrorLoading => 'Error loading challenge';

  @override
  String get dailyChallengeNoData => 'No challenge data available';

  @override
  String get dailyChallengeAlreadyCompleted => 'Challenge already completed today! 🎉';

  @override
  String get dailyChallengeAlreadyCompletedMessage => 'Come back tomorrow for a new challenge!';

  @override
  String get dailyChallengeBack => 'Back';

  @override
  String get dailyChallengeBrilliantSuccess => 'You brilliantly succeeded in this challenge!';

  @override
  String get dailyChallengeKeepProgressing => 'Keep going, you\'re making progress every day!';

  @override
  String get dailyChallengePoints => 'points';

  @override
  String get dailyChallengeSeconds => 'seconds';

  @override
  String get dailyChallengeViewLeaderboard => 'VIEW LEADERBOARD';

  @override
  String get dailyChallengeResultBack => 'BACK';

  @override
  String get leaderboardTitle => 'LEADERBOARD';

  @override
  String get leaderboardWelcomeChampion => 'Welcome Champion!';

  @override
  String get leaderboardToAppearInRanking => 'To appear in the ranking';

  @override
  String get leaderboardChooseUsername => 'Choose your username!';

  @override
  String get leaderboardNameVisibleToAll => 'Your name will be visible to all';

  @override
  String get leaderboardLater => 'Later';

  @override
  String get leaderboardChooseMyName => 'Choose my name';

  @override
  String get leaderboardLoading => '🏆 Loading leaderboard...';

  @override
  String get leaderboardTabTop => '🏅 TOP 20';

  @override
  String get leaderboardTabMe => '👤 ME';

  @override
  String get leaderboardTabStats => '📊 STATS';

  @override
  String get leaderboardNoChampions => '🎯 No champions yet';

  @override
  String get leaderboardBeTheFirst => 'Be the first to take up the challenge!';

  @override
  String get leaderboardYourHistory => '📜 Your History';

  @override
  String get leaderboardYourLegendsWillAppear => 'Your legendary feats will appear here!';

  @override
  String get leaderboardNoStatsYet => '📊 No stats yet';

  @override
  String get leaderboardUnlockStats => 'Complete your first challenge to unlock your statistics!';

  @override
  String get leaderboardCurrentStreak => '🔥 Current Streak';

  @override
  String get leaderboardConsecutiveDays => 'consecutive days';

  @override
  String get leaderboardTotalStars => '⭐ Total Stars';

  @override
  String get leaderboardStarsCollected => 'stars collected';

  @override
  String get leaderboardPersonalRecord => '🏆 Personal Record';

  @override
  String get leaderboardDaysYourBest => 'days - your best';

  @override
  String get leaderboardPoints => 'points';

  @override
  String get leaderboardStars => 'stars';

  @override
  String get leaderboardYou => 'YOU';

  @override
  String get leaderboardEmptyStateTitle => 'No data available';

  @override
  String get leaderboardEmptyStateMessage => 'Challenge yourself to appear here!';

  @override
  String get progressScreen_title => 'My Progress';

  @override
  String get progressScreen_subtitle => 'Track your evolution! 📊';

  @override
  String get progressScreen_loadingError => 'Error while loading';

  @override
  String get progressChart_byCategory => 'Progress by category';

  @override
  String get progressChart_byGrade => 'Progress by grade level';

  @override
  String get progressScreen_byCategory => 'By category';

  @override
  String get progressScreen_byGrade => 'By grade level';

  @override
  String get mathKidBadge_title => '🎯 MATHKID 🎯';

  @override
  String get mathKidBadge_champion => 'Super Champion!';

  @override
  String get badgesSection_title => 'My Badges';

  @override
  String badgesSection_count(Object earned, Object total) {
    return '$earned/$total badges earned';
  }

  @override
  String get badgesSection_allUnlocked => '🎉 All badges unlocked! Champion!';

  @override
  String badgesSection_continueToUnlock(Object plural, Object remaining) {
    return 'Continue to unlock $remaining badge$plural!';
  }

  @override
  String get badgesSection_startPlaying => 'Start solving exercises to earn your first badges!';

  @override
  String get badgesSection_awesome => 'Awesome! Keep going to unlock all badges!';

  @override
  String get badgesSection_champion => 'Bravo! You are a true champion! 🌟';

  @override
  String get badgesSection_tipStart => 'Start solving exercises to earn your first badges!';

  @override
  String get badgesSection_tipKeepGoing => 'Awesome! Keep going to unlock all badges!';

  @override
  String get badgesSection_tipChampion => 'Bravo! You are a true champion! 🌟';

  @override
  String get badge => 'badge';

  @override
  String get badges => 'badges';

  @override
  String get earned => 'earned';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileManageInfo => 'Manage your information and access your statistics';

  @override
  String get profileMenu => 'Main Menu';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileFirstnamePseudo => 'First Name / Username';

  @override
  String get profileClass => 'Class';

  @override
  String get profileSchool => 'School';

  @override
  String get profileMottoHobby => 'Motto or Hobby';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileSave => 'Save';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully!';

  @override
  String get profileError => 'Error: ';

  @override
  String get profileChoosePhoto => 'Choose your photo';

  @override
  String get profileGallery => 'Gallery';

  @override
  String get profileSchoolInfo => 'School Information';

  @override
  String get profileInstitution => 'Institution';

  @override
  String get profileStudentNumber => 'Student N°';

  @override
  String get profileSchoolYear => 'School Year';

  @override
  String get profileMotto => 'Motto';

  @override
  String get profileLevelNotDefined => 'Level not defined';

  @override
  String get profileFieldRequired => 'This field is required';

  @override
  String get profileLeaderboards => 'Leaderboards';

  @override
  String get profileMyProgress => 'My Progress';

  @override
  String get profileStore => 'Store';

  @override
  String get profileHelpCenter => 'Help Center';

  @override
  String get profileSoundMusic => 'Sound & Music';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileBackHome => 'Back to Home';

  @override
  String get notificationSettingsTitle => 'My Notifications';

  @override
  String get notificationConfigureReminders => 'Configure your reminders to never miss your math sessions!';

  @override
  String get notificationScheduleReminder => 'Schedule a reminder';

  @override
  String get notificationReminderTime => 'Reminder time';

  @override
  String get notificationHour => 'Hour';

  @override
  String get notificationMinute => 'Minute';

  @override
  String get notificationRepeatDaily => 'Repeat daily';

  @override
  String get notificationSchedule => 'Schedule';

  @override
  String notificationScheduledAt(Object hour, Object minute) {
    return 'Notification scheduled at ${hour}h$minute ! ⏰';
  }

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsDisabled => 'Notifications disabled';

  @override
  String get iWillReceiveReminders => 'I will receive reminders';

  @override
  String get noRemindersWillBeSent => 'No reminders will be sent';

  @override
  String get notificationsActivated => 'Notifications activated ! 📱';

  @override
  String get notificationsDeactivated => 'Notifications deactivated';

  @override
  String get pleaseAllowExactAlarms => 'Please allow exact alarms in your settings.';

  @override
  String get scheduledReminders => 'Scheduled reminders';

  @override
  String get daily => 'Daily';

  @override
  String get once => 'Once';

  @override
  String get activeReminders => 'Active reminders';

  @override
  String get dailyReminders => 'Daily';

  @override
  String get statistics => 'Statistics';

  @override
  String get tipsForUsingReminders => 'Tips for using your reminders';

  @override
  String get tip1 => '🕐 Schedule your sessions when you\'re most focused';

  @override
  String get tip2 => '🔄 Activate daily reminders to create a routine';

  @override
  String get newReminder => 'New reminder';

  @override
  String get fieldRequired => 'Required';

  @override
  String get fieldInvalid => 'Invalid';

  @override
  String get programNotification => 'Schedule a notification';

  @override
  String get soundSettingsTitle => 'Sound Settings 🎵';

  @override
  String get soundSettingsSubtitle => 'Customize your sounds';

  @override
  String get soundEffects => 'Sound effects';

  @override
  String get soundEffectsActive => 'Active';

  @override
  String get soundEffectsDisabled => 'Disabled';

  @override
  String get backgroundMusic => 'Background music';

  @override
  String get backgroundMusicActive => 'Active';

  @override
  String get backgroundMusicDisabled => 'Disabled';

  @override
  String get sfxVolume => 'Effects volume';

  @override
  String get musicVolume => 'Music volume';

  @override
  String get storeTitle => '🏪 STORE';

  @override
  String get storeTabLives => 'Lives';

  @override
  String get storeTabGems => 'Gems';

  @override
  String get unlimitedLivesWeek => 'Unlimited Week ! ♾️';

  @override
  String get unlimitedLivesDescription => 'Enjoy 7 days without losing lives!';

  @override
  String get chatbotActivated => 'Assistant Activated! 🤖';

  @override
  String get chatbotReadyToHelp => 'MathKid is ready to help you!';

  @override
  String gemsReceived(Object icon) {
    return 'Gems Received! $icon';
  }

  @override
  String gemsReceivedCount(Object count) {
    return 'You received $count gems!';
  }

  @override
  String get livesRefilled => 'Lives refilled! 🎉';

  @override
  String get readyToContinue => 'You\'re ready to continue the adventure!';

  @override
  String storeError(Object error) {
    return 'Oops: $error';
  }

  @override
  String get storeSuccess => 'Great!';

  @override
  String get storeUnlimitedLives => 'Unlimited Lives!';

  @override
  String get storeMyLives => 'My Lives';

  @override
  String get storeUnlimitedDescription => 'You\'re invincible this week! 🦸';

  @override
  String storeNextLife(Object time) {
    return 'Next life: $time';
  }

  @override
  String get storeSectionLivesBoosts => '💖 Lives & Boosts';

  @override
  String get storeSectionGemPacks => '💎 Gem Packs';

  @override
  String get storeNoProducts => 'No products available...';

  @override
  String get storeTryAgain => 'Try again';

  @override
  String get storeInfoTitle => 'Good to know';

  @override
  String storeMaxLives(Object count) {
    return 'Max $count lives stored';
  }

  @override
  String storeLifeRegeneration(Object minutes) {
    return '1 life regenerated every $minutes minutes';
  }

  @override
  String get storeUnlimitedMode => 'Unlimited mode = No life loss!';

  @override
  String get storeGemsInfoTitle => 'What are Gems for?';

  @override
  String storeHintCost(Object gems) {
    return 'Hint: $gems gems';
  }

  @override
  String storeSkipQuestionCost(Object gems) {
    return 'Skip a question: $gems gems';
  }

  @override
  String storeFastRechargeCost(Object gems) {
    return 'Fast life recharge: $gems gems';
  }

  @override
  String storeUnlockThemesCost(Object gems) {
    return 'Unlock themes: $gems gems';
  }

  @override
  String get storeBadgePopular => 'Popular 🔥';

  @override
  String get storeBadgeBestOffer => 'Best Offer 🌟';

  @override
  String get storeBadgeNew => 'New 🤖';

  @override
  String get storeBadgeBestValue => 'Best Value 💎';

  @override
  String get updateRequiredTitle => 'Update required! 🚀';

  @override
  String get updateNewVersionAvailable => 'New version available';

  @override
  String get updateAppImproving => 'MathsCool is improving!';

  @override
  String get updateDescription => 'To enjoy the latest features and continue your math adventure, update the app now!';

  @override
  String get updateWhatsNew => 'What\'s new:';

  @override
  String get updateFeatureInfiniteMode => '♾️ Infinite Mode';

  @override
  String get updateFeatureAchievements => '🏆 60+ Achievements';

  @override
  String get updateFeatureModernDesign => '🎨 Modern design';

  @override
  String get updateFeatureAIAssistant => '🤖 AI Assistant';

  @override
  String get updateButton => 'Update now';

  @override
  String updateVersionRequired(Object version) {
    return 'Version $version required';
  }

  @override
  String get updateDontMissFeatures => '✨ Don\'t miss the new features! ✨';

  @override
  String get chatbotLimitReached => 'Limit reached! 🚀';

  @override
  String get chatbotFreeQuestionsUsed => 'You have used your 3 free questions for today!';

  @override
  String get chatbotSubscribePrompt => 'Subscribe to ask as many questions as you want to MathKid! 🚀';

  @override
  String get chatbotLater => 'Later';

  @override
  String get chatbotDiscover => 'Discover ✨';

  @override
  String get gemsMyGems => 'My Gems';

  @override
  String get gemsCurrent => 'Current';

  @override
  String get gemsSpent => 'Spent';

  @override
  String get progressChartTitle => 'My progress';

  @override
  String get progressNoData => 'No data for the moment';

  @override
  String themeBadgeLevel(Object level) {
    return 'Niv.$level';
  }

  @override
  String get themeBadgeLocked => 'Locked';

  @override
  String get chooseYourLanguage => 'Choose your language 🌍';

  @override
  String get questionSkipped => 'Question skipped! ⏭️';

  @override
  String get storeHintLabel => 'Hint 💡';

  @override
  String get achievementFirstSteps => 'First steps';

  @override
  String get achievementFirstStepsDesc => 'Solve your first exercise';

  @override
  String get achievementGettingStarted => 'Getting started!';

  @override
  String get achievementGettingStartedDesc => 'Solve 5 exercises';

  @override
  String get achievementOnTrack => 'On track';

  @override
  String get achievementOnTrackDesc => 'Solve 15 exercises';

  @override
  String get achievementBeginner => 'Beginner';

  @override
  String get achievementBeginnerDesc => 'Solve 25 exercises';

  @override
  String get achievementLearner => 'Learner';

  @override
  String get achievementLearnerDesc => 'Solve 50 exercises';

  @override
  String get achievementStudent => 'Studious student';

  @override
  String get achievementStudentDesc => 'Solve 75 exercises';

  @override
  String get achievementSkilled => 'Skilled';

  @override
  String get achievementSkilledDesc => 'Solve 100 exercises';

  @override
  String get achievementExpert => 'Expert';

  @override
  String get achievementExpertDesc => 'Solve 150 exercises';

  @override
  String get achievementMaster => 'Master';

  @override
  String get achievementMasterDesc => 'Solve 200 exercises';

  @override
  String get achievementChampion => 'Champion';

  @override
  String get achievementChampionDesc => 'Solve 300 exercises';

  @override
  String get achievementLegend => 'Legend';

  @override
  String get achievementLegendDesc => 'Solve 500 exercises';

  @override
  String get achievementPerfectionist => 'Perfectionist';

  @override
  String get achievementPerfectionistDesc => 'Get a perfect score';

  @override
  String get achievementFlawlessTrio => 'Perfect trio';

  @override
  String get achievementFlawlessTrioDesc => 'Get 3 perfect scores';

  @override
  String get achievementPerfectFive => 'Perfect hand';

  @override
  String get achievementPerfectFiveDesc => 'Get 5 perfect scores';

  @override
  String get achievementPerfectTen => 'Absolute perfection';

  @override
  String get achievementPerfectTenDesc => 'Get 10 perfect scores';

  @override
  String get achievementPerfectMaster => 'Perfect master';

  @override
  String get achievementPerfectMasterDesc => 'Get 20 perfect scores';

  @override
  String get achievementDailyPlayer => 'Daily player';

  @override
  String get achievementDailyPlayerDesc => 'Play 3 days in a row';

  @override
  String get achievementCommitted => 'Committed';

  @override
  String get achievementCommittedDesc => 'Play 5 days in a row';

  @override
  String get achievementWeeklyWarrior => 'Weekly warrior';

  @override
  String get achievementWeeklyWarriorDesc => 'Play 7 days in a row';

  @override
  String get achievementTwoWeeks => 'Fortnight fighter';

  @override
  String get achievementTwoWeeksDesc => 'Play 14 days in a row';

  @override
  String get achievementMonthlyMaster => 'Monthly master';

  @override
  String get achievementMonthlyMasterDesc => 'Play 30 days in a row';

  @override
  String get achievementInfiniteBeginner => 'Infinite beginner';

  @override
  String get achievementInfiniteBeginnerDesc => 'Solve 25 infinite mode exercises';

  @override
  String get achievementInfiniteExplorer => 'Infinite explorer';

  @override
  String get achievementInfiniteExplorerDesc => 'Solve 50 infinite mode exercises';

  @override
  String get achievementInfiniteWarrior => 'Infinite warrior';

  @override
  String get achievementInfiniteWarriorDesc => 'Solve 100 infinite mode exercises';

  @override
  String get achievementInfiniteMaster => 'Master of infinity';

  @override
  String get achievementInfiniteMasterDesc => 'Solve 200 infinite mode exercises';

  @override
  String get achievementNightOwl => 'Night owl';

  @override
  String get achievementNightOwlDesc => 'Play between midnight and 6 AM';

  @override
  String get achievementEarlyBird => 'Early bird';

  @override
  String get achievementEarlyBirdDesc => 'Play between 5 AM and 7 AM';

  @override
  String get achievementWeekendWarrior => 'Weekend warrior';

  @override
  String get achievementWeekendWarriorDesc => 'Play every weekend for a month';

  @override
  String get achievementLuckySeven => 'Lucky seven';

  @override
  String get achievementLuckySevenDesc => 'Solve 777 exercises';

  @override
  String get notifMotivational1 => 'Time to make some mathematical magic! ✨';

  @override
  String get notifMotivational2 => 'Your number friends are waiting for you! 🔢';

  @override
  String get notifMotivational3 => 'Come discover new math challenges! 🎯';

  @override
  String get notifMotivational4 => 'It\'s time to become a math superhero! 🦸‍♂️';

  @override
  String get notifMotivational5 => 'The equations are calling! Ready to play? 🎮';

  @override
  String get notifMotivational6 => 'Transform yourself into a math genius! 🧠';

  @override
  String get notifMotivational7 => 'A new math adventure awaits you! 🌟';

  @override
  String get notifMotivational8 => 'Come show your math talents! 💪';

  @override
  String get notifMotivational9 => 'Let\'s go for a fun math session! 🎉';

  @override
  String get notifMotivational10 => 'Your neurons want to calculate! 🧮';

  @override
  String get notifMotivational11 => 'Numbers have prepared surprises for you! 🎁';

  @override
  String get notifMotivational12 => 'Ready to solve math mysteries? 🔍';

  @override
  String get notifMotivational13 => 'Time to make your brain shine! ✨';

  @override
  String get notifMotivational14 => 'Come collect new achievements! 🏆';

  @override
  String get notifMotivational15 => 'A dose of math to start well! ☀️';

  @override
  String get notifMotivational16 => 'A new lesson awaits you! 🌟';

  @override
  String get notifMotivational17 => 'Ready for your learning session? 💫';

  @override
  String get notifAchievement1 => '🏆 Psst... A new trophy might be waiting for you!';

  @override
  String get notifAchievement2 => '🥇 Come unlock your next Expert badge!';

  @override
  String get notifAchievement3 => '🚀 You\'re close to the goal! Come progress in your achievements.';

  @override
  String get notifAchievement4 => '🔥 Keep the pace! New rewards are available.';

  @override
  String get notifAchievement5 => '👑 Become the King of the category today!';

  @override
  String get notifAchievement6 => '🎯 Objective in sight: Come complete your missions!';

  @override
  String get notifAchievement7 => '🌟 Your badges feel lonely... Come earn more!';

  @override
  String get notifAchievement8 => '💪 Show us your talents and earn lives!';

  @override
  String get notifDailyChallenge1 => '⏰ Today\'s challenge expires soon! Don\'t miss it!';

  @override
  String get notifDailyChallenge2 => '🎯 A crispy challenge awaits you today!';

  @override
  String get notifDailyChallenge3 => '🔥 Your daily challenge is ready! Come conquer it!';

  @override
  String get notifDailyChallenge4 => '⭐ Earn stars with today\'s challenge!';

  @override
  String get notifDailyChallenge5 => '🚀 Today\'s challenge will boost your ranking!';

  @override
  String get notifDailyChallenge6 => '💎 A unique challenge for you today! Go!';

  @override
  String get notifDailyChallenge7 => '🎪 Today\'s challenge is here! Your turn to play!';

  @override
  String get notifDailyChallenge8 => '⚡ Flash challenge: Show what you\'re worth today!';

  @override
  String get notifDailyChallenge9 => '🎁 Today\'s gift: A super challenge just for you!';

  @override
  String get notifDailyChallenge10 => '🌟 Complete the challenge and shine on the leaderboard!';

  @override
  String notifLeaderboard1(Object name) {
    return '🏆 Don\'t let $name beat your record!';
  }

  @override
  String notifLeaderboard2(Object name) {
    return '👑 $name is ahead of you! Catch up!';
  }

  @override
  String notifLeaderboard3(Object name) {
    return '⚔️ Duel at the top with $name! Who will be #1?';
  }

  @override
  String notifLeaderboard4(Object name) {
    return '🥇 $name got a perfect score! Your turn to do better!';
  }

  @override
  String notifLeaderboard5(Object name) {
    return '📈 $name is climbing fast! Defend your position!';
  }

  @override
  String notifLeaderboard6(Object name) {
    return '💪 $name is just ahead of you! Surpass them!';
  }

  @override
  String notifLeaderboard7(Object name) {
    return '🎯 $name is aiming for the podium, and you?';
  }

  @override
  String notifLeaderboard8(Object name) {
    return '🔥 $name earned 3 stars! Match their score!';
  }

  @override
  String notifLeaderboard9(Object name) {
    return '⭐ $name shines on the leaderboard! Show your talent!';
  }

  @override
  String notifLeaderboard10(Object name) {
    return '🚀 $name is launched! Don\'t get left behind!';
  }

  @override
  String get notifChannelAchievements => 'Trophy Reminders';

  @override
  String get notifChannelAchievementsDesc => 'Reminders to unlock achievements and badges';

  @override
  String get notifChannelDailyChallenge => 'Daily Challenge';

  @override
  String get notifChannelDailyChallengeDesc => 'Reminders for the daily challenge';

  @override
  String get notifChannelLeaderboard => 'Leaderboard';

  @override
  String get notifChannelLeaderboardDesc => 'Reminders to climb the leaderboard';

  @override
  String get notifChannelLives => 'Lives Refilled';

  @override
  String get notifChannelLivesDesc => 'Notifications when lives are full';

  @override
  String get notifChannelImmediate => 'Immediate notifications';

  @override
  String get notifTitleAchievements => 'New achievements available! 🏆';

  @override
  String get notifTitleDailyChallenge => 'Daily Challenge available! 🎯';

  @override
  String get notifTitleLeaderboard => 'Climb the leaderboard! 🏅';

  @override
  String get notifTitleLivesRefilled => 'Lives at max! ❤️';

  @override
  String notifBodyLivesRefilled(Object name) {
    return 'Hey $name, your lives are refilled! Come play! 🎮';
  }
}
