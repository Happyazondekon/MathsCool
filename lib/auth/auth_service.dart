import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show SocketException;

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    await _auth.signOut();
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
    required String password
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
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
      default:
        return 'Une erreur est survenue : ${e.code}';
    }
  }
}