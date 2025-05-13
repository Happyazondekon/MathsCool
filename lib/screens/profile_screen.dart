import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/models/user_model.dart';
import 'package:mathscool/auth/screens/login_screen.dart';
import 'package:mathscool/screens/progress_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final authService = Provider.of<AuthService>(context);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen(onRegisterClicked: () {}, onForgotPasswordClicked: () {})),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(user),
            const SizedBox(height: 20),
            _buildProgressSection(context),
            const SizedBox(height: 20),
            _buildAccountActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(AppUser user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue[100],
          child: Icon(
            Icons.person,
            size: 40,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.displayName ?? 'Utilisateur MathsCool',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(user.email),
            Text(
              'Compte ${user.userType == 'child' ? 'Enfant' : 'Parent'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ma Progression',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Cliquez pour voir votre progression.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Paramètres'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Aide'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Mes Badges'),
          onTap: () {},
        ),
      ],
    );
  }
}