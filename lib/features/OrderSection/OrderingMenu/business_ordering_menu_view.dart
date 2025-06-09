import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/utils/formatted_time.dart';

class BusinessOrderingMenuView extends StatelessWidget {
  final int id;
  final String businessName;
  final String businessType;
  final String businessImage;
  final double businessRating;
  final double businessDistance;
  final String businessAddress;
  final DateTime businessOpenHour;
  final DateTime businessCloseHour;
  final String businessEstimatedDelivery;
  final int? discountNumber;
  final bool isFreeShipment;

  const BusinessOrderingMenuView({
    super.key,
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.businessImage,
    required this.businessRating,
    required this.businessDistance,
    required this.businessAddress,
    required this.businessOpenHour,
    required this.businessCloseHour,
    required this.businessEstimatedDelivery,
    this.discountNumber,
    required this.isFreeShipment,
  });

  static BusinessOrderingMenuView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    print('BusinessOrderingMenuView.fromExtra: $extra');

    return BusinessOrderingMenuView(
      id: extra['business_id'],
      businessName: extra['business_name'],
      businessType: extra['business_type'],
      businessImage: extra['business_image'],
      businessRating: extra['business_rating'],
      businessDistance: extra['business_distance'],
      businessAddress: extra['business_address'],
      businessOpenHour: extra['business_open_hour'] as DateTime,
      businessCloseHour: extra['business_close_hour'] as DateTime,
      businessEstimatedDelivery: extra['estimated_delivery'],
      discountNumber: extra['discount_number'],
      isFreeShipment: extra['is_free_shipment'],
    );
  }


  @override
  Widget build(BuildContext context) {
    final formattedOpen = formatHours(businessOpenHour);
    final formattedClose = formatHours(businessCloseHour);

    return Scaffold(
      appBar: AppBar(title: Text(businessName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              businessImage,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Text('Type: $businessType'),
            Text('Rating: $businessRating'),
            Text('Distance: ${businessDistance.toStringAsFixed(2)} km'),
            Text('Address: $businessAddress'),
            Text('Open: $formattedOpen - $formattedClose'),
            Text('Est. Delivery: $businessEstimatedDelivery'),
            if (discountNumber != null) Text('Discount: $discountNumber%'),
            Text(isFreeShipment ? 'Free Shipment Available' : 'No Free Shipment'),
          ],
        ),
      ),
    );
  }
}