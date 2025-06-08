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
                  image: business['business_image'],
                  name: business['business_name'],
                  type: business['business_type'],
                  rate: business['business_rating'],
                  location: business['business_distance'],
                  percentage: business['discount_number'],
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