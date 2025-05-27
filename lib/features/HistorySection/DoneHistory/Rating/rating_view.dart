import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';

import '../../../../shared/utils/handling_choose_image.dart';
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
  int selectedRating = 5;
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.frogGreen,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border.all(color: AppColors.dark, width: 1.5),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.businessImage ?? 'assets/images/dummy/chat/driver.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ratingTarget,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.frogGreen,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: const Border(
                    left: BorderSide(color: AppColors.dark, width: 1.5),
                    right: BorderSide(color: AppColors.dark, width: 1.5),
                    bottom: BorderSide(color: AppColors.dark, width: 1.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    final value = index + 1;
                    return GestureDetector(
                      onTap: () => setState(() => selectedRating = value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: selectedRating == value ? AppColors.orangyYellow : AppColors.soapstone,
                          child: Text(
                            "$value",
                            style: TextStyle(
                              color: AppColors.dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              const Text("Berikan Komentar",
                  style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.dark, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _commentController,
                      maxLines: 4,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Tulis komentarmu...",
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: const Border(
                          top: BorderSide(color: AppColors.dark, width: 1.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (_selectedImages.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Text(
                                "Masukkan Gambar",
                                style: TextStyle(
                                  color: AppColors.darkGray,
                                  fontSize: 14,
                                  fontFamily: AppFonts.fontMedium,
                                  fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                          else
                            ..._selectedImages.asMap().entries.map((entry) {
                              final index = entry.key;
                              final imgPath = entry.value;
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Image.file(
                                      File(imgPath),
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: AppColors.persianRed,
                                        child: Icon(Icons.close, size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          const Spacer(),
                          IconButton(
                            onPressed: _handleChooseImage,
                            icon: const Icon(Icons.image),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              SubmitButton(
                onPressed: () async {
                  // Validate rating and comment
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