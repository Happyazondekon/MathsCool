// lib/screens/sound_settings_screen.dart
import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class SoundSettingsScreen extends StatefulWidget {
  const SoundSettingsScreen({Key? key}) : super(key: key);

  @override
  State<SoundSettingsScreen> createState() => _SoundSettingsScreenState();
}

class _SoundSettingsScreenState extends State<SoundSettingsScreen> {
  final SoundService _soundService = SoundService();
  late bool _soundEnabled;
  late bool _musicEnabled;
  late double _sfxVolume;
  late double _musicVolume;

  @override
  void initState() {
    super.initState();
    _soundEnabled = _soundService.soundEnabled;
    _musicEnabled = _soundService.musicEnabled;
    _sfxVolume = _soundService.sfxVolume;
    _musicVolume = _soundService.musicVolume;
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildMainToggleCard(),
                      const SizedBox(height: 20),
                      if (_soundEnabled) _buildSfxVolumeCard(),
                      if (_soundEnabled) const SizedBox(height: 20),
                      if (_musicEnabled) _buildMusicVolumeCard(),
                      const SizedBox(height: 20),

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

  Widget _buildHeader() {
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
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD32F2F)),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Paramètres Audio 🎵',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  'Personnalise tes sons',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMainToggleCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sons d'effets
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _soundEnabled ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _soundEnabled ? Icons.volume_up : Icons.volume_off,
                    color: _soundEnabled ? Colors.green : Colors.grey,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sons d\'effets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      Text(
                        _soundEnabled ? 'Actifs' : 'Désactivés',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _soundEnabled,
                  onChanged: (value) async {
                    await _soundService.setSoundEnabled(value);
                    setState(() => _soundEnabled = value);
                    if (value) await _soundService.playButtonClick();
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade300),

          // Musique de fond
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _musicEnabled ? Colors.purple.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _musicEnabled ? Icons.music_note : Icons.music_off,
                    color: _musicEnabled ? Colors.purple : Colors.grey,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Musique de fond',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      Text(
                        _musicEnabled ? 'Active' : 'Désactivée',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _musicEnabled,
                  onChanged: (value) async {
                    await _soundService.setMusicEnabled(value);
                    setState(() => _musicEnabled = value);
                  },
                  activeColor: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSfxVolumeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.graphic_eq, color: Colors.green.shade600, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Volume des effets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.volume_down, color: Colors.grey.shade600),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.green.shade100,
                    thumbColor: Colors.green,
                    overlayColor: Colors.green.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _sfxVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(_sfxVolume * 100).round()}%',
                    onChanged: (value) {
                      setState(() => _sfxVolume = value);
                    },
                    onChangeEnd: (value) async {
                      await _soundService.setSfxVolume(value);
                      await _soundService.playButtonClick();
                    },
                  ),
                ),
              ),
              Icon(Icons.volume_up, color: Colors.grey.shade600),
            ],
          ),
          Text(
            '${(_sfxVolume * 100).round()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicVolumeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.music_note, color: Colors.purple.shade600, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Volume musique',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.volume_down, color: Colors.grey.shade600),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.purple,
                    inactiveTrackColor: Colors.purple.shade100,
                    thumbColor: Colors.purple,
                    overlayColor: Colors.purple.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _musicVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(_musicVolume * 100).round()}%',
                    onChanged: (value) {
                      setState(() => _musicVolume = value);
                    },
                    onChangeEnd: (value) async {
                      await _soundService.setMusicVolume(value);
                    },
                  ),
                ),
              ),
              Icon(Icons.volume_up, color: Colors.grey.shade600),
            ],
          ),
          Text(
            '${(_musicVolume * 100).round()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

