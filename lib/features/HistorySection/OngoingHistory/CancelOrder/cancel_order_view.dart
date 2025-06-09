import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';
import 'package:ta_nutrisenior_app/shared/widgets/confirm_dialog.dart';
import 'package:ta_nutrisenior_app/shared/widgets/warning_button.dart';

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

  final List<Map<String, dynamic>> cancelReasons = [
    {'id': 1, 'reason': 'Pesanan terlalu lama sampai'},
    {'id': 2, 'reason': 'Ingin memesan dari restoran lain'},
    {'id': 3, 'reason': 'Menu yang dipesan salah atau berubah pikiran'},
    {'id': 4, 'reason': 'Alamat pengantaran salah'},
    {'id': 5, 'reason': 'Tidak bisa dihubungi terlalu lama'},
  ];

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
                        const Text(
                          "Alasan Pembatalan Pesanan?",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.fontBold,
                            color: AppColors.dark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ...cancelReasons.map((reason) {
                          return RadioListTile<int>(
                            value: reason['id'],
                            groupValue: selectedReasonId,
                            onChanged: (value) {
                              setState(() {
                                selectedReasonId = value;
                                otherReasonText = '';
                              });
                            },
                            title: Text(reason['reason']),
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
                          title: const Text("Lainnya"),
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
                              style: const TextStyle(fontSize: 14),
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

                                    // Show loading dialog using safe root context
                                    showDialog(
                                      context: rootContext,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );

                                    await Future.delayed(const Duration(seconds: 2));

                                    if (!mounted) return;

                                    rootContext.pop();
                                    
                                    Fluttertoast.showToast(
                                      msg: 'Pesanan berhasil dibatalkan.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );

                                    print('Cancel Order ID: ${widget.historyId}');
                                    
                                    rootContext.go('/historyOngoing',
                                      extra: {'history_id': widget.historyId},
                                    );
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