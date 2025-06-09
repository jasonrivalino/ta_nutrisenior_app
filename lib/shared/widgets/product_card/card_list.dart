import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

class CardList extends StatelessWidget {
  final String businessImage;
  final String businessName;
  final double businessRate;
  final double businessLocation;
  final int? discountNumber;
  final bool isFreeShipment;
  final VoidCallback onTap;

  const CardList({
    super.key,
    required this.businessImage,
    required this.businessName,
    required this.businessRate,
    required this.businessLocation,
    this.discountNumber,
    required this.isFreeShipment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ecruWhite,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.soapstone.withValues(alpha: 0.3),
        splashColor: AppColors.darkGray.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: AppColors.darkGray,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.darkGray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        businessImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (discountNumber != null || isFreeShipment)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 85, // Match the image width
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.orangyYellow,
                          border: Border.all(color: AppColors.darkGray, width: 1),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: discountNumber != null
                            ? Text(
                                'Diskon $discountNumber%',
                                style: const TextStyle(
                                  color: AppColors.dark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  FaIcon(FontAwesomeIcons.personBiking, size: 12, color: AppColors.dark),
                                  SizedBox(width: 6),
                                  Text(
                                    'FREE',
                                    style: TextStyle(
                                      color: AppColors.dark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 15),
              // Info section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      businessName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                        fontSize: 16,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.soapstone,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.dark, width: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(FontAwesomeIcons.solidStar, size: 12, color: AppColors.dark),
                              const SizedBox(width: 3),
                              Text(
                                '${businessRate.toStringAsFixed(1)}/5',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.fontMedium,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.soapstone,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.dark, width: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, size: 16, color: AppColors.dark),
                              const SizedBox(width: 3),
                              Text(
                                '${businessLocation.toStringAsFixed(2)} km',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.fontMedium,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}