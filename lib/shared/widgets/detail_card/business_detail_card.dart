import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config/constants.dart';

import '../../styles/colors.dart';
import '../../styles/texts.dart';
import '../../utils/formatted_time.dart';
import '../../utils/is_business_open.dart';

class BusinessInfoCard extends StatelessWidget {
  final String businessImage;
  final String businessName;
  final String businessType;
  final String businessAddress;
  final String? businessEstimatedDelivery;
  final double businessRating;
  final double? businessDistance;
  final DateTime? businessOpenHour;
  final DateTime? businessCloseHour;
  final int? discountNumber;
  final bool? isFreeShipment;

  const BusinessInfoCard({
    super.key,
    required this.businessImage,
    required this.businessName,
    required this.businessType,
    required this.businessAddress,
    this.businessEstimatedDelivery,
    required this.businessRating,
    this.businessDistance,
    this.businessOpenHour,
    this.businessCloseHour,
    this.discountNumber,
    this.isFreeShipment,
  });

  @override
  Widget build(BuildContext context) {
    final formattedOpen = businessOpenHour != null ? formatTime(businessOpenHour!) : null;
    final formattedClose = businessCloseHour != null ? formatTime(businessCloseHour!) : null;

    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isBusinessOpen(businessOpenHour, businessCloseHour)
              ? AppColors.ecruWhite
              : AppColors.lightGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dark.withValues(alpha: 0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark.withValues(alpha: 0.15), // soft shadow
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
              padding: EdgeInsets.symmetric(horizontal: screenHeight > 900 ? 12 : 11, vertical: screenHeight > 900 ? 12 : 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight > 900 ? 70 : 65,
                    width: screenHeight > 900 ? 70 : 65,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.darkGray, width: 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ColorFiltered(
                              colorFilter: isBusinessOpen(businessOpenHour, businessCloseHour)
                                  ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
                                  : const ColorFilter.mode(AppColors.darkGray, BlendMode.saturation),
                              child: Image.asset(
                                businessImage,
                                height: screenHeight > 900 ? 70 : 65,
                                width: screenHeight > 900 ? 70 : 65,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  String fallbackImage = AppConstants.errorDummyRestaurant;
                                  if (businessType == 'market') {
                                    fallbackImage = AppConstants.errorDummyMarket;
                                  }
                                  return Image.asset(
                                    fallbackImage,
                                    height: screenHeight > 900 ? 70 : 65,
                                    width: screenHeight > 900 ? 70 : 65,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        if (discountNumber != null || (isFreeShipment != null && isFreeShipment!))
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                color: isBusinessOpen(businessOpenHour, businessCloseHour)
                                    ? AppColors.orangyYellow
                                    : AppColors.darkGray,
                                border: Border.all(color: AppColors.darkGray, width: 1),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: discountNumber != null
                                  ? Text(
                                      'Disc $discountNumber%',
                                      style: AppTextStyles.textBold(
                                        size: 12,
                                        color: AppColors.dark,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(FontAwesomeIcons.personBiking, size: 12, color: AppColors.dark),
                                        SizedBox(width: 6),
                                        Text(
                                          'FREE',
                                          style: AppTextStyles.textBold(
                                            size: 12,
                                            color: AppColors.dark,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenHeight > 900 ? 12 : 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                businessName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.textBold(
                                  size: 16,
                                  color: AppColors.dark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight > 900 ? 21 : 18),
                        Row(
                          children: [
                            _infoBadge(
                              icon: FaIcon(FontAwesomeIcons.solidStar, size: 12, color: AppColors.dark),
                              label: '${businessRating.toStringAsFixed(1)}/5',
                            ),
                            if (businessDistance != null) ...[
                              const SizedBox(width: 4),
                              _infoBadge(
                                icon: const Icon(Icons.location_on, size: 12, color: AppColors.dark),
                                label: '${businessDistance!.toStringAsFixed(2)} km',
                              ),
                            ],
                            if (businessEstimatedDelivery != null) ...[
                              const SizedBox(width: 4),
                              _infoBadge(
                                icon: const Icon(Icons.timer, size: 12, color: AppColors.dark),
                                label: businessEstimatedDelivery!,
                              ),
                            ],
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
                  style: AppTextStyles.textMedium(
                    size: 14,
                    color: AppColors.dark,
                  ),
                ),
              ),
            ),
            
            // Make divider appear only if formattedOpen and formattedClose are not null
            if (formattedOpen != null && formattedClose != null)
              const Divider(height: 1, thickness: 1, color: AppColors.dark),

            // Section 3: Open-Close Hours
            if (formattedOpen != null && formattedClose != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Center(
                  child: Text(
                    // Add handling if 00:00 - 23:59 then change text to "Buka 24 Jam"
                    formattedOpen == '00:00' && formattedClose == '23:59'
                        ? 'Buka 24 Jam'
                        : '$formattedOpen - $formattedClose',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textMedium(
                      size: 14,
                      color: AppColors.dark,
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
          Text(
            label,
            style: AppTextStyles.textMedium(
              size: 14,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}