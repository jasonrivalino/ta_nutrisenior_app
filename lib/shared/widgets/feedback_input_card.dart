import 'dart:io';
import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/texts.dart';

class FeedbackInputCard extends StatelessWidget {
  final TextEditingController controller;
  final String titleText;
  final String placeholderText;
  final List<String> selectedImages;
  final VoidCallback onChooseImage;
  final Function(int) onRemoveImage;

  const FeedbackInputCard({
    super.key,
    required this.controller,
    required this.titleText,
    required this.placeholderText,
    required this.selectedImages,
    required this.onChooseImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Comment Title
        Text(
          titleText,
          style: AppTextStyles.textBold(
            size: 20,
            color: AppColors.dark,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        // Comment input card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.soapstone,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: AppColors.dark, width: 1.5),
          ),
          child: TextField(
            controller: controller,
            maxLines: 5,
            cursorColor: AppColors.dark, // Warna garis ketik (cursor)
            style: AppTextStyles.textMedium(
              size: 14,
              color: AppColors.dark, // Warna teks yang diketik
            ),
            decoration: InputDecoration.collapsed(
              hintText: placeholderText,
              hintStyle: AppTextStyles.textMedium(
                size: 14,
                color: AppColors.darkGray, // Warna hint text (placeholder)
              ),
            ),
          ),
        ),
        // Image Upload Box
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          decoration: BoxDecoration(
            color: AppColors.soapstone,
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
            children: [
              if (selectedImages.isEmpty)
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    "Masukkan Gambar Pendukung",
                    style: AppTextStyles.textMedium(
                      size: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                )
              else
                ...selectedImages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final path = entry.value;
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(path),
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onRemoveImage(index),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: AppColors.persianRed,
                            child: Icon(Icons.close, size: 14, color: AppColors.soapstone),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              const Spacer(),
              IconButton(
                onPressed: onChooseImage,
                icon: const Icon(Icons.image),
              ),
            ],
          ),
        ),
      ],
    );
  }
}