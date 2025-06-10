import '../../../database/business_list_table.dart';
import '../../../database/business_promo_list_table.dart';
import '../../../shared/utils/is_business_open.dart';

class SearchPageController {
  static List<Map<String, dynamic>> _getSortedData(String type, int sortOption) {
    final data = _joinedBusinessData
        .where((business) => business['business_type'] == type)
        .toList();

    // Sort open businesses first
    data.sort((a, b) {
      final aOpen = isBusinessOpen(a['business_open_hour'], a['business_close_hour']);
      final bOpen = isBusinessOpen(b['business_open_hour'], b['business_close_hour']);
      if (aOpen && !bOpen) return -1;
      if (!aOpen && bOpen) return 1;
      return 0;
    });

    // Apply sortOption
    if (sortOption == 1) {
      // Rating: largest to smallest
      data.sort((a, b) => (b['business_rating'] as double).compareTo(a['business_rating'] as double));
    } else if (sortOption == 2) {
      // Distance: smallest to largest
      data.sort((a, b) => (a['business_distance'] as double).compareTo(b['business_distance'] as double));
    }

    return data;
  }

  static List<Map<String, dynamic>> restaurantList({int sortOption = 0}) {
    return _getSortedData('restaurant', sortOption);
  }

  static List<Map<String, dynamic>> marketList({int sortOption = 0}) {
    return _getSortedData('market', sortOption);
  }

  static List<Map<String, dynamic>> get _joinedBusinessData {
    return businessListTable.map((business) {
      final promo = businessPromoListTable.firstWhere(
        (p) => p['business_id'] == business['business_id'],
        orElse: () => {},
      );

      return {
        ...business,
        'discount_number': promo['discount_number'],
        'is_free_shipment': promo['is_free_shipment'],
      };
    }).toList();
  }
}