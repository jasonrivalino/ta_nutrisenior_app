import 'package:flutter/material.dart';

import '../../../../database/history_list_table.dart';
import '../../../../database/history_order_list_table.dart';
import '../../../../database/history_add_ons_list_table.dart';

class CancelledOrderController {
  final int historyId;

  CancelledOrderController({required this.historyId});

  void cancelOrder() {
    // Ubah status menjadi 'dibatalkan' di historyOrderListTable
    for (var order in historyOrderListTable) {
      if (order['history_id'] == historyId) {
        order['status'] = 'dibatalkan';
        debugPrint('[DEBUG] Status order dengan history_id=$historyId diubah menjadi dibatalkan.');
      }
    }

    // Remove from historyListTable
    historyListTable.removeWhere((item) => item['history_id'] == historyId);

    // Remove from historyAddOnsListTable
    historyAddOnsListTable.removeWhere((addOn) => addOn['history_id'] == historyId);
  }
}