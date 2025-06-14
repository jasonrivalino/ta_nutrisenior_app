import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

import '../../../shared/widgets/appbar.dart';
import 'done_history_details_widget.dart';
import 'done_history_rating_controller.dart';

class DoneHistoryDetailsView extends StatelessWidget {
  final int historyId;
  final int businessId;
  final DateTime orderDate;
  final String driverName;
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
    required this.driverName,
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
      historyId: extra['history_id'],
      businessId: extra['business_id'],
      orderDate: extra['order_date'],
      businessName: extra['business_name'],
      businessImage: extra['business_image'],
      businessType: extra['business_type'],
      driverName: extra['driver_name'],
      addressReceiver: extra['address_receiver'],
      orderList: extra['order_list'],
      serviceFee: extra['service_fee'],
      deliveryFee: extra['delivery_fee'],
      totalPrice: extra['total_price'],
      paymentMethod: extra['payment_method'],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan yang sudah terurut dari controller
    final ratings = HistoryRatingController.fetchOrderedRatings(historyId);

    final hasDriverRating = ratings.any((r) => r['rating_type'] == 'driver');
    final hasBusinessRating = ratings.any((r) => r['rating_type'] == businessType.toLowerCase());

    final showBottomNavbar = !(hasDriverRating && hasBusinessRating);

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(
        title: 'Detail Pembelian',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoneOrderTimeDriverCard(
              orderDate: orderDate,
              driverName: driverName,
            ),
            const SizedBox(height: 16),
            DoneOrderAddressCard(
              businessName: businessName,
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
            RatingBox(
              historyId: historyId,
              businessName: businessName,
              ratings: ratings,
            ),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNavbar
        ? GiveRatingBottomNavbar(
            businessType: businessType,
            ratings: ratings,
            onDriverPressed: () {
              context.push('/history/done/details/:id/rating', extra: {
                'history_id': historyId,
                'business_id': businessId,
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
          )
        : null,
    );
  }
}