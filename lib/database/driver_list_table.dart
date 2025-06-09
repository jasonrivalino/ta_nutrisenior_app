import 'dart:math';

import '../shared/utils/generate_random_driver_phone_number.dart';

final Random random = Random();

final List<Map<String, dynamic>> driverListTable = List.generate(10, (index) {
  double driverRating = 4 + random.nextDouble(); // value between 4.0 and <5.0

  return {
    'driver_id': index + 1,
    'driver_name': 'Driver #${index + 1}',
    'driver_image': 'assets/images/dummy/chat/driver.png',
    'driver_rating': double.parse(driverRating.toStringAsFixed(1)), // one decimal
    'driver_phone_number': generatePhoneNumber(),
  };
});