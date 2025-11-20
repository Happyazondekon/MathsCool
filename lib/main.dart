// main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/models/user_model.dart';
import 'package:mathscool/screens/home_screen.dart';
import 'package:mathscool/auth/screens/login_screen.dart';
import 'package:mathscool/auth/screens/register_screen.dart';
import 'package:mathscool/auth/screens/forgot_password_screen.dart';
import 'package:mathscool/auth/screens/email_verification_screen.dart'; // <-- NOUVEAU: Import de l'écran de vérification
import 'package:mathscool/services/user_service.dart';
import 'package:mathscool/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp();

  // Initialiser le service de notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<AppUser?>(
          // Le userStream fournit l'objet AppUser avec l'état 'emailVerified'
          create: (context) => AuthService().userStream,
          initialData: null,
        ),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => UserService()),
        Provider.value(value: notificationService), // Ajouter le service de notifications
      ],
      child: const MathsCoolApp(),
    ),
  );
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
      ),
      home: const AuthWrapper(),
      // Définir la route /home (utilisée par EmailVerificationScreen après vérification)
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

    // 1. Si l'utilisateur est connecté
    if (user != null) {

      // 2. NOUVEAU: Vérifier si l'email est vérifié
      // Cette propriété vient du modèle AppUser que nous avons mis à jour.
      if (!user.emailVerified) {
        return const EmailVerificationScreen(); // Rediriger vers l'écran de vérification
      }

      // 3. Si l'utilisateur est connecté ET que l'email est vérifié:

      // Programmer les notifications de manière asynchrone
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleNotificationsForUser(user, notificationService);
      });

      return const HomeScreen();
    }

    // 4. Si l'utilisateur n'est PAS connecté: afficher les écrans d'authentification

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

  // Méthode pour programmer les notifications pour l'utilisateur connecté
  Future<void> _scheduleNotificationsForUser(AppUser user, NotificationService notificationService) async {
    try {
      final userName = user.displayName ?? 'MathKid';

      print('Notifications programmées pour $userName');
    } catch (e) {
      print('Erreur lors de la programmation des notifications: $e');
    }
  }
}