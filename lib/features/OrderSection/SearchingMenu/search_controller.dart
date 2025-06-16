import 'dart:math';

import '../../../database/address_list_table.dart';
import '../../../database/business_list_table.dart';
import '../../../database/business_promo_list_table.dart';
import '../../../shared/utils/is_business_open.dart';

class SearchPageController {
  static List<Map<String, dynamic>> getRecentSearchBusinesses(List<int> recentSearchIds, String type) {
    final businesses = _joinedBusinessData
        .where((b) => b['business_type'] == type)
        .toList();

    return recentSearchIds
        .map((id) => businesses.firstWhere(
              (b) => b['business_id'] == id,
              orElse: () => {},
            ))
        .where((b) => b.isNotEmpty)
        .toList();
  }

  static List<Map<String, dynamic>> _getSortedData(String type, int sortOption) {
    final data = _joinedBusinessData
        .where((business) => business['business_type'] == type)
        .toList();

    // Prioritaskan bisnis yang sedang buka
    data.sort((a, b) {
      final aOpen = isBusinessOpen(a['business_open_hour'], a['business_close_hour']);
      final bOpen = isBusinessOpen(b['business_open_hour'], b['business_close_hour']);
      if (aOpen && !bOpen) return -1;
      if (!aOpen && bOpen) return 1;
      return 0;
    });

    // Opsi sorting tambahan
    if (sortOption == 1) {
      data.sort((a, b) => (b['business_rating'] as double).compareTo(a['business_rating'] as double));
    } else if (sortOption == 2) {
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

class AddressChooseController {
  static List<Map<String, dynamic>> getAddressesCondition(List <int> addressIdList){
    return addressIdList
        .map((id) => addressListTable.firstWhere(
              (a) => a['address_id'] == id,
              orElse: () => {},
            ))
        .where((a) => a.isNotEmpty)
        .toList();
  }

  static List<Map<String, dynamic>> getMainAddress() {
    return addressListTable.where((a) => a['isBookmarked'] == true).toList();
  }

  static List<Map<String, dynamic>> getAllAddresses() {
    return addressListTable;
  }
}

class AddressChangeController {
  static List<int> mainAddressSearches = [1];

  static List<Map<String, dynamic>>? _originalBusinessListTable;

  static void updateBusinessDistances(int selectedAddressId) {
    // Save original only once
    _originalBusinessListTable ??= businessListTable
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (mainAddressSearches.contains(selectedAddressId)) {
      for (int i = 0; i < businessListTable.length; i++) {
        businessListTable[i]['business_distance'] =
            _originalBusinessListTable![i]['business_distance'];
      }
    } else {
      final random = Random();
      for (var business in businessListTable) {
        business['business_distance'] = double.parse(
          (0.75 + random.nextDouble() * (7.50 - 0.75)).toStringAsFixed(2),
        );
      }
    }
  }
}