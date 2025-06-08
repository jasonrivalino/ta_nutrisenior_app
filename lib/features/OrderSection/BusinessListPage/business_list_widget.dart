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
                  businessImage: business['business_image'],
                  businessName: business['business_name'],
                  businessRate: business['business_rating'],
                  businessLocation: business['business_distance'],
                  discountNumber: business['discount_number'] != null
                      ? business['discount_number'] as int?
                      : null,
                  isFreeShipment: business['is_free_shipment'] ?? false,
                  onTap: () {
                    final type = business['business_type'];
                    final route = type == 'restaurant'
                        ? '/restaurant/detail/${business['business_id']}'
                        : '/market/detail/${business['business_id']}';

                    context.push(route, extra: {
                      'business_id': business['business_id'],
                      'business_name': business['business_name'],
                      'business_image': business['business_image'],
                      'business_rating': business['business_rating'],
                      'business_distance': business['business_distance'],
                      'business_address': business['business_address'],
                      'business_open_hours': business['business_open_hours'],
                      'discount_number': business['discount_number'],
                      'is_free_shipment': business['is_free_shipment'],
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