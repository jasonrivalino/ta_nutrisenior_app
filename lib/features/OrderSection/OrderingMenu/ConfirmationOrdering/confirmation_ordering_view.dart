import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/widgets/appbar.dart';
import '../business_ordering_menu_widget.dart';
import 'confirmation_ordering_widget.dart';

class OrderConfirmationView extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final int serviceFee;
  final int totalPrice;

  const OrderConfirmationView({
    super.key,
    required this.selectedProducts,
    required this.serviceFee,
    required this.totalPrice,
  });

  static OrderConfirmationView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    return OrderConfirmationView(
      selectedProducts: extra['selected_products'] as List<Map<String, dynamic>>,
      serviceFee: extra['service_fee'] as int,
      totalPrice: extra['total_price'] as int,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fixed delivery fee
    const deliveryFee = 2000;

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(
        title: "Konfirmasi Pesanan",
        showBackButton: true,
      ),
      body: ListView(
        children: [
          // Lokasi Penerima
          RecipientLocationBox(
            onAddressClick: () {},
            onNotesClick: () {},
          ),
          const SizedBox(height: 8),

          // Detail Pesanan
          OrderDetailListBox(
            selectedProducts: selectedProducts,
            serviceFee: serviceFee,
            deliveryFee: deliveryFee,
            onAddMorePressed: () => context.pop(),
          ),
          const SizedBox(height: 8),

          // Metode Pembayaran
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Lihat Semua", style: TextStyle(color: AppColors.berylGreen)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.payments_outlined),
                    const SizedBox(width: 8),
                    const Text("Pembayaran Tunai"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navbar
      bottomNavigationBar: OrderBottomNavbar(
        totalPrice: totalPrice + serviceFee + deliveryFee,
        buttonText: "Lakukan Pemesanan",
        onOrderPressed: () {
          // Final confirmation logic here
        },
      ),
    );
  }
}