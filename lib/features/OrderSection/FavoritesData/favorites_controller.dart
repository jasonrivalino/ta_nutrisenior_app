import '../../../database/business_list_table.dart';
import '../../../database/favorites_list_table.dart';
import '../../../database/business_promo_list_table.dart'; // Make sure this is imported

class FavoritesController {
  static List<Map<String, dynamic>> get favoritesRestaurant {
    return _getFavoritesByType('restaurant');
  }

  static List<Map<String, dynamic>> get favoritesMarket {
    return _getFavoritesByType('market');
  }

  static List<Map<String, dynamic>> _getFavoritesByType(String type) {
    final favoriteIdsInOrder = favoritesListTable.map((fav) => fav['business_id']).toList();

    // Create a map of businesses for quick lookup
    final businessMap = {
      for (var business in businessListTable)
        business['business_id']: business
    };

    // Create a map of promos for quick lookup
    final promoMap = {
      for (var promo in businessPromoListTable)
        promo['business_id']: promo
    };

    // Join data
    return favoriteIdsInOrder
        .map((id) {
          final business = businessMap[id];
          if (business == null || business['business_type'] != type) return null;

          final promo = promoMap[id];
          return {
            ...business,
            'discount_number': promo?['discount_number'],
            'is_free_shipment': promo?['is_free_shipment'],
          };
        })
        .where((item) => item != null)
        .cast<Map<String, dynamic>>()
        .toList();
  }
}