import 'package:flutter/material.dart';
import '../../../shared/styles/colors.dart';

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
      style: const TextStyle(
        color: Colors.black, // Typed text color
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Background color
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), // Padding
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.darkGray), // Placeholder color
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