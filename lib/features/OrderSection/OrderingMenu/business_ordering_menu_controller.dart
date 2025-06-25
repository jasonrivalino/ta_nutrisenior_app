import '../../../database/addons_list_table.dart';
import '../../../database/business_product_list_table.dart';
import '../../../database/business_promo_list_table.dart';
import '../../../database/favorites_list_table.dart';
import '../../../database/product_list_table.dart';
import '../../../database/recommended_product_list_table.dart';

class BusinessOrderingMenuController {
  static Future<Map<String, List<Map<String, dynamic>>>> fetchProducts(int businessId) async {
    // 1. Ambil semua product_id untuk bisnis ini
    final matchedProductIds = businessProductListTable
        .where((entry) => entry['business_id'] == businessId)
        .map((entry) => entry['product_id'])
        .toSet();

    // 2. Ambil promo (jika ada)
    final promo = businessPromoListTable.firstWhere(
      (promo) => promo['business_id'] == businessId,
      orElse: () => {},
    );
    final int? discountNumber = promo['discount_number'] as int?;

    // 3. Kelompokkan add-ons berdasarkan product_id
    final Map<int, List<Map<String, dynamic>>> productAddOnsMap = {};
    for (final entry in businessProductListTable.where((e) => e['business_id'] == businessId)) {
      final productId = entry['product_id'];
      final addOnsId = entry['add_ons_id'];

      final addOns = addOnsListTable.firstWhere(
        (a) => a['add_ons_id'] == addOnsId,
        orElse: () => {},
      );

      if (addOns.isNotEmpty) {
        productAddOnsMap.putIfAbsent(productId, () => []).add(addOns);
      }
    }

    // 4. Proses semua produk
    final allProducts = productListTable
        .where((product) => matchedProductIds.contains(product['product_id']))
        .map((product) {
          final productCopy = Map<String, dynamic>.from(product);
          final productId = product['product_id'];

          if (discountNumber != null) {
            productCopy['discount_number'] = discountNumber;
            productCopy['discounted_price'] =
                (product['product_price'] * (100 - discountNumber) ~/ 100);
          }

          productCopy['add_ons'] = productAddOnsMap[productId] ?? [];

          return productCopy;
        })
        .toList();

    // 5. Ambil daftar produk rekomendasi
    final recommendedOrder = recommendedProductListTable
        .map((entry) => entry['product_id'])
        .toList();
    final recommendedProductIds = recommendedOrder.toSet();

    final recommendedProducts = allProducts
        .where((product) => recommendedProductIds.contains(product['product_id']))
        .toList();

    recommendedProducts.sort((a, b) {
      return recommendedOrder.indexOf(a['product_id']) -
          recommendedOrder.indexOf(b['product_id']);
    });

    return {
      'allProducts': allProducts,
      'recommendedProducts': recommendedProducts,
    };
  }

  // Tambahan di BusinessOrderingMenuController
  static Map<String, dynamic> getPromoByBusinessId(int businessId) {
    return businessPromoListTable.firstWhere(
      (promo) => promo['business_id'] == businessId,
      orElse: () => {},
    );
  }

  static int? getDiscountNumber(int businessId) {
    final promo = getPromoByBusinessId(businessId);
    return promo['discount_number'] as int?;
  }

  static bool getIsFreeShipment(int businessId) {
    final promo = getPromoByBusinessId(businessId);
    return promo['is_free_shipment'] as bool? ?? false;
  }
}

// Fetch for favorite businesses
class FavoritesBusinessController {
  static bool isBusinessFavorited(int businessId) {
    return favoritesListTable.any((item) => item['business_id'] == businessId);
  }

  static void toggleFavorite(int businessId) {
    final isFavorited = isBusinessFavorited(businessId);
    if (isFavorited) {
      favoritesListTable.removeWhere((item) => item['business_id'] == businessId);
    } else {
      favoritesListTable.add({'business_id': businessId});
    }
  }
}