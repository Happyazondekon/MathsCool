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

  // IDs des produits (À DÉFINIR dans Google Play Console)
  static const String REFILL_LIVES_ID = 'refill_lives_1';
  static const String UNLIMITED_LIVES_WEEK_ID = 'unlimited_lives_week';

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

      // Lancer l'achat
      await _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true, // Important pour les consommables
      );

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
        // Achat en cours (afficher loading)
        if (kDebugMode) print('⏳ Achat en attente...');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Achat réussi
        _handleSuccessfulPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        // Erreur
        final error = purchase.error?.message ?? 'Erreur inconnue';
        if (kDebugMode) print('❌ Erreur achat: $error');
        onPurchaseError?.call(error);
      }

      // IMPORTANT: Finaliser l'achat
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  /// Traiter un achat réussi
  void _handleSuccessfulPurchase(PurchaseDetails purchase) {
    if (kDebugMode) print('✅ Achat réussi: ${purchase.productID}');

    // Appeler le callback de succès
    onPurchaseSuccess?.call(purchase.productID);

    // Vérifier la signature Android (sécurité)
    if (purchase is GooglePlayPurchaseDetails) {
      final verified = _verifyPurchase(purchase);
      if (!verified) {
        if (kDebugMode) print('⚠️ Signature invalide');
        return;
      }
    }
  }

  /// Vérifier la signature d'achat (basique)
  bool _verifyPurchase(GooglePlayPurchaseDetails purchase) {
    // TODO: Implémenter la vérification serveur pour la production
    // Pour l'instant, on accepte tous les achats en dev
    return purchase.billingClientPurchase.isAcknowledged ||
        purchase.status == PurchaseStatus.purchased;
  }

  /// Restaurer les achats (pour abonnements)
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      if (kDebugMode) print('🔄 Restauration des achats lancée');
    } catch (e) {
      if (kDebugMode) print('❌ Erreur restauration: $e');
      onPurchaseError?.call(e.toString());
    }
  }

  /// Nettoyer les ressources
  void dispose() {
    _subscription?.cancel();
  }
}