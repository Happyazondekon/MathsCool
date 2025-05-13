import 'package:flutter/material.dart';
import 'package:mathscool/screens/level_selection.dart';
import 'package:mathscool/screens/profile_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedAvatar = 'assets/avatars/avatar1.png'; // Default avatar

  @override
  void initState() {
    super.initState();
    _loadSelectedAvatar(); // Charger l'avatar sélectionné
  }

  Future<void> _loadSelectedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('selectedAvatar') ?? 'assets/avatars/avatar1.png';
    setState(() {
      selectedAvatar = avatarPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fond coloré avec formes
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  Colors.white,
                ],
                stops: const [0.0, 0.5],
              ),
            ),
          ),

          // Bulles décoratives
          Positioned(
            top: 50,
            left: 20,
            child: _buildBubble(60, AppColors.accent.withOpacity(0.7)),
          ),
          Positioned(
            top: 80,
            right: 40,
            child: _buildBubble(40, AppColors.secondary.withOpacity(0.7)),
          ),
          Positioned(
            top: 150,
            left: 70,
            child: _buildBubble(30, AppColors.error.withOpacity(0.7)),
          ),

          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                // Première section avec le logo et le bouton profil
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(text: 'Maths'),
                            TextSpan(
                              text: 'Cool',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        ).then((_) => _loadSelectedAvatar()), // Recharger l'avatar après retour du profil
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(selectedAvatar),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Message de bienvenue juste en dessous de la première section
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'Bonjour MathKid 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image centrée
                        Image.asset(
                          'assets/images/home.png',
                          width: size.width * 0.8,
                          height: size.height * 0.4,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 20), // Espacement entre l'image et le bouton

                        // Bouton "Commencer à apprendre"
                        Container(
                          width: size.width * 0.7,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.secondary,
                                AppColors.primary
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LevelSelectionScreen()),
                                );
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Commencer à apprendre',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.play_circle_fill,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}