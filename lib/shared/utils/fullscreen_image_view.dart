import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../styles/colors.dart';
import '../styles/texts.dart';
import '../utils/formatted_time.dart';

class FullScreenImageView extends StatelessWidget {
  final String imagePath;
  final String senderName;
  final dynamic sendTime; // accept String or DateTime

  const FullScreenImageView({
    super.key,
    required this.imagePath,
    required this.senderName,
    this.sendTime,
  });

  bool _isAsset(String path) {
    return !(path.startsWith('/') || path.startsWith('file:'));
  }

  @override
  Widget build(BuildContext context) {
    final isAsset = _isAsset(imagePath);

    return Scaffold(
      backgroundColor: AppColors.dark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.soapstone),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SizedBox(
          height: kToolbarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                senderName,
                style: AppTextStyles.textBold(
                  size: 18,
                  color: AppColors.soapstone,
                ),
              ),
              if (sendTime != null)
                Text(
                  formatFullDateTime(sendTime),
                  style: AppTextStyles.textMedium(
                    size: 14,
                    color: AppColors.soapstone,
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Hero(
        tag: imagePath,
        child: PhotoView(
          imageProvider: isAsset
              ? AssetImage(imagePath)
              : FileImage(File(imagePath)) as ImageProvider,
          backgroundDecoration: const BoxDecoration(color: AppColors.dark),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.0,
        ),
      ),
    );
  }
}