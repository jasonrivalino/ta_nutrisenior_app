import '../../../database/business_list_table.dart';
import '../../../database/favorites_list_table.dart';
import '../../../database/business_promo_list_table.dart';

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
    final joined = favoriteIdsInOrder
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

    // Sort: open businesses first
    joined.sort((a, b) {
      final aOpen = isBusinessOpen(a['business_open_hour'], a['business_close_hour']);
      final bOpen = isBusinessOpen(b['business_open_hour'], b['business_close_hour']);

      if (aOpen && !bOpen) return -1;
      if (!aOpen && bOpen) return 1;
      return 0;
    });

    return joined;
  }

  static bool isBusinessOpen(DateTime? open, DateTime? close) {
    if (open == null || close == null) return true;
    final now = DateTime.now();
    final openToday = DateTime(now.year, now.month, now.day, open.hour, open.minute);
    final closeToday = DateTime(now.year, now.month, now.day, close.hour, close.minute);
    return now.isAfter(openToday) && now.isBefore(closeToday);
  }
}