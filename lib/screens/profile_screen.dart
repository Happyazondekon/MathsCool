import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/screens/help_screen.dart';
import 'package:mathscool/screens/home_screen.dart';
import 'package:mathscool/screens/notification_settings_screen.dart';
import 'package:mathscool/screens/progress_screen.dart';
import 'package:mathscool/screens/leaderboard_screen.dart';
import 'package:mathscool/screens/store_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final _displayNameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedLevel;

  bool _isEditing = false;
  bool _isUpdating = false;

  String? _selectedAvatar;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Clés de sauvegarde SharedPreferences
  static const String _avatarPrefsKey = 'user_avatar_path';
  static const String _schoolPrefsKey = 'user_school';
  static const String _levelPrefsKey = 'user_level';
  static const String _bioPrefsKey = 'user_bio';

  // Liste des niveaux disponibles
  final List<String> _levels = [
    'CI', 'CP', 'CE1', 'CE2', 'CM1', 'CM2',
    '6ème', '5ème', '4ème', '3ème'
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _schoolController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Chargement des données locales
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _selectedAvatar = prefs.getString(_avatarPrefsKey);
        // École par défaut = MathsCool
        _schoolController.text = prefs.getString(_schoolPrefsKey) ?? 'MathsCool';
        _bioController.text = prefs.getString(_bioPrefsKey) ?? '';
        _selectedLevel = prefs.getString(_levelPrefsKey);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();

      // 1. GESTION AVATAR
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        final base64Image = base64Encode(bytes);
        final avatarPath = 'base64:$base64Image';
        await prefs.setString(_avatarPrefsKey, avatarPath);
        setState(() => _selectedAvatar = avatarPath);
      } else if (_selectedAvatar != null) {
        await prefs.setString(_avatarPrefsKey, _selectedAvatar!);
      }

      // 2. GESTION INFOS SUP
      await prefs.setString(_schoolPrefsKey, _schoolController.text.trim());
      await prefs.setString(_bioPrefsKey, _bioController.text.trim());
      if (_selectedLevel != null) {
        await prefs.setString(_levelPrefsKey, _selectedLevel!);
      }

      // 3. GESTION DU NOM
      if (_displayNameController.text.trim().isNotEmpty) {
        try {
          await authService.updateUserProfile(
            displayName: _displayNameController.text.trim(),
            photoURL: null,
          );
          await authService.reloadUser();
        } catch (e) {
          if (kDebugMode) print('Error updating display name: $e');
        }
      }

      // 4. UI FEEDBACK
      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _selectedAvatar = null;
      });
    }
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisis ta photo', style: TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              for (int i = 1; i <= 4; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = 'assets/avatars/avatar$i.png';
                      _imageFile = null;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset('assets/avatars/avatar$i.png'),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo, size: 30, color: Colors.green),
                      Text('Galerie', style: TextStyle(fontFamily: 'ComicNeue')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser;

    if (currentUser == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final displayName = currentUser.displayName ?? 'MathKid';
    final email = currentUser.email ?? '';

    if (!_isEditing && _displayNameController.text.isEmpty) {
      _displayNameController.text = displayName;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B6B),
              Color(0xFFD32F2F),
              Colors.red,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),

              // Section informations profil
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _isEditing
                      ? _buildEditForm(context)
                      : _buildProfileContent(context, displayName, email),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD32F2F)),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Mon Profil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFD32F2F)),
                onPressed: () async {
                  await authService.signOut();
                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.yellow.shade400],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Gère tes informations et accède à tes statistiques',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
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

  Widget _buildProfileContent(BuildContext context, String displayName, String email) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // Carte profil principale
          _buildProfileCard(context, displayName, email),
          const SizedBox(height: 20),

          // Titre section menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Menu Principal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Grille des options de menu
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: _menuOptions.length,
            itemBuilder: (context, index) {
              return _buildMenuCard(context, _menuOptions[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String displayName, String email) {
    final now = DateTime.now();
    final studentId = email.hashCode.abs().toString().substring(0, 6);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value.clamp(0.0, 1.0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => setState(() => _isEditing = true),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade400,
                Colors.blue.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Motif décoratif
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Contenu principal
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: _buildAvatarImage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Informations principales
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'ComicNeue',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _selectedLevel ?? 'Niveau non défini',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bouton édition
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.purple,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Informations supplémentaires
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informations Scolaires',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'ComicNeue',
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Établissement', _schoolController.text.isNotEmpty ? _schoolController.text : 'MathsCool'),
                          const SizedBox(height: 8),
                          _buildInfoRow('N° Élève', studentId),
                          const SizedBox(height: 8),
                          _buildInfoRow('Année Scolaire', '${now.year}-${now.year + 1}'),
                          if (_bioController.text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow('Devise', _bioController.text),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value.clamp(0.0, 1.0),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Modifier le Profil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Avatar avec bouton de changement
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(56),
                          child: SizedBox(
                            width: 112,
                            height: 112,
                            child: _buildAvatarImage(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showAvatarSelectionDialog,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Champs de formulaire
                TextFormField(
                  controller: _displayNameController,
                  decoration: _inputDecoration('Prénom / Pseudo', Icons.person_outline),
                  validator: (v) => v!.isEmpty ? 'Ce champ est requis' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  decoration: _inputDecoration('Classe', Icons.school_outlined),
                  items: _levels.map((level) => DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedLevel = val),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _schoolController,
                  decoration: _inputDecoration('École', Icons.location_city_outlined),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _bioController,
                  decoration: _inputDecoration('Devise ou Hobby', Icons.favorite_outline),
                  maxLength: 40,
                ),

                const SizedBox(height: 24),

                // Boutons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => setState(() => _isEditing = false),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _isUpdating ? null : _updateProfile,
                        child: _isUpdating
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                            : const Text('Sauvegarder'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.red),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildAvatarImage() {
    ImageProvider? image;

    if (_imageFile != null) {
      image = FileImage(_imageFile!);
    } else if (_selectedAvatar != null) {
      if (_selectedAvatar!.startsWith('base64:')) {
        try {
          final base64String = _selectedAvatar!.substring(7);
          final bytes = base64Decode(base64String);
          image = MemoryImage(bytes);
        } catch (e) {
          image = const AssetImage('assets/avatars/avatar1.png');
        }
      } else if (_selectedAvatar!.startsWith('assets/')) {
        image = AssetImage(_selectedAvatar!);
      } else {
        image = const AssetImage('assets/avatars/avatar1.png');
      }
    } else {
      image = const AssetImage('assets/avatars/avatar1.png');
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Options de menu
  final List<Map<String, dynamic>> _menuOptions = [
    {
      'title': 'Classements ',
      'icon': Icons.emoji_events_rounded,
      'color': Colors.amber,
      'route': (BuildContext context) => const LeaderboardScreen(),
    },
    {
      'title': 'Ma Progression',
      'icon': Icons.bar_chart_rounded,
      'color': Colors.blue,
      'route': (BuildContext context) => const ProgressScreen(),
    },
    {
      'title': 'Boutique',
      'icon': Icons.shopping_bag_rounded, // Icône de sac de shopping
      'color': Colors.orangeAccent,       // Couleur vive pour attirer l'attention
      'route': (BuildContext context) => const StoreScreen(), // Remplacez par votre écran de boutique
    },
    {
      'title': 'Centre d\'Aide',
      'icon': Icons.help_outline_rounded,
      'color': Colors.green,
      'route': (BuildContext context) => const HelpScreen(),
    },
    {
      'title': 'Mes Rappels',
      'icon': Icons.notifications_active_outlined,
      'color': Colors.orange,
      'route': (BuildContext context) => NotificationSettingsScreen(userName: ''),
    },
    {
      'title': 'Retour Accueil',
      'icon': Icons.home_rounded,
      'color': Colors.red,
      'route': (BuildContext context) => const HomeScreen(),
    },
  ];

  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> option, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value.clamp(0.0, 1.0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (option['title'] == 'Retour Accueil') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: option['route']),
                  (route) => false,
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: option['route']),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                option['color'].withOpacity(0.8),
                option['color'].withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: option['color'].withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Motif décoratif
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Contenu
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        option['icon'],
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        option['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ComicNeue',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}