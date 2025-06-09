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
    final int historyId = historyData['history_id'];
    final DateTime orderDate = historyData['order_date'];
    final String businessName = historyData['business_name'];
    final String businessImage = historyData['business_image'];
    final String status = historyData['status'];

    // int totalOrderPrice = historyData['orderList']
    //   .fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));
    // num totalPrice = totalOrderPrice + historyData['serviceFee'] + historyData['deliveryFee'];

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
                    if (status != 'selesai')
                      Text(
                        status.toUpperCase(),
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
                        businessImage,
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
                                'Rp. 100.000', // Replace with totalPrice calculation
                                // NumberFormat.currency(
                                //   locale: 'id_ID',
                                //   symbol: 'Rp',
                                //   decimalDigits: 0,
                                // ).format(totalPrice.toInt()),
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
                                  if (status == 'selesai')
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
                                              '/history/done/details/$historyId',
                                              extra: {
                                                'history_id': historyId,
                                                'order_date': orderDate,
                                                'driver_name': historyData['driver_name'],
                                                'business_name': historyData['business_name'],
                                                'business_image': historyData['business_image'],
                                                'business_type': historyData['business_type'],
                                                'address_receiver': historyData['address_receiver'],
                                                // 'orderList': historyData['orderList'],
                                                'service_fee': historyData['service_fee'],
                                                'delivery_fee': historyData['delivery_fee'],
                                                'total_price': 100000, // Replace with totalPrice calculation
                                                'payment_method': historyData['payment_method'],
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
                                          if (status == 'diproses') {
                                            context.push(
                                              '/history/processing/$historyId',
                                              extra: {
                                                'history_id': historyId,
                                                'business_name': historyData['business_name'],
                                                'business_type': historyData['business_type'],
                                                'business_image': historyData['business_image'],
                                                'estimated_arrival_time': historyData['estimated_arrival_time'],
                                                // 'orderList': historyData['orderList'],
                                                'service_fee': historyData['service_fee'],
                                                'delivery_fee': historyData['delivery_fee'],
                                                'total_price': 100000, // Replace with totalPrice calculation
                                                'status': historyData['status'],
                                              },
                                            );
                                          } else if (status == 'dikirim') {
                                            context.push(
                                              '/history/delivering/${historyData['id']}',
                                              extra: {
                                                'history_id': historyId,
                                                'business_name': historyData['business_name'],
                                                'business_type': historyData['business_type'],
                                                'business_image': historyData['business_image'],
                                                'estimated_arrival_time': historyData['estimated_arrival_time'],
                                                'driver_id': historyData['driver_id'],
                                                'driver_name': historyData['driver_name'],
                                                'driver_image': historyData['driver_image'],
                                                'driver_rating': historyData['driver_rating'],
                                                'driver_phone_number': historyData['driver_phone_number'],
                                                'status': historyData['status'],
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