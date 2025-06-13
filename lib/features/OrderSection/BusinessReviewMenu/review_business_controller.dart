import '../../../database/other_user_rating_list_table.dart';
import '../../../database/other_user_rating_image_list_table.dart';

class ReviewBusinessController {
  final int businessId;

  ReviewBusinessController({required this.businessId});

  List<Map<String, dynamic>> fetchAllRatings() {
    final result = otherUserRatingListTable
        .where((rating) => rating['business_id'] == businessId)
        .map((rating) {
          final ratingId = rating['rating_id'];
          final images = otherUserRatingImageListTable
              .where((img) => img['rating_id'] == ratingId)
              .map((img) => img['rating_image'] as String)
              .toList();
          return {
            ...rating,
            'rating_images': images, // new field
          };
        }).toList();

    result.sort((a, b) =>
        (b['rating_date'] as DateTime).compareTo(a['rating_date'] as DateTime));
    return result;
  }

  List<Map<String, dynamic>> fetchFilteredRatings(int? ratingNumber) {
    final allRatings = fetchAllRatings();

    if (ratingNumber == null) {
      return allRatings;
    }

    return allRatings
        .where((rating) => rating['rating_number'] == ratingNumber)
        .toList();
  }
}