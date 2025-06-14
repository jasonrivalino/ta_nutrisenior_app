import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

import '../../utils/format_currency.dart';

class CardList extends StatefulWidget {
  final String? businessImage;
  final String? businessName;
  final String businessType;
  final double? businessRate;
  final double? businessLocation;
  final bool? isOpen;
  final String? productImage;
  final String? productName;
  final int? productPrice;
  final int? discountNumber;
  final bool? isFreeShipment;
  final VoidCallback onTap;

  const CardList({
    super.key,
    this.businessImage,
    this.businessName,
    required this.businessType,
    this.businessRate,
    this.businessLocation,
    this.isOpen = true,
    this.productImage,
    this.productName,
    this.productPrice,
    this.discountNumber,
    this.isFreeShipment,
    required this.onTap,
  });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  int _count = 0;

  void _incrementCount() {
    setState(() {
      _count++;
    });
  }

  void _decrementCount() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isOpen = widget.isOpen ?? true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isOpen ? widget.onTap : null,
        hoverColor: AppColors.soapstone.withAlpha(80),
        splashColor: AppColors.darkGray.withAlpha(50),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isOpen ? AppColors.ecruWhite : AppColors.lightGray,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: AppColors.darkGray,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // [Image and Badge Stack same as before]
              Stack(
                children: [
                  Container(
                    width: widget.businessName != null ? 85 : 65,
                    height: widget.businessName != null ? 85 : 65,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.darkGray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ColorFiltered(
                        colorFilter: isOpen
                            ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
                            : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                        child: Image.asset(
                          widget.businessImage ?? widget.productImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            String fallbackImage = 'assets/images/dummy/errorhandling/dummyrestaurant.png';

                            if (widget.businessType == 'restaurant' && widget.businessImage != null) {
                              fallbackImage = 'assets/images/dummy/errorhandling/dummyrestaurant.png';
                            } else if (widget.businessType == 'market' && widget.businessImage != null) {
                              fallbackImage = 'assets/images/dummy/errorhandling/dummymarket.png';
                            } else if (widget.businessType == 'restaurant' && widget.productImage != null) {
                              fallbackImage = 'assets/images/dummy/errorhandling/dummyfood.png';
                            } else if (widget.businessType == 'market' && widget.productImage != null) {
                              fallbackImage = 'assets/images/dummy/errorhandling/dummyingredient.png';
                            }

                            return Image.asset(
                              fallbackImage,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (!isOpen)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(120),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Tutup',
                          style: TextStyle(
                            color: AppColors.soapstone,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.fontBold,
                          ),
                        ),
                      ),
                    ),
                  if ((widget.discountNumber != null || (widget.isFreeShipment ?? false)) && isOpen)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 85,
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
                        child: widget.discountNumber != null
                            ? Text(
                                'Diskon ${widget.discountNumber}%',
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.businessName != null) ...[
                      Text(
                        widget.businessName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                          fontSize: 17,
                          height: screenHeight > 900 ? 1.35 : 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (widget.businessRate != null)
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
                                  const FaIcon(FontAwesomeIcons.solidStar, size: 12, color: AppColors.dark),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${widget.businessRate!.toStringAsFixed(1)}/5',
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
                          if (widget.businessLocation != null)
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
                                  const Icon(Icons.location_on, size: 16, color: AppColors.dark),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${widget.businessLocation!.toStringAsFixed(2)} km',
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
                    ] else if (widget.productName != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.productName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.fontBold,
                                    fontSize: 17,
                                    height: screenHeight > 900 ? 1.35 : 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                if (widget.productPrice != null)
                                  Text(
                                    formatCurrency(widget.productPrice!),
                                    style: const TextStyle(
                                      color: AppColors.dark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.fontBold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _count == 0
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10), // adjust gap size as needed
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.darkGray),
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.soapstone,
                                  ),
                                  child: InkWell(
                                    onTap: _incrementCount,
                                    borderRadius: BorderRadius.circular(20),
                                    child: const Icon(
                                      Icons.add,
                                      size: 20,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.darkGray),
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.soapstone,
                                    ),
                                    child: InkWell(
                                      onTap: _decrementCount,
                                      borderRadius: BorderRadius.circular(6),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$_count',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.darkGray),
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.soapstone,
                                    ),
                                    child: InkWell(
                                      onTap: _incrementCount,
                                      borderRadius: BorderRadius.circular(6),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ],
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