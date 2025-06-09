import '../../database/business_list_table.dart';
import '../../database/business_promo_list_table.dart';

class PromoController {
  static final List<Map<String, dynamic>> _mergedData = _mergeAndSort();

  // Public static filtered lists
  static final List<Map<String, dynamic>> promoDiscountRestaurant = _mergedData
      .where((b) => b['business_type'] == 'restaurant' && b['discount_number'] != null)
      .toList();

  static final List<Map<String, dynamic>> promoFreeShipmentRestaurant = _mergedData
      .where((b) => b['business_type'] == 'restaurant' && b['is_free_shipment'] == true)
      .toList();

  static final List<Map<String, dynamic>> promoDiscountMarket = _mergedData
      .where((b) => b['business_type'] == 'market' && b['discount_number'] != null)
      .toList();

  static final List<Map<String, dynamic>> promoFreeShipmentMarket = _mergedData
      .where((b) => b['business_type'] == 'market' && b['is_free_shipment'] == true)
      .toList();

  // Merge promo and business table, and preserve promo table order
  static List<Map<String, dynamic>> _mergeAndSort() {
    return businessPromoListTable.map((promo) {
      final business = businessListTable.firstWhere(
        (b) => b['business_id'] == promo['business_id'],
        orElse: () => {},
      );
      return {...business, ...promo};
    }).where((entry) => entry.isNotEmpty).toList();
  }
}