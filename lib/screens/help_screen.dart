import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';

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
                colors: [AppColors.christ, Colors.white],
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
                      _buildMathKidManualCard(),
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
        color: AppColors.christ,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text(
            'Centre d\'aide',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
        leading: Icon(Icons.question_answer, color: AppColors.christ),
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

  Widget _buildMathKidManualCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        leading: Icon(Icons.menu_book, color: AppColors.christ),
        title: const Text(
          'Manuel MathKid - Deviens un champion des maths !',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
          ),
        ),
        children: [
          _buildManualContent(),
        ],
      ),
    );
  }

  Widget _buildManualContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroductionSection(),
          const SizedBox(height: 20),
          _buildChapterSection(
            '🔢 Chapitre 1 : L\'Addition - Le Pouvoir de Rassembler',
            [
              'L\'addition, c\'est comme rassembler des bonbons dans ton panier. Par exemple : 3 + 2 = 5.',
              '🎯 Astuce MathKid : Utilise tes doigts ou des dessins pour visualiser les nombres !',
              '🤝 Les Amis du 10 : 1+9=10, 2+8=10, 3+7=10...',
              '📊 Pour les grands nombres, commence toujours par les unités !',
            ],
          ),
          const SizedBox(height: 16),
          _buildChapterSection(
            '🏴‍☠️ Chapitre 2 : La Soustraction - Le Secret des Pirates',
            [
              'La soustraction, c\'est comme si un pirate venait voler une partie de ton trésor.',
              'Exemple : 10 - 4 = 6 pièces d\'or restantes.',
              '🎯 Astuce MathKid : Dessine les nombres pour mieux comprendre comment emprunter une dizaine.',
              'Parfois il faut "emprunter" des dizaines pour faire la soustraction !',
            ],
          ),
          const SizedBox(height: 16),
          _buildChapterSection(
            '✨ Chapitre 3 : La Multiplication - La Magie des Groupes',
            [
              'La multiplication, c\'est comme ajouter plusieurs fois le même nombre.',
              'Exemple : 3 × 4 = 4 + 4 + 4 = 12 bonbons au total.',
              '🎵 Apprends ta table de multiplication comme une chanson !',
              '🎯 Défi : Répète chaque jour une table jusqu\'à la connaître parfaitement.',
            ],
          ),
          const SizedBox(height: 16),
          _buildChapterSection(
            '🤝 Chapitre 4 : La Division - Le Partage Équitable',
            [
              'La division, c\'est comme partager tes bonbons équitablement entre tes amis.',
              'Exemple : 12 ÷ 3 = 4 bonbons pour chaque ami.',
              'Parfois il reste des bonbons : 14 ÷ 3 = 4 avec un reste de 2.',
              '🎯 Astuce MathKid : Utilise des objets comme des billes pour t\'entraîner !',
            ],
          ),
          const SizedBox(height: 16),
          _buildChapterSection(
            '📐 Chapitre 5 : La Géométrie - Le Monde des Formes',
            [
              '🔲 Carré : 4 côtés égaux, 4 angles droits',
              '🔺 Triangle : 3 côtés, 3 angles',
              '▭ Rectangle : 4 côtés, 2 longs et 2 courts',
              '🧊 Cube : 6 faces carrées',
              '🔺 Pyramide : Une base et des faces triangulaires',
              '⚽ Sphere : Comme un ballon de foot !',
            ],
          ),
          const SizedBox(height: 20),
          _buildConclusionSection(),
        ],
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.christ.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🌟 Introduction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.christ,
              fontFamily: 'ComicNeue',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Salut, jeune MathKid ! Les maths, ce n\'est pas juste des chiffres ennuyeux, c\'est un jeu passionnant qui te permettra de résoudre des énigmes, de compter plus vite que tes amis, et même de construire des choses incroyables !',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'ComicNeue',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterSection(String title, List<String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
            fontFamily: 'ComicNeue',
          ),
        ),
        const SizedBox(height: 8),
        ...content.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: AppColors.christ, fontSize: 16)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildConclusionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎉 Tu es maintenant un vrai MathKid !',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontFamily: 'ComicNeue',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Félicitations ! Tu as découvert les bases des mathématiques. Continue à pratiquer et amuse-toi bien en apprenant ! Les maths, c\'est un super-pouvoir que tu peux utiliser chaque jour.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'ComicNeue',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.star, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Signé : Ton Coach MathKid Happy',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
            ],
          ),
        ],
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
                Icon(Icons.lightbulb, color: AppColors.christ),
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
            _buildTipItem('Joue avec les nombres', 'Utilise tes doigts, des dessins ou des objets pour mieux comprendre.'),
            _buildTipItem('Répète les tables', 'Apprends tes tables de multiplication comme des chansons !'),
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