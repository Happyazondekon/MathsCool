import 'package:flutter/material.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/utils/colors.dart'; // Supposons que AppColors n'est pas utilisé directement pour le thème de Noël ici

// --- COULEURS DE NOËL SPÉCIFIQUES ---
// On définit de nouvelles couleurs pour le thème de Noël
class ChristmasColors {
  static const Color primaryRed = Color(0xFFC63437); // Rouge profond de Noël
  static const Color secondaryGreen = Color(0xFF2E7D32); // Vert sapin
  static const Color accentGold = Color(0xFFFFD700); // Or (pour les boutons/accents)
  static const Color snowWhite = Color(0xFFFFFFFF); // Neige/Blanc
}
// ------------------------------------

class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterClicked;
  final VoidCallback onForgotPasswordClicked;

  const LoginScreen({
    super.key,
    required this.onRegisterClicked,
    required this.onForgotPasswordClicked,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;

  // LOGIQUE NON MODIFIÉE
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = context.read<AuthService>();
      final user = await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // MODIFIÉ: Vérifier si l'utilisateur a vérifié son email
      if (user != null && mounted) {
        if (!user.emailVerified) {
          // Rediriger vers l'écran de vérification
          Navigator.of(context).pushReplacementNamed('/email-verification');
        } else {
          // Email vérifié, rediriger vers l'écran principal
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // La taille n'est pas utilisée mais conservée
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      // Changement de la couleur de l'indicateur de chargement de la barre d'état
      body: Stack(
        children: [
          // Background with Gradient (Thème de Noël)
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              // Si vous avez une image de logo.png avec un fond transparent
                              // ou si vous voulez l'entourer d'un décor de Noël:
                              backgroundImage: const AssetImage('assets/images/logo.png'),
                            ),
                          ),
                          // Petit élément de Noël (comme un bonnet ou un flocon)
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              Icons.star, // Étoile ou flocon de neige
                              color: ChristmasColors.snowWhite,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Phrase de bienvenue (Texte de Noël)
                      const Text(
                        'Noël sur MathsCool ! 🎁',
                        style: TextStyle(
                          fontSize: 24, // Augmenté pour la fête
                          fontWeight: FontWeight.bold,
                          color: ChristmasColors.snowWhite,
                          letterSpacing: 1.2, // Pour un look plus festif
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Connectez-vous pour des mathématiques illuminées de joie !',
                        style: TextStyle(
                          fontSize: 16,
                          color: ChristmasColors.snowWhite, // Blanc neige
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Email Input (Couleurs adaptées)
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black87), // Texte en noir
                        decoration: InputDecoration(
                          labelText: 'Adresse Email',
                          prefixIcon: const Icon(Icons.email, color: ChristmasColors.primaryRed), // Icône Rouge
                          filled: true,
                          fillColor: ChristmasColors.snowWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.accentGold, width: 2), // Bordure Dorée
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.secondaryGreen, width: 1), // Bordure Verte
                          ),
                        ),
                        validator: (value) =>
                        value!.contains('@') ? null : 'Email invalide',
                      ),
                      const SizedBox(height: 16),
                      // Password Input (Couleurs adaptées)
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock, color: ChristmasColors.primaryRed), // Icône Rouge
                          filled: true,
                          fillColor: ChristmasColors.snowWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.accentGold, width: 2), // Bordure Dorée
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: ChristmasColors.secondaryGreen, width: 1), // Bordure Verte
                          ),
                        ),
                        validator: (value) =>
                        value!.length >= 6 ? null : '6 caractères minimum',
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
                      // Login Button (Thème de Noël)
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            elevation: 5, // Ajout d'une légère ombre
                          ),
                          onPressed: _login,
                          child: const Text(
                            'Connexion 🎅',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ChristmasColors.primaryRed, // Texte Rouge
                            ),
                          ),
                        ),
                      ),
                      // Forgot Password Link
                      TextButton(
                        onPressed: widget.onForgotPasswordClicked,
                        child: const Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(color: ChristmasColors.snowWhite),
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
                      const Divider(height: 40, color: ChristmasColors.snowWhite),
                      // Register Link
                      TextButton(
                        onPressed: widget.onRegisterClicked,
                        child: RichText(
                          text: const TextSpan(
                            text: 'Nouveau sur MathsCool ? ',
                            style: TextStyle(
                              color: ChristmasColors.snowWhite,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'Créer un compte',
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