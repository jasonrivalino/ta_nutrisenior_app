import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/texts.dart';
import '../../utils/is_business_open.dart';

class ListTitle extends StatelessWidget {
  final String title;
  final DateTime? businessOpenHour;
  final DateTime? businessCloseHour;

  const ListTitle({
    super.key,
    this.businessOpenHour,
    this.businessCloseHour,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 20, 7),
      decoration: BoxDecoration(
        color: (businessOpenHour == null || businessCloseHour == null || isBusinessOpen(businessOpenHour, businessCloseHour))
            ? AppColors.drabGreen
            : AppColors.darkGray,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Text(
        title,
        style: AppTextStyles.textBold(
          size: 20,
          color: AppColors.soapstone,
        ),
      ),
    );
  }
}