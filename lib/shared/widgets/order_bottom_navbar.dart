import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/utils/format_currency.dart';
import '../styles/texts.dart';

class OrderBottomNavbar extends StatelessWidget {
  final int totalPrice;
  final String buttonText;
  final VoidCallback onOrderPressed;

  const OrderBottomNavbar({
    super.key,
    required this.totalPrice,
    required this.buttonText,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.berylGreen,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Total Harga",
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.dark,
                ),
              ),
              const Spacer(),
              Text(
                formatCurrency(totalPrice),
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: onOrderPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.woodland,
                foregroundColor: AppColors.soapstone,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                buttonText,
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.soapstone,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}