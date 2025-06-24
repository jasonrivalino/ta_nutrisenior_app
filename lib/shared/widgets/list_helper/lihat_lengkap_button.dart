import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../styles/colors.dart';
import '../../styles/fonts.dart';

class LihatLengkapButton extends StatelessWidget {
  final String routeName;

  const LihatLengkapButton({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.push(routeName);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.woodland,
        foregroundColor: AppColors.soapstone,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        minimumSize: const Size(0, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Removes extra vertical space
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Text(
          'Lihat Lengkap >',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.fontBold,
            color: AppColors.soapstone,
          ),
        ),
      ),
    );
  }
}