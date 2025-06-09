import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessOrderingMenuView extends StatelessWidget {
  final int id;
  final String businessName;
  final String businessImage;
  final double businessRating;
  final double businessDistance;
  final String businessAddress;
  final String businessOpenHours;
  final int? discountNumber;
  final bool isFreeShipment;

  const BusinessOrderingMenuView({
    super.key,
    required this.id,
    required this.businessName,
    required this.businessImage,
    required this.businessRating,
    required this.businessDistance,
    required this.businessAddress,
    required this.businessOpenHours,
    this.discountNumber,
    required this.isFreeShipment,
  });

  static BusinessOrderingMenuView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    return BusinessOrderingMenuView(
      id: extra['business_id'],
      businessName: extra['business_name'],
      businessImage: extra['business_image'],
      businessRating: extra['business_rating'],
      businessDistance: extra['business_distance'],
      businessAddress: extra['business_address'],
      businessOpenHours: extra['business_open_hours'],
      discountNumber: extra['discount_number'],
      isFreeShipment: extra['is_free_shipment'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(businessName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(businessImage, height: 100, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text('Rating: $businessRating'),
            Text('Distance: $businessDistance km'),
            Text('Address: $businessAddress'),
            Text('Open Hours: $businessOpenHours'),
            if (discountNumber != null) Text('Discount: $discountNumber%'),
            Text(isFreeShipment ? 'Free Shipment Available' : 'No Free Shipment'),
          ],
        ),
      ),
    );
  }
}