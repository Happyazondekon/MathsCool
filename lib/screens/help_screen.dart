import 'package:flutter/material.dart';

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
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildTabBar(),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPrimaryContent(),
                    _buildCollegeContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  'Centre d\'aide',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  'Tout pour réussir ! 📚',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
          fontSize: 15,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Primaire'),
          Tab(text: 'Collège'),
        ],
      ),
    );
  }

  Widget _buildPrimaryContent() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        _buildFAQCard(),
        const SizedBox(height: 16.0),
        _buildMathKidManualCard(),
        const SizedBox(height: 16.0),
        _buildTipsCard(isCollege: false),
      ],
    );
  }

  Widget _buildCollegeContent() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        _buildFAQCard(),
        const SizedBox(height: 16.0),
        _buildMathExpertManualCard(),
        const SizedBox(height: 16.0),
        _buildTipsCard(isCollege: true),
      ],
    );
  }

  Widget _buildFAQCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.question_answer_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: const Text(
            'Questions fréquentes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
              fontSize: 18,
              color: Color(0xFFD32F2F),
            ),
          ),
          children: [
            _buildFAQItem('Comment choisir mon niveau ?', 'Choisis le niveau qui correspond à ta classe (ex: CE1 ou 5ème).'),
            const Divider(indent: 20, endIndent: 20),
            _buildFAQItem('Comment suivre ma progression ?', 'Consulte la section "Progrès" dans le menu principal.'),
            const Divider(indent: 20, endIndent: 20),
            _buildFAQItem('Comment obtenir des badges ?', 'Réussis les exercices avec un bon score pour débloquer des badges !'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_rounded,
                  size: 16,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'ComicNeue',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      answer,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'ComicNeue',
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMathKidManualCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: const Text(
            'Manuel MathKid',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
              fontSize: 18,
              color: Color(0xFFD32F2F),
            ),
          ),
          subtitle: const Text(
            'Niveau Primaire',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'ComicNeue',
              color: Colors.grey,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildManualSection(
                    '🔢 Addition & Soustraction',
                    [
                      'L\'addition ( + ) c\'est rassembler : 3 + 2 = 5.',
                      'La soustraction ( - ) c\'est enlever : 5 - 2 = 3.',
                    ],
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '✖️ Multiplication',
                    [
                      'C\'est ajouter plusieurs fois le même nombre :',
                      '3 × 4 = 12 (c\'est 4+4+4).',
                    ],
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '📐 Géométrie',
                    [
                      '• Carré : 4 côtés égaux',
                      '• Rectangle : 2 grands côtés, 2 petits',
                      '• Triangle : 3 côtés',
                    ],
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMathExpertManualCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade700],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: const Text(
            'Manuel MathExpert',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
              fontSize: 18,
              color: Color(0xFFD32F2F),
            ),
          ),
          subtitle: const Text(
            'Niveau Collège',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'ComicNeue',
              color: Colors.grey,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildManualSection(
                    '± Nombres Relatifs',
                    [
                      'Les nombres relatifs ont un signe (+ ou -).',
                      '• Addition : Si les signes sont les mêmes, on ajoute.',
                      '• Multiplication : "Moins par Moins donne Plus" !',
                    ],
                    Colors.indigo,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '½ Fractions',
                    [
                      'Une fraction est un partage.',
                      '• Simplifier : Diviser le haut et le bas par le même nombre.',
                      '• Additionner : Mettre au même dénominateur !',
                    ],
                    Colors.teal,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    'x Algèbre & Équations',
                    [
                      'On remplace un nombre inconnu par une lettre (x).',
                      'But : Trouver la valeur de x qui rend l\'égalité vraie.',
                    ],
                    Colors.deepOrange,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '📐 Théorèmes',
                    [
                      '• Pythagore : a² + b² = c² (triangle rectangle)',
                      '• Thalès : Pour calculer des longueurs.',
                    ],
                    Colors.brown,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualSection(String title, List<String> points, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...points.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'ComicNeue',
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTipsCard({required bool isCollege}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tips_and_updates_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Astuces pour réussir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: Color(0xFFD32F2F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isCollege) ...[
            _buildTipItem('Rigueur', 'Écris toutes les étapes de tes calculs au brouillon.', Icons.edit_note_rounded),
            _buildTipItem('Relire', 'Vérifie toujours la cohérence de tes résultats.', Icons.fact_check_rounded),
            _buildTipItem('Fiches', 'Fais des fiches de résumé pour les théorèmes.', Icons.sticky_note_2_rounded),
          ] else ...[
            _buildTipItem('Pratique', '15 minutes par jour suffisent !', Icons.timer_rounded),
            _buildTipItem('Jeux', 'Amuse-toi avec les nombres au quotidien.', Icons.games_rounded),
            _buildTipItem('Erreurs', 'Se tromper, c\'est apprendre !', Icons.emoji_objects_rounded),
          ],
        ],
      ),
    );
  }

  Widget _buildTipItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'ComicNeue',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'ComicNeue',
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}