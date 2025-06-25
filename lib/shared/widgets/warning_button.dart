import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/texts.dart';

class WarningButton extends StatelessWidget {
  final String warningText;
  final VoidCallback? onPressed;

  const WarningButton({
    super.key,
    required this.warningText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.persianRed,
        foregroundColor: AppColors.soapstone,
        minimumSize: const Size.fromHeight(45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        warningText,
        style: AppTextStyles.textBold(
          size: 16,
          color: AppColors.soapstone,
        ),
      ),
    );
  }
}