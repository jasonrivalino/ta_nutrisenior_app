import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';

// Assuming SelectionToggle is imported or defined somewhere:
import '../../../shared/widgets/list_helper/resto_market_selector.dart';
import 'promo_detail_widget.dart';

class PromoDetailView extends StatelessWidget {
  final int initialIndex;
  final String restoRoute;
  final String marketRoute;
  final String promoTitle;
  final List<Map<String, dynamic>> freeShipmentBusinesses;

  const PromoDetailView({
    super.key,
    required this.initialIndex,
    required this.restoRoute,
    required this.marketRoute,
    required this.promoTitle,
    required this.freeShipmentBusinesses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Promo Lengkap',
        showBackButton: true,
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
            PromoDetailWidget(
              title: promoTitle,
              businesses: freeShipmentBusinesses,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}