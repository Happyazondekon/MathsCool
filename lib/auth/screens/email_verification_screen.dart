import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  bool _isLoading = false;
  bool _canResendEmail = true;
  int _resendCountdown = 60; // Compte à rebours de 60 secondes pour le renvoi
  String? _errorMessage;
  String? _successMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Configuration des animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    // 1. Démarrer la vérification périodique du statut (toutes les 3 secondes)
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkEmailVerificationStatus();
    });

    // 2. Envoyer l'email au démarrage (si l'utilisateur arrive ici après une reconnexion)
    // Utiliser addPostFrameCallback pour s'assurer que le context est prêt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationEmail(initialSend: true);
    });

    _animationController.repeat(reverse: true);
  }

  // Vérifie si l'utilisateur a vérifié son email.
  Future<void> _checkEmailVerificationStatus() async {
    if (!mounted) return;

    final authService = context.read<AuthService>();
    try {
      // 1. Recharger l'utilisateur Firebase pour obtenir le statut le plus récent
      await authService.reloadCurrentUser();

      // 2. Forcer le rechargement de l'utilisateur courant
      final currentUser = authService.currentFirebaseUser;
      if (currentUser != null) {
        await currentUser.reload();

        // 3. Récupérer à nouveau l'utilisateur après le reload
        final refreshedUser = FirebaseAuth.instance.currentUser;
        final isVerified = refreshedUser?.emailVerified ?? false;

        if (isVerified && mounted) {
          _timer.cancel(); // Arrêter le minuteur
          // Ne pas naviguer directement, laisser le AuthWrapper gérer la redirection
          // Le StreamProvider va détecter le changement automatiquement
        }
      }
    } catch (e) {
      // En cas d'erreur, on continue silencieusement
      print('Erreur lors de la vérification: $e');
    }
  }

  // Envoie l'email de vérification et démarre le compte à rebours de renvoi
  Future<void> _sendVerificationEmail({bool initialSend = false}) async {
    if (!initialSend && !_canResendEmail) return;

    if (!initialSend) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });
    }

    try {
      final authService = context.read<AuthService>();
      await authService.sendEmailVerification();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _canResendEmail = false;
          _resendCountdown = 60;
          _successMessage = "Email de vérification envoyé. Vérifiez votre boîte de réception et vos spams.";
        });
        _startResendTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Erreur lors de l'envoi de l'email: ${e.toString()}";
          _successMessage = null;
        });
      }
    }
  }

  // Gère le compte à rebours pour le bouton de renvoi
  void _startResendTimer() {
    // Annuler l'ancien timer si il existe
    // Le timer est périodique, il doit être géré avec soin ou utiliser un second Timer pour le compte à rebours
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendCountdown < 1) {
          timer.cancel();
          _canResendEmail = true;
        } else {
          _resendCountdown--;
        }
      });
    });
  }

  // Déconnexion de l'utilisateur
  Future<void> _signOut() async {
    await context.read<AuthService>().signOut();
    // La déconnexion déclenchera automatiquement la redirection vers l'écran de connexion via le _AuthGate.
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Arrière-plan (facultatif)
          // ...

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.email_outlined,
                          color: AppColors.secondary,
                          size: 60,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Vérifiez votre Email',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Un lien de vérification a été envoyé à ${_getFormattedEmail() ?? 'votre adresse email'}.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Affichage du message d'erreur ou de succès
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        if (_successMessage != null)
                          Text(
                            _successMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        const SizedBox(height: 20),

                        // Bouton de renvoi de l'email
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton.icon(
                          onPressed: _canResendEmail ? _sendVerificationEmail : null,
                          icon: const Icon(Icons.send),
                          label: Text(
                            _canResendEmail
                                ? 'Renvoyer l\'email'
                                : 'Renvoyer dans ${_resendCountdown}s',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Bouton pour se déconnecter
                        TextButton.icon(
                          onPressed: _signOut,
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 20,
                          ),
                          label: const Text(
                            'Utiliser un autre compte',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Aide pour formater l'email pour l'affichage (facultatif)
  String? _getFormattedEmail() {
    final email = context.read<AuthService>().currentUser?.email;
    if (email == null) return null;
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final userPart = parts[0];
    final domainPart = parts[1];

    // Masque une partie de l'email (ex: u***@d***.com)
    if (userPart.length > 2) {
      return '${userPart.substring(0, 1)}***@$domainPart';
    }
    return email;
  }
}