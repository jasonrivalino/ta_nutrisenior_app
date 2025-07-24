import 'package:flutter/material.dart';

import '../../../../config/constants.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/texts.dart';

class RatingCard extends StatelessWidget {
  final String ratingTarget;
  final String? businessImage;
  final int selectedRating;
  final Function(int) onRatingSelected;

  const RatingCard({
    super.key,
    required this.ratingTarget,
    this.businessImage,
    required this.selectedRating,
    required this.onRatingSelected,
  });

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
                  businessImage ?? AppConstants.driverImagePlaceholder,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ratingTarget,
                  style: AppTextStyles.textBold(
                    size: 18,
                    color: AppColors.dark,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = value <= selectedRating;

              return GestureDetector(
                onTap: () => onRatingSelected(value),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 62,
                      color: isSelected ? AppColors.orangyYellow : AppColors.soapstone,
                    ),
                    Text(
                      value.toString(),
                      style: AppTextStyles.textBold(
                        size: 16,
                        color: isSelected ? AppColors.dark : AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}