import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/lives_model.dart';
import '../services/billing_service.dart';
import '../services/lives_service.dart';
import '../models/user_model.dart';
import '../utils/colors.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final BillingService _billingService = BillingService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupBilling();
  }

  Future<void> _setupBilling() async {
    setState(() => _isLoading = true);

    await _billingService.initialize();

    // Configurer les callbacks
    _billingService.onPurchaseSuccess = _handlePurchaseSuccess;
    _billingService.onPurchaseError = _handlePurchaseError;

    // Forcer la reconstruction pour afficher les produits chargés
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _handlePurchaseSuccess(String productId) {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final livesService = Provider.of<LivesService>(context, listen: false);

    // --- ADAPTATION : Distinction entre recharge et illimité ---
    if (productId == BillingService.UNLIMITED_LIVES_WEEK_ID) {
      // Cas 1 : Semaine illimitée
      livesService.activateUnlimitedWeek(user.uid);
    } else {
      // Cas 2 : Recharge simple (par défaut ou si ID correspond à refill)
      livesService.refillLives(user.uid);
    }

    // Afficher confirmation
    _showSuccessDialog(isUnlimited: productId == BillingService.UNLIMITED_LIVES_WEEK_ID);
  }

  void _handlePurchaseError(String error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog({bool isUnlimited = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              width: 150,
              height: 150,
              repeat: false,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.check_circle, size: 80, color: Colors.green);
              },
            ),
            const SizedBox(height: 16),
            Text(
              isUnlimited ? 'Semaine Illimitée ! ♾️' : 'Vies rechargées ! 🎉',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicNeue',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUnlimited
                  ? 'Profite de 7 jours sans perdre de vies !'
                  : 'Tu peux continuer à jouer !',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Super !'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation de watch pour mettre à jour l'interface quand les vies changent
    final livesService = Provider.of<LivesService>(context);
    final livesData = livesService.livesData;

    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.christ, Colors.white],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),

                if (_isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildLivesStatus(livesData),
                          const SizedBox(height: 24),
                          _buildProductsList(),
                          const SizedBox(height: 24),
                          _buildInfoCard(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.christ,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Boutique 🎁',
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

  Widget _buildLivesStatus(LivesData? livesData) {
    if (livesData == null) return const SizedBox.shrink();

    final int maxLives = LivesData.MAX_LIVES;
    final int currentLives = livesData.availableLives;

    // --- ADAPTATION : Vérification de l'illimité ---
    final bool isUnlimited = livesData.isUnlimited;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUnlimited
              ? [Colors.purple.shade100, Colors.deepPurple.shade100] // Couleur spéciale si illimité
              : [Colors.pink.shade100, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isUnlimited ? Colors.purple.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnlimited ? Icons.all_inclusive : Icons.favorite,
              color: isUnlimited ? Colors.purple : Colors.red.shade400,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tes Vies',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isUnlimited
                      ? 'Vies Illimitées ♾️'
                      : '$currentLives/$maxLives disponibles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isUnlimited ? Colors.purple.shade700 : Colors.red.shade700,
                  ),
                ),
                // On n'affiche le timer que si PAS illimité et PAS plein
                if (!isUnlimited && currentLives < maxLives)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Prochaine vie: ${Provider.of<LivesService>(context).getFormattedTimeUntilNextLife()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (isUnlimited)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Profite bien !',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    // Récupérer la liste des produits depuis le service de facturation
    final List<ProductDetails> products = _billingService.products;

    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'Aucun produit disponible',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Vérifie ta connexion ou la configuration Google Play.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _setupBilling,
              icon: const Icon(Icons.refresh),
              label: const Text("Réessayer"),
            )
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acheter des vies',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'ComicNeue',
            shadows: [
              Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 1))
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...products.map((product) => _buildProductCard(product)),
      ],
    );
  }

  Widget _buildProductCard(ProductDetails product) {
    // Détecter si c'est l'offre illimitée pour changer l'icône/couleur
    final bool isUnlimitedOffer = product.id == BillingService.UNLIMITED_LIVES_WEEK_ID;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnlimitedOffer ? Colors.purple.shade50 : Colors.red.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isUnlimitedOffer ? Icons.all_inclusive : Icons.favorite,
            color: isUnlimitedOffer ? Colors.purple : Colors.red.shade400,
            size: 28,
          ),
        ),
        title: Text(
          product.title.replaceAll('(MathsCool)', ''), // Nettoyage du nom
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'ComicNeue',
          ),
        ),
        subtitle: Text(
          product.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: ElevatedButton(
          onPressed: () => _billingService.buyProduct(product.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: isUnlimitedOffer ? Colors.purple : AppColors.christ,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(
            product.price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                'Comment ça marche ?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...[
            '❤️ Tu as ${LivesData.MAX_LIVES} vies au maximum',
            '❌ Chaque réponse incorrecte = -1 vie',
            '⏱️ Chaque vie se régénère en ${LivesData.REGENERATION_TIME.inMinutes} minutes',
            '🎁 Achète des vies ou passe en mode illimité !',
          ].map((text) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}