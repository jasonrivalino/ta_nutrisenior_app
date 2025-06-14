import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/widgets/appbar.dart';
import 'detail_ordering_widget.dart';

class DetailOrderingView extends StatefulWidget {
  final int businessId;
  final String businessType;
  final int productId;
  final String productImage;
  final String productName;
  final int productPrice;
  final String productDescription;
  final int qtyProduct;
  final String? notes;

  const DetailOrderingView({
    super.key,
    required this.businessId,
    required this.businessType,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.qtyProduct,
    this.notes,
  });

  factory DetailOrderingView.fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;
    return DetailOrderingView(
      businessId: extra['business_id'] as int,
      businessType: extra['business_type'] as String,
      productId: extra['product_id'] as int,
      productImage: extra['product_image'] as String,
      productName: extra['product_name'] as String,
      productPrice: extra['product_price'] as int,
      productDescription: extra['product_description'] as String,
      qtyProduct: extra['qty_product'] as int,
      notes: extra['notes'] as String?,
    );
  }

  @override
  State<DetailOrderingView> createState() => _DetailOrderingViewState();
}

class _DetailOrderingViewState extends State<DetailOrderingView> {
  late int quantity;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    quantity = widget.qtyProduct;
    _noteController = TextEditingController(text: widget.notes ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(
        title: widget.businessType == 'restaurant' ? 'Pesan Makanan' : 'Pesan Belanjaan',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Image.asset(
            widget.productImage,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProductDetailInfoBox(
                    productName: widget.productName,
                    productPrice: widget.productPrice,
                    productDescription: widget.productDescription,
                  ),
                  ProductNoteInputBox(
                    businessType: widget.businessType,
                    noteController: _noteController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SetQuantityBottomNavbar(
        businessType: widget.businessType,
        quantity: quantity,
        onQuantityChanged: (newQty) {
          setState(() => quantity = newQty);
        },
        onAddPressed: () {
          final notes = _noteController.text;

          context.pop({
            'product_id': widget.productId,
            'qty_product': quantity,
            'notes': notes,
          });
        },
      ),
    );
  }
}