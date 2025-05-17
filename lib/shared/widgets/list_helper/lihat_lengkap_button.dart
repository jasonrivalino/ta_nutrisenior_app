import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

class LihatLengkapButton extends StatelessWidget {
  final String routeName;

  const LihatLengkapButton({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.woodland,
        foregroundColor: AppColors.soapstone,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0, 
        shadowColor: Colors.transparent, // Removes shadow completely
      ),
      child: const Text(
        'Lihat Lengkap >',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.fontBold,
          color: AppColors.soapstone,
        ),
      ),
    );
  }
}