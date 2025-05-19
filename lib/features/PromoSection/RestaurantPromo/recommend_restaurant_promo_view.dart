import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/features/PromoSection/recommend_promo_widget.dart';

import '../../../shared/styles/colors.dart';
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
    final heightCard = (screenHeight * 0.235).clamp(200.0, double.infinity);
    final gapHeight = (screenHeight * 0.03).clamp(0.0, screenHeight > 900 ? 30.0 : 17.5);

    // print('Gap Height: $gapHeight');
    print('Height Card: $heightCard');
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Promo Aplikasi',
        showBackButton: false,
      ),
      backgroundColor: AppColors.soapstone,
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
            RecommendedPromoSection(
                title: 'Promo Diskon',
                routeDetail: '/restaurantpromo',
                heightCard: heightCard,
                restaurants: discountRestaurant
            ),
            SizedBox(height: gapHeight),
            RecommendedPromoSection(
              title: 'Gratis Ongkir',
              routeDetail: '/restaurantpromo', 
              heightCard: heightCard,
              restaurants: freeShipmentRestaurant,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}