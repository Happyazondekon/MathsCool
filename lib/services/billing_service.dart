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

  // IDs des produits (Exactement ceux de Google Play Console)
  static const String REFILL_LIVES_ID = 'refill_lives_1';
  static const String UNLIMITED_LIVES_WEEK_ID = 'unlimited_lives_week';
  static const String CHATBOT_SUBSCRIPTION_MONTHLY = 'chatbot_subscription_monthly';
  static const String CHATBOT_SUBSCRIPTION_YEARLY = 'chatbot_subscription_yearly';

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

      // Écouter les achats
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) {
          if (kDebugMode) print('Erreur stream achats: $error');
          onPurchaseError?.call(error.toString());
        },
      );

      // Charger les produits
      await _loadProducts();

      if (kDebugMode) print('✅ Billing Service initialisé');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur init billing: $e');
    }
  }

  /// Charger les produits depuis Google Play
  Future<void> _loadProducts() async {
    try {
      const productIds = <String>{
        REFILL_LIVES_ID,
        UNLIMITED_LIVES_WEEK_ID,
        CHATBOT_SUBSCRIPTION_MONTHLY,
        CHATBOT_SUBSCRIPTION_YEARLY,
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

      // --- CORRECTION ICI : Ajouter les abonnements Chatbot à la liste des non-consommables ---
      if (productId == UNLIMITED_LIVES_WEEK_ID ||
          productId == CHATBOT_SUBSCRIPTION_MONTHLY ||
          productId == CHATBOT_SUBSCRIPTION_YEARLY) {

        // Cas 1 : Abonnements (Vies illimitées OU Chatbot) -> Non Consommable
        // NOTE: buyNonConsumable gère correctement les abonnements récurrents Google Play
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      } else {

        // Cas 2 : Consommables (Recharge de vies uniquement) -> Consommable
        await _iap.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true, // On consomme immédiatement
        );
      }
      // -------------------------------------------------------------------------------------

      if (kDebugMode) print('🛒 Achat lancé: ${product.title}');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur achat: $e');
      onPurchaseError?.call(e.toString());
    }
  }

  /// Gérer les mises à jour d'achat
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (kDebugMode) print('📨 Achat reçu: ${purchase.productID} - ${purchase.status}');

      if (purchase.status == PurchaseStatus.pending) {
        // Achat en cours...
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Achat réussi
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

  void dispose() {
    _subscription?.cancel();
  }
}