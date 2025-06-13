import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/lihat_lengkap_button.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/list_title.dart';

import '../../shared/widgets/product_card/card_box.dart';

class RecommendedPromoSection extends StatelessWidget {
  final String title;
  final String routeDetail;
  final double heightCard;
  final List<Map<String, dynamic>> businesses;

  const RecommendedPromoSection({
    super.key,
    required this.title,
    required this.routeDetail,
    required this.heightCard,
    required this.businesses,
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
            itemCount: businesses.take(5).length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final business = businesses[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.425,
                child: CardBox(
                  businessImage: business['business_image'],
                  businessName: business['business_name'],
                  businessRate: business['business_rating'],
                  businessLocation: business['business_distance'],
                  discountNumber: business['discount_number'],
                  onTap: () {
                    final route = '/business/detail/${business['business_id']}';
                    context.push(route, extra: business);
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