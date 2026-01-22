import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class BillingService {
  static final BillingService _instance = BillingService._internal();
  factory BillingService() => _instance;
  BillingService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // ===== IDs DES PRODUITS =====

  // Vies
  static const String REFILL_LIVES_ID = 'refill_lives_1';
  static const String UNLIMITED_LIVES_WEEK_ID = 'unlimited_lives_week';

  // Chatbot
  static const String CHATBOT_SUBSCRIPTION_MONTHLY = 'chatbot_subscription_monthly';
  static const String CHATBOT_SUBSCRIPTION_YEARLY = 'chatbot_subscription_yearly';

  // ✅ NOUVEAU : Packs de Gems
  static const String GEMS_PACK_SMALL = 'gems_pack_small';    // 100 gems - 0.99€
  static const String GEMS_PACK_MEDIUM = 'gems_pack_medium';  // 550 gems - 3.99€
  static const String GEMS_PACK_LARGE = 'gems_pack_large';    // 1400 gems - 7.99€
  static const String GEMS_PACK_MEGA = 'gems_pack_mega';      // 3700 gems - 14.99€

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  // Callbacks
  Function(String productId)? onPurchaseSuccess;
  Function(String error)? onPurchaseError;

  /// Initialiser le service
  Future<void> initialize() async {
    try {
      _isAvailable = await _iap.isAvailable();

      if (!_isAvailable) {
        if (kDebugMode) print('❌ In-App Purchase non disponible');
        return;
      }

      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) {
          if (kDebugMode) print('Erreur stream achats: $error');
          onPurchaseError?.call(error.toString());
        },
      );

      await _loadProducts();

      if (kDebugMode) print('✅ Billing Service initialisé');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur init billing: $e');
    }
  }

  /// Charger les produits depuis Google Play
  Future<void> _loadProducts() async {
    try {
      // ✅ AJOUT DES PACKS DE GEMS
      const productIds = <String>{
        REFILL_LIVES_ID,
        UNLIMITED_LIVES_WEEK_ID,
        CHATBOT_SUBSCRIPTION_MONTHLY,
        CHATBOT_SUBSCRIPTION_YEARLY,
        GEMS_PACK_SMALL,
        GEMS_PACK_MEDIUM,
        GEMS_PACK_LARGE,
        GEMS_PACK_MEGA,
      };

      final ProductDetailsResponse response = await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        if (kDebugMode) print('⚠️ Produits non trouvés: ${response.notFoundIDs}');
      }

      _products = response.productDetails;

      if (kDebugMode) {
        print('📦 ${_products.length} produits chargés:');
        for (var product in _products) {
          print('  - ${product.id}: ${product.title} (${product.price})');
        }
      }
    } catch (e) {
      if (kDebugMode) print('❌ Erreur chargement produits: $e');
    }
  }

  /// Acheter un produit
  Future<void> buyProduct(String productId) async {
    try {
      if (!_isAvailable) {
        onPurchaseError?.call('Service d\'achat non disponible');
        return;
      }

      final product = _products.firstWhere(
            (p) => p.id == productId,
        orElse: () => throw Exception('Produit non trouvé'),
      );

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

      // ✅ DISTINCTION : Consommables vs Non-Consommables
      final isConsumable = _isConsumableProduct(productId);

      if (isConsumable) {
        // Consommables : Recharge vies + Packs de gems
        await _iap.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true,
        );
      } else {
        // Non-Consommables : Abonnements (vies illimitées, chatbot)
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }

      if (kDebugMode) print('🛒 Achat lancé: ${product.title}');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur achat: $e');
      onPurchaseError?.call(e.toString());
    }
  }

  /// ✅ NOUVEAU : Déterminer si un produit est consommable
  bool _isConsumableProduct(String productId) {
    const consumableProducts = {
      REFILL_LIVES_ID,
      GEMS_PACK_SMALL,
      GEMS_PACK_MEDIUM,
      GEMS_PACK_LARGE,
      GEMS_PACK_MEGA,
    };

    return consumableProducts.contains(productId);
  }

  /// Gérer les mises à jour d'achat
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (kDebugMode) print('📨 Achat reçu: ${purchase.productID} - ${purchase.status}');

      if (purchase.status == PurchaseStatus.pending) {
        // Achat en cours...
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _handleSuccessfulPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        final error = purchase.error?.message ?? 'Erreur inconnue';
        if (kDebugMode) print('❌ Erreur achat: $error');
        onPurchaseError?.call(error);
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  /// Traiter un achat réussi
  void _handleSuccessfulPurchase(PurchaseDetails purchase) {
    if (kDebugMode) print('✅ Achat réussi: ${purchase.productID}');

    onPurchaseSuccess?.call(purchase.productID);

    if (purchase is GooglePlayPurchaseDetails) {
      // Vérification signature (optionnel en dev)
    }
  }

  /// Restaurer les achats
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      if (kDebugMode) print('🔄 Restauration des achats lancée');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur restauration: $e');
      onPurchaseError?.call(e.toString());
    }
  }

  /// ✅ NOUVEAU : Helper pour obtenir les infos d'un pack de gems
  Map<String, dynamic>? getGemPackInfo(String productId) {
    const gemPacks = {
      GEMS_PACK_SMALL: {'gems': 100, 'bonus': 0, 'icon': '💰'},
      GEMS_PACK_MEDIUM: {'gems': 500, 'bonus': 50, 'icon': '💎', 'popular': true},
      GEMS_PACK_LARGE: {'gems': 1200, 'bonus': 200, 'icon': '💍'},
      GEMS_PACK_MEGA: {'gems': 3000, 'bonus': 700, 'icon': '🏆', 'bestValue': true},
    };

    return gemPacks[productId];
  }

  /// ✅ NOUVEAU : Obtenir uniquement les packs de gems
  List<ProductDetails> getGemPacks() {
    return _products.where((p) {
      return p.id == GEMS_PACK_SMALL ||
          p.id == GEMS_PACK_MEDIUM ||
          p.id == GEMS_PACK_LARGE ||
          p.id == GEMS_PACK_MEGA;
    }).toList();
  }

  /// ✅ NOUVEAU : Obtenir les produits de vies
  List<ProductDetails> getLifeProducts() {
    return _products.where((p) {
      return p.id == REFILL_LIVES_ID || p.id == UNLIMITED_LIVES_WEEK_ID;
    }).toList();
  }

  /// ✅ NOUVEAU : Obtenir les abonnements chatbot
  List<ProductDetails> getChatbotSubscriptions() {
    return _products.where((p) {
      return p.id == CHATBOT_SUBSCRIPTION_MONTHLY ||
          p.id == CHATBOT_SUBSCRIPTION_YEARLY;
    }).toList();
  }

  void dispose() {
    _subscription?.cancel();
  }
}