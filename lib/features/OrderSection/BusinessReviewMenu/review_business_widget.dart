import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';
import '../../../shared/utils/formatted_time.dart';
import '../../../shared/utils/fullscreen_image_view.dart';

class RatingFilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const RatingFilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.drabGreen : AppColors.soapstone,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.drabGreen : AppColors.dark,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.solidStar,
              size: 14,
              color: AppColors.dark,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.fontBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessRatingItem extends StatelessWidget {
  final Map<String, dynamic> rating;

  const BusinessRatingItem({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.darkGray,
            child: ClipOval(
              child: Image.asset(
                rating['userimage'],
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/dummy/userreview/johndoe.png',
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rating['username'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.dark,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                      ),
                    ),
                    Text(
                      formatDate(rating['rating_date']),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.dark,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return FaIcon(
                      index < rating['rating_number']
                          ? FontAwesomeIcons.solidStar
                          : FontAwesomeIcons.star,
                      color: AppColors.artyClickAmber,
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Text(rating['rating_comment'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.dark,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.fontMedium,
                  ),
                ),
                if ((rating['rating_images'] as List).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (rating['rating_images'] as List<String>).map((imagePath) {
                      final isLocalFile = imagePath.startsWith('/data/');

                      final imageWidget = isLocalFile
                          ? Image.file(
                              File(imagePath),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.lightGray,
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            )
                          : Image.asset(
                              imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.lightGray,
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            );

                      final canTap = !(isLocalFile && !File(imagePath).existsSync());

                      return GestureDetector(
                        onTap: canTap
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FullScreenImageView(
                                      imagePath: imagePath,
                                      senderName: rating['username'],
                                      sendTime: formatDate(rating['rating_date']),
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.dark.withValues(alpha: 0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Hero(
                              tag: imagePath,
                              child: imageWidget,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}