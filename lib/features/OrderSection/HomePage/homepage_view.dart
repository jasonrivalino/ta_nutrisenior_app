import 'package:flutter/material.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/bottom_navbar.dart';
import 'homepage_data.dart';
import 'homepage_widget.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final heightRecommendedToday =
        (screenHeight * 0.205).clamp(180.0, double.infinity);
    final heightCard = (screenHeight * 0.235).clamp(200.0, double.infinity);
    final gapHeight =
        (screenHeight * 0.03).clamp(0.0, screenHeight > 900 ? 17.5 : 25.0);
    print('Gap Height: $gapHeight');

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Top Section
            const HomeTopBarSection(),
            SizedBox(height: 32),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecommendedHomeSection(
                      category: 'RecommendedToday',
                      title: 'Rekomendasi Hari Ini',
                      heightCard: heightRecommendedToday,
                      businesses: recommendedToday,
                    ),
                    SizedBox(height: gapHeight),
                    RecommendedHomeSection(
                      category: 'RecommendedList',
                      title: 'Resto Pilihan',
                      routeDetail: '/restaurantpromo/free_shipment/detail',
                      heightCard: heightCard,
                      businesses: recommendedRestaurant,
                    ),
                    SizedBox(height: gapHeight),
                    RecommendedHomeSection(
                      category: 'RecommendedList',
                      title: 'Pusat Belanja Pilihan',
                      routeDetail: '/marketpromo/free_shipment/detail',
                      heightCard: heightCard,
                      businesses: recommendedMarket,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}