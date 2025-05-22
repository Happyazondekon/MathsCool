import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/models/user_model.dart';
import 'package:mathscool/screens/home_screen.dart';
import 'package:mathscool/auth/screens/login_screen.dart';
import 'package:mathscool/auth/screens/register_screen.dart';
import 'package:mathscool/auth/screens/forgot_password_screen.dart';
import 'package:mathscool/services/user_service.dart';

// Import des services de notification
import 'package:mathscool/notification_service.dart';
import 'package:mathscool/notification_scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp();

  // Initialisation du système de notifications
  await _initializeNotifications();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<AppUser?>(
          create: (context) => AuthService().userStream,
          initialData: null,
        ),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => UserService()),
        // Ajout des services de notification
        Provider(create: (_) => NotificationService()),
        Provider(create: (_) => NotificationScheduler()),
      ],
      child: const MathsCoolApp(),
    ),
  );
}

// Initialisation du système de notifications
Future<void> _initializeNotifications() async {
  try {
    // Initialiser seulement le service de base, pas le scheduler
    final notificationService = NotificationService();
    await notificationService.initialize();
    print('✅ Service de notifications initialisé avec succès');
  } catch (e) {
    print('❌ Erreur lors de l\'initialisation des notifications: $e');
    // Ne pas faire échouer l'app si les notifications ne marchent pas
  }
}

class MathsCoolApp extends StatelessWidget {
  const MathsCoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathsCool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'ComicNeue',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Couleurs personnalisées pour l'app
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
      ),
      home: const AuthWrapper(),
      // Routes pour la navigation
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(
          onRegisterClicked: () {},
          onForgotPasswordClicked: () {},
        ),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  bool _isLoginScreen = true;
  bool _isForgotPasswordScreen = false;
  NotificationScheduler? _notificationScheduler;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotificationScheduler();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Nettoyage sécurisé du scheduler
    try {
      _notificationScheduler?.dispose();
    } catch (e) {
      print('❌ Erreur lors du nettoyage du scheduler: $e');
    }
    super.dispose();
  }

  void _initializeNotificationScheduler() {
    try {
      _notificationScheduler = Provider.of<NotificationScheduler>(context, listen: false);
      // Initialiser le scheduler après que le widget soit construit
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await _notificationScheduler!.initialize();
        } catch (e) {
          print('❌ Erreur initialisation scheduler: $e');
        }
      });
    } catch (e) {
      print('❌ Erreur récupération scheduler: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Gestion du cycle de vie de l'app pour les notifications
    switch (state) {
      case AppLifecycleState.resumed:
      // L'app est revenue au premier plan
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
      // L'app est passée en arrière-plan
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
      // L'app va être fermée
        break;
      default:
        break;
    }
  }

  void _handleAppResumed() {
    // Vérifier si l'utilisateur est connecté et programmer des notifications
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user != null) {
      _scheduleNotificationsForUser();
    }
  }

  void _handleAppPaused() {
    // L'app passe en arrière-plan, les notifications programmées continueront
    print('📱 App en arrière-plan - notifications actives');
  }

  Future<void> _scheduleNotificationsForUser() async {
    try {
      // S'assurer que le scheduler est initialisé
      if (_notificationScheduler == null) return;

      // S'assurer que les notifications sont programmées pour l'utilisateur connecté
      final isEnabled = await _notificationScheduler!.areNotificationsEnabled();
      if (isEnabled) {
        print('🔔 Vérification et programmation des notifications...');
        // Le scheduler vérifie automatiquement et programme si nécessaire
      }
    } catch (e) {
      print('❌ Erreur lors de la programmation des notifications: $e');
    }
  }

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

    // Si l'utilisateur est connecté, programmer les notifications et afficher l'écran d'accueil
    if (user != null) {
      // Programmer les notifications lors de la connexion
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleNotificationsForUser();
      });

      return const HomeScreen();
    }

    // Écrans d'authentification
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
}