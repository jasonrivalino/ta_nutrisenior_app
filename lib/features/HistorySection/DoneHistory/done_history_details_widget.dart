import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';
import '../../../shared/utils/format_currency.dart';
import '../../../shared/utils/formatted_time.dart';
import '../../../shared/utils/fullscreen_image_view.dart';
import '../../../shared/widgets/elevated_button.dart';

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
              Text(
                "Waktu Pesan",
                style: AppTextStyles.textBold(
                  size: 18,
                  color: AppColors.dark,
                ),
              ),
              Text(
                DateFormat('d MMM y, HH:mm').format(orderDate),
                style: AppTextStyles.textMedium(
                  size: 16,
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
              Text(
                "Pengemudi",
                style: AppTextStyles.textBold(
                  size: 18,
                  color: AppColors.dark,
                ),
              ),
              Text(
                driverName,
                style: AppTextStyles.textMedium(
                  size: 16,
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
                style: AppTextStyles.textMedium(
                  size: 14,
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
                  Text(
                    'Nama Restoran',
                    style: AppTextStyles.textMedium(
                      size: 14,
                      color: AppColors.dark,
                    ),
                  ),
                  Text(businessName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textBold(
                      size: 18,
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
                  Text(
                    'Alamat Penerima',
                    style: AppTextStyles.textMedium(
                      size: 14,
                      color: AppColors.dark,
                    ),
                  ),
                  Text(addressReceiver,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textBold(
                      size: 18,
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
          Text('Detail Pesanan',
            style: AppTextStyles.textBold(
              size: 18,
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
                          style: AppTextStyles.textBold(
                            size: 16,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            item['product_name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.textBold(
                              size: 16,
                              color: AppColors.dark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatCurrency(item['product_price'] * item['qty_product']),
                          style: AppTextStyles.textBold(
                            size: 16,
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
                              Text('+',
                                style: AppTextStyles.textMedium(
                                  size: 14,
                                  color: AppColors.dark,
                                ),
                              ),
                              const SizedBox(width: 34),
                              Expanded(
                                child: Text(
                                  addOn['add_ons_name'],
                                  style: AppTextStyles.textMedium(
                                    size: 14,
                                    color: AppColors.dark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(formatCurrency(addOn['total_price']),
                                style: AppTextStyles.textBold(
                                  size: 14,
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
                          Text(
                            'Note:',
                            style: AppTextStyles.textRegular(
                              size: 14,
                              color: AppColors.dark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['notes'],
                              style: AppTextStyles.textRegular(
                                size: 14,
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
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.dark,
                ),
              ),
              Text(
                formatCurrency(serviceFee),
                style: AppTextStyles.textBold(
                  size: 16,
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
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.dark,
                ),
              ),
              Text(
                deliveryFee == 0 ? "Gratis" : formatCurrency(deliveryFee),
                style: AppTextStyles.textBold(
                  size: 16,
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
                style: AppTextStyles.textBold(
                  size: 18,
                  color: AppColors.dark,
                ),
              ),
              Text(formatCurrency(totalPrice),
                style: AppTextStyles.textBold(
                  size: 18,
                  color: AppColors.dark,
                ),
              ),  
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Metode bayar",
                style: AppTextStyles.textBold(
                  size: 18,
                  color: AppColors.dark,
                ),
              ),
              Text(paymentMethod,
                style: AppTextStyles.textBold(
                  size: 18,
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

class FeedbackInformationBox extends StatelessWidget {
  final int historyId;
  final String businessName;
  final String? businessType;
  final List<Map<String, dynamic>> ratings;
  final Map<String, dynamic>? driverReport;
  final Map<String, dynamic>? businessReport;

  const FeedbackInformationBox({
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

    final driverRatings =
        ratings.where((r) => r['rating_type'] == 'driver').toList();
    final businessRatings =
        ratings.where((r) => r['rating_type'] != 'driver').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === DRIVER REPORT ===
        if (driverReport != null)
          _buildReportBox(
            context: context,
            title: 'Pengemudi telah dilaporkan',
            reason: driverReport?['report_reason'] ?? '-',
            description: driverReport?['report_description'] ?? '-',
            reportImages:
                (driverReport?['report_images'] as List<String>? ?? []),
          ),

        // === DRIVER RATINGS ===
        ...driverRatings.map((rating) => _buildRatingBox(
              context,
              rating,
              'Pengemudi',
              businessName,
            )),

        // === BUSINESS REPORT ===
        if (businessReport != null)
          _buildReportBox(
            context: context,
            title: businessType == 'restaurant'
                ? 'Restoran telah dilaporkan'
                : 'Pusat Belanja telah dilaporkan',
            reason: businessReport?['report_reason'] ?? '-',
            description: businessReport?['report_description'] ?? '-',
            reportImages:
                (businessReport?['report_images'] as List<String>? ?? []),
          ),

        // === BUSINESS RATINGS ===
        ...businessRatings.map((rating) => _buildRatingBox(
              context,
              rating,
              businessType == 'restaurant' ? 'Restoran' : 'Pusat Belanja',
              businessName,
            )),
      ],
    );
  }

  Widget _buildReportBox({
    required BuildContext context,
    required String title,
    required String reason,
    required String description,
    List<String> reportImages = const [],
  }) {
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
            style: AppTextStyles.textBold(
              size: 18,
              color: AppColors.persianRed,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Alasan: $reason',
            style: AppTextStyles.textBold(
              size: 14,
              color: AppColors.persianRed,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTextStyles.textMedium(
              size: 14,
              color: AppColors.persianRed,
            ),
          ),
          if (reportImages.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: reportImages.map((path) {
                final isFileImage = !path.startsWith('assets/');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageView(
                          imagePath: path,
                          senderName: 'Gambar Laporan',
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
    final ratingNumber = rating['rating_number'] ?? 0;
    final ratingComment = rating['rating_comment'] ?? '-';
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
            style: AppTextStyles.textBold(
              size: 16,
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
            style: AppTextStyles.textBold(
              size: 14,
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
                          sendTime: formatFullDateTime(ratingDate),
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
            style: AppTextStyles.textMedium(
              size: 13,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}

class GiveFeedbackBottomNavbar extends StatelessWidget {
  final String businessType;
  final List<Map<String, dynamic>> ratings;
  final VoidCallback onDriverPressed;
  final VoidCallback onBusinessPressed;
  final Map<String, dynamic>? driverReport;
  final Map<String, dynamic>? businessReport;

  const GiveFeedbackBottomNavbar({
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
          Text(
            "Yuk berikan penilaian!",
            style: AppTextStyles.textBold(
              size: 18,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (shouldShowDriverButton)
                ElevatedButtonWidget(
                  onPressed: onDriverPressed,
                  backgroundColor: AppColors.woodland,
                  foregroundColor: AppColors.soapstone,
                  textStyle: AppTextStyles.textBold(size: 16, color: AppColors.soapstone),
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  minimumSize: const Size(0, 40),
                  borderRadius: 20,
                  elevation: 0,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text("Pengemudi",
                    style: AppTextStyles.textBold(
                      size: 16,
                      color: AppColors.soapstone,
                    ),
                  ),
                ),
              if (shouldShowBusinessButton)
                ElevatedButtonWidget(
                  onPressed: onBusinessPressed,
                  backgroundColor: AppColors.woodland,
                  foregroundColor: AppColors.soapstone,
                  textStyle: AppTextStyles.textBold(size: 16, color: AppColors.soapstone),
                  padding: EdgeInsets.symmetric(
                    horizontal: businessType == 'restaurant' ? 40.0 : 22.0,
                  ),
                  minimumSize: const Size(0, 40),
                  borderRadius: 20,
                  elevation: 0,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text(
                    businessType == 'restaurant' ? "Restoran" : "Pusat Belanja",
                    style: AppTextStyles.textBold(
                      size: 16,
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