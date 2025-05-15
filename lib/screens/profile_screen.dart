import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/auth/auth_service.dart';
import 'package:mathscool/screens/progress_screen.dart';
import 'package:mathscool/utils/colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

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
        // Vérifier si c'est un avatar prédéfini ou une URL
        if (savedAvatar.startsWith('assets/')) {
          _selectedAvatar = savedAvatar;
        } else if (savedAvatar.isNotEmpty) {
          // C'est une URL d'image stockée sur Firebase
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

      // Traitement de l'image s'il y en a une
      if (_imageFile != null) {
        // Upload de l'image vers Firebase Storage
        photoURL = await _uploadImage(_imageFile!);
        // Sauvegarde de l'URL dans les SharedPreferences
        await prefs.setString(_avatarPrefsKey, photoURL);
      } else if (_selectedAvatar != null) {
        photoURL = _selectedAvatar;
        await prefs.setString(_avatarPrefsKey, _selectedAvatar!);
      }

      // Mises à jour séparées pour éviter les problèmes de casting
      // 1. Mise à jour du displayName si nécessaire
      if (_displayNameController.text.trim().isNotEmpty) {
        try {
          await authService.updateUserProfile(
            displayName: _displayNameController.text.trim(),
            photoURL: null,  // Important: ne pas mélanger les mises à jour
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error updating display name: $e');
          }
          // Continue malgré l'erreur pour essayer d'au moins mettre à jour la photo
        }
      }

      // 2. Mise à jour de la photo si nécessaire
      if (photoURL != null) {
        try {
          await authService.updateUserProfile(
            displayName: null,  // Important: ne pas mélanger les mises à jour
            photoURL: photoURL,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error updating photo URL: $e');
          }
          // Continue même si la mise à jour de la photo échoue
        }
      }


      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );

      // Retour à l'écran d'accueil après l'enregistrement
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

      // Récupérer et retourner l'URL de l'image
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
        _selectedAvatar = null; // Réinitialiser l'avatar s'il y en avait un
      });
    }
  }

  void _selectAvatar(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
      _imageFile = null; // Réinitialiser l'image s'il y en avait une
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
              // Option pour sélectionner depuis la galerie
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

    // Si l'utilisateur n'est pas connecté, on affiche un écran de chargement
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Récupération des données de l'utilisateur
    final displayName = currentUser.displayName ?? 'MathKid';
    final email = currentUser.email ?? '';
    final photoURL = currentUser.photoURL;

    // Initialiser le contrôleur avec le displayName actuel si ce n'est pas encore fait
    if (_displayNameController.text.isEmpty && !_isEditing) {
      _displayNameController.text = displayName;
    }

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
              await authService.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String displayName, String email, String? photoURL) {
    // Déterminer l'image à afficher
    ImageProvider? profileImage;

    if (_imageFile != null) {
      // Image sélectionnée depuis la galerie
      profileImage = FileImage(_imageFile!);
    } else if (_selectedAvatar != null) {
      // Avatar prédéfini sélectionné
      if (_selectedAvatar!.startsWith('assets/')) {
        profileImage = AssetImage(_selectedAvatar!);
      } else {
        profileImage = NetworkImage(_selectedAvatar!);
      }
    } else if (photoURL != null) {
      // Image de profil existante sur Firebase
      if (photoURL.startsWith('assets/')) {
        profileImage = AssetImage(photoURL);
      } else {
        profileImage = NetworkImage(photoURL);
      }
    } else {
      // Avatar par défaut
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
              // Photo de profil avec bouton pour modifier
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

              // Nom d'utilisateur (éditable)
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

              // Email (non éditable)
              Text(
                email,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 15),

              // Bouton d'édition ou de sauvegarde
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