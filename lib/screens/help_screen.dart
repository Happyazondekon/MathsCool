import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 2 onglets : Primaire et Collège
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPrimaryContent(), // Contenu existant (adapté)
                      _buildCollegeContent(), // Nouveau contenu
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        labelColor: AppColors.christ,
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicNeue', fontSize: 16),
        tabs: const [
          Tab(text: 'Primaire'),
          Tab(text: 'Collège'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Centre d\'aide',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'ComicNeue',
              ),
            ),
          ),
          const SizedBox(width: 48), // Pour équilibrer l'icône de retour
        ],
      ),
    );
  }

  // --- CONTENU PRIMAIRE (Votre code existant légèrement réorganisé) ---
  Widget _buildPrimaryContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildFAQCard(),
        const SizedBox(height: 16.0),
        _buildMathKidManualCard(), // Manuel Primaire
        const SizedBox(height: 16.0),
        _buildTipsCard(isCollege: false),
      ],
    );
  }

  // --- CONTENU COLLÈGE (Nouveau) ---
  Widget _buildCollegeContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildFAQCard(),
        const SizedBox(height: 16.0),
        _buildMathExpertManualCard(), // Manuel Collège
        const SizedBox(height: 16.0),
        _buildTipsCard(isCollege: true),
      ],
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
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicNeue'),
        ),
        children: [
          _buildFAQItem('Comment choisir mon niveau ?', 'Choisis le niveau qui correspond à ta classe (ex: CE1 ou 5ème).'),
          _buildFAQItem('Comment suivre ma progression ?', 'Consulte la section "Progrès" dans le menu principal.'),
          _buildFAQItem('Comment obtenir des badges ?', 'Réussis les exercices avec un bon score pour débloquer des badges !'),
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
          Text(question, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 16, fontFamily: 'ComicNeue')),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 14, fontFamily: 'ComicNeue')),
        ],
      ),
    );
  }

  // --- MANUEL PRIMAIRE ---
  Widget _buildMathKidManualCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        leading: Icon(Icons.menu_book, color: AppColors.christ),
        title: const Text(
          'Manuel MathKid (Primaire)',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicNeue'),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('🔢 Addition & Soustraction'),
                _buildText('L\'addition ( + ) c\'est rassembler : 3 + 2 = 5.'),
                _buildText('La soustraction ( - ) c\'est enlever : 5 - 2 = 3.'),
                const SizedBox(height: 10),
                _buildSectionTitle('✖️ Multiplication'),
                _buildText('C\'est ajouter plusieurs fois le même nombre : 3 x 4 = 12 (c\'est 4+4+4).'),
                const SizedBox(height: 10),
                _buildSectionTitle('📐 Géométrie'),
                _buildText('• Carré : 4 côtés égaux\n• Rectangle : 2 grands côtés, 2 petits\n• Triangle : 3 côtés'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MANUEL COLLÈGE ---
  Widget _buildMathExpertManualCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        leading: Icon(Icons.school, color: Colors.deepPurple), // Couleur différente
        title: const Text(
          'Manuel MathExpert (Collège)',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicNeue'),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('± Nombres Relatifs'),
                _buildText('Les nombres relatifs ont un signe (+ ou -).'),
                _buildText('• Addition : Si les signes sont les mêmes, on ajoute. Sinon, on soustrait.'),
                _buildText('• Multiplication : "Moins par Moins donne Plus" ! (-2 x -3 = +6)'),

                const SizedBox(height: 12),
                _buildSectionTitle('½ Fractions'),
                _buildText('Une fraction est un partage.'),
                _buildText('• Simplifier : Diviser le haut et le bas par le même nombre.'),
                _buildText('• Additionner : Il faut mettre au même dénominateur !'),

                const SizedBox(height: 12),
                _buildSectionTitle('x Algèbre & Équations'),
                _buildText('On remplace un nombre inconnu par une lettre (souvent x).'),
                _buildText('But du jeu : Trouver la valeur de x qui rend l\'égalité vraie.'),

                const SizedBox(height: 12),
                _buildSectionTitle('📐 Théorèmes'),
                _buildText('• Pythagore : Dans un triangle rectangle, a² + b² = c² (c est l\'hypoténuse).'),
                _buildText('• Thalès : Sert à calculer des longueurs dans des triangles semblables.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.3)),
    );
  }

  Widget _buildTipsCard({required bool isCollege}) {
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
                Icon(Icons.lightbulb, color: isCollege ? Colors.deepPurple : AppColors.christ),
                const SizedBox(width: 8),
                const Text(
                  'Astuces pour réussir',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'ComicNeue'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isCollege) ...[
              _buildTipItem('Rigueur', 'Écris toutes les étapes de tes calculs au brouillon.'),
              _buildTipItem('Relire', 'Vérifie toujours la cohérence de tes résultats.'),
              _buildTipItem('Fiches', 'Fais des fiches de résumé pour les théorèmes.'),
            ] else ...[
              _buildTipItem('Pratique', '15 minutes par jour suffisent !'),
              _buildTipItem('Jeux', 'Amuse-toi avec les nombres au quotidien.'),
              _buildTipItem('Erreurs', 'Se tromper, c\'est apprendre !'),
            ],
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
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontFamily: 'ComicNeue', fontSize: 14),
                children: [
                  TextSpan(text: '$title : ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}