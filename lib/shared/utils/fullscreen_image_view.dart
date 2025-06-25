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
      body: Stack(
        children: [
          // Fullscreen image
          Hero(
            tag: imagePath,
            child: PhotoView(
              imageProvider: isAsset
                  ? AssetImage(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider,
              backgroundDecoration: const BoxDecoration(color: AppColors.dark),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.0,
              initialScale: PhotoViewComputedScale.contained,
              basePosition: Alignment.center,
            ),
          ),

          // Overlay AppBar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 8,
              right: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.dark.withValues(alpha: 0.8),
            ),
            child: SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.soapstone),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}