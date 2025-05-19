import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart'; // Customize this path as needed
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';  // Customize this path as needed

class CardList extends StatelessWidget {
  final String image;
  final String name;
  final String type;
  final double rate;
  final double location;
  final int? percentage;
  final VoidCallback? onTap; // <- Add this for tap handling

  const CardList({
    super.key,
    required this.image,
    required this.name,
    required this.type,
    required this.rate,
    required this.location,
    this.percentage,
    this.onTap,
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
              // Image section
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  image,
                  width: 85,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),

              // Info section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
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
                        _infoBadge(
                          icon: const FaIcon(FontAwesomeIcons.solidStar, size: 12, color: AppColors.dark),
                          text: '${rate.toStringAsFixed(1)}/5',
                        ),
                        const SizedBox(width: 8),
                        _infoBadge(
                          icon: const Icon(Icons.location_on, size: 16, color: AppColors.dark),
                          text: '${location.toStringAsFixed(2)} km',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Optional discount badge
              if (percentage != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$percentage% OFF",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBadge({required Widget icon, required String text}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.soapstone,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dark, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.fontMedium,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}