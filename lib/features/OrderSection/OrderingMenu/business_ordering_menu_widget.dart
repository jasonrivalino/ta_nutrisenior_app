import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';
import '../../../shared/utils/formatted_time.dart';
import '../../../shared/widgets/list_helper/list_title.dart';
import '../../../shared/widgets/product_card/card_box.dart';
import '../../../shared/widgets/product_card/card_list.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
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
    final formattedOpen = businessOpenHour != null ? formatHours(businessOpenHour!) : null;
    final formattedClose = businessCloseHour != null ? formatHours(businessCloseHour!) : null;

    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
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
                            child: Image.asset(
                              businessImage,
                              height: screenHeight > 900 ? 70 : 65,
                              width: screenHeight > 900 ? 70 : 65,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                String fallbackImage = 'assets/images/dummy/errorhandling/dummyrestaurant.png';
                                if (businessType == 'market') {
                                  fallbackImage = 'assets/images/dummy/errorhandling/dummymarket.png';
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
                        if (discountNumber != null || (isFreeShipment != null && isFreeShipment!))
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
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
                                      'Disc $discountNumber%',
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.fontMedium,
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

class RecommendedProductSection extends StatelessWidget {
  final String title;
  final double heightCard;
  final String businessType;
  final List<Map<String, dynamic>> products;

  const RecommendedProductSection({
    super.key,
    required this.title,
    required this.heightCard,
    required this.businessType,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    print("RecommendedProductSection: $title, businessType: $businessType, products: ${products.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTitle(title: title),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Rekomendasi produk saat ini belum tersedia",
              style: TextStyle(fontSize: 14, color: AppColors.dark),
            ),
          )
        else
          SizedBox(
            height: heightCard,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              itemCount: products.take(5).length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.425,
                  child: CardBox(
                    businessType: businessType,
                    productImage: product['product_image'],
                    productName: product['product_name'],
                    productPrice: product['product_price'],
                    onTap: () {
                      print("Tapped product: ${product['product_name']}");
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class ProductListWidget extends StatelessWidget {
  final String? title;
  final String businessType;
  final List<Map<String, dynamic>> products;

  const ProductListWidget({
    super.key,
    required this.title,
    required this.businessType,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          ListTitle(title: title!),
          const SizedBox(height: 17.5),
        ],
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Daftar produk saat ini belum tersedia",
              style: TextStyle(fontSize: 14, color: AppColors.dark),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.darkGray,
                  width: 0.5,
                ),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // disable nested scroll
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return CardList(
                  businessType: businessType,
                  productImage: product['product_image'],
                  productName: product['product_name'],
                  productPrice: product['product_price'],
                  onTap: () {
                    print("Tapped product: ${product['product_name']}");
                  },
                );
              },
            ),
          ),
        const SizedBox(height: 5),
      ],
    );
  }
}