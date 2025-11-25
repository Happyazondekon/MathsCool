import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:mathscool/services/lives_service.dart'; // NOUVEAU : Import du service de vies

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
          create: (context) => AuthService().userStream,
          initialData: null,
        ),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => UserService()),
        Provider(create: (_) => ProgressService()),

        ChangeNotifierProvider(create: (_) => LivesService()),

        Provider.value(value: notificationService),
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

      // Programmer les notifications de manière asynchrone
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
      print('Notifications programmées pour $userName');
    } catch (e) {
      print('Erreur lors de la programmation des notifications: $e');
    }
  }
}