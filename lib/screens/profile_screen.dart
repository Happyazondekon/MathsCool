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
            content: Text('Carte scolaire mise à jour ! 🎅'),
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
                      border: Border.all(color: Colors.red, width: 2), // Rouge Noël
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
                    color: Colors.green[50], // Vert pâle Noël
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
      body: Stack(
        children: [
          // Fond dégradé Noël
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.christ, Colors.white],
              ),
            ),
          ),
          // Éléments décoratifs Noël
          Positioned(
            top: 50,
            right: 20,
            child: Icon(Icons.star, color: Colors.yellow[700], size: 30),
          ),
          Positioned(
            top: 100,
            left: 10,
            child: Icon(Icons.ac_unit, color: Colors.blue[50], size: 25),
          ),
          Positioned(
            bottom: 150,
            right: 30,
            child: Icon(Icons.card_giftcard, color: Colors.red[300], size: 28),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, authService),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: _isEditing
                              ? _buildEditForm()
                              : _buildSchoolIDCard(displayName, email),
                        ),
                        const SizedBox(height: 20),
                        _buildMenuOptions(context),
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

  // --- CARTE SCOLAIRE THÈME NOËL ---
  Widget _buildSchoolIDCard(String name, String email) {
    final now = DateTime.now();
    final studentId = email.hashCode.abs().toString().substring(0, 6);

    return Stack(
      children: [
        Container(
          key: const ValueKey('card'),
          width: double.infinity,
          height: 520,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // HEADER - Bandeau supérieur Noël
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    // Motif de Noël
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Icon(Icons.star, color: Colors.yellow[100]!.withOpacity(0.3), size: 80),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: Icon(Icons.ac_unit, color: Colors.blue[50]!.withOpacity(0.3), size: 60),
                    ),
                    // Contenu du header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo école avec bordure Noël
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 40,
                              width: 40,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.calculate_rounded,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Nom de l'école
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'MathsCool',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ComicNeue',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'CARTE D\'ÉLÈVE - JOYEUX NOËL !',
                                  style: TextStyle(
                                    color: Colors.yellow[100],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Année scolaire
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.yellow.withOpacity(0.5)),
                            ),
                            child: Text(
                              '${now.year}-${now.year + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // CORPS DE LA CARTE
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Photo et informations principales
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Photo d'identité avec bordure Noël
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3), // Rouge Noël
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 100,
                                height: 120,
                                color: Colors.green[50], // Fond vert pâle
                                child: _buildAvatarImage(isRectangle: true),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Informations élève
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                _buildInfoRow('NOM', name.toUpperCase()),
                                const SizedBox(height: 12),
                                _buildInfoRow('CLASSE', _selectedLevel ?? 'Non défini'),
                                const SizedBox(height: 12),
                                _buildInfoRow('N° ÉLÈVE', studentId),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Séparateur avec icône Noël
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.green[300], thickness: 2)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.star, color: Colors.yellow[700], size: 20),
                          ),
                          Expanded(child: Divider(color: Colors.green[300], thickness: 2)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Informations supplémentaires
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[50]!, Colors.green[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red[100]!),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              Icons.home_work_outlined,
                              'Établissement',
                              _schoolController.text.isNotEmpty ? _schoolController.text : 'MathsCool',
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              Icons.favorite_outline,
                              'Devise de Noël',
                              _bioController.text.isNotEmpty ? _bioController.text : 'Joyeuses Mathématiques ! 🎄',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // FOOTER - Bande décorative Noël
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.green.shade600],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bouton crayon en haut à droite
        Positioned(
          top: 130,
          right: 95,
          child: GestureDetector(
            onTap: () => setState(() => _isEditing = true),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.green[800],
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
            fontFamily: 'ComicNeue',
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.red),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- FORMULAIRE D'ÉDITION THÈME NOËL ---
  Widget _buildEditForm() {
    return Card(
      key: const ValueKey('form'),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.edit, color: Colors.red),
                  const SizedBox(width: 8),
                  const Text(
                    'Modifier mes informations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicNeue',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Center(
                child: Stack(
                  children: [
                    _buildAvatarImage(radius: 50),
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _displayNameController,
                decoration: _inputDecoration('Ton Prénom / Pseudo', Icons.person_outline),
                validator: (v) => v!.isEmpty ? 'Dis-nous comment tu t\'appelles !' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: _inputDecoration('Ta Classe', Icons.school_outlined),
                items: _levels.map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                )).toList(),
                onChanged: (val) => setState(() => _selectedLevel = val),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _schoolController,
                decoration: _inputDecoration('Ton École', Icons.location_city_outlined).copyWith(
                  helperText: 'Par défaut: MathsCool',
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bioController,
                maxLength: 40,
                decoration: _inputDecoration('Ta devise ou Hobby', Icons.favorite_outline).copyWith(
                  helperText: 'Ex: J\'adore les cadeaux de Noël !',
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _isEditing = false),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Annuler'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isUpdating ? null : _updateProfile,
                      icon: _isUpdating
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check, size: 18),
                      label: const Text('Sauvegarder'),
                    ),
                  ),
                ],
              ),
            ],
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
        borderSide: BorderSide(color: Colors.green[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildAvatarImage({double? radius, bool isRectangle = false}) {
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

    if (isRectangle) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius ?? 40,
      backgroundImage: image,
      backgroundColor: Colors.green[100],
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Column(
      children: [
        _buildMenuCard(
          'Voir ma progression',
          Icons.bar_chart_rounded,
          Colors.red, // Rouge Noël
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
        ),
        const SizedBox(height: 10),
        _buildMenuCard(
          'Centre d\'aide',
          Icons.help_outline_rounded,
          Colors.green, // Vert Noël
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
        ),
        const SizedBox(height: 10),
        _buildMenuCard(
          'Mes Rappels',
          Icons.notifications_active_outlined,
          Colors.orange, // Orange Noël
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationSettingsScreen(userName: _displayNameController.text))),
        ),
        const SizedBox(height: 10),
        _buildMenuCard(
          'Retour accueil',
          Icons.home_rounded,
          Colors.red, // Rouge Noël
              () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false),
        ),
      ],
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green[50], // Fond vert pâle Noël
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
            fontSize: 16,
            color: Colors.green[900],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.red),
        onTap: onTap,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Ma Carte Scolaire 🎄',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'ComicNeue',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 26),
            onPressed: () async {
              await authService.signOut();
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}