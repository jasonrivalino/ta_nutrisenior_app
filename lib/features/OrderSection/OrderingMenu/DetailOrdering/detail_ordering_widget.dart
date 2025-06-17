import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/utils/calculate_price_fee.dart';
import 'package:ta_nutrisenior_app/shared/utils/format_currency.dart';

import '../../../../shared/styles/fonts.dart';

class ProductDetailInfoBox extends StatelessWidget {
  final String productName;
  final int productPrice;
  final String productDescription;
  final int? discountNumber;

  const ProductDetailInfoBox({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    this.discountNumber,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = discountNumber != null;
    final int discountedPrice = hasDiscount
        ? (productPrice * (100 - discountNumber!) ~/ 100)
        : productPrice;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.soapstone,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              Expanded(
                child: Text(
                  productName,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
              ),

              // Price Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasDiscount)
                    Text(
                      formatCurrency(discountedPrice),
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                      ),
                    ),
                  if (hasDiscount) const SizedBox(height: 2),
                  Text(
                    formatCurrency(productPrice),
                    style: TextStyle(
                      color: hasDiscount ? AppColors.darkGray : AppColors.dark,
                      fontSize: hasDiscount ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.fontBold,
                      decoration: hasDiscount ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            productDescription,
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.fontMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductAddOnsSelectionBox extends StatefulWidget {
  final List<Map<String, dynamic>> addOns;
  final void Function(List<int> selectedAddOnIds) onAddOnsChanged;
  final List<int>? initiallySelectedAddOnIds;

  const ProductAddOnsSelectionBox({
    super.key,
    required this.addOns,
    required this.onAddOnsChanged,
    this.initiallySelectedAddOnIds,
  });

  @override
  State<ProductAddOnsSelectionBox> createState() => _ProductAddOnsSelectionBoxState();
}

class _ProductAddOnsSelectionBoxState extends State<ProductAddOnsSelectionBox> {
  late Set<int> _selectedAddOnIds;

  @override
  void initState() {
    super.initState();
    _selectedAddOnIds = Set<int>.from(widget.initiallySelectedAddOnIds ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.soapstone,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8, left: 16),
            child: Text(
              'Pilih Tambahan',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.fontBold,
              ),
            ),
          ),
          ...widget.addOns.map((addOn) {
            final int id = addOn['add_ons_id'];
            final String name = addOn['add_ons_name'];
            final int price = addOn['add_ons_price'];
            final bool isSelected = _selectedAddOnIds.contains(id);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                hoverColor: AppColors.soapstone.withAlpha(80),
                splashColor: AppColors.darkGray.withAlpha(50),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedAddOnIds.remove(id);
                    } else {
                      _selectedAddOnIds.add(id);
                    }
                    widget.onAddOnsChanged(_selectedAddOnIds.toList());
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? AppColors.soapstone.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      FaIcon(
                        isSelected
                            ? FontAwesomeIcons.solidCircleCheck
                            : FontAwesomeIcons.circle,
                        color: isSelected ? AppColors.dark : AppColors.darkGray,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$name (${formatCurrency(price)})',
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 14,
                            fontFamily: AppFonts.fontMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ProductNoteInputBox extends StatelessWidget {
  final String businessType;
  final TextEditingController noteController;

  const ProductNoteInputBox({
    super.key,
    required this.businessType,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.soapstone,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note", 
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.fontBold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(
              color: AppColors.dark,
              fontSize: 14,
              fontFamily: AppFonts.fontMedium,
              fontWeight: FontWeight.w500,
            ),
            controller: noteController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: businessType == 'restaurant'
                  ? 'Tambahkan pesan makanan'
                  : 'Tambahkan pesan belanjaan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}

class SetQuantityBottomNavbar extends StatelessWidget {
  final String businessType;
  final int baseProductPrice;
  final int addOnsPrice;
  final int? discountNumber;
  final int quantity;
  final void Function(int) onQuantityChanged;
  final VoidCallback onAddPressed;

  const SetQuantityBottomNavbar({
    super.key,
    required this.businessType,
    required this.baseProductPrice,
    required this.addOnsPrice,
    this.discountNumber,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.berylGreen,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                "Jumlah Pesanan",
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 16,
                  fontFamily: AppFonts.fontBold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.darkGray),
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.soapstone,
                    ),
                    child: InkWell(
                      onTap: () =>
                          onQuantityChanged(quantity > 0 ? quantity - 1 : 0),
                      borderRadius: BorderRadius.circular(6),
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.darkGray),
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.soapstone,
                    ),
                    child: InkWell(
                      onTap: () => onQuantityChanged(quantity + 1),
                      borderRadius: BorderRadius.circular(6),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: onAddPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.woodland,
                foregroundColor: AppColors.soapstone,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Tambah ${businessType == 'restaurant' ? 'Makanan' : 'Belanjaan'} - ${formatCurrency(getFinalPrice(baseProductPrice, addOnsPrice, quantity, discountNumber))}',
                style: TextStyle(
                  fontFamily: AppFonts.fontBold,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}