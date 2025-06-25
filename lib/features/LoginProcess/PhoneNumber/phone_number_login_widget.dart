import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';

class PhoneNumberInput extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;

  const PhoneNumberInput({
    super.key,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      style: AppTextStyles.textMedium(
        size: 16,
        color: AppColors.dark,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.soapstone, // Background color
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), // Padding
        hintText: hintText,
        hintStyle: AppTextStyles.textMedium(
          size: 16,
          color: AppColors.darkGray,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.dark, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.dark, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.dark, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }
}