import 'package:flutter/material.dart';

import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';

class RecommendRestaurantPromoView extends StatelessWidget {
  const RecommendRestaurantPromoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Promo Aplikasi',
        showBackButton: false,
      ),
      backgroundColor: Colors.green[50],
      body: Center(
        child: Text(
          'This is restaurant promo page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}