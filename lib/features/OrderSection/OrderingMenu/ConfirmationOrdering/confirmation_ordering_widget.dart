import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/fonts.dart';
import '../../../../shared/utils/format_currency.dart';

class RecipientLocationBox extends StatelessWidget {
  final VoidCallback onAddressClick;
  final VoidCallback onNotesClick;

  const RecipientLocationBox({
    super.key,
    required this.onAddressClick,
    required this.onNotesClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lokasi Penerima",
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.fontBold,
            ),
          ),
          const Divider(color: AppColors.dark, thickness: 1),
          const SizedBox(height: 6),
          const Text(
            "Rumah Wisma Teduh",
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.fontBold,
            ),
          ),
          Text(
            "Jl. Lorem Ipsum 1 No. 2",
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.fontMedium,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Note: taruh depan kamar saja nomor 11",
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.fontMedium,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: onAddressClick,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.woodland,
                  foregroundColor: AppColors.soapstone,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  minimumSize: const Size(0, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Alamat Detail"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onNotesClick,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.woodland,
                  foregroundColor: AppColors.soapstone,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  minimumSize: const Size(0, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.woodland),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Tambahkan Note"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderDetailListBox extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final int serviceFee;
  final int deliveryFee;
  final VoidCallback onAddMorePressed;

  const OrderDetailListBox({
    super.key,
    required this.selectedProducts,
    required this.serviceFee,
    required this.deliveryFee,
    required this.onAddMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail Pesanan",
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.fontBold,
            ),
          ),
          const Divider(color: AppColors.dark, thickness: 1),
          ...selectedProducts.map((product) {
            final subtotal = product['product_price'] * product['qty_product'];
            return Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO: implement "ubah" functionality
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          minimumSize: const Size(0, 24),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.dark,
                        ),
                        child: const Text(
                          "Ubah",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.dark,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.fontMedium,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${product['qty_product']}x",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.dark,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['product_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.dark,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.fontBold,
                              ),
                            ),
                            Text(
                              "Note: ${(product['notes']?.toString().trim().isNotEmpty ?? false) ? product['notes'] : '-'}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.dark,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.fontMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formatCurrency(subtotal),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.dark,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const Divider(color: AppColors.dark, thickness: 1),
          const SizedBox(height: 4),
          _priceRow("Harga pelayanan", serviceFee),
          _priceRow("Harga ongkir", deliveryFee),
          // Uncomment if needed
          // Row(
          //   children: [
          //     const Text("Ingin Tambah Pesanan lagi??"),
          //     const SizedBox(width: 12),
          //     ElevatedButton.icon(
          //       onPressed: onAddMorePressed,
          //       icon: const Icon(Icons.add, size: 16),
          //       label: const Text("Tambah"),
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: AppColors.berylGreen,
          //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(formatCurrency(value)),
        ],
      ),
    );
  }
}
