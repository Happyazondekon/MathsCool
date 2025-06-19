import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mathscool/screens/help_screen.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/screens/progress_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'home_screen.dart';
import 'notification_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isUpdating = false;
  String? _selectedAvatar;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  static const String _avatarPrefsKey = 'user_avatar_path';

  @override
  void initState() {
    super.initState();
    _loadSavedAvatar();
  }

  Future<void> _loadSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAvatar = prefs.getString(_avatarPrefsKey);

    if (savedAvatar != null && mounted) {
      setState(() {
        if (savedAvatar.startsWith('assets/')) {
          _selectedAvatar = savedAvatar;
        } else if (savedAvatar.isNotEmpty) {
          _selectedAvatar = savedAvatar;
        }
      });
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();

      String? photoURL;

      if (_imageFile != null) {
        photoURL = await _uploadImage(_imageFile!);
        await prefs.setString(_avatarPrefsKey, photoURL);
      } else if (_selectedAvatar != null) {
        photoURL = _selectedAvatar;
        await prefs.setString(_avatarPrefsKey, _selectedAvatar!);
      }

      if (_displayNameController.text.trim().isNotEmpty) {
        try {
          await authService.updateUserProfile(
            displayName: _displayNameController.text.trim(),
            photoURL: null,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error updating display name: $e');
          }
        }
      }

      if (photoURL != null) {
        try {
          await authService.updateUserProfile(
            displayName: null,
            photoURL: photoURL,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error updating photo URL: $e');
          }
        }
      }

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Global profile update error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileName = path.basename(imageFile.path);
      final authService = Provider.of<AuthService>(context, listen: false);
      final uid = authService.currentUser?.uid ?? 'unknown';
      final destination = 'users/$uid/profile/$fileName';

      final ref = FirebaseStorage.instance.ref().child(destination);
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      throw 'Erreur lors du téléchargement de l\'image';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _selectedAvatar = null;
      });
    }
  }

  void _selectAvatar(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
      _imageFile = null;
    });
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir un avatar'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              for (int i = 1; i <= 4; i++)
                GestureDetector(
                  onTap: () {
                    _selectAvatar('assets/avatars/avatar$i.png');
                    Navigator.pop(context);
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/avatars/avatar$i.png'),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_photo_alternate, size: 40),
                      Text('Galerie', textAlign: TextAlign.center),
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

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final displayName = currentUser.displayName ?? 'MathKid';
    final email = currentUser.email ?? '';
    final photoURL = currentUser.photoURL;

    if (_displayNameController.text.isEmpty && !_isEditing) {
      _displayNameController.text = displayName;
    }

    return Scaffold(
      body: Stack(
        children: [
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
                      _buildUserInfo(displayName, email, photoURL),
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
              try {
                await authService.signOut(); // Déconnexion
                Navigator.pop(context); // Retourne au wrapper
              } catch (e) {
                if (kDebugMode) {
                  print('Error during logout: $e');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String displayName, String email, String? photoURL) {
    ImageProvider? profileImage;

    if (_imageFile != null) {
      profileImage = FileImage(_imageFile!);
    } else if (_selectedAvatar != null) {
      if (_selectedAvatar!.startsWith('assets/')) {
        profileImage = AssetImage(_selectedAvatar!);
      } else {
        profileImage = NetworkImage(_selectedAvatar!);
      }
    } else if (photoURL != null) {
      if (photoURL.startsWith('assets/')) {
        profileImage = AssetImage(photoURL);
      } else {
        profileImage = NetworkImage(photoURL);
      }
    } else {
      profileImage = const AssetImage('assets/avatars/avatar1.png');
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImage,
                  ),
                  if (_isEditing)
                    GestureDetector(
                      onTap: _showAvatarSelectionDialog,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (_isEditing)
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom d\'utilisateur';
                    }
                    return null;
                  },
                )
              else
                Text(
                  displayName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 5),
              Text(
                email,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
              if (_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: _isUpdating
                          ? null
                          : () => setState(() => _isEditing = false),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                      onPressed: _isUpdating ? null : _updateProfile,
                      child: _isUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Enregistrer'),
                    ),
                  ],
                )
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Modifier le profil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                  onPressed: () => setState(() => _isEditing = true),
                ),
            ],
          ),
        ),
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
    final authService = Provider.of<AuthService>(context, listen: false);
    final displayName = authService.currentUser?.displayName ?? 'MathKid';

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          // Aide
          ListTile(
            leading: const Icon(Icons.help, color: AppColors.primary),
            title: const Text('Aide'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpScreen(),
                ),
              );
            },
          ),
          // Mes Rappels
          ListTile(
            leading: const Icon(Icons.notifications, color: AppColors.primary),
            title: const Text('Mes Rappels'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationSettingsScreen(
                    userName: displayName,
                  ),
                ),
              );
            },
          ),
          // Retourner à l'accueil
          ListTile(
            leading: const Icon(Icons.home, color: AppColors.primary),
            title: const Text('Retourner à l\'accueil'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}