import 'package:flutter/material.dart';
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
                  image: business['image'],
                  name: business['name'],
                  rate: business['rate'],
                  location: business['location'],
                  percentage: business['percentage'],
                  onTap: () {},
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