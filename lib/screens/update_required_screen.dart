import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/remote_config_service.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({Key? key}) : super(key: key);

  Future<void> _launchStore() async {
    final url = RemoteConfigService().storeUrl;
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animation pulsante
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  onEnd: () {
                    // Répéter l'animation
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.system_update_rounded,
                        size: 80,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Titre principal
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Mise à jour requise ! 🚀",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Carte d'information
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Badge Version
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.new_releases_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Nouvelle version disponible',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicNeue',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Message principal
                        const Text(
                          "MathsCool s'améliore !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          "Pour profiter des dernières fonctionnalités et continuer ton aventure mathématique, mets à jour l'application maintenant !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            fontFamily: 'ComicNeue',
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nouveautés
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star_rounded, color: Colors.orange.shade600, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Nouveautés :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade800,
                                      fontFamily: 'ComicNeue',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildFeature('♾️', 'Mode Infini'),
                              _buildFeature('🏆', '60+ Achievements'),
                              _buildFeature('🎨', 'Design moderne'),
                              _buildFeature('🤖', 'Assistant IA'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Bouton de mise à jour
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _launchStore,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              shadowColor: const Color(0xFFD32F2F).withOpacity(0.5),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.download_rounded, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Mettre à jour maintenant',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ComicNeue',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Note de version
                        Text(
                          'Version 2.2.3 requise',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Message d'encouragement
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    '✨ Ne rate pas les nouvelles fonctionnalités ! ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'ComicNeue',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}