import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

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
    this.etaText = "Tiba dalam 30-40 min",
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
                    etaText,
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
  const OrderStatusDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Text(
                "BELANJAAN SEDANG DIKEMAS",
                style: TextStyle(
                  color: AppColors.woodland,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppFonts.fontBold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                "Pengemudi sedang menyiapkan belanjaan Anda di supermarket...",
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

            // Tampilkan semua item tanpa scroll
            if (orderList != null && orderList!.isNotEmpty)
              ...orderList!.map((item) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatCurrency(item['price'] ?? 0)),
                            if ((item['notes'] as String?)?.isNotEmpty ?? false)
                              Text("Catatan: ${item['notes']}"),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.soapstone,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.dark),
                          ),
                          child: Text("${item['quantity']} pcs"),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.dark),
                  ],
                );
              }),

            // Harga-harga
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                children: [
                  _priceRow("Harga pelayanan", formatCurrency(serviceFee!)),
                  _priceRow("Harga ongkir", formatCurrency(deliveryFee!)),
                ],
              ),
            ),
            const Divider(color: AppColors.dark),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              child: Column(
                children: [
                  _priceRow("Total harga", formatCurrency(totalPrice!), freeIfZero: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String amount, {bool freeIfZero = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            (amount == 'Rp0' && freeIfZero) ? 'Gratis' : amount,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}