import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/constants.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/utils/get_total_add_ons_price.dart';
import '../../../../shared/widgets/appbar.dart';

import 'detail_ordering_widget.dart';
import 'detail_ordering_controller.dart';

class DetailOrderingView extends StatefulWidget {
  final int businessId;
  final String businessType;
  final int? discountNumber;
  final int productId;
  final String productImage;
  final String productName;
  final int productPrice;
  final String productDescription;
  final int qtyProduct;
  final String? notes;
  final Map<String, List<int>>? selectedAddOnIdsMap;

  const DetailOrderingView({
    super.key,
    required this.businessId,
    required this.businessType,
    this.discountNumber,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.qtyProduct,
    this.notes,
    this.selectedAddOnIdsMap,
  });

  factory DetailOrderingView.fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    // Safely parse the map for selected add-ons
    final rawAddOnsMap = extra['add_ons'] as Map?;
    final selectedMap = rawAddOnsMap?.map(
      (key, value) => MapEntry(key.toString(), List<int>.from(value)),
    );

    return DetailOrderingView(
      businessId: extra['business_id'] as int,
      businessType: extra['business_type'] as String,
      discountNumber: extra['discount_number'] as int?,
      productId: extra['product_id'] as int,
      productImage: extra['product_image'] as String,
      productName: extra['product_name'] as String,
      productPrice: extra['product_price'] as int,
      productDescription: extra['product_description'] as String,
      qtyProduct: extra['qty_product'] as int,
      notes: extra['notes'] as String?,
      selectedAddOnIdsMap: selectedMap,
    );
  }

  @override
  State<DetailOrderingView> createState() => _DetailOrderingViewState();
}

class _DetailOrderingViewState extends State<DetailOrderingView> {
  late int quantity;
  late TextEditingController _noteController;

  List<Map<String, dynamic>> addOnsList = [];
  List<int> selectedAddOnIds = [];

  @override
  void initState() {
    super.initState();

    quantity = widget.qtyProduct == 0 ? 1 : widget.qtyProduct;
    _noteController = TextEditingController(text: widget.notes ?? '');

    // Use only the selected add-ons for this product
    selectedAddOnIds = widget.selectedAddOnIdsMap?[widget.productId.toString()] ?? [];

    // Fetch add-ons list specific for this product and business
    addOnsList = getAddOnsForProductController(
      productId: widget.productId,
      businessId: widget.businessId,
    );

    print('Selected Add-Ons for Product ${widget.productId}: $selectedAddOnIds');
    print('Generated Add-Ons List: $addOnsList');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAddOnsPrice = getTotalAddOnsPrice(
      addOns: addOnsList,
      selectedAddOnIds: selectedAddOnIds,
    );

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
            errorBuilder: (context, error, stackTrace) {
              final fallbackImage = widget.businessType == 'restaurant'
                  ? AppConstants.errorDummyFood
                  : AppConstants.errorDummyIngredient;
              return Image.asset(
                fallbackImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProductDetailInfoBox(
                    productName: widget.productName,
                    productPrice: widget.productPrice,
                    productDescription: widget.productDescription,
                    discountNumber: widget.discountNumber,
                  ),
                  if (addOnsList.isNotEmpty)
                    ProductAddOnsSelectionBox(
                      addOns: addOnsList,
                      initiallySelectedAddOnIds: selectedAddOnIds,
                      onAddOnsChanged: (selectedIds) {
                        setState(() {
                          selectedAddOnIds = selectedIds;
                        });
                      },
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
        baseProductPrice: widget.productPrice,
        addOnsPrice: totalAddOnsPrice,
        discountNumber: widget.discountNumber,
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
            'add_ons': {
              widget.productId.toString(): selectedAddOnIds,
            },
          });
        },
      ),
    );
  }
}