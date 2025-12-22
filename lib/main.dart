import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mathscool/services/chatbot_service.dart';
import 'package:mathscool/services/sound_service.dart';
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

// Imports pour le Kill Switch
import 'package:mathscool/services/remote_config_service.dart';
import 'package:mathscool/screens/update_required_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp();

  // ✅ Initialiser le service audio
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
        ChangeNotifierProvider(create: (_) => AchievementService()),
        ChangeNotifierProvider(create: (_) => DailyChallengeService()),
        Provider(create: (_) => ChatbotService()),
        Provider.value(value: notificationService),
      ],
      child: MathsCoolApp(showUpdateScreen: updateRequired),
    ),
  );
}

// ✅ MODIFICATION : StatefulWidget pour gérer le cycle de vie
class MathsCoolApp extends StatefulWidget {
  final bool showUpdateScreen;

  const MathsCoolApp({
    super.key,
    this.showUpdateScreen = false,
  });

  @override
  State<MathsCoolApp> createState() => _MathsCoolAppState();
}

// ✅ NOUVEAU : State avec WidgetsBindingObserver
class _MathsCoolAppState extends State<MathsCoolApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // ✅ Enregistrer l'observateur du cycle de vie
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // ✅ Nettoyer l'observateur
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ NOUVEAU : Méthode appelée quand l'état de l'app change
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      // 🟢 App revient au premier plan
        print('📱 App au premier plan');
        SoundService().resumeAll();
        break;

      case AppLifecycleState.inactive:
      // 🟡 App en transition (ex: notification)
        print('📱 App inactive');
        break;

      case AppLifecycleState.paused:
      // 🔴 App en arrière-plan
        print('📱 App en arrière-plan');
        SoundService().pauseAll();
        break;

      case AppLifecycleState.detached:
      // ⚫ App en cours de fermeture
        print('📱 App se ferme');
        SoundService().dispose();
        break;

      case AppLifecycleState.hidden:
      // 🟤 App cachée (nouveau dans Flutter 3.13+)
        print('📱 App cachée');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathsCool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'ComicNeue',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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

    if (user != null) {
      if (!user.emailVerified) {
        return const EmailVerificationScreen();
      }

      // Programmer les notifications de manière asynchrone une fois connecté
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleNotificationsForUser(user, notificationService);
      });

      return const HomeScreen();
    }

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

  Future<void> _scheduleNotificationsForUser(AppUser user, NotificationService notificationService) async {
    try {
      final userName = user.displayName ?? 'MathKid';

      // 1. Restaurer les notifications personnalisées existantes
      await notificationService.restoreCustomNotifications(userName);

      // 2. Programmer le rappel quotidien pour les achievements
      await notificationService.scheduleDailyAchievementReminder();

      print('Notifications programmées pour $userName');
    } catch (e) {
      print('Erreur lors de la programmation des notifications: $e');
    }
  }
}