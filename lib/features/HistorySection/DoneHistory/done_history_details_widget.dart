import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

import '../../../shared/utils/format_currency.dart';
import '../../../shared/utils/formatted_time.dart';
import '../../../shared/utils/fullscreen_image_view.dart';

// Class to display order time and driver name in a card format
class DoneOrderTimeDriverCard extends StatelessWidget {
  final DateTime orderDate;
  final String driverName;

  const DoneOrderTimeDriverCard ({
    super.key,
    required this.orderDate,
    required this.driverName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        border: Border.all(color: AppColors.darkGray, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waktu Pesan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Waktu Pesan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              Text(DateFormat('d MMM y, HH:mm').format(orderDate),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: AppFonts.fontMedium,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Pengemudi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pengemudi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              Text(driverName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: AppFonts.fontMedium,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Class to display restaurant name and receiver address in a card format
class DoneOrderAddressCard extends StatelessWidget {
  final String businessName;
  final String addressReceiver;

  const DoneOrderAddressCard({
    super.key,
    required this.businessName,
    required this.addressReceiver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        border: Border.all(color: AppColors.darkGray, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.restaurant, size: 25, color: AppColors.dark),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Restoran',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: AppFonts.fontMedium,
                      color: AppColors.dark,
                    ),
                  ),
                  Text(businessName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: AppFonts.fontBold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Receiver Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 25, color: AppColors.dark),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alamat Penerima',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: AppFonts.fontMedium,
                      color: AppColors.dark,
                    ),
                  ),
                  Text(addressReceiver,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: AppFonts.fontBold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Class to display order details in a card format
class DoneOrderDetailsCard extends StatelessWidget {
  final List<dynamic> orderList;
  final int serviceFee;
  final int deliveryFee;
  final int totalPrice;
  final String paymentMethod;

  const DoneOrderDetailsCard({
    super.key,
    required this.orderList,
    required this.serviceFee,
    required this.deliveryFee,
    required this.totalPrice,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        border: Border.all(color: AppColors.darkGray, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detail Pesanan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: AppFonts.fontBold,
              color: AppColors.dark,
            ),
          ),

          const Divider(),
          
          ...orderList.map<Widget>((item) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: item != orderList.last ? 8.0 : 0.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${item['qty_product']}x ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: AppFonts.fontBold,
                      color: AppColors.dark,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['product_name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: AppFonts.fontBold,
                            color: AppColors.dark,
                          ),
                        ),
                        if (item['notes'] != null && item['notes'].toString().isNotEmpty)
                          Text('Note: ${item['notes']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: AppFonts.fontMedium,
                              color: AppColors.dark,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(formatCurrency(item['product_price'] * item['qty_product']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: AppFonts.fontBold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Harga pelayanan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              Text(
                formatCurrency(serviceFee),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),

          // Delivery Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Harga pengiriman",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              Text(
                deliveryFee == 0 ? "Gratis" : formatCurrency(deliveryFee),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),

          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Harga",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              Text(formatCurrency(totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),  
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Metode bayar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              Text(paymentMethod,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GiveRatingBottomNavbar extends StatelessWidget {
  final String businessType;
  final List<Map<String, dynamic>> ratings;
  final VoidCallback onDriverPressed;
  final VoidCallback onBusinessPressed;

  const GiveRatingBottomNavbar({
    super.key,
    required this.businessType,
    required this.ratings,
    required this.onDriverPressed,
    required this.onBusinessPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasDriverRating = ratings.any((r) => r['rating_type'] == 'driver');
    final hasBusinessRating = ratings.any((r) => r['rating_type'] == businessType.toLowerCase());

    // Don't show anything if both ratings exist
    if (hasDriverRating && hasBusinessRating) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Yuk berikan penilaian!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.fontBold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!hasDriverRating)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.woodland,
                    foregroundColor: AppColors.soapstone,
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onDriverPressed,
                  child: const Text(
                    "Pengemudi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.fontBold,
                      color: AppColors.soapstone,
                    ),
                  ),
                ),
              if (!hasBusinessRating)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.woodland,
                    foregroundColor: AppColors.soapstone,
                    padding: EdgeInsets.symmetric(
                      horizontal: businessType == 'restaurant' ? 40.0 : 22.0,
                    ),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onBusinessPressed,
                  child: Text(
                    businessType == 'restaurant' ? "Restoran" : "Pusat Belanja",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.fontBold,
                      color: AppColors.soapstone,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class RatingBox extends StatelessWidget {
  final int historyId;
  final String businessName;
  final List<Map<String, dynamic>> ratings;

  const RatingBox({
    super.key,
    required this.historyId,
    required this.businessName,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) return const SizedBox.shrink();

    print("ratings: $ratings");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ratings.map((rating) {
        final ratingType = rating['rating_type'];
        final ratingNumber = rating['rating_number'];
        final ratingComment = rating['rating_comment'];
        final ratingDate = rating['rating_date'] as DateTime;
        final imagePaths = rating['rating_images'] as List<String>?;
        print("imagePaths: $imagePaths");

        final ratingTitle = ratingType == 'driver'
            ? 'Rating untuk Pengemudi'
            : 'Rating untuk ${ratingType == 'restaurant' ? 'Restoran' : 'Pusat Belanja'}';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.ecruWhite,
            border: Border.all(color: AppColors.darkGray, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ratingTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: FaIcon(
                      index < ratingNumber
                          ? FontAwesomeIcons.solidStar
                          : FontAwesomeIcons.star,
                      color: AppColors.dark,
                      size: 16,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                ratingComment,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
              if (imagePaths != null && imagePaths.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: imagePaths.map((path) {
                    final isFileImage = !path.startsWith('assets/');
                    return GestureDetector(
                      onTap: () {
                        String senderLabel;
                        if (ratingType == 'driver') {
                          senderLabel = 'Pengemudi';
                        } else if (ratingType == 'restaurant') {
                          senderLabel = 'Restoran';
                        } else {
                          senderLabel = 'Pusat Belanja';
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImageView(
                              imagePath: path,
                              senderName: 'Rating $senderLabel - $businessName',
                              sendTime:
                                  '${formatDate(ratingDate)} ${ratingDate.hour.toString().padLeft(2, '0')}:${ratingDate.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isFileImage
                            ? Image.file(
                                File(path),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 60,
                                  height: 60,
                                  color: AppColors.lightGray,
                                  child: const Icon(Icons.broken_image),
                                ),
                              )
                            : Image.asset(
                                path,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 60,
                                  height: 60,
                                  color: AppColors.lightGray,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                '${formatDate(ratingDate)} ${ratingDate.hour.toString().padLeft(2, '0')}:${ratingDate.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}