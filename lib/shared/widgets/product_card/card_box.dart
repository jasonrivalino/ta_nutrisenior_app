import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/utils/format_currency.dart';
import '../../styles/fonts.dart';

class CardBox extends StatefulWidget {
  final int? businessId;
  final String? businessImage;
  final String? businessName;
  final String businessType;
  final double? businessRate;
  final double? businessLocation;
  final int? productId;
  final String? productImage;
  final String? productName;
  final int? productPrice;
  final String? productDescription;
  final int? discountNumber;
  final int? count;
  final String? notes;
  final ValueChanged<int>? onCountChanged;
  final ValueChanged<String>? onNotesChanged;
  final List<Map<String, dynamic>>? addOns;
  final VoidCallback onTap;

  const CardBox({
    super.key,
    this.businessId,
    this.businessImage,
    this.businessName,
    required this.businessType,
    this.businessRate,
    this.businessLocation,
    this.productId,
    this.productImage,
    this.productName,
    this.productPrice,
    this.productDescription,
    this.discountNumber,
    required this.onTap,
    this.count = 0,
    this.notes = '',
    this.onCountChanged,
    this.addOns,
    this.onNotesChanged,
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

  // Step 2: Add these methods inside the class
  void _incrementCount() async {
    // If count is 0, open detail page instead
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
          'add_ons': widget.addOns,
        },
      );

      if (result != null) {
        final newQty = result['qty_product'] ?? 0;
        final notes = result['notes'] ?? '';
        if (widget.onCountChanged != null) {
          widget.onCountChanged!(newQty);
        }
        if (widget.onNotesChanged != null) {
          widget.onNotesChanged!(notes);
        }
      }
    } else {
      // If count is already > 0, just increment
      if (widget.onCountChanged != null) {
        widget.onCountChanged!(widget.count! + 1);
      }
    }
  }

  void _decrementCount() {
    if (widget.count! > 0) {
      widget.onCountChanged!(widget.count! - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = (screenHeight * 0.10).clamp(100.0, 120.0);

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
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ]
              : [
                  const BoxShadow(
                    color: Colors.black12,
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
                    Image.asset(
                      widget.businessImage ?? widget.productImage!,
                      height: imageHeight,
                      width: double.infinity,
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
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
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
                              color: AppColors.orangyYellow,
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
                                  color: Colors.black,
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
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: _incrementCount,
                                  borderRadius: BorderRadius.circular(14),
                                  child: const Icon(Icons.add, size: 16, color: AppColors.dark),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.soapstone,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _decrementCount,
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
                                      onTap: _incrementCount,
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
                            fontSize: 17,
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
                            fontSize: 17,
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