import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';
import '../../../shared/utils/formatted_time.dart';

class BusinessHeaderBar extends StatelessWidget {
  final VoidCallback onFavoritesClick;
  final VoidCallback onRatingClick;
  final bool isFavorite;

  const BusinessHeaderBar({
    super.key,
    required this.onFavoritesClick,
    required this.onRatingClick,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.soapstone,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.dark),
              onPressed: () => context.pop(),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.soapstone,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: AppColors.persianRed,
                  ),
                  onPressed: onFavoritesClick,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.soapstone,
                child: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.solidStar, size: 16, color: Colors.amber),
                  onPressed: onRatingClick,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BusinessInfoCard extends StatelessWidget {
  final String businessImage;
  final String businessName;
  final String businessAddress;
  final String businessEstimatedDelivery;
  final double businessRating;
  final double businessDistance;
  final DateTime businessOpenHour;
  final DateTime businessCloseHour;
  final int? discountNumber;
  final bool isFreeShipment;

  const BusinessInfoCard({
    super.key,
    required this.businessImage,
    required this.businessName,
    required this.businessAddress,
    required this.businessEstimatedDelivery,
    required this.businessRating,
    required this.businessDistance,
    required this.businessOpenHour,
    required this.businessCloseHour,
    this.discountNumber,
    required this.isFreeShipment,
  });

  @override
  Widget build(BuildContext context) {
    final formattedOpen = formatHours(businessOpenHour);
    final formattedClose = formatHours(businessCloseHour);

    return Positioned(
      top: 105,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.ecruWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dark.withValues(alpha: 0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark.withValues(alpha: 0.2), // soft shadow
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4), // shadow moves down
            ),
          ],
        ),
        child: Column(
          children: [
            // Section 1: Image + name + info row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      businessImage,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                businessName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if ((discountNumber != null || isFreeShipment))
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.orangyYellow,
                                  border: Border.all(color: AppColors.darkGray, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (discountNumber != null)
                                      Text(
                                        'Diskon $discountNumber%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dark,
                                          fontFamily: AppFonts.fontBold,
                                        ),
                                      )
                                    else ...[
                                      const FaIcon(FontAwesomeIcons.personBiking, size: 12, color: AppColors.dark),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'FREE',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.dark,
                                          fontFamily: AppFonts.fontBold,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _infoBadge(
                              icon: FaIcon(FontAwesomeIcons.solidStar, size: 12, color: AppColors.dark),
                              label: '${businessRating.toStringAsFixed(1)}/5',
                            ),
                            const SizedBox(width: 4),
                            _infoBadge(
                              icon: const Icon(Icons.location_on, size: 12, color: AppColors.dark),
                              label: '${businessDistance.toStringAsFixed(2)} km',
                            ),
                            const SizedBox(width: 4),
                            _infoBadge(
                              icon: const Icon(Icons.timer, size: 12, color: AppColors.dark),
                              label: businessEstimatedDelivery,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.dark),

            // Section 2: Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Center(
                child: Text(
                  businessAddress,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.fontMedium,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.dark),

            // Section 3: Open-Close Hours
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Center(
                child: Text(
                  '$formattedOpen - $formattedClose',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.fontMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBadge({required Widget icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.soapstone,
        border: Border.all(color: AppColors.dark),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 3),
          Text(label, style: const TextStyle(color: AppColors.dark)),
        ],
      ),
    );
  }
}