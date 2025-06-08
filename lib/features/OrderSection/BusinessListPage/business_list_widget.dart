import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/widgets/list_helper/list_title.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/product_card/card_list.dart';

class BusinessListWidget extends StatelessWidget {
  final String? title;
  final List<Map<String, dynamic>> businesses;

  const BusinessListWidget({
    super.key,
    required this.title,
    required this.businesses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          ListTitle(title: title!),
          const SizedBox(height: 17.5),
        ],
        // Scrollable list only
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.darkGray,
                  width: 0.5,
                ),
              ),
            ),
            child: ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business = businesses[index];
                return CardList(
                  image: business['business_image'],
                  name: business['business_name'],
                  rate: business['business_rating'],
                  location: business['business_distance'],
                  percentage: business['discount_number'] != null
                      ? business['discount_number'] as int?
                      : null,
                  freeShipment: business['is_free_shipment'] ?? false,
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
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}