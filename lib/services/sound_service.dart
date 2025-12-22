// lib/services/sound_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _sfxVolume = 0.7;
  double _musicVolume = 0.3;
  bool _isInitialized = false;

  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';
  static const String _sfxVolumeKey = 'sfx_volume';
  static const String _musicVolumeKey = 'music_volume';

  // Initialisation avec préchauffage des sons
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      _soundEnabled = prefs.getBool(_soundEnabledKey) ?? true;
      _musicEnabled = prefs.getBool(_musicEnabledKey) ?? true;
      _sfxVolume = prefs.getDouble(_sfxVolumeKey) ?? 0.7;
      _musicVolume = prefs.getDouble(_musicVolumeKey) ?? 0.3;

      // Configuration des players
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _sfxPlayer.setReleaseMode(ReleaseMode.release);

      // ✅ PRÉCHAUFFAGE : Précharger les sons les plus utilisés
      if (_soundEnabled) {
        await _preloadSounds();
      }

      _isInitialized = true;
      if (kDebugMode) print('✅ SoundService initialisé avec succès');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur initialisation SoundService: $e');
    }
  }

  // Précharger les sons critiques pour éviter les latences
  Future<void> _preloadSounds() async {
    try {
      // Sons les plus fréquents
      final criticalSounds = [
        'sounds/click.mp3',
        'sounds/correct.mp3',
        'sounds/wrong.mp3',
      ];

      for (final sound in criticalSounds) {
        await _sfxPlayer.setSource(AssetSource(sound));
      }

      if (kDebugMode) print('✅ Sons critiques préchargés');
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur préchargement sons: $e');
    }
  }

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  double get sfxVolume => _sfxVolume;
  double get musicVolume => _musicVolume;
  bool get isInitialized => _isInitialized;

  // Setters avec sauvegarde
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);

    // Si on réactive, précharger les sons
    if (enabled && _isInitialized) {
      await _preloadSounds();
    }
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicEnabledKey, enabled);

    if (!enabled) {
      await _musicPlayer.stop();
    } else {
      await playBackgroundMusic();
    }
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0); // Sécurité
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_sfxVolumeKey, _sfxVolume);
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0); // Sécurité
    await _musicPlayer.setVolume(_musicVolume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_musicVolumeKey, _musicVolume);
  }

  // ===== MÉTHODE GÉNÉRIQUE POUR JOUER UN SON =====
  Future<void> _playSfx(String soundFile, {double volumeMultiplier = 1.0, bool stopPrevious = true}) async {
    if (!_soundEnabled) return;

    try {
      if (stopPrevious) {
        await _sfxPlayer.stop();
      }
      await _sfxPlayer.setVolume((_sfxVolume * volumeMultiplier).clamp(0.0, 1.0));
      await _sfxPlayer.play(AssetSource(soundFile));
    } catch (e) {
      if (kDebugMode) print('❌ Erreur lecture son $soundFile: $e');
    }
  }

  // ===== SONS D'EFFET (SFX) =====

  /// Son de bonne réponse
  Future<void> playCorrectAnswer() async {
    await _playSfx('sounds/correct.mp3');
  }

  /// Son de mauvaise réponse
  Future<void> playWrongAnswer() async {
    await _playSfx('sounds/wrong.mp3');
  }

  /// Son de bouton/clic (plus discret)
  Future<void> playButtonClick() async {
    await _playSfx('sounds/click.mp3', volumeMultiplier: 0.5, stopPrevious: false);
  }

  /// Son de victoire/succès
  Future<void> playVictory() async {
    await _playSfx('sounds/victory.mp3');
  }

  /// Son de badge/achievement débloqué
  Future<void> playAchievement() async {
    await _playSfx('sounds/achievement.mp3');
  }

  /// Son de perte de vie
  Future<void> playLifeLost() async {
    await _playSfx('sounds/life_lost.mp3');
  }

  /// Son de recharge de vies
  Future<void> playLifeRestore() async {
    await _playSfx('sounds/life_restore.mp3');
  }

  /// Son de niveau complété
  Future<void> playLevelComplete() async {
    await _playSfx('sounds/level_complete.mp3');
  }

  /// Son de notification (plus discret)
  Future<void> playNotification() async {
    await _playSfx('sounds/notification.mp3', volumeMultiplier: 0.6, stopPrevious: false);
  }

  /// Son d'étoiles (selon le nombre)
  Future<void> playStars(int starCount) async {
    final soundFile = starCount >= 3
        ? 'sounds/stars_3.mp3'
        : starCount == 2
        ? 'sounds/stars_2.mp3'
        : 'sounds/stars_1.mp3';

    await _playSfx(soundFile);
  }

  /// Son de countdown (3, 2, 1)
  Future<void> playCountdown() async {
    await _playSfx('sounds/countdown.mp3', stopPrevious: false);
  }

  /// Son de début de défi
  Future<void> playStartChallenge() async {
    await _playSfx('sounds/start.mp3');
  }

  // ===== MUSIQUE DE FOND =====

  /// Jouer la musique de fond
  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;

    try {
      // Vérifier si la musique est déjà en cours
      if (await _musicPlayer.getCurrentPosition() != null) {
        final state = _musicPlayer.state;
        if (state == PlayerState.playing) {
          if (kDebugMode) print('🎵 Musique déjà en cours');
          return;
        }
      }

      // Configuration pour la boucle
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(_musicVolume);

      // Lancer la musique
      await _musicPlayer.play(AssetSource('sounds/background_music.mp3'));

      if (kDebugMode) print('🎵 Musique de fond lancée');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur lecture musique: $e');
    }
  }

  /// Arrêter la musique de fond
  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
      if (kDebugMode) print('🔇 Musique arrêtée');
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur arrêt musique: $e');
    }
  }

  /// Pause musique de fond
  Future<void> pauseBackgroundMusic() async {
    try {
      await _musicPlayer.pause();
      if (kDebugMode) print('⏸️ Musique en pause');
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur pause musique: $e');
    }
  }

  /// Reprendre musique de fond
  Future<void> resumeBackgroundMusic() async {
    if (!_musicEnabled) return;

    try {
      await _musicPlayer.resume();
      if (kDebugMode) print('▶️ Musique reprise');
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur reprise musique: $e');
    }
  }

  /// Faire un fade out de la musique
  Future<void> fadeOutMusic({Duration duration = const Duration(seconds: 2)}) async {
    try {
      const steps = 20;
      final stepDuration = duration.inMilliseconds ~/ steps;
      final volumeStep = _musicVolume / steps;

      for (int i = 0; i < steps; i++) {
        final newVolume = _musicVolume - (volumeStep * i);
        await _musicPlayer.setVolume(newVolume.clamp(0.0, 1.0));
        await Future.delayed(Duration(milliseconds: stepDuration));
      }

      await _musicPlayer.stop();
      await _musicPlayer.setVolume(_musicVolume); // Restaurer le volume
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur fade out: $e');
    }
  }

  /// Faire un fade in de la musique
  Future<void> fadeInMusic({Duration duration = const Duration(seconds: 2)}) async {
    if (!_musicEnabled) return;

    try {
      await _musicPlayer.setVolume(0.0);
      await _musicPlayer.play(AssetSource('sounds/background_music.mp3'));

      const steps = 20;
      final stepDuration = duration.inMilliseconds ~/ steps;
      final volumeStep = _musicVolume / steps;

      for (int i = 0; i < steps; i++) {
        final newVolume = volumeStep * i;
        await _musicPlayer.setVolume(newVolume.clamp(0.0, 1.0));
        await Future.delayed(Duration(milliseconds: stepDuration));
      }

      await _musicPlayer.setVolume(_musicVolume); // Volume final
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur fade in: $e');
    }
  }

  // ===== GESTION DU CYCLE DE VIE =====

  /// Mettre en pause tous les sons (pour app en arrière-plan)
  Future<void> pauseAll() async {
    try {
      await _sfxPlayer.pause();
      await _musicPlayer.pause();
      if (kDebugMode) print('⏸️ Tous les sons en pause');
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur pause tous: $e');
    }
  }

  /// Reprendre tous les sons
  Future<void> resumeAll() async {
    try {
      if (_musicEnabled) {
        await _musicPlayer.resume();
      }
      if (kDebugMode) print('▶️ Sons repris');
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur reprise tous: $e');
    }
  }

  /// Nettoyage complet
  Future<void> dispose() async {
    try {
      await _sfxPlayer.dispose();
      await _musicPlayer.dispose();
      _isInitialized = false;
      if (kDebugMode) print('🧹 SoundService nettoyé');
    } catch (e) {
      if (kDebugMode) print('⚠️ Erreur dispose: $e');
    }
  }
}