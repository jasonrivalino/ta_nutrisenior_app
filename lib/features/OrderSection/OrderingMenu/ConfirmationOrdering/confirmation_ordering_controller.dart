import '../../../../database/driver_list_table.dart';
import '../../../../database/history_list_table.dart';
import '../../../../database/history_order_list_table.dart';

class OrderConfirmationController {
  static int addOrder({
    required int businessId,
    required List<Map<String, dynamic>> selectedProducts,
    required String estimatedDelivery,
    required int deliveryFee,
    required String paymentMethod,
  }) {
    int newHistoryId = historyOrderListTable.isNotEmpty
        ? historyOrderListTable.last['history_id'] + 1
        : 1;

    final randomDriver = driverListTable[random.nextInt(driverListTable.length)];

    historyOrderListTable.add({
      'history_id': newHistoryId,
      'business_id': businessId,
      'driver_id': randomDriver['driver_id'],
      'order_date': DateTime.now(),
      'address_receiver': 'Jl. Lorem Ipsum 1 No. 2',
      'estimated_arrival_time': estimatedDelivery,
      'delivery_fee': deliveryFee,
      'payment_method': paymentMethod,
      'status': 'diproses',
    });

    for (var product in selectedProducts) {
      final int productId = product['product_id'] is int
          ? product['product_id']
          : int.parse(product['product_id'].toString());

      historyListTable.add({
        'history_id': newHistoryId,
        'product_id': productId,
        'qty_product': product['qty_product'],
        'notes': product['notes'] ?? '',
      });
    }

    print('✅ Order has been added successfully with history_id: $newHistoryId');
    return newHistoryId;
  }
}