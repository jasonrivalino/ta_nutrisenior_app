import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/features/PromoSection/RestaurantPromo/recommend_restaurant_promo_widget.dart';

import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';

// Assuming SelectionToggle is imported or defined somewhere:
import '../../../shared/widgets/list_helper/resto_market_selector.dart';
import 'recommend_restaurant_promo_data.dart';

class RecommendRestaurantPromoView extends StatelessWidget {
  const RecommendRestaurantPromoView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Constraint for responsive height
    final heightCardDiscount = (screenHeight * 0.24).clamp(200.0, double.infinity);
    final gapHeight = (screenHeight * 0.04).clamp(0.0, 35.0);
    final heightCardFreeShipment = (screenHeight * 0.205).clamp(172.5, double.infinity);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Promo Aplikasi',
        showBackButton: false,
      ),
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add the SelectionToggle at the top or wherever suitable
            RestoMarketSelectionToggle(
              initialIndex: 0, // or 1 depending on the default selection
              restoRoute: '/restaurantpromo',
              marketRoute: '/marketpromo',
            ),
            PromoRestoSection(
                title: 'Promo Diskon',
                routeDetail: '/restaurantpromo',
                heightCard: heightCardDiscount,
                restaurants: discountRestaurant
            ),
            SizedBox(height: gapHeight),
            PromoRestoSection(
              title: 'Gratis Ongkir',
              routeDetail: '/restaurantpromo', 
              heightCard: heightCardFreeShipment,
              restaurants: freeShipmentRestaurant,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}