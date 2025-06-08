import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessOrderingMenuView extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final double rate;
  final double location;
  final String address;
  final String openHours;
  final int? percentage;
  final bool freeShipment;

  const BusinessOrderingMenuView({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.rate,
    required this.location,
    required this.address,
    required this.openHours,
    this.percentage,
    required this.freeShipment,
  });

  static BusinessOrderingMenuView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    return BusinessOrderingMenuView(
      id: extra['id'],
      image: extra['image'],
      name: extra['name'],
      rate: extra['rate'],
      location: extra['location'],
      address: extra['address'],
      openHours: extra['openHours'],
      percentage: extra['percentage'],
      freeShipment: extra['freeShipment'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image),
            const SizedBox(height: 12),
            Text('Rating: $rate'),
            Text('Distance: $location km'),
            Text('Address: $address'),
            Text('Open Hours: $openHours'),
            if (percentage != null) Text('Discount: $percentage%'),
            Text(freeShipment ? 'Free Shipment Available' : 'No Free Shipment'),
          ],
        ),
      ),
    );
  }
}