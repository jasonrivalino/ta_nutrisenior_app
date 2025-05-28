import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/features/HistorySection/DoneHistory/Rating/rating_widget.dart';
// import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';

import '../../../../shared/utils/handling_choose_image.dart';
import '../../../../shared/widgets/comment_input_card.dart';
import '../../../../shared/widgets/submit_button.dart';

class RatingView extends StatefulWidget {
  final int id;
  final String? driverName;
  final String? businessName;
  final String? businessType;
  final String? businessImage;

  const RatingView({
    super.key,
    required this.id,
    this.driverName,
    this.businessName,
    this.businessType,
    this.businessImage,
  });

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
    final isRestaurant = widget.businessType == "Restaurant";

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isDriver ? "Beri Rating Pengemudi" : "Beri Rating ${isRestaurant ? 'Restoran' : 'Pusat Belanja'}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
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
              CommentInputCard(
                controller: _commentController,
                selectedImages: _selectedImages,
                onChooseImage: _handleChooseImage,
                onRemoveImage: _removeImage,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              GestureDetector(
                onTap: () {
                  // TODO: Handle report action
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.report, color: AppColors.persianRed, size: 16),
                    SizedBox(width: 6),
                    Text(
                      isDriver ? "Laporkan Pengemudi" : "Laporkan ${isRestaurant ? 'Restoran' : 'Pusat Belanja'}",
                      style: const TextStyle(
                        color: AppColors.persianRed, 
                        fontSize: 14, 
                        fontFamily: AppFonts.fontMedium, 
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              SubmitButton(
                onPressed: () async {
                  // Validate rating and comment
                  if (_commentController.text.trim().isEmpty ) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Komentar tidak boleh kosong."),
                        backgroundColor: AppColors.persianRed,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

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

                  // Handling no connection
                  final connectivityResult = await Connectivity().checkConnectivity();
                  if (connectivityResult.contains(ConnectivityResult.none)) {
                    Fluttertoast.showToast(
                      msg: "Gagal memberikan rating.\nSilahkan coba lagi.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }
                  
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  // Wait for 2 seconds
                  await Future.delayed(const Duration(seconds: 2));

                  // Dismiss loading
                  Navigator.of(context).pop();

                  // Show success toast
                  Fluttertoast.showToast(
                    msg: "Rating berhasil diberikan!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );

                  // Navigate to history page
                  context.go('/history'); // Adjust route if needed
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}