import 'package:flutter/material.dart';

import '../../../../database/history_list_table.dart';
import '../../../../database/history_order_list_table.dart';
import '../../../../database/history_add_ons_list_table.dart';

class CancelledOrderController {
  final int historyId;

  CancelledOrderController({required this.historyId});

  void cancelOrder() {
    // Remove from historyOrderListTable
    historyOrderListTable.removeWhere((order) => order['history_id'] == historyId);

    // Remove from historyListTable
    historyListTable.removeWhere((item) => item['history_id'] == historyId);

    // Remove from historyAddOnsListTable
    historyAddOnsListTable.removeWhere((addOn) => addOn['history_id'] == historyId);

    debugPrint('[DEBUG] Order with history_id=$historyId cancelled and removed from all related tables.');
  }
}