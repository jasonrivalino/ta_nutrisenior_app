import '../../database/business_list_table.dart';
import '../../database/business_promo_list_table.dart';

class PromoController {
  static final List<Map<String, dynamic>> _mergedData = _mergeAndSort();

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

  static List<Map<String, dynamic>> _mergeAndSort() {
    final merged = businessPromoListTable.map((promo) {
      final business = businessListTable.firstWhere(
        (b) => b['business_id'] == promo['business_id'],
        orElse: () => {},
      );
      return {...business, ...promo};
    }).where((entry) => entry.isNotEmpty).toList();

    // Sort open businesses first
    merged.sort((a, b) {
      final aOpen = isBusinessOpen(a['business_open_hour'], a['business_close_hour']);
      final bOpen = isBusinessOpen(b['business_open_hour'], b['business_close_hour']);

      if (aOpen && !bOpen) return -1;
      if (!aOpen && bOpen) return 1;
      return 0;
    });

    return merged;
  }

  static bool isBusinessOpen(DateTime? open, DateTime? close) {
    if (open == null || close == null) return true;
    final now = DateTime.now();
    final openToday = DateTime(now.year, now.month, now.day, open.hour, open.minute);
    final closeToday = DateTime(now.year, now.month, now.day, close.hour, close.minute);
    return now.isAfter(openToday) && now.isBefore(closeToday);
  }
}