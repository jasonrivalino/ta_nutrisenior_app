import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/styles/colors.dart';
import '../../shared/styles/texts.dart';
import '../../shared/widgets/detail_card/card_box.dart';
import '../../shared/widgets/elevated_button.dart';
import '../../shared/widgets/list_helper/list_title.dart';

class RecommendedPromoCardList extends StatelessWidget {
  final String title;
  final String routeDetail;
  final double heightCard;
  final List<Map<String, dynamic>> businesses;

  const RecommendedPromoCardList({
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
              ElevatedButtonWidget(
                onPressed: () => context.push(routeDetail),
                backgroundColor: AppColors.woodland,
                foregroundColor: AppColors.soapstone,
                textStyle: AppTextStyles.textBold(size: 14, color: AppColors.soapstone),
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                minimumSize: const Size(0, 30),
                borderRadius: 8,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Text('Lihat Lengkap >',
                  style: AppTextStyles.textBold(
                    size: 14,
                    color: AppColors.soapstone
                  )
                ),
              ),
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
                  businessType: business['business_type'],
                  businessRate: business['business_rating'],
                  businessLocation: business['business_distance'],
                  businessOpenHour: business['business_open_hour'],
                  businessCloseHour: business['business_close_hour'],
                  discountNumber: business['discount_number'],
                  isHalal: business['is_halal'],
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