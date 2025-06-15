import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/fonts.dart';
import '../../../../shared/utils/format_currency.dart';

class RecipientLocationBox extends StatelessWidget {
  final VoidCallback onAddressClick;
  final VoidCallback onNotesClick;
  final String note;

  const RecipientLocationBox({
    super.key,
    required this.onAddressClick,
    required this.onNotesClick,
    required this.note,
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
          const Text(
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
            "Note: $note",
            style: const TextStyle(
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
  final int businessId;
  final String businessType;
  final void Function(String productId, int newQty) onCountChanged;
  final void Function(String productId, String notes)? onNotesChanged;

  const OrderDetailListBox({
    super.key,
    required this.selectedProducts,
    required this.serviceFee,
    required this.deliveryFee,
    required this.businessId,
    required this.businessType,
    required this.onCountChanged,
    this.onNotesChanged,
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
                        onPressed: () async {
                          final productId = product['product_id'];
                          final int productIdInt = productId is int ? productId : int.parse(productId.toString());
                          final route = '/business/detail/$businessId/ordering/$productId';
                          print("Navigating to: $route");

                          final result = await context.push<Map<String, dynamic>>(route, extra: {
                            'business_id': businessId,
                            'business_type': businessType,
                            'product_id': productIdInt,
                            'product_image': product['product_image'],
                            'product_name': product['product_name'],
                            'product_price': product['product_price'],
                            'product_description': product['product_description'],
                            'qty_product': product['qty_product'],
                            'notes': product['notes'],
                          });

                          if (result != null) {
                            final returnedProductId = result['product_id'].toString();
                            final newQty = result['qty_product'] ?? 0;
                            final notes = result['notes'] ?? '';

                            print('Returned from detail: productId: $returnedProductId, qty: $newQty, notes: $notes');

                            onCountChanged(returnedProductId, newQty);
                            if (onNotesChanged != null) {
                              onNotesChanged!(returnedProductId, notes);
                            }
                          }
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
                        style: const TextStyle(
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
                              style: const TextStyle(
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
                              style: const TextStyle(
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
                        style: const TextStyle(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Harga Pelayanan",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
                Text(
                  formatCurrency(serviceFee),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Harga Pengiriman",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
                Text(
                  deliveryFee == 0 ? 'Gratis' : formatCurrency(deliveryFee),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddMoreOrderButtonBox extends StatelessWidget {
  final VoidCallback onAddMorePressed;

  const AddMoreOrderButtonBox({
    super.key,
    required this.onAddMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.ecruWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Ingin Tambah Pesanan lagi??",
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.fontBold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: onAddMorePressed,
            icon: const Icon(Icons.add, size: 16),
            label: const Text("Tambah"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.woodland,
              foregroundColor: AppColors.soapstone,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(0, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodBox extends StatefulWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodBox({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  State<PaymentMethodBox> createState() => _PaymentMethodBoxState();
}

class _PaymentMethodBoxState extends State<PaymentMethodBox> {
  late String selectedMethod;

  final List<Map<String, dynamic>> paymentOptions = [
    {
      'label': 'Pembayaran Tunai',
      'icon': Icons.payments_outlined,
    },
    {
      'label': 'Virtual Account Transfer',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'label': 'QRIS Scan',
      'icon': Icons.qr_code_scanner_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    final currentOption = paymentOptions.firstWhere(
      (option) => option['label'] == selectedMethod,
    );

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Metode Pembayaran",
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.berylGreen,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, modalSetState) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    "Pilih Metode Pembayaran:",
                                    style: TextStyle(
                                      color: AppColors.dark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.fontBold,
                                    ),
                                  ),
                                ),
                                ...paymentOptions.map((option) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: RadioListTile<String>(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      value: option['label'],
                                      groupValue: selectedMethod,
                                      onChanged: (value) {
                                        modalSetState(() {});
                                        setState(() {
                                          selectedMethod = value!;
                                        });
                                        widget.onMethodSelected(value!); // notify parent
                                        Navigator.pop(context);
                                      },
                                      title: Row(
                                        children: [
                                          Icon(option['icon'], size: 24),
                                          const SizedBox(width: 6),
                                          Text(option['label'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.dark,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppFonts.fontMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(currentOption['icon']),
              const SizedBox(width: 12),
              Text(selectedMethod),
            ],
          ),
        ],
      ),
    );
  }
}