import '../../../database/business_product_list_table.dart';
import '../../../database/business_promo_list_table.dart';
import '../../../database/favorites_list_table.dart';
import '../../../database/product_list_table.dart';
import '../../../database/recommended_product_list_table.dart';

class BusinessOrderingMenuController {
  static Future<Map<String, List<Map<String, dynamic>>>> fetchProducts(int businessId) async {
    final matchedProductIds = businessProductListTable
        .where((entry) => entry['business_id'] == businessId)
        .map((entry) => entry['product_id'])
        .toSet();

    // Get discount info if available
    final promo = businessPromoListTable.firstWhere(
      (promo) => promo['business_id'] == businessId,
      orElse: () => {},
    );

    final int? discountNumber = promo['discount_number'] as int?;

    final allProducts = productListTable
        .where((product) => matchedProductIds.contains(product['product_id']))
        .map((product) {
          final productCopy = Map<String, dynamic>.from(product);
          if (discountNumber != null) {
            productCopy['discount_number'] = discountNumber;
            productCopy['discounted_price'] =
                (product['product_price'] * (100 - discountNumber) ~/ 100);
          }
          return productCopy;
        })
        .toList();

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