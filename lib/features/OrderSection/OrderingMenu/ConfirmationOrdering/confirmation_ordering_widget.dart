import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/texts.dart';
import '../../../../shared/utils/format_currency.dart';

class RecipientLocationBox extends StatelessWidget {
  final VoidCallback onAddressClick;
  final VoidCallback onNotesClick;
  final String note;
  final String addressName;
  final String addressDetail;

  const RecipientLocationBox({
    super.key,
    required this.onAddressClick,
    required this.onNotesClick,
    required this.note,
    required this.addressName,
    required this.addressDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lokasi Penerima",
            style: AppTextStyles.textBold(
              size: 20,
              color: AppColors.dark,
            ),
          ),
          const Divider(color: AppColors.dark, thickness: 1),
          const SizedBox(height: 6),
          Text(
            addressName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.textBold(
              size: 16,
              color: AppColors.dark,
            ),
          ),
          Text(
            addressDetail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.textMedium(
              size: 14,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Note: $note",
            style: AppTextStyles.textMedium(
              size: 14,
              color: AppColors.dark,
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
                child: Text("Pilih Alamat Detail",
                  style: AppTextStyles.textMedium(
                    size: 14,
                    color: AppColors.soapstone,
                  ),
                ),
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
                child: Text("Tambahkan Note",
                  style: AppTextStyles.textMedium(
                    size: 14,
                    color: AppColors.soapstone,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DriverNoteOverlay extends StatefulWidget {
  final String initialNote;
  final void Function(String note) onNoteSubmitted;

  const DriverNoteOverlay({
    super.key,
    required this.initialNote,
    required this.onNoteSubmitted,
  });

  @override
  State<DriverNoteOverlay> createState() => _DriverNoteOverlayState();
}

class _DriverNoteOverlayState extends State<DriverNoteOverlay> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialNote == '-' ? '' : widget.initialNote,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note Pengantar",
            style: AppTextStyles.textBold(
              size: 20,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: AppTextStyles.textMedium(
              size: 14,
              color: AppColors.dark,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.soapstone,
              hintText: "Tulis note di sini...",
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final trimmed = _controller.text.trim();
              widget.onNoteSubmitted(trimmed.isEmpty ? "-" : trimmed);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.woodland,
              foregroundColor: AppColors.soapstone,
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Tambahkan Note',
              style: AppTextStyles.textBold(
                size: 16,
                color: AppColors.soapstone,
              ),
            ),
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
  final int? discountNumber;
  final int businessId;
  final String businessType;
  final void Function(String productId, int newQty) onCountChanged;
  final void Function(String productId, String notes)? onNotesChanged;
  final void Function(String productId, List<int> newAddOnIds)? onAddOnsChanged;

  const OrderDetailListBox({
    super.key,
    required this.selectedProducts,
    required this.serviceFee,
    required this.deliveryFee,
    this.discountNumber,
    required this.businessId,
    required this.businessType,
    required this.onCountChanged,
    this.onNotesChanged,
    this.onAddOnsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detail Pesanan",
            style: AppTextStyles.textBold(
              size: 20,
              color: AppColors.dark,
            ),
          ),
          const Divider(color: AppColors.dark, thickness: 1),

          /// Handling when empty
          if (selectedProducts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Pesanan masih kosong',
                      style: AppTextStyles.textBold(
                        size: 16,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Silakan tambahkan ${businessType == "restaurant" ? "makanan" : "belanjaan"} terlebih dahulu',
                      style: AppTextStyles.textMedium(
                        size: 14,
                        color: AppColors.dark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...selectedProducts.map((product) {
              final subtotal = product['product_price'] * product['qty_product'];
              final productIdStr = product['product_id'].toString();

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

                            final result = await context.push<Map<String, dynamic>>(route, extra: {
                              'business_id': businessId,
                              'business_type': businessType,
                              'product_id': productIdInt,
                              'discount_number': discountNumber,
                              'product_image': product['product_image'],
                              'product_name': product['product_name'],
                              'product_price': product['original_price'],
                              'product_description': product['product_description'],
                              'qty_product': product['qty_product'],
                              'notes': product['notes'],
                              'add_ons': {
                                productIdStr: product['add_ons'] ?? [],
                              }
                            });

                            if (result != null) {
                              final returnedProductId = result['product_id'].toString();
                              final newQty = result['qty_product'] ?? 0;
                              final notes = result['notes'] ?? '';
                              final addOnsResult = result['add_ons'] as Map<String, dynamic>?;

                              onCountChanged(returnedProductId, newQty);
                              if (onNotesChanged != null) {
                                onNotesChanged!(returnedProductId, notes);
                              }
                              if (onAddOnsChanged != null && addOnsResult != null) {
                                final updatedAddOnIds = List<int>.from(
                                  addOnsResult[returnedProductId] ?? [],
                                );
                                onAddOnsChanged!(returnedProductId, updatedAddOnIds);
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            minimumSize: const Size(0, 24),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: AppColors.dark,
                          ),
                          child: Text(
                            "Ubah",
                            style: AppTextStyles.textMedium(
                              size: 16,
                              color: AppColors.dark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${product['qty_product']}x",
                          style: AppTextStyles.textBold(
                            size: 16,
                            color: AppColors.dark,
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
                                style: AppTextStyles.textBold(
                                  size: 16,
                                  color: AppColors.dark,
                                ),
                              ),
                              Text(
                                "Note: ${(product['notes']?.toString().trim().isNotEmpty ?? false) ? product['notes'] : '-'}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.textMedium(
                                  size: 14,
                                  color: AppColors.dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          formatCurrency(subtotal),
                          style: AppTextStyles.textBold(
                            size: 16,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),

                    if (product['add_ons_details'] != null && product['add_ons_details'].isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Column(
                        children: List.generate(product['add_ons_details'].length, (index) {
                          final addOn = product['add_ons_details'][index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  final currentAddOnsDetails = List<Map<String, dynamic>>.from(product['add_ons_details']);
                                  final removedAddOn = currentAddOnsDetails[index];
                                  final removedAddOnId = removedAddOn['add_ons_id'];

                                  final updatedAddOnIds = List<int>.from(product['add_ons']);
                                  updatedAddOnIds.remove(removedAddOnId);

                                  if (onAddOnsChanged != null) {
                                    onAddOnsChanged!(productIdStr, updatedAddOnIds);
                                  }
                                },
                                icon: const Icon(Icons.remove_circle, size: 20, color: AppColors.persianRed),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  '${addOn['add_ons_name']}',
                                  style: AppTextStyles.textMedium(
                                    size: 16,
                                    color: AppColors.dark,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                formatCurrency(addOn['add_ons_price'] * product['qty_product']),
                                style: AppTextStyles.textBold(
                                  size: 16,
                                  color: AppColors.dark,
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ],
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
                Text(
                  "Harga Pelayanan",
                  style: AppTextStyles.textBold(
                    size: 16,
                    color: AppColors.dark,
                  ),
                ),
                Text(
                  formatCurrency(serviceFee),
                  style: AppTextStyles.textBold(
                    size: 16,
                    color: AppColors.dark,
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
                Text(
                  "Harga Pengiriman",
                  style: AppTextStyles.textBold(
                    size: 16,
                    color: AppColors.dark,
                  ),
                ),
                Text(
                  deliveryFee == 0 ? 'Gratis' : formatCurrency(deliveryFee),
                  style: AppTextStyles.textBold(
                    size: 16,
                    color: AppColors.dark,
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
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Tambah Pesanan lagi??",
            style: AppTextStyles.textBold(
              size: 20,
              color: AppColors.dark,
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
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.15),
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
              Text(
                "Metode Pembayaran",
                style: AppTextStyles.textBold(
                  size: 20,
                  color: AppColors.dark,
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
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    "Pilih Metode Pembayaran:",
                                    style: AppTextStyles.textBold(
                                      size: 20,
                                      color: AppColors.dark,
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
                                          const SizedBox(width: 10),
                                          Text(option['label'],
                                            style: AppTextStyles.textMedium(
                                              size: 16,
                                              color: AppColors.dark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Text(
                  "Lihat Semua",
                  style: AppTextStyles.textBold(
                    size: 16,
                    color: AppColors.dark,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.dark, thickness: 1),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(currentOption['icon']),
              const SizedBox(width: 12),
              Text(selectedMethod,
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}