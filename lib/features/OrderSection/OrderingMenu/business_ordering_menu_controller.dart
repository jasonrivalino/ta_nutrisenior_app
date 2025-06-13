import '../../../database/business_product_list_table.dart';
import '../../../database/product_list_table.dart';
import '../../../database/recommended_product_list_table.dart';

class BusinessOrderingMenuController {
  static Future<Map<String, List<Map<String, dynamic>>>> fetchProducts(int businessId) async {
    final matchedProductIds = businessProductListTable
        .where((entry) => entry['business_id'] == businessId)
        .map((entry) => entry['product_id'])
        .toSet();

    final allProducts = productListTable
        .where((product) => matchedProductIds.contains(product['product_id']))
        .toList();

    final recommendedOrder = recommendedProductListTable
        .map((entry) => entry['product_id'])
        .toList();

    final recommendedProductIds = recommendedOrder.toSet();

    final recommendedProducts = allProducts
        .where((product) => recommendedProductIds.contains(product['product_id']))
        .toList();

    // Sort based on the order in recommendedProductListTable
    recommendedProducts.sort((a, b) {
      return recommendedOrder.indexOf(a['product_id']) - recommendedOrder.indexOf(b['product_id']);
    });

    return {
      'allProducts': allProducts,
      'recommendedProducts': recommendedProducts,
    };
  }
}