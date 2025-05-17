import 'package:flutter/material.dart';

import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';

// Assuming SelectionToggle is imported or defined somewhere:
import '../../../shared/widgets/list_helper/resto_market_selector.dart';

class RecommendMarketPromoView extends StatelessWidget {
  const RecommendMarketPromoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Promo Aplikasi',
        showBackButton: false,
      ),
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          // Add the SelectionToggle at the top or wherever suitable
          RestoMarketSelectionToggle(
            initialIndex: 1, // or 1 depending on the default selection
            restoRoute: '/restaurantpromo',
            marketRoute: '/marketpromo',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'This is market promo page',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}