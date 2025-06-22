import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/utils/format_currency.dart';

// Class for estimated time card
class EstimatedTimeCard extends StatelessWidget {
  final String businessName;
  final String businessImage;
  final String etaText;
  final double topPosition;

  const EstimatedTimeCard({
    super.key,
    required this.businessName,
    required this.businessImage,
    required this.etaText,
    required this.topPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.ecruWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.dark, width: 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(businessImage),
              radius: 30,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.soapstone,
                    border: Border.all(color: AppColors.dark, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Tiba dalam $etaText",
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: AppFonts.fontMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Class for order status details
class OrderStatusDetails extends StatelessWidget {
  final String businessType;
  final String status;

  const OrderStatusDetails({
    super.key,
    required this.businessType,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String title = "";
    String description = "";

    if (businessType == 'restaurant' && status == 'diproses') {
      title = "MAKANAN DALAM PROSES";
      description = "Dapur restoran sedang menyiapkan hidangan spesial Anda...";
    } else if (businessType == 'market' && status == 'diproses') {
      title = "BELANJAAN SEDANG DIKEMAS";
      description = "Pengemudi sedang menyiapkan belanjaan Anda di supermarket...";
    } else if (businessType == 'restaurant' && status == 'dikirim') {
      title = "MAKANAN DALAM PERJALANAN";
      description = "Waktunya siap-siap makan! Makanan sedang dalam perjalanan...";
    } else if (businessType == 'market' && status == 'dikirim') {
      title = "BELANJAAN DALAM PERJALANAN";
      description = "Waktunya siap-siap! Belanjaan Anda sedang dalam perjalanan...";
    } else {
      title = "STATUS PESANAN";
      description = "Mohon tunggu, kami sedang memproses pesanan Anda...";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.woodland,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: AppFonts.fontBold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: AppFonts.fontMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Class for order list details
class OrderListDetails extends StatelessWidget {
  final List<Map<String, dynamic>>? orderList;
  final int? serviceFee;
  final int? deliveryFee;
  final int? totalPrice;

  const OrderListDetails({
    super.key,
    required this.orderList,
    required this.serviceFee,
    required this.deliveryFee,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // Hapus height agar tinggi menyesuaikan konten
        decoration: BoxDecoration(
          color: AppColors.ecruWhite,
          border: Border.all(color: AppColors.dark),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Text(
                "Daftar Pesanan",
                style: TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                ),
              ),
            ),
            const Divider(color: AppColors.dark),

            if (orderList != null && orderList!.isNotEmpty)
              ...orderList!.map((item) {
                final addOns = item['add_ons'] as List<dynamic>? ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padded Row section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Qty Box
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.soapstone,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.dark),
                            ),
                            child: Text(
                              "${item['qty_product']} pcs",
                              style: TextStyle(
                                color: AppColors.dark,
                                fontFamily: AppFonts.fontMedium,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),

                          // Product Name + Add-ons
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['product_name'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.dark,
                                          fontFamily: AppFonts.fontBold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formatCurrency(item['product_price'] * item['qty_product']),
                                      style: TextStyle(
                                        color: AppColors.dark,
                                        fontFamily: AppFonts.fontBold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                // Add-ons List
                                if (addOns.isNotEmpty)
                                  ...addOns.map<Widget>((addOn) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2, left: 2),
                                      child: Row(
                                        children: [
                                          const Text(
                                            '+',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppFonts.fontMedium,
                                              color: AppColors.dark,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              addOn['add_ons_name'],
                                              style: const TextStyle(
                                                color: AppColors.dark,
                                                fontFamily: AppFonts.fontMedium,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            formatCurrency(addOn['total_price']),
                                            style: const TextStyle(
                                              color: AppColors.dark,
                                              fontFamily: AppFonts.fontMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notes (if any)
                    if ((item['notes'] as String?)?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(left: 19, right: 12, bottom: 4),
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
                            const SizedBox(width: 19),
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
                );
              }),
            
            const Divider(color: AppColors.dark),

            // Harga-harga
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Harga pelayanan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: AppFonts.fontBold,
                            color: AppColors.dark,
                          ),
                        ),
                        Text(formatCurrency(serviceFee!),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Harga pengiriman",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: AppFonts.fontBold,
                            color: AppColors.dark,
                          ),
                        ),
                        Text(
                          deliveryFee == 0 ? 'Gratis' : formatCurrency(deliveryFee!),
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
            ),
            const Divider(color: AppColors.dark),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Total Harga",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: AppFonts.fontBold,
                          color: AppColors.dark,
                        ),
                      ),
                      Text(formatCurrency(totalPrice!),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliverDriverCard extends StatelessWidget {
  final int? driverId;
  final String? driverName;
  final String? driverImage;
  final double? driverRate;
  final String? driverPhoneNumber;

  const DeliverDriverCard({
    super.key,
    this.driverId,
    this.driverName,
    this.driverImage,
    this.driverRate,
    this.driverPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dark, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              driverImage ?? 'assets/images/dummy/chat/driver.png',
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: AppFonts.fontBold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.soapstone,
                    border: Border.all(color: AppColors.dark),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.solidStar, size: 12, color: AppColors.dark),
                      const SizedBox(width: 4),
                      Text(
                        "$driverRate/5",
                        style: TextStyle(
                          color: AppColors.dark,
                          fontFamily: AppFonts.fontMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              Material(
                color: AppColors.woodland,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    context.push('/chatlist/detail/$driverId',
                    extra: {
                      'driver_id': driverId,
                      'driver_name': driverName,
                      'driver_image': driverImage,
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.message,
                      size: 20,
                      color: AppColors.soapstone,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.woodland,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    // Check permission
                    PermissionStatus status = await Permission.phone.request();

                    if (status.isGranted) {
                      final Uri callUri = Uri(scheme: 'tel', path: driverPhoneNumber);
                      if (await canLaunchUrl(callUri)) {
                        await launchUrl(callUri, mode: LaunchMode.externalApplication); // Or LaunchMode.platformDefault
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tidak dapat membuka aplikasi telepon')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Izin telepon ditolak')),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.phone,
                      size: 20,
                      color: AppColors.soapstone,
                    ),
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