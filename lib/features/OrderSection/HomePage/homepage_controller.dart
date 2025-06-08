import '../../../database/business_list_table.dart';
import '../../../database/business_promo_list_table.dart';
import '../../../database/recommended_list_table.dart';

final List<Map<String, dynamic>> _recommendedListTable = recommendedListTable;
final List<Map<String, dynamic>> _promoListTable = businessPromoListTable;

class HomePageController {
  static final List<Map<String, dynamic>> _businessListTable = businessListTable;

  static List<Map<String, dynamic>> _getRecommendedBusinessesByCategory(String category) {
    final filteredIds = _recommendedListTable
        .where((r) => r['recommend_category'] == category)
        .map((r) => int.tryParse(r['business_id'].toString()))
        .whereType<int>()
        .toList();

    final businesses = <Map<String, dynamic>>[];

    for (var id in filteredIds) {
      final business = _businessListTable.firstWhere(
        (b) => b['business_id'] == id,
        orElse: () => <String, dynamic>{},
      );

      if (business.isNotEmpty) {
        // Find promo for this business
        final promo = _promoListTable.firstWhere(
          (p) => p['business_id'] == id,
          orElse: () => {
            'discount_number': null,
            'is_free_shipment': false,
          },
        );

        // Merge promo into business
        final merged = {
          ...business,
          'discount_number': promo['discount_number'],
          'is_free_shipment': promo['is_free_shipment'],
        };

        businesses.add(merged);
      }
    }
    return businesses;
  }

  static List<Map<String, dynamic>> get recommendedToday {
    return _getRecommendedBusinessesByCategory('today');
  }

  static List<Map<String, dynamic>> get recommendedRestaurant {
    return _getRecommendedBusinessesByCategory('restaurant')
        .where((b) => b['business_type'] == 'restaurant')
        .toList();
  }

  static List<Map<String, dynamic>> get recommendedMarket {
    return _getRecommendedBusinessesByCategory('market')
        .where((b) => b['business_type'] == 'market')
        .toList();
  }
}