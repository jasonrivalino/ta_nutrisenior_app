import 'package:flutter/material.dart';

import '../../database/addons_list_table.dart';
import '../../database/business_product_list_table.dart';
import '../../database/history_add_ons_list_table.dart';
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

      // print('--- History ID: ${historyItem['history_id']} ---');
      // print('Delivery Fee: $deliveryFee');
      // print('Discount: $discountPercent%');
      // print('Free Shipment: $isFreeShipment');

      final List<Map<String, dynamic>> matchedOrders = historyListTable
          .where((order) => order['history_id'] == historyItem['history_id'])
          .map((order) {
            final int productId = order['product_id'];
            final int qty = order['qty_product'] ?? 1;

            final matchedProduct = productListTable.firstWhere(
              (product) => product['product_id'] == productId,
              orElse: () => {},
            );

            final int originalPrice = matchedProduct['product_price'] ?? 0;
            final int discountedPrice = discountPercent != null
                ? (originalPrice * (100 - discountPercent) ~/ 100)
                : originalPrice;

            // print('Product: ${matchedProduct['product_name']}');
            // print('Original Price: $originalPrice');
            // print('Discounted Price: $discountedPrice');
            // print('Quantity: $qty');

            // Filter only add-ons belonging to this product
            final List<Map<String, dynamic>> matchedAddOns = historyAddOnsList
                .where((entry) =>
                    entry['history_id'] == historyItem['history_id'] &&
                    businessProductListTable.any((bp) =>
                        bp['product_id'] == productId &&
                        bp['add_ons_id'] == entry['add_ons_id']))
                .map((entry) {
                  final addOn = addOnsListTable.firstWhere(
                    (a) => a['add_ons_id'] == entry['add_ons_id'],
                    orElse: () => {},
                  );

                  final int addOnPrice = addOn['add_ons_price'] ?? 0;
                  final int totalAddOnPrice = addOnPrice * qty;

                  // print('  Add-on: ${addOn['add_ons_name']}');
                  // print('  Add-on Price: $addOnPrice');
                  // print('  Total Add-on Price (x$qty): $totalAddOnPrice');

                  return {
                    ...addOn,
                    'total_price': totalAddOnPrice,
                  };
                }).toList();

            final int addOnsTotal = matchedAddOns.fold(0, (sum, a) => sum + (a['total_price'] as int));

            // final int orderTotal = discountedPrice * qty + addOnsTotal;
            // print('Total for this product (price * qty + add-ons): $orderTotal');

            return {
              'product_name': matchedProduct['product_name'] ?? 'Unknown Product',
              'product_price': discountedPrice,
              'qty_product': qty,
              'notes': order['notes'],
              'add_ons_details': matchedAddOns,
              'add_ons_total': addOnsTotal,
            };
          }).toList();

      final int totalOrderPrice = matchedOrders.fold(
        0,
        (sum, item) =>
            sum +
            ((item['product_price'] as int) * (item['qty_product'] as int)) +
            (item['add_ons_total'] as int),
      );

      final int serviceFee = matchedBusiness['service_fee'] ?? 0;
      final int totalPrice = totalOrderPrice + serviceFee + deliveryFee;

      // print('Service Fee: $serviceFee');
      // print('Final Total Price for history ID ${historyItem['history_id']}: $totalPrice\n');

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