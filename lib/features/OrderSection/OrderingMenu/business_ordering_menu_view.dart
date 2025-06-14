import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
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
  });

  static BusinessOrderingMenuView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;
    print('BusinessOrderingMenuView.fromExtra: $extra');

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

  @override
  void initState() {
    super.initState();
    isFavorite = FavoritesBusinessController.isBusinessFavorited(widget.businessId);
    _loadRecommendedProducts();
  }

  Future<void> _loadRecommendedProducts() async {
    final productMap = await BusinessOrderingMenuController.fetchProducts(widget.businessId);
    setState(() {
      recommendedProducts = productMap['recommendedProducts'] ?? [];
      allProducts = productMap['allProducts'] ?? [];
      isLoading = false;
    });
  }

  int get totalSelectedPrice {
    final uniqueProducts = <String, Map<String, dynamic>>{};

    // Merge both product lists, using product_id as the key to avoid duplicates
    for (final product in recommendedProducts + allProducts) {
      final id = product['product_id'].toString();
      uniqueProducts[id] = product; // overwrites duplicates, which is fine
    }

    num total = 0;
    for (final entry in uniqueProducts.entries) {
      final id = entry.key;
      final product = entry.value;
      final count = selectedProductCounts[id] ?? 0;
      final price = product['product_price'] ?? 0;
      total += count * price;
    }

    return total.toInt(); // final cast
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
            // Background image
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  widget.businessImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    final fallbackImage = widget.businessType == 'market'
                        ? 'assets/images/dummy/errorhandling/dummymarket.png'
                        : 'assets/images/dummy/errorhandling/dummyrestaurant.png';

                    return Image.asset(
                      fallbackImage,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            // Foreground content
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
                          ? "Restoran berhasil ditambahkan ke favorit!"
                          : "Restoran dihapus dari daftar favorit!",
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
                  discountNumber: widget.discountNumber,
                  isFreeShipment: widget.isFreeShipment,
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
                                heightCard: 200,
                                businessId: widget.businessId,
                                businessType: widget.businessType,
                                products: recommendedProducts,
                                selectedCounts: selectedProductCounts,
                                selectedNotes: selectedProductNotes,
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
                              ),
                              const SizedBox(height: 14),
                              ProductListWidget(
                                title: widget.businessType == 'restaurant'
                                    ? 'Daftar Menu'
                                    : 'Daftar Belanjaan',
                                businessId: widget.businessId,
                                businessType: widget.businessType,
                                products: allProducts,
                                selectedCounts: selectedProductCounts,
                                selectedNotes: selectedProductNotes,
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
            onOrderPressed: () {
              final selectedEntries = selectedProductCounts.entries
                  .where((entry) => entry.value > 0)
                  .toList();

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

                if (product != null) {
                  final name = product['product_name'];
                  final price = product['product_price'];

                  selectedProducts.add({
                    'product_id': productId,
                    'product_name': name,
                    'product_price': price,
                    'qty_product': qty,
                    'notes': notes,
                  });
                }
              }

              context.push(
                '/business/detail/${widget.businessId}/confirm',
                extra: {
                  'selected_products': selectedProducts,
                  'service_fee': widget.serviceFee,
                  'total_price': totalSelectedPrice,
                },
              );
            },
          )
        : null,
    );
  }
}