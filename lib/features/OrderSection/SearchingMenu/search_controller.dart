import '../../../database/business_list_table.dart';
import '../../../database/business_promo_list_table.dart';
import '../../../shared/utils/is_business_open.dart';

class SearchPageController {
  static List<Map<String, dynamic>> get _joinedBusinessData {
    return businessListTable.map((business) {
      // Find matching promo by business_id
      final promo = businessPromoListTable.firstWhere(
        (p) => p['business_id'] == business['business_id'],
        orElse: () => {},
      );

      // Merge business and promo data
      return {
        ...business,
        'discount_number': promo['discount_number'],
        'is_free_shipment': promo['is_free_shipment'],
      };
    }).toList();
  }

  static List<Map<String, dynamic>> get restaurantList {
    final data = _joinedBusinessData
        .where((business) => business['business_type'] == 'restaurant')
        .toList();

    // Sort: open businesses first
    data.sort((a, b) {
      final aOpen = isBusinessOpen(a['business_open_hour'], a['business_close_hour']);
      final bOpen = isBusinessOpen(b['business_open_hour'], b['business_close_hour']);

      if (aOpen && !bOpen) return -1;
      if (!aOpen && bOpen) return 1;
      return 0;
    });

    return data;
  }

  static List<Map<String, dynamic>> get marketList {
    final data = _joinedBusinessData
        .where((business) => business['business_type'] == 'market')
        .toList();

    // Sort: open businesses first
    data.sort((a, b) {
      final aOpen = isBusinessOpen(a['business_open_hour'], a['business_close_hour']);
      final bOpen = isBusinessOpen(b['business_open_hour'], b['business_close_hour']);

      if (aOpen && !bOpen) return -1;
      if (!aOpen && bOpen) return 1;
      return 0;
    });

    return data;
  }
}