import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import '../../styles/fonts.dart';

class ListTitle extends StatelessWidget {
  final String title;

  const ListTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 20, 8),
      decoration: BoxDecoration(
        color: AppColors.drabGreen,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.fontBold,
          color: AppColors.soapstone,
        ),
      ),
    );
  }
}