import 'package:flutter/material.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/utils/colors.dart';

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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = context.read<AuthService>();
      await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = context.read<AuthService>();
      await authService.signInWithGoogle();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.secondary],
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
                      // Logo de l'application
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: const AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Phrase de bienvenue
                      const Text(
                        'Bienvenue sur MathsCool !',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Connectez-vous pour accéder à votre espace d\'apprentissage.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Adresse Email',
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) =>
                        value!.contains('@') ? null : 'Email invalide',
                      ),
                      const SizedBox(height: 16),
                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) =>
                        value!.length >= 6 ? null : '6 caractères minimum',
                      ),
                      // Error Message
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                          onPressed: _login,
                          child: const Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Forgot Password Link
                      TextButton(
                        onPressed: widget.onForgotPasswordClicked,
                        child: const Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                                child:
                                Divider(color: Colors.white70, thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'OU',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                                child:
                                Divider(color: Colors.white70, thickness: 1)),
                          ],
                        ),
                      ),
                      // Google Sign-in Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isGoogleLoading
                            ? const Center(child: CircularProgressIndicator())
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
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _signInWithGoogle,
                        ),
                      ),
                      const Divider(height: 40, color: Colors.white),
                      // Register Link
                      TextButton(
                        onPressed: widget.onRegisterClicked,
                        child: RichText(
                          text: TextSpan(
                            text: 'Nouveau sur MathsCool ? ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Créer un compte',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
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