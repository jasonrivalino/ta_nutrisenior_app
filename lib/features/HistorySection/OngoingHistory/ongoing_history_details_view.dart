import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/features/HistorySection/OngoingHistory/ongoing_history_details_widget.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
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
    // Determine top position based on orderList length
    int orderCount = orderList?.length ?? 0;
    double topPosition;

    if (orderCount == 1) {
      topPosition = 325;
    } else if (orderCount == 2) {
      topPosition = 240;
    } else {
      topPosition = 150;
    }

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
              // Fixed Status Section
              Positioned(
                top: topPosition,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height - topPosition,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: OrderStatusDetails(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 200),
                          child: OrderListDetails(
                            orderList: orderList,
                            serviceFee: serviceFee,
                            deliveryFee: deliveryFee,
                            totalPrice: totalPrice,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating EstimatedTimeCard
              EstimatedTimeCard(
                businessName: businessName,
                businessImage: businessImage,
                topPosition: topPosition - 40,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
        child: WarningButton(
          warningText: "Batalkan Pemesanan",
          onPressed: () {
            // Handle cancel order action
          },
        ),
      ),
    );
  }
}