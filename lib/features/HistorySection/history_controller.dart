import '../../database/history_order_list_table.dart';
import '../../database/business_list_table.dart';
import '../../database/driver_list_table.dart';
import '../../database/history_list_table.dart';
import '../../database/product_list_table.dart';

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

      // Get matching orders by history_id
      final List<Map<String, dynamic>> matchedOrders = historyListTable
          .where((order) => order['history_id'] == historyItem['history_id'])
          .map((order) {
            final matchedProduct = productListTable.firstWhere(
              (product) => product['product_id'] == order['product_id'],
              orElse: () => {},
            );
            return {
              'product_name': matchedProduct['product_name'] ?? 'Unknown Product',
              'product_price': matchedProduct['product_price'] ?? 0,
              'qty_product': order['qty_product'],
              'notes': order['notes'],
            };
          }).toList();

      // Calculate total order price
      final int totalOrderPrice = matchedOrders.fold(
        0,
        (sum, item) => sum + (item['product_price'] as int) * (item['qty_product'] as int),
      );

      final int serviceFee = historyItem['service_fee'] ?? 0;
      final int deliveryFee = historyItem['delivery_fee'] ?? 0;

      final int totalPrice = totalOrderPrice + serviceFee + deliveryFee;

      // Debug print
      print("Order list for history_id ${historyItem['history_id']}: $matchedOrders");
      print("Total price for history_id ${historyItem['history_id']}: $totalPrice");

      return {
        ...historyItem,
        ...matchedDriver,
        'business_name': matchedBusiness['business_name'] ?? 'Unknown Business',
        'business_type': matchedBusiness['business_type'] ?? 'Unknown Type',
        'business_image': matchedBusiness['business_image'] ?? '',
        'order_list': matchedOrders,
        'total_price': totalPrice,
      };
    }).toList();

    // Sort from newest to oldest based on 'order_date'
    allHistoryList.sort((a, b) => (b['order_date'] as DateTime).compareTo(a['order_date'] as DateTime));

    return allHistoryList;
  }
}