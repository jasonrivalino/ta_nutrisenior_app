import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

import '../../../shared/widgets/appbar.dart';
import '../history_list_data.dart';
import 'done_history_details_widget.dart';

class DoneHistoryDetailsView extends StatelessWidget {
  final int id;

  const DoneHistoryDetailsView({
    super.key,
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    final order = doneHistoryList.firstWhere(
      (item) => item['id'] == id,
      orElse: () => {},
    );

    // Now safe to access order fields
    int totalOrderPrice = order['orderList']
        .fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));
    num totalPrice = totalOrderPrice + order['serviceFee'] + order['deliveryFee'];

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
            // Waktu & Pengemudi
            DoneOrderTimeDriverCard(
              orderDate: order['orderDate'],
              driverName: order['driverName'],
            ),

            const SizedBox(height: 16),

            // Nama Restoran & Alamat
            DoneOrderAddressCard(
              businessName: order['businessName'],
              addressReceiver: order['addressReceiver'],
            ),

            const SizedBox(height: 16),

            // Detail Pesanan
            DoneOrderDetailsCard(
              orderList: order['orderList'],
              serviceFee: order['serviceFee'],
              deliveryFee: order['deliveryFee'],
              totalPrice: totalPrice.toInt(),
              paymentMethod: order['paymentMethod'],
            ),
          ],
        ),
      ),
      bottomNavigationBar: GiveRatingBottomNavbar(
        businessType: order['businessType'],
        onDriverPressed: () {
          context.push('/history/done/details/:id/rating', extra: {
            'id': order['id'],
            'driverName': order['driverName'],
          });
        },
        onRestaurantPressed: () {
          context.push('/history/done/details/:id/rating', extra: {
            'id': order['id'],
            'businessName': order['businessName'],
            'businessType': order['businessType'],
            'businessImage': order['businessImage'],
          });
        },
      ),
    );
  }
}
