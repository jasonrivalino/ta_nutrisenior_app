import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../database/business_promo_list_table.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/utils/get_total_add_ons_price.dart';
import 'business_ordering_menu_controller.dart';
import 'business_ordering_menu_widget.dart';

class BusinessOrderingMenuView extends StatefulWidget {
  final int businessId;
  final String businessName;
  final String businessType;
  final String businessImage;
  final double businessRating;
  final double businessDistance;
  final String businessAddress;
  final DateTime businessOpenHour;
  final DateTime businessCloseHour;
  final String businessEstimatedDelivery;
  final int? discountNumber;
  final bool isFreeShipment;
  final int serviceFee;
  final int? productId;
  final int? qtyProduct;
  final String? notes;
  final List<int>? addOns;
  final int? selectedAddressId;

  const BusinessOrderingMenuView({
    super.key,
    required this.businessId,
    required this.businessName,
    required this.businessType,
    required this.businessImage,
    required this.businessRating,
    required this.businessDistance,
    required this.businessAddress,
    required this.businessOpenHour,
    required this.businessCloseHour,
    required this.businessEstimatedDelivery,
    this.discountNumber,
    required this.isFreeShipment,
    required this.serviceFee,
    this.productId,
    this.qtyProduct,
    this.notes,
    this.addOns,
    this.selectedAddressId,
  });

  static BusinessOrderingMenuView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    return BusinessOrderingMenuView(
      businessId: extra['business_id'] as int,
      businessName: extra['business_name'] as String,
      businessType: extra['business_type'] as String,
      businessImage: extra['business_image'] as String,
      businessRating: extra['business_rating'] as double,
      businessDistance: extra['business_distance'] as double,
      businessAddress: extra['business_address'] as String,
      businessOpenHour: extra['business_open_hour'] as DateTime,
      businessCloseHour: extra['business_close_hour'] as DateTime,
      businessEstimatedDelivery: extra['estimated_delivery'] as String,
      discountNumber: extra['discount_number'] as int?,
      isFreeShipment: extra['is_free_shipment'] as bool,
      serviceFee: extra['service_fee'] as int,
      productId: extra['product_id'] as int?,
      qtyProduct: extra['qty_product'] as int?,
      notes: extra['notes'] as String?,
      addOns: extra['add_ons'] as List<int>?,
      selectedAddressId: extra['selected_address_id'] as int? ?? 1,
    );
  }

  @override
  State<BusinessOrderingMenuView> createState() => _BusinessOrderingMenuViewState();
}

class _BusinessOrderingMenuViewState extends State<BusinessOrderingMenuView> {
  bool isFavorite = false;
  bool isLoading = true;
  List<Map<String, dynamic>> recommendedProducts = [];
  List<Map<String, dynamic>> allProducts = [];

  Map<String, int> selectedProductCounts = {};
  Map<String, String> selectedProductNotes = {};
  Map<String, List<int>> selectedAddOnIds = {};

  int? discountNumber;
  bool isFreeShipment = false;

  // Flatten all available add-ons from products
  List<Map<String, dynamic>> get allAddOnsList {
    return (recommendedProducts + allProducts)
        .expand((product) {
          final pid = product['product_id'];
          final List<Map<String, dynamic>> productAddOns = List<Map<String, dynamic>>.from(product['add_ons'] ?? []);
          return productAddOns.map((addOn) => {
                ...addOn,
                'product_id': pid,
              });
        })
        .toList();
  }

  @override
  void initState() {
    super.initState();
    isFavorite = FavoritesBusinessController.isBusinessFavorited(widget.businessId);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productMap = await BusinessOrderingMenuController.fetchProducts(widget.businessId);

    setState(() {
      allProducts = productMap['allProducts'] ?? [];
      recommendedProducts = productMap['recommendedProducts'] ?? [];

      if (allProducts.isNotEmpty) {
        discountNumber = allProducts.first['discount_number'] as int?;
      }

      final promo = businessPromoListTable.firstWhere(
        (entry) => entry['business_id'] == widget.businessId,
        orElse: () => {},
      );
      isFreeShipment = promo['is_free_shipment'] as bool? ?? false;

      isLoading = false;
    });
  }

  // Total price includes product price + selected add-ons
  int get totalSelectedPrice {
    final uniqueProducts = <String, Map<String, dynamic>>{};
    for (final product in recommendedProducts + allProducts) {
      final id = product['product_id'].toString();
      uniqueProducts[id] = product;
    }

    num total = 0;
    final effectiveAddOnIds = <int>[];

    print("=== Product Price Calculation Debug ===");

    for (final entry in uniqueProducts.entries) {
      final id = entry.key;
      final product = entry.value;
      final count = selectedProductCounts[id] ?? 0;
      final price = product['discounted_price'] ?? product['product_price'] ?? 0;

      if (count > 0) {
        final subtotal = count * price;
        total += subtotal;

        // Only include add-ons for products with count > 0
        final addOnIds = selectedAddOnIds[id];
        if (addOnIds != null) {
          effectiveAddOnIds.addAll(addOnIds);
        }
      } else {
        // Clean up add-ons for products with 0 count
        if (selectedAddOnIds.containsKey(id)) {
          selectedAddOnIds.remove(id);
        }
      }
    }

    final totalAddOnsPrice = getTotalAddOnsPrice(
      addOns: allAddOnsList,
      selectedAddOnIds: effectiveAddOnIds,
    );

    print("Selected Add-On IDs: $effectiveAddOnIds");
    print("Add-Ons Total Price: $totalAddOnsPrice");

    total += totalAddOnsPrice;
    print("Final Total Price: $total");

    return total.toInt();
  }

  bool get hasSelectedProducts =>
      selectedProductCounts.values.any((count) => count > 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.soapstone,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      widget.businessImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        final fallbackImage = widget.businessType == 'market'
                            ? 'assets/images/dummy/errorhandling/dummymarket.png'
                            : 'assets/images/dummy/errorhandling/dummyrestaurant.png';
                        return Image.asset(fallbackImage, fit: BoxFit.cover);
                      },
                    ),
                    Container(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                BusinessHeaderBar(
                  isFavorite: isFavorite,
                  onFavoritesClick: () async {
                    final connectivityResult = await Connectivity().checkConnectivity();
                    if (connectivityResult.contains(ConnectivityResult.none)) {
                      Fluttertoast.showToast(
                        msg: "Gagal mengubah status favorit.\nSilahkan coba lagi.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }

                    setState(() {
                      FavoritesBusinessController.toggleFavorite(widget.businessId);
                      isFavorite = FavoritesBusinessController.isBusinessFavorited(widget.businessId);
                    });

                    Fluttertoast.showToast(
                      msg: isFavorite
                          ? widget.businessType == 'restaurant'
                              ? "Restoran berhasil ditambahkan ke daftar favorit!"
                              : "Pusat belanja berhasil ditambahkan ke daftar favorit!"
                          : widget.businessType == 'restaurant'
                              ? "Restoran dihapus dari daftar favorit!"
                              : "Pusat belanja dihapus dari daftar favorit!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  onRatingClick: () {
                    context.push('/business/detail/${widget.businessId}/review', extra: {
                      'business_id': widget.businessId,
                      'business_name': widget.businessName,
                      'business_type': widget.businessType,
                      'business_image': widget.businessImage,
                      'business_rating': widget.businessRating,
                      'business_address': widget.businessAddress,
                    });
                  },
                ),
                const SizedBox(height: 12),
                BusinessInfoCard(
                  businessImage: widget.businessImage,
                  businessName: widget.businessName,
                  businessType: widget.businessType,
                  businessAddress: widget.businessAddress,
                  businessEstimatedDelivery: widget.businessEstimatedDelivery,
                  businessRating: widget.businessRating,
                  businessDistance: widget.businessDistance,
                  businessOpenHour: widget.businessOpenHour,
                  businessCloseHour: widget.businessCloseHour,
                  discountNumber: discountNumber,
                  isFreeShipment: isFreeShipment,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              RecommendedProductSection(
                                title: widget.businessType == 'restaurant'
                                    ? 'Rekomendasi Menu'
                                    : 'Rekomendasi Belanjaan',
                                heightCard: (discountNumber != null) ? 220 : 200,
                                businessId: widget.businessId,
                                businessType: widget.businessType,
                                discountNumber: discountNumber,
                                products: recommendedProducts,
                                addOns: recommendedProducts
                                  .expand((product) {
                                    final pid = product['product_id'];
                                    final List<Map<String, dynamic>> productAddOns = List<Map<String, dynamic>>.from(product['add_ons'] ?? []);
                                    return productAddOns.map((addOn) => {
                                          ...addOn,
                                          'product_id': pid,
                                        });
                                  })
                                  .toList(),
                                selectedCounts: selectedProductCounts,
                                selectedNotes: selectedProductNotes,
                                selectedAddOnIdsMap: selectedAddOnIds,
                                onCountChanged: (productId, newCount) {
                                  setState(() {
                                    selectedProductCounts[productId] = newCount;
                                  });
                                },
                                onNotesChanged: (productId, notes) {
                                  setState(() {
                                    selectedProductNotes[productId] = notes;
                                  });
                                },
                                onAddOnsChanged: (productId, updatedAddOnIds) {
                                  setState(() {
                                    selectedAddOnIds[productId] = updatedAddOnIds;
                                  });
                                },
                              ),
                              const SizedBox(height: 14),
                              ProductListWidget(
                                title: widget.businessType == 'restaurant'
                                    ? 'Daftar Menu'
                                    : 'Daftar Belanjaan',
                                businessId: widget.businessId,
                                businessType: widget.businessType,
                                discountNumber: discountNumber,
                                products: allProducts,
                                addOns: allProducts
                                  .expand((product) {
                                    final pid = product['product_id'];
                                    final List<Map<String, dynamic>> productAddOns = List<Map<String, dynamic>>.from(product['add_ons'] ?? []);
                                    return productAddOns.map((addOn) => {
                                          ...addOn,
                                          'product_id': pid,
                                        });
                                  })
                                  .toList(),
                                selectedCounts: selectedProductCounts,
                                selectedNotes: selectedProductNotes,
                                selectedAddOnIdsMap: selectedAddOnIds,
                                onCountChanged: (productId, newCount) {
                                  setState(() {
                                    selectedProductCounts[productId] = newCount;

                                    if (newCount == 0) {
                                      selectedAddOnIds.remove(productId);
                                    }
                                  });
                                },
                                onNotesChanged: (productId, notes) {
                                  setState(() {
                                    selectedProductNotes[productId] = notes;
                                  });
                                },
                                onAddOnsChanged: (productId, updatedAddOnIds) {
                                  setState(() {
                                    selectedAddOnIds[productId] = updatedAddOnIds;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: hasSelectedProducts
          ? OrderBottomNavbar(
              totalPrice: totalSelectedPrice,
              buttonText: 'Konfirmasi Pesanan',
              onOrderPressed: () async {
                final selectedEntries = selectedProductCounts.entries.where((e) => e.value > 0).toList();
                if (selectedEntries.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Tidak ada produk yang dipilih.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  return;
                }

                final uniqueProducts = {
                  for (final product in recommendedProducts + allProducts)
                    product['product_id'].toString(): product,
                };

                final selectedProducts = <Map<String, dynamic>>[];
                for (final entry in selectedEntries) {
                  final productId = entry.key;
                  final qty = entry.value;
                  final notes = selectedProductNotes[productId] ?? '';
                  final product = uniqueProducts[productId];
                  final addOnIds = selectedAddOnIds[productId] ?? [];

                  // Match and get detailed add-on info
                  final seenAddOnIds = <int>{};
                  final detailedAddOns = allAddOnsList
                      .where((addOn) =>
                          addOn['product_id'].toString() == productId &&
                          addOnIds.contains(addOn['add_ons_id']))
                      .map((addOn) => {
                            'add_ons_id': addOn['add_ons_id'],
                            'add_ons_name': addOn['add_ons_name'],
                            'add_ons_price': addOn['add_ons_price'],
                          })
                      .where((addOn) => seenAddOnIds.add(addOn['add_ons_id'] as int))
                      .toList();

                  print("Detailed add-ons for product $productId: $detailedAddOns");

                  if (product != null) {
                    selectedProducts.add({
                      'product_id': productId,
                      'product_name': product['product_name'],
                      'product_image': product['product_image'],
                      'product_description': product['product_description'],
                      'product_price': product['discounted_price'] ?? product['product_price'],
                      'original_price': product['product_price'],
                      'qty_product': qty,
                      'notes': notes,
                      'add_ons': addOnIds, // Just the list of IDs
                      'add_ons_details': detailedAddOns,
                    });
                  }
                }

                final updated = await context.push<List<Map<String, dynamic>>>(
                  '/business/detail/${widget.businessId}/confirm',
                  extra: {
                    'selected_products': selectedProducts,
                    'service_fee': widget.serviceFee,
                    'business_id': widget.businessId,
                    'business_name': widget.businessName,
                    'business_type': widget.businessType,
                    'business_image': widget.businessImage,
                    'business_distance': widget.businessDistance,
                    'business_estimated_delivery': widget.businessEstimatedDelivery,
                    'discount_number': widget.discountNumber,
                    'is_free_shipment': isFreeShipment,
                    'total_price': totalSelectedPrice,
                    'selected_address_id': widget.selectedAddressId,
                  },
                );

                if (updated != null) {
                  setState(() {
                    selectedProductCounts.clear();
                    selectedProductNotes.clear();
                    selectedAddOnIds.clear();
                    for (final product in updated) {
                      final id = product['product_id'].toString();
                      selectedProductCounts[id] = product['qty_product'] ?? 0;
                      selectedProductNotes[id] = product['notes'] ?? '';
                      selectedAddOnIds[id] = product['add_ons'] ?? [];
                    }
                  });
                }
              },
            )
          : null,
    );
  }
}