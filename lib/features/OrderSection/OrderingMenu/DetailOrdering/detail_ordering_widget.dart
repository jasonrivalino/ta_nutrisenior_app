import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/utils/format_currency.dart';

import '../../../../shared/styles/fonts.dart';

class ProductDetailInfoBox extends StatelessWidget {
  final String productName;
  final int productPrice;
  final String productDescription;

  const ProductDetailInfoBox({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                productName,
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                ),
              ),
              Text(
                formatCurrency(productPrice),
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
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
  final int quantity;
  final void Function(int) onQuantityChanged;
  final VoidCallback onAddPressed;

  const SetQuantityBottomNavbar({
    super.key,
    required this.businessType,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.berylGreen,
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
                  color: Colors.black12,
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
                'Tambah ${businessType == 'restaurant' ? 'Makanan' : 'Belanjaan'}',
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