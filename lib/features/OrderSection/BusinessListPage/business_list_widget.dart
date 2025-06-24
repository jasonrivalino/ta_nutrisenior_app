import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/utils/is_business_open.dart';
import '../../../shared/widgets/list_helper/list_title.dart';
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
                final isOpen = isBusinessOpen(
                  business['business_open_hour'],
                  business['business_close_hour'],
                );
                return CardList(
                  businessImage: business['business_image'],
                  businessName: business['business_name'],
                  businessType: business['business_type'],
                  businessRate: business['business_rating'],
                  businessLocation: business['business_distance'],
                  discountNumber: business['discount_number'],
                  isFreeShipment: business['is_free_shipment'],
                  isOpen: isOpen,
                  onTap: () {
                    final route = '/business/detail/${business['business_id']}';
                    context.push(route, extra: business);
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