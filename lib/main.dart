import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mathscool/services/chatbot_service.dart';
import 'package:mathscool/services/sound_service.dart';
import 'package:mathscool/services/username_service.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/models/user_model.dart';
import 'package:mathscool/screens/home_screen.dart';
import 'package:mathscool/auth/screens/login_screen.dart';
import 'package:mathscool/auth/screens/register_screen.dart';
import 'package:mathscool/auth/screens/forgot_password_screen.dart';
import 'package:mathscool/auth/screens/email_verification_screen.dart';
import 'package:mathscool/services/user_service.dart';
import 'package:mathscool/services/notification_service.dart';
import 'package:mathscool/services/progress_service.dart';
import 'package:mathscool/services/lives_service.dart';
import 'package:mathscool/services/achievement_service.dart';
import 'package:mathscool/services/daily_challenge_service.dart';

// ✅ IMPORTS GEMS AJOUTÉS
import 'package:mathscool/services/gems_service.dart';

// Imports pour le Kill Switch
import 'package:mathscool/services/remote_config_service.dart';
import 'package:mathscool/screens/update_required_screen.dart';

// Import pour l'internationalisation
import 'package:mathscool/services/localization_service.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp();

  // Initialiser le service audio
  await SoundService().initialize();

  // Initialiser le service de notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialiser Remote Config et vérifier la version
  final remoteConfig = RemoteConfigService();
  await remoteConfig.initialize();

  // Vérifier si une mise à jour est requise AVANT de lancer l'app
  final bool updateRequired = await remoteConfig.isUpdateRequired();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<AppUser?>(
          create: (context) => AuthService().userStream,
          initialData: null,
        ),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => UserService()),
        Provider(create: (_) => ProgressService()),
        ChangeNotifierProvider(create: (_) => LivesService()),

        // ✅ GEMS SERVICE - AJOUTÉ EN PREMIER
        ChangeNotifierProvider(create: (_) => GemsService()),

        // ✅ ACHIEVEMENT SERVICE - MODIFIÉ pour dépendre de GemsService
        ChangeNotifierProxyProvider<GemsService, AchievementService>(
          create: (context) => AchievementService(
            Provider.of<GemsService>(context, listen: false),
          ),
          update: (context, gemsService, previousAchievementService) =>
          previousAchievementService ?? AchievementService(gemsService),
        ),

        ChangeNotifierProvider(create: (_) => DailyChallengeService()),
        ChangeNotifierProvider(create: (_) => UsernameService()),
        Provider(create: (_) => ChatbotService()),
        Provider.value(value: notificationService),
        ChangeNotifierProvider(create: (_) => LocalizationService()),
      ],
      child: MathsCoolApp(showUpdateScreen: updateRequired),
    ),
  );
}

class MathsCoolApp extends StatefulWidget {
  final bool showUpdateScreen;

  const MathsCoolApp({
    super.key,
    this.showUpdateScreen = false,
  });

  @override
  State<MathsCoolApp> createState() => _MathsCoolAppState();
}

class _MathsCoolAppState extends State<MathsCoolApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print('📱 App au premier plan');
        SoundService().resumeAll();
        break;

      case AppLifecycleState.inactive:
        print('📱 App inactive');
        break;

      case AppLifecycleState.paused:
        print('📱 App en arrière-plan');
        SoundService().pauseAll();
        break;

      case AppLifecycleState.detached:
        print('📱 App se ferme');
        SoundService().dispose();
        break;

      case AppLifecycleState.hidden:
        print('📱 App cachée');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return MaterialApp(
      title: 'MathsCool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'ComicNeue',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: localizationService.currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],
      home: widget.showUpdateScreen
          ? const UpdateRequiredScreen()
          : const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoginScreen = true;
  bool _isForgotPasswordScreen = false;

  void _toggleToRegister() {
    setState(() {
      _isLoginScreen = false;
      _isForgotPasswordScreen = false;
    });
  }

  void _toggleToLogin() {
    setState(() {
      _isLoginScreen = true;
      _isForgotPasswordScreen = false;
    });
  }

  void _toggleToForgotPassword() {
    setState(() {
      _isLoginScreen = false;
      _isForgotPasswordScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    final gemsService = Provider.of<GemsService>(context, listen: false);

    // ✅ DÉCONNEXION : Arrêter le listener des gems
    if (user == null) {
      gemsService.stopListening();

      if (_isForgotPasswordScreen) {
        return ForgotPasswordScreen(
          onLoginClicked: _toggleToLogin,
        );
      }

      if (!_isLoginScreen) {
        return RegisterScreen(
          onLoginClicked: _toggleToLogin,
        );
      }

      return LoginScreen(
        onRegisterClicked: _toggleToRegister,
        onForgotPasswordClicked: _toggleToForgotPassword,
      );
    }

    // ✅ CONNEXION : Vérifier email
    if (!user.emailVerified) {
      return const EmailVerificationScreen();
    }

    // ✅ CHARGER LES GEMS AU LOGIN (avec écoute en temps réel)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData(user, notificationService);
    });

    return const HomeScreen();
  }

  // ✅ NOUVELLE MÉTHODE : Initialiser toutes les données utilisateur
  Future<void> _initializeUserData(AppUser user, NotificationService notificationService) async {
    try {
      final gemsService = Provider.of<GemsService>(context, listen: false);
      final achievementService = Provider.of<AchievementService>(context, listen: false);

      // 1. Charger les Gems (démarre automatiquement le listener en temps réel)
      await gemsService.loadGems(user.uid);

      // 2. Charger les Achievements
      await achievementService.initialize();
      await achievementService.loadUserAchievements(user.uid);

      // 3. Programmer les notifications
      await _scheduleNotificationsForUser(user, notificationService);

      print('✅ Données utilisateur initialisées avec succès');
    } catch (e) {
      print('❌ Erreur initialisation données utilisateur: $e');
    }
  }

  Future<void> _scheduleNotificationsForUser(AppUser user, NotificationService notificationService) async {
    try {
      final userName = user.displayName ?? 'MathKid';

      // 1. Restaurer les notifications personnalisées existantes
      await notificationService.restoreCustomNotifications(userName);

      // 2. Programmer TOUTES les notifications automatiques en une seule fois
      final results = await notificationService.scheduleAllAutomaticReminders(userName);

      // 3. Log des résultats
      print('📱 Notifications programmées pour $userName');
      print('   ✅ Achievements: ${results['achievements']}');
      print('   ✅ Daily Challenge: ${results['dailyChallenge']}');
      print('   ✅ Leaderboard: ${results['leaderboard']}');

    } catch (e) {
      print('❌ Erreur lors de la programmation des notifications: $e');
    }
  }
}