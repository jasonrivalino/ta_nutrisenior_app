import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/lihat_lengkap_button.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/list_title.dart';

import '../../shared/widgets/product_card/card_box.dart';

class RecommendedPromoSection extends StatelessWidget {
  final String title;
  final String routeDetail;
  final double heightCard;
  final List<Map<String, dynamic>> restaurants;

  const RecommendedPromoSection({
    super.key,
    required this.title,
    required this.routeDetail,
    required this.heightCard,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Button Row
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTitle(title: title),
              LihatLengkapButton(routeName: routeDetail),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal Scrollable Card Row
        SizedBox(
          height: heightCard,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            itemCount: restaurants.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.425,
                child: CardBox(
                  image: restaurant['image'],
                  name: restaurant['name'],
                  type: restaurant['type'],
                  rate: restaurant['rate'],
                  location: restaurant['location'],
                  percentage: restaurant['percentage'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}