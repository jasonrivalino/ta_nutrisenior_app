import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/fonts.dart';

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
      child: const Text(
        'Submit',
        style: TextStyle(
          fontFamily: AppFonts.fontBold,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}