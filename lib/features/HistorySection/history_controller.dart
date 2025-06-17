import 'package:flutter/material.dart';

import '../../database/history_order_list_table.dart';
import '../../database/business_list_table.dart';
import '../../database/driver_list_table.dart';
import '../../database/history_list_table.dart';
import '../../database/product_list_table.dart';
import '../../database/business_promo_list_table.dart';
import '../../shared/utils/calculate_price_fee.dart';

class HistoryController {
  static List<Map<String, dynamic>> fetchHistoryList() {
    final List<Map<String, dynamic>> allHistoryList = historyOrderListTable.map((historyItem) {
      final matchedDriver = driverListTable.firstWhere(
        (driver) => driver['driver_id'] == historyItem['driver_id'],
        orElse: () => {},
      );

      final matchedBusiness = businessListTable.firstWhere(
        (business) => business['business_id'] == historyItem['business_id'],
        orElse: () => {},
      );

      final matchedPromo = businessPromoListTable.firstWhere(
        (promo) => promo['business_id'] == historyItem['business_id'],
        orElse: () => {},
      );

      final int? discountPercent = matchedPromo['discount_number'] as int?;
      final bool isFreeShipment = matchedPromo['is_free_shipment'] as bool? ?? false;

      final double businessDistance = matchedBusiness['business_distance']?.toDouble() ?? 0.0;
      final int deliveryFee = historyItem['delivery_fee'] as int? ??
          calculateDeliveryFee(isFreeShipment, businessDistance);

      // Get matching orders by history_id
      final List<Map<String, dynamic>> matchedOrders = historyListTable
          .where((order) => order['history_id'] == historyItem['history_id'])
          .map((order) {
            final matchedProduct = productListTable.firstWhere(
              (product) => product['product_id'] == order['product_id'],
              orElse: () => {},
            );

            final int originalPrice = matchedProduct['product_price'] ?? 0;
            final int discountedPrice = discountPercent != null
                ? (originalPrice * (100 - discountPercent) ~/ 100)
                : originalPrice;

            return {
              'product_name': matchedProduct['product_name'] ?? 'Unknown Product',
              'product_price': discountedPrice,
              'qty_product': order['qty_product'],
              'notes': order['notes'],
            };
          }).toList();

      final int totalOrderPrice = matchedOrders.fold(
        0,
        (sum, item) => sum + (item['product_price'] as int) * (item['qty_product'] as int),
      );

      final int serviceFee = matchedBusiness['service_fee'] ?? 0;
      final int totalPrice = totalOrderPrice + serviceFee + deliveryFee;

      return {
        ...historyItem,
        ...matchedDriver,
        ...matchedBusiness,
        'promo_discount': discountPercent ?? 0,
        'is_free_shipment': isFreeShipment,
        'delivery_fee': deliveryFee,
        'order_list': matchedOrders,
        'total_price': totalPrice,
      };
    }).toList();

    allHistoryList.sort((a, b) => (b['order_date'] as DateTime).compareTo(a['order_date'] as DateTime));
    return allHistoryList;
  }
}

class CancelledOrderController {
  final int historyId;

  CancelledOrderController({required this.historyId});

  void cancelOrder() {
    // Remove from historyOrderListTable
    historyOrderListTable.removeWhere((order) => order['history_id'] == historyId);

    // Remove from historyListTable
    historyListTable.removeWhere((item) => item['history_id'] == historyId);

    debugPrint('[DEBUG] Order with history_id=$historyId cancelled and removed from all related tables.');
  }
}