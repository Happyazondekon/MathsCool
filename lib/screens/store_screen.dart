import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mathscool/generated/gen_l10n/app_localizations.dart';

import '../services/billing_service.dart';
import '../services/chatbot_service.dart';
import '../services/lives_service.dart';
import '../services/gems_service.dart'; // ✅ AJOUTÉ
import '../models/user_model.dart';
import '../models/lives_model.dart';
import '../utils/colors.dart';
import '../widgets/gems_display_widget.dart'; // ✅ AJOUTÉ

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  final BillingService _billingService = BillingService();
  late AnimationController _animController;
  bool _isLoading = false;
  int _selectedTab = 0; // ✅ NOUVEAU : 0 = Vies & Boosts, 1 = Gems

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _setupBilling();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _setupBilling() async {
    setState(() => _isLoading = true);

    await _billingService.initialize();

    _billingService.onPurchaseSuccess = _handlePurchaseSuccess;
    _billingService.onPurchaseError = _handlePurchaseError;

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _handlePurchaseSuccess(String productId) {
    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final livesService = Provider.of<LivesService>(context, listen: false);
    final chatbotService = Provider.of<ChatbotService>(context, listen: false);
    final gemsService = Provider.of<GemsService>(context, listen: false);

    // ✅ GESTION DES PACKS DE GEMS
    if (productId == BillingService.GEMS_PACK_SMALL ||
        productId == BillingService.GEMS_PACK_MEDIUM ||
        productId == BillingService.GEMS_PACK_LARGE ||
        productId == BillingService.GEMS_PACK_MEGA) {
      gemsService.purchaseGemsPack(user.uid, productId);
      _showSuccessDialog(type: 'gems', productId: productId);
    }
    // Gestion des vies
    else if (productId == BillingService.UNLIMITED_LIVES_WEEK_ID) {
      livesService.activateUnlimitedWeek(user.uid);
      _showSuccessDialog(type: 'unlimited');
    }
    else if (productId == BillingService.REFILL_LIVES_ID) {
      livesService.refillLives(user.uid);
      _showSuccessDialog(type: 'refill');
    }
    // Gestion du chatbot
    else if (productId == BillingService.CHATBOT_SUBSCRIPTION_MONTHLY) {
      chatbotService.activateSubscription(user.uid, const Duration(days: 30));
      _showSuccessDialog(type: 'chatbot');
    }
    else if (productId == BillingService.CHATBOT_SUBSCRIPTION_YEARLY) {
      chatbotService.activateSubscription(user.uid, const Duration(days: 365));
      _showSuccessDialog(type: 'chatbot');
    }
  }

  void _handlePurchaseError(String error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: // Pass the variable directly into the method
            Text(AppLocalizations.of(context)!.storeError(error))
            )],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog({required String type, String? productId}) {
    String title;
    String message;
    Color color;

    switch (type) {
      case 'unlimited':
        title = AppLocalizations.of(context)!.unlimitedLivesWeek;
        message = AppLocalizations.of(context)!.unlimitedLivesDescription;
        color = Colors.purple;
        break;
      case 'chatbot':
        title = AppLocalizations.of(context)!.chatbotActivated;
        message = AppLocalizations.of(context)!.chatbotReadyToHelp;
        color = Colors.blue;
        break;
      case 'gems':
        final packInfo = _billingService.getGemPackInfo(productId ?? '');
        final totalGems = (packInfo?['gems'] ?? 0) + (packInfo?['bonus'] ?? 0);
        title = AppLocalizations.of(context)!.gemsReceived(packInfo?['icon'] ?? '💎');
        message = AppLocalizations.of(context)!.gemsReceivedCount(totalGems.toString());
        color = Colors.amber;
        break;
      default:
        title = AppLocalizations.of(context)!.livesRefilled;
        message = AppLocalizations.of(context)!.readyToContinue;
        color = Colors.green;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 150,
                height: 150,
                repeat: false,
                errorBuilder: (_, __, ___) => Icon(Icons.check_circle, size: 80, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontFamily: 'ComicNeue'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                ),
                child:  Text(
                    AppLocalizations.of(context)!.storeSuccess,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'ComicNeue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final livesService = Provider.of<LivesService>(context);
    final livesData = livesService.livesData;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF9A9E),
              Color(0xFFFECFEF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              // ✅ NOUVEAU : Onglets
              _buildTabBar(),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.christ))
                    : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (_selectedTab == 0) ...[
                        // Onglet Vies & Boosts
                        FadeTransition(
                          opacity: _animController,
                          child: _buildLivesStatusCard(livesData),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle(AppLocalizations.of(context)!.storeSectionLivesBoosts),
                        const SizedBox(height: 12),
                        _buildLifeProductsList(),
                        const SizedBox(height: 24),
                        _buildInfoCard(),
                      ] else ...[
                        // Onglet Gems
                        FadeTransition(
                          opacity: _animController,
                          child: const GemsStatsCard(), // ✅ Widget du gems_display_widget.dart
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle(AppLocalizations.of(context)!.storeSectionGemPacks),
                        const SizedBox(height: 12),
                        _buildGemsPacksList(),
                        const SizedBox(height: 24),
                        _buildGemsInfoCard(),
                      ],
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

  // ✅ NOUVEAU : TabBar pour switcher entre Vies et Gems
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _selectedTab == 0
                      ? LinearGradient(
                    colors: [Colors.red.shade400, Colors.pink.shade300],
                  )
                      : null,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: _selectedTab == 0 ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.storeTabLives,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedTab == 0 ? Colors.white : Colors.grey,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _selectedTab == 1
                      ? LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade300],
                  )
                      : null,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.diamond,
                      color: _selectedTab == 1 ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.storeTabGems,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedTab == 1 ? Colors.white : Colors.grey,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.christ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
           Expanded(
            child: Text(
              AppLocalizations.of(context)!.storeTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'ComicNeue',
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    offset: Offset(1, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildLivesStatusCard(LivesData? livesData) {
    if (livesData == null) return const SizedBox.shrink();

    final bool isUnlimited = livesData.isUnlimited;
    final int maxLives = LivesData.MAX_LIVES;
    final int currentLives = livesData.availableLives;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUnlimited
              ? [const Color(0xFF9C27B0), const Color(0xFFE040FB)]
              : [const Color(0xFFFF5252), const Color(0xFFFF8A80)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (isUnlimited ? Colors.purple : Colors.red).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnlimited ? Icons.all_inclusive_rounded : Icons.favorite_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isUnlimited
                ? AppLocalizations.of(context)!.storeUnlimitedLives
                : AppLocalizations.of(context)!.storeMyLives,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'ComicNeue',
            ),
          ),
          const SizedBox(height: 8),
          if (!isUnlimited)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(maxLives, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < currentLives ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 28,
                  ),
                );
              }),
            ),
          if (!isUnlimited && currentLives < maxLives)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.storeNextLife(
                          Provider.of<LivesService>(context).getFormattedTimeUntilNextLife()
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isUnlimited)
             Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                AppLocalizations.of(context)!.storeUnlimitedDescription,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
          fontFamily: 'ComicNeue',
        ),
      ),
    );
  }

  // ✅ SÉPARÉ : Liste des produits VIES uniquement
  Widget _buildLifeProductsList() {
    final lifeProducts = _billingService.getLifeProducts();
    final chatbotProducts = _billingService.getChatbotSubscriptions();
    final allProducts = [...lifeProducts, ...chatbotProducts];

    if (allProducts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: allProducts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: _buildProductCard(allProducts[index]),
        );
      },
    );
  }

  // ✅ NOUVEAU : Liste des packs de GEMS uniquement
  Widget _buildGemsPacksList() {
    final gemPacks = _billingService.getGemPacks();

    if (gemPacks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: gemPacks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: _buildProductCard(gemPacks[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.storefront_outlined, size: 50, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.storeNoProducts,
            style: TextStyle(color: Colors.grey.shade600, fontFamily: 'ComicNeue'),
          ),
          TextButton(
            onPressed: _setupBilling,
            child:  Text(AppLocalizations.of(context)!.storeTryAgain),
          )
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductDetails product) {
    bool isUnlimited = product.id == BillingService.UNLIMITED_LIVES_WEEK_ID;
    bool isChatbot = product.id.contains('chatbot');
    bool isGems = product.id.contains('gems_pack');

    List<Color> gradientColors = [const Color(0xFFFF7043), const Color(0xFFFFAB91)];
    IconData icon = Icons.favorite_rounded;
    String badgeText = "Populaire 🔥";
    bool showBadge = false;

    if (isUnlimited) {
      gradientColors = [const Color(0xFF7B1FA2), const Color(0xFFBA68C8)];
      icon = Icons.all_inclusive;
      badgeText = AppLocalizations.of(context)!.storeBadgeBestOffer;
      showBadge = true;
    } else if (isChatbot) {
      gradientColors = [const Color(0xFF2196F3), const Color(0xFF64B5F6)];
      icon = Icons.smart_toy_rounded;
      badgeText = AppLocalizations.of(context)!.storeBadgeNew;
      showBadge = true;
    } else if (isGems) {
      gradientColors = [const Color(0xFFFFD700), const Color(0xFFFFA500)];
      icon = Icons.diamond;

      final packInfo = _billingService.getGemPackInfo(product.id);
      if (packInfo?['popular'] == true) {
        badgeText = AppLocalizations.of(context)!.storeBadgePopular;
        showBadge = true;
      } else if (packInfo?['bestValue'] == true) {
        badgeText = AppLocalizations.of(context)!.storeBadgeBestValue;
        showBadge = true;
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _billingService.buyProduct(product.id),
              borderRadius: BorderRadius.circular(25),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title.replaceAll('(MathsCool)', '').trim(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ComicNeue',
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isGems) ...[
                            Builder(
                              builder: (context) {
                                final packInfo = _billingService.getGemPackInfo(product.id);
                                if (packInfo == null) return const SizedBox.shrink();

                                return Row(
                                  children: [
                                    Text(
                                      '${packInfo['gems']} gems',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        fontFamily: 'ComicNeue',
                                      ),
                                    ),
                                    if (packInfo['bonus'] > 0) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '+${packInfo['bonus']} bonus',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ] else ...[
                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        product.price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: gradientColors[0],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showBadge)
          Positioned(
            top: -10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.orange, Colors.orangeAccent]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Icon(Icons.lightbulb_rounded, color: Color(0xFF1976D2)),
              SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.storeInfoTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          // Pass LivesData.MAX_LIVES directly into the method
          _buildInfoRow('❤️', AppLocalizations.of(context)!.storeMaxLives(LivesData.MAX_LIVES.toString())),

          // Pass the minutes directly into the method
          _buildInfoRow('⏱️', AppLocalizations.of(context)!.storeLifeRegeneration(LivesData.REGENERATION_TIME.inMinutes.toString())),

          // storeUnlimitedMode has no placeholder, so it remains a getter
          _buildInfoRow('♾️', AppLocalizations.of(context)!.storeUnlimitedMode),
        ],
      ),
    );
  }

  // ✅ NOUVEAU : Card d'info pour les Gems
  Widget _buildGemsInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Icon(Icons.diamond, color: Color(0xFFFFA000)),
              SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.storeGemsInfoTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF57F17),
                  fontFamily: 'ComicNeue',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('💡', AppLocalizations.of(context)!.storeHintCost('20')),
          _buildInfoRow('⏭️', AppLocalizations.of(context)!.storeSkipQuestionCost('30')),
          _buildInfoRow('⚡', AppLocalizations.of(context)!.storeFastRechargeCost('50')),
          _buildInfoRow('🎨', AppLocalizations.of(context)!.storeUnlockThemesCost('100')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: _selectedTab == 0 ? Colors.blue.shade900 : Colors.orange.shade900,
                fontFamily: 'ComicNeue',
              ),
            ),
          ),
        ],
      ),
    );
  }
}