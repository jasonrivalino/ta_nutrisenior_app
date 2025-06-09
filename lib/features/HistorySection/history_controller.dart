import '../../database/history_order_list_table.dart';
import '../../database/business_list_table.dart';
import '../../database/driver_list_table.dart';

class HistoryController {
  static List<Map<String, dynamic>> fetchHistoryList() {
    final List<Map<String, dynamic>> allHistoryList = historyOrderList.map((historyItem) {
      final matchedDriver = driverListTable.firstWhere(
        (driver) => driver['driver_id'] == historyItem['driver_id'],
        orElse: () => {},
      );

      final matchedBusiness = businessListTable.firstWhere(
        (business) => business['business_id'] == historyItem['business_id'],
        orElse: () => {},
      );

      return {
        ...historyItem,
        ...matchedDriver,
        'business_name': matchedBusiness['business_name'] ?? 'Unknown Business',
        'business_type': matchedBusiness['business_type'] ?? 'Unknown Type',
        'business_image': matchedBusiness['business_image'] ?? '',
      };
    }).toList();

    // Sort from newest to oldest based on 'order_date'
    allHistoryList.sort((a, b) => (b['order_date'] as DateTime).compareTo(a['order_date'] as DateTime));

    return allHistoryList;
  }
}