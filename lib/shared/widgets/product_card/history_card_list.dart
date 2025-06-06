import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

import '../../styles/colors.dart';

class HistoryCardList extends StatelessWidget {
  final Map<String, dynamic> historyData;

  const HistoryCardList({
    super.key,
    required this.historyData,
  });

  @override
  Widget build(BuildContext context) {
    final int id = historyData['id'];
    final DateTime orderDate = historyData['orderDate'];
    final String image = historyData['businessImage'];
    final String businessName = historyData['businessName'];
    final String cardType = historyData['cardType'];

    int totalOrderPrice = historyData['orderList']
      .fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));
    num totalPrice = totalOrderPrice + historyData['serviceFee'] + historyData['deliveryFee'];

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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp',
                                  decimalDigits: 0,
                                ).format(totalPrice.toInt()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: AppFonts.fontBold,
                                  color: AppColors.dark,
                                ),
                              ),
                              const Spacer(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (cardType == 'done')
                                    Row(
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
                                            context.push(
                                              '/history/done/details/$id',
                                              extra: {
                                                'id': id,
                                                'totalPrice': totalPrice,
                                                'orderDate': orderDate,
                                                'driverName': historyData['driverName'],
                                                'businessName': historyData['businessName'],
                                                'addressReceiver': historyData['addressReceiver'],
                                                'orderList': historyData['orderList'],
                                                'serviceFee': historyData['serviceFee'],
                                                'deliveryFee': historyData['deliveryFee'],
                                                'paymentMethod': historyData['paymentMethod'],
                                                'businessImage': historyData['businessImage'],
                                                'businessType': historyData['businessType'],
                                              },
                                            );
                                          },
                                          child: const Text("Detail"),
                                        ),
                                        const SizedBox(width: 8),
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
                                            // Implement re-order logic
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
                                          if (cardType == 'diproses') {
                                            context.push(
                                              '/history/processing/$id',
                                              extra: {
                                                'id': id,
                                                'businessName': historyData['businessName'],
                                                'businessType': historyData['businessType'],
                                                'businessImage': historyData['businessImage'],
                                                'estimatedArrival': historyData['estimatedArrival'],
                                                'orderList': historyData['orderList'],
                                                'serviceFee': historyData['serviceFee'],
                                                'deliveryFee': historyData['deliveryFee'],
                                                'totalPrice': totalPrice,
                                                'cardType': historyData['cardType'],
                                              },
                                            );
                                          } else if (cardType == 'dikirim') {
                                            context.push(
                                              '/history/delivering/${historyData['id']}',
                                              extra: {
                                                'id': historyData['id'],
                                                'businessName': historyData['businessName'],
                                                'businessType': historyData['businessType'],
                                                'businessImage': historyData['businessImage'],
                                                'driverName': historyData['driverName'],
                                                'addressReceiver': historyData['addressReceiver'],
                                                'cardType': historyData['cardType'],
                                              },
                                            );
                                          }
                                        },
                                        child: const Text("Detail"),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}