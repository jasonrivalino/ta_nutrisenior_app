import '../../../database/history_rating_image_list_table.dart';
import '../../../database/history_rating_list_table.dart';

class HistoryRatingController {
  static List<Map<String, dynamic>> fetchRatingsByHistoryId(int historyId) {
    final ratings = historyRatingListTable
        .where((rating) => rating['history_id'] == historyId)
        .toList();

    for (var rating in ratings) {
      final matchingImages = _findAllMatchingImages(
        historyId: historyId,
        ratingType: rating['rating_type'],
      );

      rating['rating_images'] = matchingImages;
    }

    return ratings;
  }

  static List<String> _findAllMatchingImages({
    required int historyId,
    required String ratingType,
  }) {
    return historyRatingImageListTable
        .where((img) {
          final imageType = img['rating_type'];
          final imageHistoryId = img['history_id'];

          final isBusinessMatch = imageType == 'business' &&
              (ratingType == 'restaurant' || ratingType == 'market');
          final isExactMatch = imageType == ratingType;

          return imageHistoryId == historyId &&
              (isBusinessMatch || isExactMatch);
        })
        .map((img) => img['rating_image'].toString())
        .toList();
  }

  /// Return ratings dalam urutan: driver dulu, lalu business
  static List<Map<String, dynamic>> fetchOrderedRatings(int historyId) {
    final allRatings = fetchRatingsByHistoryId(historyId);

    final driverRatings = allRatings
        .where((r) => r['rating_type'] == 'driver')
        .toList();

    final businessRatings = allRatings
        .where((r) =>
            r['rating_type'] == 'restaurant' ||
            r['rating_type'] == 'market')
        .toList();

    return [...driverRatings, ...businessRatings];
  }
}