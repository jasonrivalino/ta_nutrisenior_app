import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/utils/is_business_open.dart';
import '../../../shared/widgets/detail_card/card_box.dart';
import '../../../shared/widgets/detail_card/card_list.dart';
import '../../../shared/widgets/list_helper/list_title.dart';

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
                  icon: const FaIcon(FontAwesomeIcons.solidStar, size: 16, color: AppColors.amber),
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

class RecommendedProductSection extends StatelessWidget {
  final String title;
  final double heightCard;
  final int businessId;
  final String businessType;
  final DateTime businessOpenHour;
  final DateTime businessCloseHour;
  final int? discountNumber;
  final List<Map<String, dynamic>> products;
  final Map<String, int> selectedCounts;
  final Map<String, String> selectedNotes;
  final Map<String, List<int>> selectedAddOnIdsMap;
  final Function(String productId, int newCount) onCountChanged;
  final Function(String productId, String notes)? onNotesChanged;
  final Function(String productId, List<int> newSelectedAddOnIds)? onAddOnsChanged;

  const RecommendedProductSection({
    super.key,
    required this.title,
    required this.heightCard,
    required this.businessId,
    required this.businessType,
    required this.businessOpenHour,
    required this.businessCloseHour,
    this.discountNumber,
    required this.products,
    required this.selectedCounts,
    required this.selectedNotes,
    required this.selectedAddOnIdsMap,
    required this.onCountChanged,
    this.onNotesChanged,
    this.onAddOnsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTitle(
                title: title,
                businessOpenHour: businessOpenHour,
                businessCloseHour: businessCloseHour,
              ),
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
                final productId = product['product_id'].toString();
                final currentCount = selectedCounts[productId] ?? 0;
                final currentNotes = selectedNotes[productId] ?? '';

                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.425,
                  child: CardBox(
                    businessId: businessId,
                    businessType: businessType,
                    businessOpenHour: businessOpenHour,
                    businessCloseHour: businessCloseHour,
                    discountNumber: discountNumber,
                    productId: product['product_id'],
                    productImage: product['product_image'],
                    productName: product['product_name'],
                    productPrice: product['product_price'],
                    productDescription: product['product_description'],
                    count: currentCount,
                    notes: currentNotes,
                    addOnsSelection: selectedAddOnIdsMap,
                    onCountChanged: (newCount) => onCountChanged(productId, newCount),
                    onNotesChanged: (notes) {
                      if (onNotesChanged != null) {
                        onNotesChanged!(productId, notes);
                      }
                    },
                    onAddOnsChanged: (Map<String, List<int>> selectedAddOns) {
                      if (onAddOnsChanged != null) {
                        // Extract relevant list for this product only
                        final updatedAddOnIds = selectedAddOns[productId] ?? [];
                        onAddOnsChanged!(productId, updatedAddOnIds);
                      }
                    },
                    onTap: () async {
                      // Add handling if business is closed
                      if (!isBusinessOpen(businessOpenHour, businessCloseHour)) {
                        return;
                      }

                      final route = '/business/detail/$businessId/ordering/$productId';

                      print('Navigating to: $route');

                      final result = await context.push<Map<String, dynamic>>(route, extra: {
                        'business_id': businessId,
                        'business_type': businessType,
                        'discount_number': discountNumber,
                        'product_id': product['product_id'],
                        'product_image': product['product_image'],
                        'product_name': product['product_name'],
                        'product_price': product['product_price'],
                        'product_description': product['product_description'],
                        'qty_product': currentCount,
                        'notes': currentNotes,
                        'add_ons': selectedAddOnIdsMap,
                      });

                      if (result != null) {
                        final returnedProductId = result['product_id'].toString();
                        final newQty = result['qty_product'] ?? 0;
                        final notes = result['notes'] ?? '';
                        final addOnsResult = result['add_ons'] as Map<String, dynamic>?;

                        print('Returned from detail: productId: $returnedProductId, qty: $newQty, notes: $notes, add_ons: $addOnsResult');

                        onCountChanged(returnedProductId, newQty);

                        if (onNotesChanged != null) {
                          onNotesChanged!(returnedProductId, notes);
                        }

                        if (onAddOnsChanged != null && addOnsResult != null) {
                          // Extract relevant list for this product only
                          final updatedAddOnIds = List<int>.from(
                            addOnsResult[returnedProductId] ?? [],
                          );
                          onAddOnsChanged!(returnedProductId, updatedAddOnIds);
                        }
                      }
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

class ProductListSection extends StatelessWidget {
  final String? title;
  final int businessId;
  final String businessType;
  final DateTime businessOpenHour;
  final DateTime businessCloseHour;
  final int? discountNumber;
  final List<Map<String, dynamic>> products;
  final Map<String, int> selectedCounts;
  final Map<String, String> selectedNotes;
  final Map<String, List<int>> selectedAddOnIdsMap;
  final Function(String productId, int newCount) onCountChanged;
  final Function(String productId, String notes)? onNotesChanged;
  final Function(String productId, List<int> newSelectedAddOnIds)? onAddOnsChanged;

  const ProductListSection({
    super.key,
    required this.title,
    required this.businessId,
    required this.businessType,
    required this.businessOpenHour,
    required this.businessCloseHour,
    this.discountNumber,
    required this.products,
    required this.selectedCounts,
    required this.selectedNotes,
    required this.selectedAddOnIdsMap,
    required this.onCountChanged,
    this.onNotesChanged,
    this.onAddOnsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTitle(
          title: title!,
          businessOpenHour: businessOpenHour,
          businessCloseHour: businessCloseHour,
        ),
        const SizedBox(height: 12),
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
                  final productId = product['product_id'].toString();
                  final currentCount = selectedCounts[productId] ?? 0;
                  final currentNotes = selectedNotes[productId] ?? '';
                  final isOpen = isBusinessOpen(businessOpenHour, businessCloseHour);

                return CardList(
                  businessId: businessId,
                  businessType: businessType,
                  isOpen: isOpen,
                  discountNumber: discountNumber,
                  productId: product['product_id'],
                  productImage: product['product_image'],
                  productName: product['product_name'],
                  productPrice: product['product_price'],
                  productDescription: product['product_description'],
                  count: currentCount,
                  notes: currentNotes,
                  addOnsSelection: selectedAddOnIdsMap,
                  onCountChanged: (newCount) => onCountChanged(productId, newCount),
                  onNotesChanged: (notes) {
                    if (onNotesChanged != null) {
                      onNotesChanged!(productId, notes);
                    }
                  },
                  onAddOnsChanged: (Map<String, List<int>> selectedAddOns) {
                    if (onAddOnsChanged != null) {
                      // Extract relevant list for this product only
                      final updatedAddOnIds = selectedAddOns[productId] ?? [];
                      onAddOnsChanged!(productId, updatedAddOnIds);
                    }
                  },
                  onTap: () async {
                    // Add handling if business is closed
                    if (!isBusinessOpen(businessOpenHour, businessCloseHour)) {
                      return;
                    }

                    final route = '/business/detail/$businessId/ordering/$productId';

                    print('Navigating to: $route');

                    final result = await context.push<Map<String, dynamic>>(route, extra: {
                      'business_id': businessId,
                      'business_type': businessType,
                      'discount_number': discountNumber,
                      'product_id': product['product_id'],
                      'product_image': product['product_image'],
                      'product_name': product['product_name'],
                      'product_price': product['product_price'],
                      'product_description': product['product_description'],
                      'qty_product': currentCount,
                      'notes': currentNotes,
                      'add_ons': selectedAddOnIdsMap,
                    });

                    if (result != null) {
                      final returnedProductId = result['product_id'].toString();
                      final newQty = result['qty_product'] ?? 0;
                      final notes = result['notes'] ?? '';
                      final addOnsResult = result['add_ons'] as Map<String, dynamic>?;

                      print('Returned from detail: productId: $returnedProductId, qty: $newQty, notes: $notes');

                      onCountChanged(returnedProductId, newQty);
                      if (onNotesChanged != null) {
                        onNotesChanged!(returnedProductId, notes);
                      }
                      if (onAddOnsChanged != null && addOnsResult != null) {
                        // Extract relevant list for this product only
                        final updatedAddOnIds = List<int>.from(
                          addOnsResult[returnedProductId] ?? [],
                        );
                        onAddOnsChanged!(returnedProductId, updatedAddOnIds);
                      }
                    }
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