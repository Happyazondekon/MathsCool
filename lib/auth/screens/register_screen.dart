import 'package:flutter/material.dart';

import 'package:mathscool/utils/colors.dart';
import 'package:provider/provider.dart';

import '../auth_service.dart';

// --- COULEURS DE NOËL SPÉCIFIQUES ---
// On utilise les mêmes couleurs de Noël que pour l'écran de connexion
class ChristmasColors {
  static const Color primaryRed = Color(0xFFC63437); // Rouge profond de Noël
  static const Color secondaryGreen = Color(0xFF2E7D32); // Vert sapin
  static const Color accentGold = Color(0xFFFFD700); // Or (pour les boutons/accents)
  static const Color snowWhite = Color(0xFFFFFFFF); // Neige/Blanc
}
// ------------------------------------

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginClicked;

  const RegisterScreen({super.key, required this.onLoginClicked});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // LOGIQUE NON MODIFIÉE
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmController.text) {
      setState(() => _errorMessage = 'Les mots de passe ne correspondent pas');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = context.read<AuthService>();
      await authService.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        displayName: _nameController.text.trim(),
      );

      // NOUVEAU: Envoyer l'email de vérification immédiatement après l'inscription
      await authService.sendEmailVerification();

      if (mounted) {
        // L'utilisateur est connecté et le Wrapper (dans main.dart) le redirigera vers EmailVerificationScreen
        // Aucun autre setState ou navigation n'est nécessaire ici.
      }
    } on Exception catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // LOGIQUE NON MODIFIÉE
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = context.read<AuthService>();
      final user = await authService.signInWithGoogle();

      if (user != null && mounted) {
        // Google Sign-In vérifie automatiquement l'email
        // Rediriger vers l'écran principal
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  // LOGIQUE NON MODIFIÉE
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Thème de Noël)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Gradient de Noël : Rouge Profond à Vert Sapin
                colors: [ChristmasColors.primaryRed, ChristmasColors.secondaryGreen],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo de l'application (Ajout d'un thème visuel de Noël autour du logo)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70, // Taille légèrement augmentée pour l'effet festif
                            backgroundColor: ChristmasColors.accentGold, // Bordure Dorée
                          ),
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: ChristmasColors.snowWhite,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: const AssetImage('assets/images/logo.png'),
                            ),
                          ),
                          // Petit élément de Noël (comme un bonnet ou un flocon)
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              Icons.star, // Étoile
                              color: ChristmasColors.snowWhite,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Phrase de bienvenue (Texte de Noël)
                      const Text(
                        'Aidez le Père Noël ! 🎁',
                        style: TextStyle(
                          fontSize: 24, // Augmenté pour la fête
                          fontWeight: FontWeight.bold,
                          color: ChristmasColors.snowWhite,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Créez votre compte pour commencer les cadeaux mathématiques.',
                        style: TextStyle(
                          fontSize: 16,
                          color: ChristmasColors.snowWhite, // Blanc neige
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Username Input (Couleurs adaptées)
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Nom d\'utilisateur',
                          prefixIcon: const Icon(Icons.person, color: ChristmasColors.primaryRed),
                          filled: true,
                          fillColor: ChristmasColors.snowWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.accentGold, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.secondaryGreen, width: 1),
                          ),
                        ),
                        validator: (value) =>
                        value!.isNotEmpty ? null : 'Entrez votre nom d\'utilisateur',
                      ),
                      const SizedBox(height: 16),
                      // Email Input (Couleurs adaptées)
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Adresse Email',
                          prefixIcon: const Icon(Icons.email, color: ChristmasColors.primaryRed),
                          filled: true,
                          fillColor: ChristmasColors.snowWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.accentGold, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.secondaryGreen, width: 1),
                          ),
                        ),
                        validator: (value) =>
                        value!.contains('@') ? null : 'Email invalide',
                      ),
                      const SizedBox(height: 16),
                      // Password Input (Couleurs adaptées)
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock, color: ChristmasColors.primaryRed),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ChristmasColors.primaryRed, // Icône rouge
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: ChristmasColors.snowWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.accentGold, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.secondaryGreen, width: 1),
                          ),
                        ),
                        validator: (value) =>
                        value!.length >= 6 ? null : '6 caractères minimum',
                      ),
                      const SizedBox(height: 16),
                      // Confirm Password Input (Couleurs adaptées)
                      TextFormField(
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          prefixIcon: const Icon(Icons.lock, color: ChristmasColors.primaryRed),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ChristmasColors.primaryRed, // Icône rouge
                            ),
                            onPressed: () =>
                                setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                          filled: true,
                          fillColor: ChristmasColors.snowWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.accentGold, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.secondaryGreen, width: 1),
                          ),
                        ),
                        validator: (value) =>
                        value!.isNotEmpty ? null : 'Confirmez votre mot de passe',
                      ),
                      // Error Message (Couleur adaptées)
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: ChristmasColors.accentGold, // Afficher l'erreur en or
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Register Button (Thème de Noël)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator(color: ChristmasColors.snowWhite)) // Indicateur blanc
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ChristmasColors.accentGold, // Bouton Or
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          onPressed: _register,
                          child: const Text(
                            'Créer un compte 🎄',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ChristmasColors.primaryRed, // Texte Rouge
                            ),
                          ),
                        ),
                      ),
                      // Séparateur
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                                child:
                                Divider(color: ChristmasColors.accentGold, thickness: 1.5)), // Or
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'OU',
                                style: TextStyle(
                                  color: ChristmasColors.snowWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                                child:
                                Divider(color: ChristmasColors.accentGold, thickness: 1.5)), // Or
                          ],
                        ),
                      ),
                      // Google Sign-in Button (Logique inchangée, style adapté)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isGoogleLoading
                            ? const Center(child: CircularProgressIndicator(color: ChristmasColors.snowWhite)) // Indicateur blanc
                            : ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            height: 24,
                          ),
                          label: const Text(
                            'Continuer avec Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ChristmasColors.snowWhite, // Bouton blanc
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: ChristmasColors.primaryRed, width: 2), // Bordure Rouge
                            ),
                          ),
                          onPressed: _signInWithGoogle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Login Link
                      TextButton(
                        onPressed: widget.onLoginClicked,
                        child: RichText(
                          text: const TextSpan(
                            text: 'Déjà un compte ? ',
                            style: TextStyle(
                              color: ChristmasColors.snowWhite,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'Se connecter',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // Couleur d'accent festive, par exemple un jaune brillant
                                  color: ChristmasColors.accentGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}