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
            image: DecorationImage(
              image: AssetImage('assets/images/bgc_math.png'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientStart.withOpacity(0.8),
                  AppColors.gradientMiddle.withOpacity(0.7),
                  AppColors.gradientEnd.withOpacity(0.6),
                  AppColors.background.withOpacity(0.5),
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
    )
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Centre d\'aide',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                Text(
                  'Tout pour réussir ! 📚',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
        color: AppColors.surface,
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
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        labelColor: AppColors.textLight,
        unselectedLabelColor: AppColors.textSecondary,
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
        color: AppColors.surface,
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
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.question_answer_rounded,
              color: AppColors.textLight,
              size: 24,
            ),
          ),
          title: Text(
            'Questions fréquentes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
              fontSize: 18,
              color: AppColors.primary,
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
                  color: AppColors.accent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'ComicNeue',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      answer,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'ComicNeue',
                        color: AppColors.textSecondary,
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
        color: AppColors.surface,
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
                colors: [AppColors.success, Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: AppColors.textLight,
              size: 24,
            ),
          ),
          title: Text(
            'Manuel MathKid',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          subtitle: Text(
            'Niveau Primaire',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'ComicNeue',
              color: AppColors.textSecondary,
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
                    AppColors.success,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '✖️ Multiplication',
                    [
                      'C\'est ajouter plusieurs fois le même nombre :',
                      '3 × 4 = 12 (c\'est 4+4+4).',
                    ],
                    AppColors.info,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '📐 Géométrie',
                    [
                      '• Carré : 4 côtés égaux',
                      '• Rectangle : 2 grands côtés, 2 petits',
                      '• Triangle : 3 côtés',
                    ],
                    AppColors.secondary,
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
        color: AppColors.surface,
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
                colors: [AppColors.secondary, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.school_rounded,
              color: AppColors.textLight,
              size: 24,
            ),
          ),
          title: Text(
            'Manuel MathExpert',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          subtitle: Text(
            'Niveau Collège',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'ComicNeue',
              color: AppColors.textSecondary,
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
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '½ Fractions',
                    [
                      'Une fraction est un partage.',
                      '• Simplifier : Diviser le haut et le bas par le même nombre.',
                      '• Additionner : Mettre au même dénominateur !',
                    ],
                    Color(0xFF14B8A6),
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    'x Algèbre & Équations',
                    [
                      'On remplace un nombre inconnu par une lettre (x).',
                      'But : Trouver la valeur de x qui rend l\'égalité vraie.',
                    ],
                    Color(0xFFF97316),
                  ),
                  const SizedBox(height: 16),
                  _buildManualSection(
                    '📐 Théorèmes',
                    [
                      '• Pythagore : a² + b² = c² (triangle rectangle)',
                      '• Thalès : Pour calculer des longueurs.',
                    ],
                    Color(0xFF78350F),
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
                  color: AppColors.textLight,
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
                      color: AppColors.textPrimary,
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
        color: AppColors.surface,
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
                    colors: [AppColors.accent, AppColors.warning],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tips_and_updates_rounded,
                  color: AppColors.textLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Astuces pour réussir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: AppColors.primary,
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
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textLight, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'ComicNeue',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'ComicNeue',
                    color: AppColors.textSecondary,
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