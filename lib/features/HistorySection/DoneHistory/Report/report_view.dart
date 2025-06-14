import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';
import 'package:ta_nutrisenior_app/shared/widgets/warning_button.dart';

import '../../../../shared/utils/handling_choose_image.dart';
import '../../../../shared/widgets/comment_input_card.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import 'report_data.dart';

class ReportView extends StatefulWidget {
  final int id;
  final bool isDriver;
  final String? businessType;

  const ReportView({
    super.key,
    required this.id,
    required this.isDriver,
    this.businessType,
  });

  factory ReportView.fromExtra(GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>? ?? {};

    return ReportView(
      id: extra['id'] as int,
      isDriver: extra['isDriver'] as bool,
      businessType: extra['businessType'] as String?,
    );
  }

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  int selectedRating = 0;
  int? selectedReasonId;
  String otherReasonText = '';
  final TextEditingController _commentController = TextEditingController();
  final List<String> _selectedImages = [];

  void _handleChooseImage() async {
    final image = await handleChooseImage(
      context: context,
      currentImageCount: _selectedImages.length,
    );

    if (image != null && _selectedImages.length < 3) {
      setState(() {
        _selectedImages.add(image.path);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  List<Map<String, dynamic>> get _reportReasons {
    if (widget.isDriver) return driverReportReason;
    if (widget.businessType == "Restaurant") return restaurantReportReason;
    return marketReportReason;
  }

  @override
  Widget build(BuildContext context) {
    final isRestaurant = widget.businessType == "Restaurant";

    final String appBarTitle = widget.isDriver
        ? "Laporkan Pengemudi"
        : isRestaurant
            ? "Laporkan Restoran"
            : "Laporkan Pusat Belanja";

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(
        title: appBarTitle,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Alasan Pelaporan",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.fontBold,
                            color: AppColors.dark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.0075),
                        // Compact radio list
                        ..._reportReasons.map((reason) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: RadioListTile<int>(
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
                                style: const TextStyle(fontSize: 14),
                              ),
                              activeColor: AppColors.dark,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: RadioListTile<int>(
                            value: 999,
                            groupValue: selectedReasonId,
                            onChanged: (value) {
                              setState(() {
                                selectedReasonId = value;
                              });
                            },
                            title: const Text("Lainnya", style: TextStyle(fontSize: 14)),
                            activeColor: AppColors.dark,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                          ),
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
                                hintText: "Tuliskan alasan lainnya...",
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: UnderlineInputBorder(),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        CommentInputCard(
                          controller: _commentController,
                          titleText: "Penjelasan",
                          placeholderText:
                              "Ceritakan detail kejadian yang Anda alami secara singkat...",
                          selectedImages: _selectedImages,
                          onChooseImage: _handleChooseImage,
                          onRemoveImage: _removeImage,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        WarningButton(
                          warningText: "Berikan Laporkan",
                          onPressed: () async {
                            if (selectedReasonId == null || (selectedReasonId == 999 && otherReasonText.trim().isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Pilih alasan pelaporan terlebih dahulu."),
                                  backgroundColor: AppColors.persianRed,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            if (_commentController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Penjelasan Laporan tidak boleh kosong."),
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
                                  titleText: 'Apakah laporan sudah yakin benar?',
                                  confirmText: 'Ya, berikan laporan',
                                  cancelText: 'Tidak, ubah dulu',
                                  onConfirm: () async {
                                    final connectivityResult = await Connectivity().checkConnectivity();
                                    if (connectivityResult.contains(ConnectivityResult.none)) {
                                      Fluttertoast.showToast(
                                        msg: 'Laporan gagal dikirimkan.\nSilahkan coba lagi.',
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

                                    rootContext.push('/history/done/details/:id/report/success', extra: widget.id);
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