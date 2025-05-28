import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/fonts.dart';

class RatingCard extends StatelessWidget {
  final String ratingTarget;
  final String? businessImage;
  final int selectedRating;
  final Function(int) onRatingSelected;

  const RatingCard({
    Key? key,
    required this.ratingTarget,
    this.businessImage,
    required this.selectedRating,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.frogGreen,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: AppColors.dark, width: 1.5),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  businessImage ?? 'assets/images/dummy/chat/driver.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ratingTarget,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.frogGreen,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            border: const Border(
              left: BorderSide(color: AppColors.dark, width: 1.5),
              right: BorderSide(color: AppColors.dark, width: 1.5),
              bottom: BorderSide(color: AppColors.dark, width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final value = index + 1;
              return GestureDetector(
                onTap: () => onRatingSelected(value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        selectedRating == value ? AppColors.orangyYellow : AppColors.soapstone,
                    child: Text(
                      "$value",
                      style: TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}