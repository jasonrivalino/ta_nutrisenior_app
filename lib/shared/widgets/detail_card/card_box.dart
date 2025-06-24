import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../config/constants.dart';

import '../../styles/colors.dart';
import '../../styles/fonts.dart';
import '../../utils/format_currency.dart';
import '../../utils/is_business_open.dart';

class CardBox extends StatefulWidget {
  final int? businessId;
  final String? businessImage;
  final String? businessName;
  final String businessType;
  final double? businessRate;
  final double? businessLocation;
  final DateTime businessOpenHour;
  final DateTime businessCloseHour;
  final int? productId;
  final String? productImage;
  final String? productName;
  final int? productPrice;
  final String? productDescription;
  final int? discountNumber;
  final int count;
  final String notes;
  final Map<String, List<int>> addOnsSelection;
  final ValueChanged<int>? onCountChanged;
  final ValueChanged<String>? onNotesChanged;
  final void Function(Map<String, List<int>>)? onAddOnsChanged;
  final VoidCallback onTap;

  const CardBox({
    super.key,
    this.businessId,
    this.businessImage,
    this.businessName,
    required this.businessType,
    this.businessRate,
    this.businessLocation,
    required this.businessOpenHour,
    required this.businessCloseHour,
    this.productId,
    this.productImage,
    this.productName,
    this.productPrice,
    this.productDescription,
    this.discountNumber,
    required this.onTap,
    this.count = 0,
    this.notes = '',
    this.addOnsSelection = const {},
    this.onCountChanged,
    this.onNotesChanged,
    this.onAddOnsChanged,
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

  void _incrementCount() async {
    if (widget.count == 0) {
      final result = await context.push<Map<String, dynamic>>(
        '/business/detail/${widget.businessId}/ordering/${widget.productId}',
        extra: {
          'business_id': widget.businessId,
          'business_type': widget.businessType,
          'discount_number': widget.discountNumber,
          'product_id': widget.productId,
          'product_image': widget.productImage,
          'product_name': widget.productName,
          'product_price': widget.productPrice,
          'product_description': widget.productDescription,
          'qty_product': widget.count,
          'notes': widget.notes,
          'add_ons': widget.addOnsSelection,
        },
      );

      if (result != null) {
        final newQty = result['qty_product'] ?? 0;
        final notes = result['notes'] ?? '';
        final rawSelectedAddOns = result['add_ons'] ?? {};

        if (widget.onCountChanged != null) {
          widget.onCountChanged!(newQty);
        }

        if (widget.onNotesChanged != null) {
          widget.onNotesChanged!(notes);
          print('Notes changed: $notes');
        }

        if (widget.onAddOnsChanged != null && rawSelectedAddOns is Map) {
          try {
            final castedAddOns = rawSelectedAddOns.map<String, List<int>>(
              (key, value) => MapEntry(
                key.toString(),
                List<int>.from(value),
              ),
            );

            widget.onAddOnsChanged!(castedAddOns);
            print('Add-ons changed: $castedAddOns');
          } catch (e) {
            print('Error parsing add-ons map: $e');
          }
        }
      }
    } else {
      if (widget.onCountChanged != null) {
        widget.onCountChanged!(widget.count + 1);
      }
    }
  }

  void _decrementCount() {
    if (widget.count > 0) {
      final newCount = widget.count - 1;
      widget.onCountChanged!(newCount);

      if (newCount == 0) {
        // Clear add-ons
        if (widget.onAddOnsChanged != null) {
          widget.onAddOnsChanged!({widget.productId.toString(): []});
        }

        // Clear notes
        if (widget.onNotesChanged != null) {
          widget.onNotesChanged!('');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = (screenHeight * 0.10).clamp(100.0, 120.0);

    final isOpen = isBusinessOpen(
      widget.businessOpenHour,
      widget.businessCloseHour,
    );

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTap();
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: AppColors.dark.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: AppColors.dark.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          color: AppColors.soapstone,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Builder(
                      builder: (context) {
                        final imagePath = widget.businessImage ?? widget.productImage!;
                        String fallbackImage = AppConstants.errorDummyRestaurant;

                        if (widget.businessType == 'restaurant' && widget.businessImage != null) {
                          fallbackImage = AppConstants.errorDummyRestaurant;
                        } else if (widget.businessType == 'market' && widget.businessImage != null) {
                          fallbackImage = AppConstants.errorDummyMarket;
                        } else if (widget.businessType == 'restaurant' && widget.productImage != null) {
                          fallbackImage = AppConstants.errorDummyFood;
                        } else if (widget.businessType == 'market' && widget.productImage != null) {
                          fallbackImage = AppConstants.errorDummyIngredient;
                        }

                        return ColorFiltered(
                          colorFilter: isOpen
                              ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
                              : const ColorFilter.mode(AppColors.darkGray, BlendMode.saturation),
                          child: Image.asset(
                            imagePath,
                            height: imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                fallbackImage,
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        );
                      },
                    ),

                    if (!isOpen && widget.businessImage != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.persianRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'TUTUP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.fontBold,
                            ),
                          ),
                        ),
                      ),

                    if (widget.discountNumber != null && widget.businessImage != null) 
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Transform.translate(
                          offset: const Offset(0, -2),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isOpen ? AppColors.orangyYellow : AppColors.darkGray,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.dark, width: 1),
                            ),
                            child: Transform.rotate(
                              angle: -5 * (22 / 7) / 180,
                              child: Text(
                                '${widget.discountNumber}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.dark,
                                  fontFamily: AppFonts.fontBold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Updated: Counter display and buttons
                    if (widget.productImage != null)
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: widget.count == 0
                            ? Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.soapstone,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.dark.withValues(alpha: 0.15),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: isOpen ? _incrementCount : null,
                                  borderRadius: BorderRadius.circular(14),
                                  child: const Icon(Icons.add, size: 16, color: AppColors.dark),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.soapstone,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.dark.withValues(alpha: 0.15),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: isOpen ? _decrementCount : null,
                                      child: const Icon(Icons.remove, size: 16, color: AppColors.dark),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${widget.count}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: AppFonts.fontBold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: isOpen ? _incrementCount : null,
                                      child: const Icon(Icons.add, size: 16, color: AppColors.dark),
                                    ),
                                  ],
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
                      // If it's a business (with name), show business layout
                      if (widget.businessName != null) ...[
                        Text(
                          widget.businessName!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.fontBold,
                            fontSize: 18,
                            height: screenHeight > 900 ? 1.35 : 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            if (widget.businessRate != null)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray,
                                  borderRadius: BorderRadius.circular(8),
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
                                  color: AppColors.lightGray,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: AppColors.dark),
                                    const SizedBox(width: 2),
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
                      ]
                      // Otherwise, if it's a product (no businessName, but has productName), show product layout
                      else if (widget.productName != null) ...[
                        Text(
                          widget.productName!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.fontBold,
                            fontSize: 18,
                            height: screenHeight > 900 ? 1.35 : 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        if (widget.productPrice != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: widget.discountNumber != null
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatCurrency(
                                          (widget.productPrice! * (100 - widget.discountNumber!) ~/ 100),
                                        ),
                                        style: const TextStyle(
                                          color: AppColors.dark,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: AppFonts.fontBold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        formatCurrency(widget.productPrice!),
                                        style: const TextStyle(
                                          color: AppColors.darkGray,
                                          fontSize: 13,
                                          decoration: TextDecoration.lineThrough,
                                          fontFamily: AppFonts.fontMedium,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    formatCurrency(widget.productPrice!),
                                    style: const TextStyle(
                                      color: AppColors.dark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.fontBold,
                                    ),
                                  ),
                          ),
                      ],
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