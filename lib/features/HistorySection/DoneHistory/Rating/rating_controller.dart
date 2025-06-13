import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../database/history_rating_list_table.dart';
import '../../../../database/other_user_rating_image_list_table.dart';
import '../../../../database/other_user_rating_list_table.dart';

class DriverRatingController {
  void addDriverRating({
    required int historyId,
    required int ratingNumber,
    required String ratingComment,
  }) {
    historyRatingList.add({
      'history_id': historyId,
      'rating_type': 'driver',
      'rating_date': DateTime.now(),
      'rating_number': ratingNumber,
      'rating_comment': ratingComment,
    });

    debugPrint('[DEBUG] New driver rating added: ${historyRatingList.last}');
  }
}

class BusinessRatingController {
  void addBusinessRating({
    required int historyId,
    required int businessId,
    required String businessType,
    required int ratingNumber,
    required String ratingComment,
    required List<String> ratingImages,
  }) async {
    final now = DateTime.now();

    historyRatingList.add({
      'history_id': historyId,
      'rating_type': businessType,
      'rating_date': now,
      'rating_number': ratingNumber,
      'rating_comment': ratingComment,
    });

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('userName') ?? 'John Doe';
    final newRatingId = (otherUserRatingListTable.map((e) => e['rating_id'] as int).fold(0, (prev, curr) => curr > prev ? curr : prev)) + 1;

    otherUserRatingListTable.add({
      'rating_id': newRatingId,
      'business_id': businessId,
      'username': username,
      'userimage': 'assets/images/dummy/chat/driver.png',
      'rating_date': now,
      'rating_number': ratingNumber,
      'rating_comment': ratingComment,
    });

    for (var image in ratingImages) {
      otherUserRatingImageListTable.add({
        'rating_id': newRatingId,
        'rating_image': image,
      });
    }
  }
}