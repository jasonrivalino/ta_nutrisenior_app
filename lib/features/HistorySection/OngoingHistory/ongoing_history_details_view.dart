import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/features/HistorySection/OngoingHistory/ongoing_history_details_widget.dart';
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
  final String estimatedArrival;
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
    required this.estimatedArrival,
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
      estimatedArrival: extra['estimatedArrival'] ?? '',
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
    double topPositionProcessing, topPositionDelivering;

    final screenHeight = MediaQuery.of(context).size.height;

    if (orderCount == 1) {
      topPositionProcessing = screenHeight > 900 ? 300 : 190;
    } else if (orderCount == 2) {
      topPositionProcessing = screenHeight > 900 ? 220 : 115;
    } else {
      topPositionProcessing = screenHeight > 900 ? 140 : 80;
    }

    topPositionDelivering = screenHeight > 900 ? 535 : 435;

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
                top: cardType == 'diproses' ? topPositionProcessing : topPositionDelivering,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height -
                  (cardType == 'diproses' ? topPositionProcessing : topPositionDelivering),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: cardType == 'diproses'
                      ? [
                          SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: OrderStatusDetails(businessType: businessType, cardType: cardType),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(bottom: screenHeight > 900 ? 205 : 185),
                              child: OrderListDetails(
                                orderList: orderList,
                                serviceFee: serviceFee,
                                deliveryFee: deliveryFee,
                                totalPrice: totalPrice,
                              ),
                            ),
                          ),
                        ]
                      : [
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: OrderStatusDetails(businessType: businessType, cardType: cardType),
                          ),
                          const SizedBox(height: 18),
                          DeliverDriverCard(
                            driverName: driverName,
                            driverRate: 4.5,
                          ),
                          const SizedBox(height: 20),
                        ],
                  ),
                ),
              ),

              // Floating EstimatedTimeCard
              EstimatedTimeCard(
                businessName: businessName,
                businessImage: businessImage,
                etaText: estimatedArrival,
                topPosition: (cardType == 'diproses' ? topPositionProcessing : topPositionDelivering) - 40,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: cardType == 'diproses'
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: AppColors.soapstone,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: WarningButton(
              warningText: "Batalkan Pemesanan",
              onPressed: () {
                // Handle cancel order action
              },
            ),
          )
        : null,
    );
  }
}