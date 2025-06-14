import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/utils/calculate_delivery_fee.dart';
import '../../../../shared/widgets/appbar.dart';
import '../business_ordering_menu_widget.dart';
import 'confirmation_ordering_widget.dart';

class OrderConfirmationView extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final int serviceFee;
  final int businessId;
  final String businessType;
  final double businessDistance;
  final bool isFreeShipment;
  final int totalPrice;

  const OrderConfirmationView({
    super.key,
    required this.selectedProducts,
    required this.businessId,
    required this.businessType,
    required this.businessDistance,
    required this.isFreeShipment,
    required this.serviceFee,
    required this.totalPrice,
  });

  static OrderConfirmationView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    return OrderConfirmationView(
      selectedProducts: extra['selected_products'] as List<Map<String, dynamic>>,
      businessId: extra['business_id'] as int,
      businessType: extra['business_type'] as String,
      businessDistance: extra['business_distance'] as double,
      isFreeShipment: extra['is_free_shipment'] as bool,
      serviceFee: extra['service_fee'] as int,
      totalPrice: extra['total_price'] as int,
    );
  }

  @override
  State<OrderConfirmationView> createState() => _OrderConfirmationViewState();
}

class _OrderConfirmationViewState extends State<OrderConfirmationView> {
  late List<Map<String, dynamic>> _selectedProducts;

  @override
  void initState() {
    super.initState();
    _selectedProducts = List<Map<String, dynamic>>.from(widget.selectedProducts);
  }

  int _calculateUpdatedTotalPrice() {
    int productTotal = _selectedProducts.fold(
      0,
      (sum, product) => sum + (product['product_price'] as int) * (product['qty_product'] as int),
    );
    final int deliveryFee = calculateDeliveryFee(widget.isFreeShipment, widget.businessDistance);
    return productTotal + widget.serviceFee + deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    final int deliveryFee = calculateDeliveryFee(widget.isFreeShipment, widget.businessDistance);

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(
        title: "Konfirmasi Pesanan",
        showBackButton: true,
        customParam: _selectedProducts,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipientLocationBox(
              onAddressClick: () {},
              onNotesClick: () {},
            ),
            const SizedBox(height: 8),

            OrderDetailListBox(
              selectedProducts: _selectedProducts,
              serviceFee: widget.serviceFee,
              deliveryFee: deliveryFee,
              businessId: widget.businessId,
              businessType: widget.businessType,
              onCountChanged: (productId, newQty) {
                setState(() {
                  _selectedProducts.removeWhere((p) {
                    final matches = p['product_id'].toString() == productId;
                    if (matches && newQty == 0) return true;
                    if (matches) p['qty_product'] = newQty;
                    return false;
                  });
                });
              },
              onNotesChanged: (productId, notes) {
                setState(() {
                  final index = _selectedProducts.indexWhere((p) => p['product_id'].toString() == productId);
                  if (index != -1) {
                    _selectedProducts[index]['notes'] = notes;
                  }
                });
              },
            ),
            const SizedBox(height: 8),

            AddMoreOrderButtonBox(
              onAddMorePressed: () {
                context.pop(_selectedProducts);
              },
            ),
            const SizedBox(height: 8),

            const PaymentMethodBox(),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: OrderBottomNavbar(
        totalPrice: _calculateUpdatedTotalPrice(),
        buttonText: "Lakukan Pemesanan",
        onOrderPressed: () {
          // Implement confirmation logic
        },
      ),
    );
  }
}