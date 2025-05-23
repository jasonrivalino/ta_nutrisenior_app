import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/lihat_lengkap_button.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/list_title.dart';

import 'package:ta_nutrisenior_app/shared/widgets/product_card/card_box.dart';

// Class for the Home Page Top Bar Section
class HomeTopBarSection extends StatelessWidget {
  const HomeTopBarSection({super.key});

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
              const Text(
                'Hello, Jane Doe',
                style: TextStyle(
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
                      // Handle favorite tap
                    },
                  ),
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.account_circle),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
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
              Navigator.pushNamed(context, '/search');
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
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: SizedBox(
                  height: heightCard,
                  width: double.infinity,
                  child: CardBox(
                    image: businesses[0]['image'],
                    name: businesses[0]['name'],
                    rate: businesses[0]['rate'],
                    location: businesses[0]['location'],
                  ),
                ),
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
                        image: business['image'],
                        name: business['name'],
                        rate: business['rate'],
                        location: business['location'],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}