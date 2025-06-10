import '../../../database/history_rating_list_table.dart';

class HistoryRatingController {
  static List<Map<String, dynamic>> fetchRatingsByHistoryId(int historyId) {
    return historyRatingList
        .where((rating) => rating['history_id'] == historyId)
        .toList();
  }
}