import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:ta_nutrisenior_app/shared/utils/format_currency.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';
import 'package:ta_nutrisenior_app/shared/widgets/warning_button.dart';

import '../../../shared/styles/colors.dart';

class OngoingHistoryDetailsView extends StatelessWidget {
  final int id;
  final String businessName;
  final String businessType;
  final String businessImage;
  final String? driverName;
  final String? addressReceiver;
  final List<Map<String, dynamic>>? orderList;
  final int? serviceFee;
  final int? deliveryFee;
  final int? totalPrice;
  final String cardType;

  const OngoingHistoryDetailsView({
    super.key,
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.businessImage,
    this.driverName,
    this.addressReceiver,
    this.orderList,
    this.serviceFee,
    this.deliveryFee,
    this.totalPrice,
    required this.cardType,
  });

  factory OngoingHistoryDetailsView.fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>? ?? {};

    debugPrint("orderList: ${extra['orderList']}");

    return OngoingHistoryDetailsView(
      id: extra['id'] ?? 0,
      businessName: extra['businessName'] ?? '',
      businessType: extra['businessType'] ?? '',
      businessImage: extra['businessImage'] ?? '',
      driverName: extra['driverName'] as String?,
      addressReceiver: extra['addressReceiver'] as String?,
      orderList: (extra['orderList'] is List)
        ? (extra['orderList'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => item)
            .toList()
        : [],      
      serviceFee: extra['serviceFee'] as int?,
      deliveryFee: extra['deliveryFee'] as int?,
      totalPrice: extra['totalPrice'] as int?,
      cardType: extra['cardType'] ?? 'diproses',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.woodland,
      appBar: CustomAppBar(
        title: "Detail Transaksi",
        showBackButton: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Scrollable content
              Positioned.fill(
                top: 100,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 60,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Column(
                                      children: const [
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
                                  const SizedBox(height: 24),

                                  // TODO: make it into single box class
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.ecruWhite,
                                      border: Border.all(color: AppColors.dark),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
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
                                        if (orderList != null && orderList!.isNotEmpty)
                                          ...orderList!.map((item) {
                                            return Column(
                                              children: [
                                                const Divider(color: AppColors.dark),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: ListTile(
                                                    tileColor: AppColors.ecruWhite,
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Text(
                                                      item['name'] ?? '',
                                                      style: TextStyle(
                                                        color: AppColors.dark,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        fontFamily: AppFonts.fontBold,
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          formatCurrency(item['price'] ?? 0),
                                                          style: TextStyle(
                                                            color: AppColors.dark,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            fontFamily: AppFonts.fontMedium,
                                                          ),
                                                        ),
                                                        if ((item['notes'] as String?)?.isNotEmpty ?? false)
                                                          Text(
                                                            "Catatan: ${item['notes']}",
                                                            style: TextStyle(
                                                              color: AppColors.dark,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14,
                                                              fontFamily: AppFonts.fontMedium,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    trailing: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.soapstone,
                                                        borderRadius: BorderRadius.circular(6),
                                                        border: Border.all(color: AppColors.dark, width: 1),
                                                      ),
                                                      child: Text(
                                                        "${item['quantity']} pcs",
                                                        style: TextStyle(
                                                          color: AppColors.dark,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          fontFamily: AppFonts.fontMedium,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        const Divider(color: AppColors.dark),
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
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                                  WarningButton(
                                    warningText: "Batalkan Pemesanan",
                                    onPressed: () {
                                      // Handle cancel order action
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating info card at top
              Positioned(
                left: 20,
                right: 20,
                top: 60,
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
                              color: Colors.black,
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
                            child: const Text(
                              "Tiba dalam 30-40 min",
                              style: TextStyle(
                                color: Colors.black,
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
              ),
            ],
          );
        },
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