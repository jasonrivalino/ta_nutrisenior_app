import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/texts.dart';
import '../../../../shared/utils/handling_choose_image.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/feedback_input_card.dart';
import '../../../../shared/widgets/submit_button.dart';

import 'rating_widget.dart';
import 'rating_controller.dart';

class RatingView extends StatefulWidget {
  final int historyId;
  final int businessId;
  final int? driverId;
  final String? driverName;
  final String? businessName;
  final String? businessType;
  final String? businessImage;

  const RatingView({
    super.key,
    required this.historyId,
    required this.businessId,
    this.driverId,
    this.driverName,
    this.businessName,
    this.businessType,
    this.businessImage,
  });

  static RatingView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra! as Map<String, dynamic>;
    return RatingView(
      historyId: extra['history_id'] as int,
      businessId: extra['business_id'] as int,
      driverId: extra['driver_id'] as int?,
      driverName: extra['driver_name'] as String?,
      businessName: extra['business_name'] as String?,
      businessImage: extra['business_image'] as String?,
      businessType: extra['business_type'] as String?,
    );
  }

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  int selectedRating = 0;
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

  @override
  Widget build(BuildContext context) {
    final isDriver = widget.driverName != null;
    final isRestaurant = widget.businessType == "restaurant";

    final String appBarTitle = isDriver
        ? "Rating Pengemudi"
        : isRestaurant
            ? "Rating Restoran"
            : "Rating Pusat Belanja";

    final String ratingTarget = isDriver
        ? widget.driverName!
        : widget.businessName ?? "Nama Bisnis";

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(
        title: appBarTitle,
        showBackButton: true,
      ),
      resizeToAvoidBottomInset: true, // This is important
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                isDriver ? "Beri Rating Pengemudi" : "Beri Rating ${isRestaurant ? 'Restoran' : 'Pusat Belanja'}",
                style: AppTextStyles.textBold(
                  size: 22,
                  color: AppColors.dark,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              RatingCard(
                ratingTarget: ratingTarget,
                businessImage: widget.businessImage,
                selectedRating: selectedRating,
                onRatingSelected: (rating) {
                  setState(() {
                    selectedRating = rating;
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              FeedbackInputCard(
                controller: _commentController,
                titleText: "Berikan Komentar",
                placeholderText: "Masukkan komentar Anda...",
                selectedImages: _selectedImages,
                onChooseImage: _handleChooseImage,
                onRemoveImage: _removeImage,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  context.push('/history/done/details/:id/report', extra: {
                    'id': widget.historyId,
                    'driver_id': widget.driverId,
                    'is_driver': isDriver,
                    'business_id': widget.businessId,
                    'business_type': widget.businessType,
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.report, color: AppColors.persianRed, size: 16),
                    SizedBox(width: 6),
                    Text(
                      isDriver ? "Laporkan Pengemudi" : "Laporkan ${isRestaurant ? 'Restoran' : 'Pusat Belanja'}",
                      style: AppTextStyles.textMedium(
                        size: 14,
                        color: AppColors.persianRed,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SubmitButton(
                onPressed: () async {
                  if (selectedRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Rating tidak boleh kosong."),
                        backgroundColor: AppColors.persianRed,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  
                  if (_commentController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Komentar tidak boleh kosong."),
                        backgroundColor: AppColors.persianRed,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  final connectivityResult = await Connectivity().checkConnectivity();
                  if (connectivityResult.contains(ConnectivityResult.none)) {
                    Fluttertoast.showToast(
                      msg: "Gagal memberikan rating.\nSilahkan coba lagi.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  await Future.delayed(const Duration(seconds: 2));

                  if (isDriver) {
                    final driverController = DriverRatingController();
                    driverController.addDriverRating(
                      historyId: widget.historyId,
                      ratingNumber: selectedRating,
                      ratingComment: _commentController.text.trim(),
                      ratingImages: _selectedImages,
                    );
                  } else {
                    final businessController = BusinessRatingController();
                    businessController.addBusinessRating(
                      historyId: widget.historyId,
                      businessId: widget.businessId,
                      businessType: widget.businessType ?? 'restaurant',
                      ratingNumber: selectedRating,
                      ratingComment: _commentController.text.trim(),
                      ratingImages: _selectedImages,
                    );
                  }

                  Navigator.of(context).pop(); // Close loading dialog

                  Fluttertoast.showToast(
                    msg: "Rating berhasil diberikan!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );

                  context.go('/historyDone');
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}