import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/appbar.dart';
import '../../../shared/styles/colors.dart';

import 'done_history_details_widget.dart';
import 'done_history_rating_controller.dart';

class DoneHistoryDetailsView extends StatelessWidget {
  final int historyId;
  final int businessId;
  final DateTime orderDate;
  final int driverId;
  final String driverName;
  final String? driverNote;
  final String businessName;
  final String businessImage;
  final String businessType;
  final String addressReceiver;
  final List<dynamic> orderList;
  final int serviceFee;
  final int deliveryFee;
  final num totalPrice;
  final String paymentMethod;

  const DoneHistoryDetailsView({
    super.key,
    required this.historyId,
    required this.businessId,
    required this.totalPrice,
    required this.orderDate,
    required this.driverId,
    required this.driverName,
    this.driverNote,
    required this.businessName,
    required this.businessImage,
    required this.businessType,
    required this.addressReceiver,
    required this.orderList,
    required this.serviceFee,
    required this.deliveryFee,
    required this.paymentMethod,
  });

  static DoneHistoryDetailsView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra! as Map<String, dynamic>;
    return DoneHistoryDetailsView(
      historyId: extra['history_id'] as int,
      businessId: extra['business_id'] as int,
      orderDate: extra['order_date'] as DateTime,
      businessName: extra['business_name'] as String,
      businessImage: extra['business_image'] as String,
      businessType: extra['business_type'] as String,
      driverId: extra['driver_id'] as int,
      driverName: extra['driver_name'] as String,
      driverNote: extra['driver_note'] as String?,
      addressReceiver: extra['address_receiver'] as String,
      orderList: extra['order_list'] as List<dynamic>,
      serviceFee: extra['service_fee'] as int,
      deliveryFee: extra['delivery_fee'] as int,
      totalPrice: extra['total_price'] as num,
      paymentMethod: extra['payment_method'] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan yang sudah terurut dari controller
    final ratings = HistoryRatingController.fetchOrderedRatings(historyId);

    final driverReport = HistoryReportController.getDriverReport(driverId);
    final businessReport = HistoryReportController.getBusinessReport(businessId);

    final hasDriverRating = ratings.any((r) => r['rating_type'] == 'driver');
    final hasBusinessRating = ratings.any((r) => r['rating_type'] == businessType.toLowerCase());

    final showBottomNavbar = !(hasDriverRating && hasBusinessRating);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        context.go('/historyDone');
      },
      child: Scaffold(
        backgroundColor: AppColors.soapstone,
        appBar: CustomAppBar(
          title: 'Detail Pembelian',
          showBackButton: true,
          onBack: () => context.go('/historyDone'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoneOrderTimeDriverCard(
                orderDate: orderDate,
                driverName: driverName,
                driverNote: driverNote,
              ),
              const SizedBox(height: 16),
              DoneOrderAddressCard(
                businessName: businessName,
                businessType: businessType,
                addressReceiver: addressReceiver,
              ),
              const SizedBox(height: 16),
              DoneOrderDetailsCard(
                orderList: orderList,
                serviceFee: serviceFee,
                deliveryFee: deliveryFee,
                totalPrice: totalPrice.toInt(),
                paymentMethod: paymentMethod,
              ),
              const SizedBox(height: 16),
              FeedbackInformationBox(
                historyId: historyId,
                businessName: businessName,
                businessType: businessType,
                ratings: ratings,
                driverReport: driverReport,
                businessReport: businessReport,
              ),
            ],
          ),
        ),
        bottomNavigationBar: showBottomNavbar
            ? SafeArea(
                child: GiveFeedbackBottomNavbar(
                  businessType: businessType,
                  ratings: ratings,
                  driverReport: driverReport,
                  businessReport: businessReport,
                  onDriverPressed: () {
                    context.push('/history/done/details/:id/rating', extra: {
                      'history_id': historyId,
                      'business_id': businessId,
                      'driver_id': driverId,
                      'driver_name': driverName,
                    });
                  },
                  onBusinessPressed: () {
                    context.push('/history/done/details/:id/rating', extra: {
                      'history_id': historyId,
                      'business_id': businessId,
                      'business_name': businessName,
                      'business_type': businessType,
                      'business_image': businessImage,
                    });
                  },
                ),
              )
            : null,
      ),
    );
  }
}