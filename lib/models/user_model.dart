import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  // NOUVEAU: Statut de vérification de l'email
  final bool emailVerified;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified, // <-- AJOUTÉ
  });

  /// Factory method pour créer un AppUser à partir d'un User Firebase
  factory AppUser.fromFirebase(User firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified, // <-- AJOUTÉ
    );
  }

  /// Méthode pour copier l'objet avec des modifications
  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified, // <-- AJOUTÉ
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified, // <-- AJOUTÉ
    );
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, emailVerified: $emailVerified)';
  }
}