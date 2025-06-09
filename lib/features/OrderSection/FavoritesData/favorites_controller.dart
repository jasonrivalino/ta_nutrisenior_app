import '../../../database/business_list_table.dart';
import '../../../database/favorites_list_table.dart';

class FavoritesController {
  static List<Map<String, dynamic>> get favoritesRestaurant {
    return _getFavoritesByType('restaurant');
  }

  static List<Map<String, dynamic>> get favoritesMarket {
    return _getFavoritesByType('market');
  }

  static List<Map<String, dynamic>> _getFavoritesByType(String type) {
    final favoriteIdsInOrder = favoritesListTable.map((fav) => fav['business_id']).toList();

    // Create a map of businesses for quick lookup by ID
    final businessMap = {
      for (var business in businessListTable)
        business['business_id']: business
    };

    // Preserve order from favoritesListTable and filter by type
    return favoriteIdsInOrder
        .map((id) => businessMap[id])
        .where((business) => business != null && business['business_type'] == type)
        .cast<Map<String, dynamic>>()
        .toList();
  }
}