import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';
import '../../../shared/widgets/list_helper/resto_market_selector.dart';

import 'recommend_promo_widget.dart';

class RecommendPromoView extends StatelessWidget {
  final int initialIndex;
  final String restoRoute;
  final String marketRoute;
  final String discountRouteDetail;
  final String freeShipmentRouteDetail;
  final List<Map<String, dynamic>> discountBusinesses;
  final List<Map<String, dynamic>> freeShipmentBusinesses;

  const RecommendPromoView({
    super.key,
    required this.initialIndex,
    required this.restoRoute,
    required this.marketRoute,
    required this.discountRouteDetail,
    required this.freeShipmentRouteDetail,
    required this.discountBusinesses,
    required this.freeShipmentBusinesses,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Constraint for responsive height
    final heightCard = (screenHeight * 0.235).clamp(200.0, double.infinity);
    final gapHeight =
        (screenHeight * 0.0325).clamp(0.0, screenHeight > 900 ? 30.0 : 18.5);

    // print('Height Card: $heightCard');

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
            RestoMarketSelectionToggle(
              initialIndex: initialIndex,
              restoRoute: restoRoute,
              marketRoute: marketRoute,
            ),
            RecommendedPromoCardList(
              title: 'Promo Diskon',
              routeDetail: discountRouteDetail,
              heightCard: heightCard,
              businesses: discountBusinesses,
            ),
            SizedBox(height: gapHeight),
            RecommendedPromoCardList(
              title: 'Gratis Ongkir',
              routeDetail: freeShipmentRouteDetail,
              heightCard: heightCard,
              businesses: freeShipmentBusinesses,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}