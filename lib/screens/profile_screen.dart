import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/screens/progress_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedAvatar = 'assets/avatars/avatar1.png'; // Default avatar

  @override
  void initState() {
    super.initState();
    _loadSelectedAvatar(); // Charger l'avatar choisi à partir de SharedPreferences
  }

  Future<void> _loadSelectedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath =
        prefs.getString('selectedAvatar') ?? 'assets/avatars/avatar1.png';
    setState(() {
      selectedAvatar = avatarPath;
    });
  }

  Future<void> _saveSelectedAvatar(String avatarPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, authService),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildUserInfo(),
                      const SizedBox(height: 20),
                      _buildAvatarSelection(),
                      const SizedBox(height: 20),
                      _buildChooseButton(context), // Bouton "Choisir"
                      const SizedBox(height: 20),
                      _buildProgressCard(context),
                      const SizedBox(height: 20),
                      _buildAccountActions(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthService authService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Text(
            'Mon Profil',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authService.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(selectedAvatar),
            ),
            const SizedBox(height: 10),
            const Text(
              'MathKid',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'mathkid@mathscool.com',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSelection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisissez un avatar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAvatarOption('assets/avatars/avatar1.png'),
                _buildAvatarOption('assets/avatars/avatar2.png'),
                _buildAvatarOption('assets/avatars/avatar3.png'),
                _buildAvatarOption('assets/avatars/avatar4.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(String avatarPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatar = avatarPath;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(2), // Espace entre la bordure et l'avatar
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: selectedAvatar == avatarPath
              ? Border.all(color: AppColors.secondary, width: 3)
              : null,
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(avatarPath),
        ),
      ),
    );
  }

  Widget _buildChooseButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      onPressed: () async {
        await _saveSelectedAvatar(selectedAvatar); // Sauvegarder l'avatar
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ); // Revenir à l'écran HomeScreen
      },
      child: const Text(
        'Choisir cet avatar',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: const Icon(Icons.bar_chart, color: AppColors.primary),
        title: const Text(
          'Voir ma progression',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
          );
        },
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.primary),
            title: const Text('Paramètres'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help, color: AppColors.primary),
            title: const Text('Aide'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.star, color: AppColors.primary),
            title: const Text('Mes Badges'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}