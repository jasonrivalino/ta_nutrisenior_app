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
  final String? driverNote;

  const DoneOrderTimeDriverCard({
    super.key,
    required this.orderDate,
    required this.driverName,
    this.driverNote,
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
              Text(
                DateFormat('d MMM y, HH:mm').format(orderDate),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                driverName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: AppFonts.fontMedium,
                  color: AppColors.dark,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          if (driverNote != null && driverNote!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                "Note: $driverNote",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: AppFonts.fontMedium,
                  color: AppColors.dark,
                ),
                textAlign: TextAlign.left,
              ),
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
            final addOns = (item['add_ons_details'] as List?) ?? [];

            return Padding(
              padding: EdgeInsets.only(
                bottom: item != orderList.last ? 8.0 : 2.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${item['qty_product']}x ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: AppFonts.fontBold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            item['product_name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: AppFonts.fontBold,
                              color: AppColors.dark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatCurrency(item['product_price'] * item['qty_product']),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: AppFonts.fontBold,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add-ons shown per row
                  if (addOns.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 11, top: 2, bottom: 4),
                      child: Column(
                        children: addOns.map<Widget>((addOn) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('+',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: AppFonts.fontMedium,
                                  color: AppColors.dark,
                                ),
                              ),
                              const SizedBox(width: 34),
                              Expanded(
                                child: Text(
                                  addOn['add_ons_name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontFamily: AppFonts.fontMedium,
                                    color: AppColors.dark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(formatCurrency(addOn['total_price']),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: AppFonts.fontBold,
                                  color: AppColors.dark,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                  if (item['notes'] != null && item['notes'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Note:',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppFonts.fontMedium,
                              color: AppColors.dark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['notes'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.fontMedium,
                                color: AppColors.dark,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
  final Map<String, dynamic>? driverReport;
  final Map<String, dynamic>? businessReport;

  const GiveRatingBottomNavbar({
    super.key,
    required this.businessType,
    required this.ratings,
    required this.onDriverPressed,
    required this.onBusinessPressed,
    this.driverReport,
    this.businessReport,
  });

  @override
  Widget build(BuildContext context) {
    final hasDriverRating = ratings.any((r) => r['rating_type'] == 'driver');
    final hasBusinessRating = ratings.any((r) => r['rating_type'] == businessType.toLowerCase());

    final shouldShowDriverButton = !hasDriverRating && driverReport == null;
    final shouldShowBusinessButton = !hasBusinessRating && businessReport == null;

    // Hide bottom bar completely if both buttons shouldn't show
    if (!shouldShowDriverButton && !shouldShowBusinessButton) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withAlpha(38),
            blurRadius: 10,
            offset: const Offset(0, -2),
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
              if (shouldShowDriverButton)
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
              if (shouldShowBusinessButton)
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
  final String? businessType;
  final List<Map<String, dynamic>> ratings;
  final Map<String, dynamic>? driverReport;
  final Map<String, dynamic>? businessReport;

  const RatingBox({
    super.key,
    required this.historyId,
    required this.businessName,
    this.businessType,
    required this.ratings,
    this.driverReport,
    this.businessReport,
  });

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty && driverReport == null && businessReport == null) {
      return const SizedBox.shrink();
    }

    // Pisahkan rating berdasarkan tipe
    final driverRatings = ratings.where((r) => r['rating_type'] == 'driver').toList();
    final businessRatings = ratings.where((r) => r['rating_type'] != 'driver').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === DRIVER ===
        if (driverReport != null)
          _buildReportBox(
            title: 'Pengemudi telah dilaporkan',
            reason: driverReport!['report_reason'],
          ),
        ...driverRatings.map((rating) => _buildRatingBox(
              context,
              rating,
              'Pengemudi',
              businessName,
            )),

        // === BUSINESS ===
        if (businessReport != null)
          _buildReportBox(
            title:
                '${businessType == 'restaurant' ? 'Restoran' : 'Pusat Belanja'} telah dilaporkan',
            reason: businessReport!['report_reason'],
          ),
        ...businessRatings.map((rating) => _buildRatingBox(
              context,
              rating,
              businessType == 'restaurant' ? 'Restoran' : 'Pusat Belanja',
              businessName,
            )),
      ],
    );
  }

  Widget _buildReportBox({required String title, required String reason}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        border: Border.all(color: AppColors.persianRed, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.fontBold,
              color: AppColors.persianRed,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Alasan: $reason',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.fontBold,
              color: AppColors.persianRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBox(
    BuildContext context,
    Map<String, dynamic> rating,
    String label,
    String businessName,
  ) {
    final ratingNumber = rating['rating_number'];
    final ratingComment = rating['rating_comment'];
    final ratingDate = rating['rating_date'] as DateTime;
    final imagePaths = rating['rating_images'] as List<String>?;

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
            'Rating untuk $label',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageView(
                          imagePath: path,
                          senderName: 'Rating $label - $businessName',
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
  }
}