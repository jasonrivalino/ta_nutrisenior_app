import '../../../../database/address_list_table.dart';
import '../../../../database/chat_list_table.dart';
import '../../../../database/driver_list_table.dart';
import '../../../../database/history_add_ons_list_table.dart';
import '../../../../database/history_list_table.dart';
import '../../../../database/history_order_list_table.dart';

class OrderConfirmationController {
  static int addOrder({
    required int businessId,
    required List<Map<String, dynamic>> selectedProducts,
    required String estimatedDelivery,
    required int deliveryFee,
    required String paymentMethod,
    required String addressDetail,
    required String driverNote,
  }) {
    int newHistoryId = historyOrderListTable.isNotEmpty
        ? historyOrderListTable.last['history_id'] + 1
        : 1;

    final randomDriver = driverListTable[random.nextInt(driverListTable.length)];

    historyOrderListTable.add({
      'history_id': newHistoryId,
      'business_id': businessId,
      'driver_id': randomDriver['driver_id'],
      'driver_note': driverNote,
      'order_date': DateTime.now(),
      'address_receiver': addressDetail,
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

      if (product.containsKey('add_ons') && product['add_ons'] is List) {
        final List<dynamic> addOns = product['add_ons'];
        for (var addOn in addOns) {
          historyAddOnsList.add({
            'history_id': newHistoryId,
            'add_ons_id': addOn is int ? addOn : int.parse(addOn.toString()),
          });
        }
      }
    }

    // ✅ Add chat message if driverNote is not empty
    if (driverNote.trim().isNotEmpty && driverNote.trim() != "-") {
      final newChatId = chatListTable.isNotEmpty
          ? chatListTable.last['chat_id'] + 1
          : 1;

      chatListTable.add({
        'chat_id': newChatId,
        'driver_id': randomDriver['driver_id'],
        'is_user': true,
        'message_sent': driverNote,
        'message_time': DateTime.now(),
      });
    }

    print('✅ Order has been added successfully with history_id: $newHistoryId');
    return newHistoryId;
  }
}

class AddressOrderController {
  static Map<String, dynamic>? getAddressById(int addressId) {
    try {
      return addressListTable.firstWhere((a) => a['address_id'] == addressId);
    } catch (e) {
      return null;
    }
  }
}