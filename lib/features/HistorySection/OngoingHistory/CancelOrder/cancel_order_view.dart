import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/texts.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/elevated_button.dart';

import 'cancel_order_data.dart';
import 'cancel_order_controller.dart';

class CancelOrderView extends StatefulWidget {
  final int historyId;

  const CancelOrderView({
    super.key,
    required this.historyId,
  });

  @override
  State<CancelOrderView> createState() => _CancelOrderViewState();
}

class _CancelOrderViewState extends State<CancelOrderView> {
  int? selectedReasonId;
  String otherReasonText = '';


  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: deviceHeight > 900
                        ? constraints.maxHeight * 0.18
                        : constraints.maxHeight * 0.15,
                  ),
                  Text(
                    "Alasan Pembatalan Pesanan?",
                    style: AppTextStyles.textBold(
                      size: 28,
                      color: AppColors.dark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
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
                      title: Text(
                        reason['reason'],
                        style: AppTextStyles.textMedium(
                          size: 16,
                          color: AppColors.dark,
                        ),
                      ),
                      activeColor: AppColors.dark,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    );
                  }).toList(),
                  RadioListTile<int>(
                    value: 999,
                    groupValue: selectedReasonId,
                    onChanged: (value) {
                      setState(() {
                        selectedReasonId = value;
                      });
                    },
                    title: Text(
                      "Lainnya",
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
                        cursorColor: AppColors.dark,
                        decoration: const InputDecoration(
                          hintText: "Lainnya",
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.dark),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.dark, width: 1.5),
                          ),
                        ),
                        style: AppTextStyles.textMedium(
                          size: 14,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButtonWidget.submitFormButton(
                      text: "Batalkan Pemesanan",
                      backgroundColor: AppColors.persianRed,
                      onPressed: () async {
                        if (selectedReasonId == null || (selectedReasonId == 999 && otherReasonText.trim().isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pilih alasan pembatalan pesanan terlebih dahulu."),
                              backgroundColor: AppColors.persianRed,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 5),
                            ),
                          );
                          return;
                              }

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
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                  return;
                                }

                                showDialog(
                                  context: rootContext,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(child: CircularProgressIndicator()),
                                );

                                await Future.delayed(const Duration(seconds: 2));
                                if (!mounted) return;

                                CancelledOrderController(historyId: widget.historyId).cancelOrder();

                                rootContext.pop(); // Close loading
                                Fluttertoast.showToast(
                                  msg: 'Pesanan berhasil dibatalkan.',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                );

                                rootContext.go('/historyOngoing');
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // padding bawah agar tidak mentok
                ],
              ),
            );
          },
        ),
      ),

    );
  }
}