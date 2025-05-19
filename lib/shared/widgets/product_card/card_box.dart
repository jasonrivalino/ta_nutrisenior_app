import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import '../../styles/fonts.dart';

class CardBox extends StatefulWidget {
  final String image;
  final String name;
  final String type;
  final double rate;
  final double location;
  final int? percentage;

  const CardBox({
    super.key,
    required this.image,
    required this.name,
    required this.type,
    required this.rate,
    required this.location,
    this.percentage,
  });

  @override
  State<CardBox> createState() => _CardBoxState();
}

class _CardBoxState extends State<CardBox> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Print
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = (screenHeight * 0.10).clamp(100.0, 120.0);

    // Print the height of the image
    print('Image Height: $imageHeight');

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          color: AppColors.soapstone,
          elevation: 0, // Use shadow from AnimatedContainer instead
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Image.asset(
                      widget.image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (widget.percentage != null)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Transform.translate(
                          offset: const Offset(0, -2), // Offset upwards by 2 pixels
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.orangyYellow,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.dark,
                              width: 1,
                            ),
                          ),
                          child: Transform.rotate(
                            angle: -5 * (22/7) / 180,
                            child: Text(
                              '${widget.percentage}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: AppFonts.fontBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                          fontSize: 17,
                          height: screenHeight > 900 ? 1.35 : 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(FontAwesomeIcons.solidStar, size: 12, color: AppColors.dark),
                                const SizedBox(width: 3),
                                Text(
                                  '${widget.rate.toStringAsFixed(1)}/5',
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
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, size: 16, color: AppColors.dark),
                                const SizedBox(width: 2),
                                Text(
                                  '${widget.location.toStringAsFixed(2)} km',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}