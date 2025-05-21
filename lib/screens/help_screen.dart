import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, Colors.white],
                stops: const [0.0, 0.6],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildFAQCard(),
                      const SizedBox(height: 16.0),
                      _buildGuideCard(context),
                      const SizedBox(height: 16.0),
                      _buildTipsCard(),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: const Column(
        children: [
          Text(
            'Centre d\'aide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'ComicNeue',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Comment peut-on t\'aider aujourd\'hui ?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'ComicNeue',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        leading: Icon(Icons.question_answer, color: AppColors.primary),
        title: const Text(
          'Questions fréquentes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
          ),
        ),
        children: [
          _buildFAQItem(
            'Comment choisir mon niveau ?',
            'Choisis le niveau qui correspond à ta classe scolaire. Par exemple, si tu es en CE1, sélectionne CE1.',
          ),
          _buildFAQItem(
            'Comment suivre ma progression ?',
            'Tu peux voir ta progression dans la section "Progrès" accessible depuis la barre de navigation en bas de l\'écran.',
          ),
          _buildFAQItem(
            'Comment changer mon avatar ?',
            'Vas dans la section "Profil", puis clique sur "Modifier le profil" et enfin sur ton avatar pour le changer.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 16,
              fontFamily: 'ComicNeue',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'ComicNeue',
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Guide d\'utilisation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Tu peux réviser tes mathématiques avec notre manuel pour devenir un véritable MathKid !',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'ComicNeue',
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Télécharger le guide'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  const url = 'https://drive.google.com/file/d/1sVq6QMqMdpwkc7l0Hx1NIwvskMgdgT2N/view?usp=sharing';

                  try {
                    final Uri uri = Uri.parse(url);

                    // Utiliser inAppWebView pour s'assurer que le lien s'ouvre
                    bool launched = await launchUrl(
                      uri,
                      mode: LaunchMode.inAppWebView,
                      webViewConfiguration: const WebViewConfiguration(
                        enableJavaScript: true,
                        enableDomStorage: true,
                      ),
                    );

                    if (!launched && context.mounted) {
                      // Essayer avec platformDefault si inAppWebView échoue
                      launched = await launchUrl(
                        uri,
                        mode: LaunchMode.platformDefault,
                      );

                      if (!launched && context.mounted) {
                        // Si les deux méthodes échouent, montrer une erreur
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Impossible d\'ouvrir le lien. Vérifiez votre connexion ou essayez avec un autre navigateur.',
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur lors de l\'ouverture du lien: ${e.toString()}'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Astuces pour progresser',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem('Pratique régulièrement', 'Essaie de consacrer 15 minutes chaque jour aux exercices.'),
            _buildTipItem('Revois tes erreurs', 'Comprendre tes erreurs est la meilleure façon d\'apprendre.'),
            _buildTipItem('Célèbre tes réussites', 'Chaque badge gagné est un pas vers la maîtrise des maths !'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppColors.secondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, fontFamily: 'ComicNeue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
