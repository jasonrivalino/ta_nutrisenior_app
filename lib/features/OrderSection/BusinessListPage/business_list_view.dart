import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';

// Assuming SelectionToggle is imported or defined somewhere:
import '../../../shared/widgets/list_helper/resto_market_selector.dart';
import 'business_list_widget.dart';

class BusinessListView extends StatelessWidget {
  final int initialIndex;
  final String restoRoute;
  final String marketRoute;
  final String? appBarTitle;
  final String? promoTitle;
  final int bottomNavIndex;
  final List<Map<String, dynamic>> businessesData;

  const BusinessListView({
    super.key,
    required this.initialIndex,
    required this.restoRoute,
    required this.marketRoute,
    this.appBarTitle,
    this.promoTitle,
    required this.bottomNavIndex,
    required this.businessesData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle ?? 'Promo Lengkap',
        showBackButton: true,
        initialIndex: initialIndex,
        selectedIndex: bottomNavIndex,
      ),
      backgroundColor: AppColors.soapstone,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RestoMarketSelectionToggle(
            initialIndex: initialIndex,
            restoRoute: restoRoute,
            marketRoute: marketRoute,
          ),
          Expanded(
            child: BusinessListWidget(
              title: promoTitle,
              businesses: businessesData,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: bottomNavIndex),
    );
  }
}