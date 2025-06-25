import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/texts.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SubmitButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.woodland,
        foregroundColor: AppColors.soapstone,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        'Submit',
        style: AppTextStyles.textBold(
          size: 18,
          color: AppColors.soapstone,
        ),
      ),
    );
  }
}