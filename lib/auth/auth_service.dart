import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show SocketException;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream d'utilisateur transformé en AppUser
  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().map((User? user) {
      if (user == null) return null;
      return AppUser.fromFirebase(user);
    });
  }

  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user != null ? AppUser.fromFirebase(user) : null;
  }

  Future<void> signOut() async {
    // Déconnexion de Google si connecté
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    // Déconnexion Firebase
    await _auth.signOut();
  }

  // Connexion avec Google
  Future<User?> signInWithGoogle() async {
    try {
      // Déclencher le flux d'authentification
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // L'utilisateur a annulé

      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Créer un credential pour Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion à Firebase avec le credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _authErrorMapper(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Network error: ${e.message}');
      }
      throw 'Vérifiez votre connexion internet';
    } catch (e) {
      if (kDebugMode) {
        print('Google sign in error: $e');
      }
      throw 'Une erreur est survenue lors de la connexion avec Google';
    }
  }

  // Connexion avec email/mot de passe
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _authErrorMapper(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Network error: ${e.message}');
      }
      throw 'Vérifiez votre connexion internet';
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      throw 'Une erreur inattendue est survenue. Réessayez.';
    }
  }

  // Inscription avec email/mot de passe
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Si un displayName est fourni, on le définit immédiatement
      if (displayName != null && result.user != null) {
        await result.user!.updateDisplayName(displayName);
        // Recharger l'utilisateur pour que les changements soient pris en compte
        await result.user!.reload();
      }

      return _auth.currentUser; // Pour obtenir les informations mises à jour
    } on FirebaseAuthException catch (e) {
      throw _authErrorMapper(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Network error: ${e.message}');
      }
      throw 'Vérifiez votre connexion internet';
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      throw 'Une erreur inattendue est survenue. Réessayez.';
    }
  }

  // Réinitialisation du mot de passe
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _authErrorMapper(e);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Network error: ${e.message}');
      }
      throw 'Vérifiez votre connexion internet';
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      throw 'Une erreur inattendue est survenue. Réessayez.';
    }
  }

  // Mise à jour du profil utilisateur
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'Aucun utilisateur connecté';
      }

      // Préparer les mises à jour
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      // Recharger l'utilisateur pour que les changements soient pris en compte
      await user.reload();

    } on FirebaseAuthException catch (e) {
      throw _authErrorMapper(e);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      throw 'Erreur lors de la mise à jour du profil';
    }
  }

  // Gestion des erreurs
  String _authErrorMapper(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email invalide';
      case 'user-disabled':
        return 'Utilisateur désactivé';
      case 'user-not-found':
        return 'Utilisateur non trouvé';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Email déjà utilisé';
      case 'operation-not-allowed':
        return 'Opération non autorisée';
      case 'weak-password':
        return 'Mot de passe trop faible';
      case 'network-request-failed':
        return 'Erreur de réseau. Vérifiez votre connexion.';
      case 'requires-recent-login':
        return 'Cette opération nécessite une authentification récente. Veuillez vous reconnecter.';
      case 'account-exists-with-different-credential':
        return 'Un compte existe déjà avec cette adresse email mais avec une méthode de connexion différente.';
      default:
        return 'Une erreur est survenue : ${e.code}';
    }
  }
}