import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/lihat_lengkap_button.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/list_title.dart';

import 'package:ta_nutrisenior_app/shared/widgets/product_card/card_box.dart';

import '../../../shared/utils/carousel_card.dart';

// Class for the Home Page Top Bar Section
class HomeTopBarSection extends StatefulWidget {
  const HomeTopBarSection({super.key});

  @override
  State<HomeTopBarSection> createState() => _HomeTopBarSectionState();
}

class _HomeTopBarSectionState extends State<HomeTopBarSection> {
  String userName = 'Jane Doe';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'John Doe';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting & Icons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hello, $userName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.favorite_border),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      context.push('/favorite/restaurant');
                    },
                  ),
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.account_circle),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      context.push('/profile');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              context.push('/search');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Text(
                'Cari pesanan pilihanmu',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Class for the Recommended Section
class RecommendedHomeSection extends StatelessWidget {
  final String category;
  final String title;
  final double heightCard;
  final String? routeDetail;
  final List<Map<String, dynamic>> businesses;

  const RecommendedHomeSection({
    super.key,
    required this.category,
    required this.title,
    required this.heightCard,
    this.routeDetail,
    required this.businesses,
  });

  @override
  Widget build(BuildContext context) {
    if (businesses.isEmpty) return const SizedBox();

    final isToday = category == 'RecommendedToday';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTitle(title: title),
              if (!isToday && routeDetail != null)
                LihatLengkapButton(routeName: routeDetail!),
            ],
          ),
        ),
        const SizedBox(height: 12),

        isToday
            ? RecommendedTodayCarousel(
                businesses: businesses,
                heightCard: heightCard,
              )
            : SizedBox(
                height: heightCard,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  itemCount: businesses.take(5).length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final business = businesses[index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.425,
                      child: CardBox(
                        image: business['business_image'],
                        name: business['business_name'],
                        rate: business['business_rating'],
                        location: business['business_distance'],
                        onTap: () {
                          final type = business['business_type'];
                          final route = type == 'restaurant'
                              ? '/restaurant/detail/${business['business_id']}'
                              : '/market/detail/${business['business_id']}';

                          context.push(route, extra: {
                            'id': business['business_id'],
                            'image': business['business_image'],
                            'name': business['business_name'],
                            'rate': business['business_rating'],
                            'location': business['business_distance'],
                            'address': business['business_address'],
                            'openHours': business['business_open_hours'],
                            'percentage': business['discount_number'],
                            'freeShipment': business['is_free_shipment'],
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

// Class for the Recommended Today Carousel
class RecommendedTodayCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> businesses;
  final double heightCard;

  const RecommendedTodayCarousel({
    super.key,
    required this.businesses,
    required this.heightCard,
  });

  @override
  State<RecommendedTodayCarousel> createState() => _RecommendedTodayCarouselState();
}

class _RecommendedTodayCarouselState extends State<RecommendedTodayCarousel> with TickerProviderStateMixin {
  late final PageController _pageController;
  late Timer _timer;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: currentIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 10), (_) {
        if (!mounted || widget.businesses.length <= 1) return;

        setState(() {
          currentIndex++;
        });

        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businesses = getLoopedBusinesses(widget.businesses);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: SizedBox(
        height: widget.heightCard,
        width: double.infinity,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            handlePageChanged(
              index: index,
              realLength: widget.businesses.length,
              controller: _pageController,
              setCurrentIndex: (i) => setState(() => currentIndex = i),
              tickerProvider: this,
            );
          },
          itemCount: businesses.length,
          itemBuilder: (context, index) {
            final business = businesses[index];
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: CardBox(
                image: business['business_image'],
                name: business['business_name'],
                rate: business['business_rating'],
                location: business['business_distance'],
                onTap: () {
                  final type = business['business_type'];
                  final route = type == 'restaurant'
                      ? '/restaurant/detail/${business['business_id']}'
                      : '/market/detail/${business['business_id']}';

                  context.push(route, extra: {
                    'id': business['business_id'],
                    'image': business['business_image'],
                    'name': business['business_name'],
                    'rate': business['business_rating'],
                    'location': business['business_distance'],
                    'address': business['business_address'],
                    'openHours': business['business_open_hours'],
                    'percentage': business['discount_number'],
                    'freeShipment': business['is_free_shipment'],
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}