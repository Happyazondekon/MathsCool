import 'dart:convert';

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

  // Méthode pour charger l'avatar sauvegardé
  Future<void> _loadSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAvatar = prefs.getString(_avatarPrefsKey);

    if (savedAvatar != null && mounted) {
      setState(() {
        _selectedAvatar = savedAvatar;
      });
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  // Méthode de mise à jour simplifiée
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();

      String? avatarPath;

      // 1. Gérer l'avatar
      if (_imageFile != null) {
        // Sauvegarder l'image en base64 dans SharedPreferences
        final base64Image = await _saveImageLocally(_imageFile!);
        if (base64Image != null) {
          avatarPath = 'base64:$base64Image';
          await prefs.setString(_avatarPrefsKey, avatarPath);
        }
      } else if (_selectedAvatar != null) {
        // Utiliser l'avatar prédéfini
        avatarPath = _selectedAvatar;
        await prefs.setString(_avatarPrefsKey, _selectedAvatar!);
      }

      // 2. Mettre à jour le nom d'affichage dans Firebase Auth
      if (_displayNameController.text.trim().isNotEmpty) {
        try {
          await authService.updateUserProfile(
            displayName: _displayNameController.text.trim(),
            photoURL: null,
          );
          await authService.reloadUser();
        } catch (e) {
          if (kDebugMode) {
            print('Error updating display name: $e');
          }
        }
      }

      // 3. Mettre à jour l'état local
      if (mounted) {
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès')),
        );

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Global profile update error: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }



  // Version améliorée avec compression et meilleure gestion
  Future<String> _uploadImage(File imageFile) async {
    try {
      if (kDebugMode) {
        print('Starting image upload...');
      }

      final authService = Provider.of<AuthService>(context, listen: false);
      final uid = authService.currentUser?.uid;

      if (uid == null) {
        throw 'Utilisateur non connecté';
      }

      // Compresser l'image avant l'upload
      File? compressedFile;
      try {
        // Importer image package si nécessaire
        final bytes = await imageFile.readAsBytes();
        if (kDebugMode) {
          print('Image size before: ${bytes.length} bytes');
        }

        // Si l'image est trop grande, on la compresse
        if (bytes.length > 500000) { // > 500KB
          // Utiliser image_picker pour redimensionner
          final XFile? compressedImage = await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 800,
            maxHeight: 800,
            imageQuality: 70,
          );

          if (compressedImage != null) {
            compressedFile = File(compressedImage.path);
            if (kDebugMode) {
              print('Image compressed');
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Compression error (using original): $e');
        }
      }

      final fileToUpload = compressedFile ?? imageFile;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final destination = 'users/$uid/profile/$fileName';

      if (kDebugMode) {
        print('Uploading to: $destination');
      }

      final ref = FirebaseStorage.instance.ref().child(destination);

      // Metadata pour optimiser
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'uploaded-by': uid},
      );

      final uploadTask = ref.putFile(fileToUpload, metadata);

      // Écouter la progression
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        if (kDebugMode) {
          print('Upload progress: ${(progress * 100).toStringAsFixed(0)}%');
        }
      });

      // Attendre la fin de l'upload avec un timeout plus long
      final snapshot = await uploadTask.timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          throw 'Le téléchargement prend trop de temps. Vérifiez votre connexion.';
        },
      );

      final downloadURL = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('Upload successful! URL: $downloadURL');
      }

      return downloadURL;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Firebase error uploading image: ${e.code} - ${e.message}');
      }

      // Messages d'erreur plus explicites
      switch (e.code) {
        case 'unauthorized':
          throw 'Permission refusée. Vérifiez les règles Firebase Storage.';
        case 'canceled':
          throw 'Téléchargement annulé';
        case 'unknown':
          throw 'Erreur réseau. Vérifiez votre connexion internet.';
        default:
          throw 'Erreur Firebase: ${e.message ?? e.code}';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      rethrow;
    }
  }

  // Méthode améliorée pour sélectionner une image
  // Méthode simplifiée pour sélectionner une image
  Future<void> _pickImage() async {
    try {
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

        if (kDebugMode) {
          print('Image selected: ${pickedFile.path}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la sélection de l\'image')),
        );
      }
    }
  }

// Méthode pour sauvegarder l'image localement
  Future<String?> _saveImageLocally(File imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Lire les bytes de l'image
      final bytes = await imageFile.readAsBytes();

      // Convertir en base64
      final base64Image = base64Encode(bytes);

      // Sauvegarder dans SharedPreferences
      await prefs.setString('user_avatar_base64', base64Image);

      if (kDebugMode) {
        print('Image saved locally, size: ${bytes.length} bytes');
      }

      return base64Image;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving image locally: $e');
      }
      return null;
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
                colors: [AppColors.christ, Colors.white],
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
        color: AppColors.christ,
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

  // Widget pour afficher l'avatar (à utiliser dans _buildUserInfo)
  Widget _buildAvatarImage() {
    ImageProvider? profileImage;

    if (_imageFile != null) {
      // Image temporaire sélectionnée
      profileImage = FileImage(_imageFile!);
    } else if (_selectedAvatar != null) {
      if (_selectedAvatar!.startsWith('base64:')) {
        // Image base64 sauvegardée
        try {
          final base64String = _selectedAvatar!.substring(7); // Enlever "base64:"
          final bytes = base64Decode(base64String);
          profileImage = MemoryImage(bytes);
        } catch (e) {
          if (kDebugMode) {
            print('Error decoding base64 image: $e');
          }
          profileImage = const AssetImage('assets/avatars/avatar1.png');
        }
      } else if (_selectedAvatar!.startsWith('assets/')) {
        // Avatar prédéfini
        profileImage = AssetImage(_selectedAvatar!);
      } else if (_selectedAvatar!.startsWith('http')) {
        // URL (si jamais vous décidez de garder les anciennes images)
        profileImage = NetworkImage(_selectedAvatar!);
      }
    } else {
      // Avatar par défaut
      profileImage = const AssetImage('assets/avatars/avatar1.png');
    }

    return CircleAvatar(
      radius: 50,
      backgroundImage: profileImage,
    );
  }

// Version simplifiée de _buildUserInfo
  Widget _buildUserInfo(String displayName, String email, String? photoURL) {
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
                  _buildAvatarImage(), // Utiliser le nouveau widget
                  if (_isEditing)
                    GestureDetector(
                      onTap: _showAvatarSelectionDialog,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.christ,
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
        leading: const Icon(Icons.bar_chart, color: AppColors.christ),
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
            leading: const Icon(Icons.help, color: AppColors.christ),
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
            leading: const Icon(Icons.notifications, color: AppColors.christ),
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
            leading: const Icon(Icons.home, color: AppColors.christ),
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