import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

import '../../styles/colors.dart';

class HistoryCardList extends StatelessWidget {
  final DateTime orderDate;
  final String image;
  final String businessName;
  final int totalPrice;
  final String cardType;
  final String? status;

  const HistoryCardList({
    super.key,
    required this.orderDate,
    required this.image,
    required this.businessName,
    required this.totalPrice,
    required this.cardType,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('d MMM yyyy, HH:mm').format(orderDate);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppColors.darkGray,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Expanded Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormatted,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: AppFonts.fontBold,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            businessName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: AppFonts.fontBold,
                              color: AppColors.dark,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 15),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(totalPrice),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: AppFonts.fontBold,
                              color: AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right section
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (cardType != 'done')
                Text(
                  cardType.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                    fontSize: 14,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
              if (cardType != 'done') const SizedBox(height: 16),

              if (cardType == 'done')
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        side: const BorderSide(color: AppColors.dark),
                        foregroundColor: AppColors.dark,
                        backgroundColor: AppColors.soapstone,
                        minimumSize: const Size(0, 33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // Detail action
                      },
                      child: const Text("Detail"),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.woodland,
                        foregroundColor: AppColors.soapstone,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // Pesan Lagi action
                      },
                      child: const Text("Pesan Lagi"),
                    ),
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      side: const BorderSide(color: AppColors.dark),
                      foregroundColor: AppColors.dark,
                      backgroundColor: AppColors.soapstone,
                      minimumSize: const Size(0, 33),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      // Detail action
                    },
                    child: const Text("Detail"),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}