import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/texts.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/warning_button.dart';

import 'cancel_order_data.dart';
import 'cancel_order_controller.dart';

class CancelOrderView extends StatefulWidget {
  final int historyId;

  const CancelOrderView({
    super.key, 
    required this.historyId
  });

  @override
  State<CancelOrderView> createState() => _CancelOrderViewState();
}

class _CancelOrderViewState extends State<CancelOrderView> {
  int? selectedReasonId;
  String otherReasonText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ecruWhite,
      appBar: const CustomAppBar(
        title: 'Pembatalan Pesanan',
        showBackButton: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alasan Pembatalan Pesanan?",
                          style: AppTextStyles.textBold(
                            size: 28,
                            color: AppColors.dark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ...cancelOrderReason.map((reason) {
                          return RadioListTile<int>(
                            value: reason['id'],
                            groupValue: selectedReasonId,
                            onChanged: (value) {
                              setState(() {
                                selectedReasonId = value;
                                otherReasonText = '';
                              });
                            },
                            title: Text(reason['reason'],
                              style: AppTextStyles.textMedium(
                                size: 16,
                                color: AppColors.dark,
                              ),
                            ),
                            activeColor: AppColors.dark,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                          );
                        }),
                        RadioListTile<int>(
                          value: 999,
                          groupValue: selectedReasonId,
                          onChanged: (value) {
                            setState(() {
                              selectedReasonId = value;
                            });
                          },
                          title: Text("Lainnya",
                            style: AppTextStyles.textMedium(
                              size: 16,
                              color: AppColors.dark,
                            ),
                          ),
                          activeColor: AppColors.dark,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        ),
                        if (selectedReasonId == 999)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  otherReasonText = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "Lainnya",
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: UnderlineInputBorder(),
                              ),
                              style: AppTextStyles.textMedium(
                                size: 14,
                                color: AppColors.dark,
                              ),
                            ),
                          ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                        WarningButton(
                          warningText: "Batalkan Pemesanan",
                          onPressed: () async {
                            if (selectedReasonId == null || (selectedReasonId == 999 && otherReasonText.trim().isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Pilih alasan pembatalan pesanan terlebih dahulu."),
                                  backgroundColor: AppColors.persianRed,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            
                            // Capture a stable context before any dialogs
                            final rootContext = context;

                            showDialog(
                              context: rootContext,
                              builder: (BuildContext dialogContext) {
                                return ConfirmDialog(
                                  titleText: 'Apakah yakin ingin membatalkan pesanan?',
                                  confirmText: 'Ya, batalkan pesanan',
                                  cancelText: 'Tidak, lanjutkan pemesanan',
                                  onConfirm: () async {
                                    final connectivityResult = await Connectivity().checkConnectivity();
                                    if (connectivityResult.contains(ConnectivityResult.none)) {
                                      Fluttertoast.showToast(
                                        msg: 'Pembatalan pesanan gagal. \nSilahkan coba lagi.',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                      return;
                                    }

                                    // Show loading
                                    showDialog(
                                      context: rootContext,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(child: CircularProgressIndicator()),
                                    );

                                    await Future.delayed(const Duration(seconds: 2));

                                    if (!mounted) return;

                                    // Cancel logic using controller
                                    CancelledOrderController(historyId: widget.historyId).cancelOrder();

                                    rootContext.pop(); // Close loading
                                    Fluttertoast.showToast(
                                      msg: 'Pesanan berhasil dibatalkan.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );

                                    rootContext.go('/historyOngoing');
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}