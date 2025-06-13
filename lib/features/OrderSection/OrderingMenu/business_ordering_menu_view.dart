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
  });

  static BusinessOrderingMenuView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;

    print('BusinessOrderingMenuView.fromExtra: $extra');

    return BusinessOrderingMenuView(
      businessId: extra['business_id'],
      businessName: extra['business_name'],
      businessType: extra['business_type'],
      businessImage: extra['business_image'],
      businessRating: extra['business_rating'],
      businessDistance: extra['business_distance'],
      businessAddress: extra['business_address'],
      businessOpenHour: extra['business_open_hour'] as DateTime,
      businessCloseHour: extra['business_close_hour'] as DateTime,
      businessEstimatedDelivery: extra['estimated_delivery'],
      discountNumber: extra['discount_number'],
      isFreeShipment: extra['is_free_shipment'],
    );
  }

  @override
  State<BusinessOrderingMenuView> createState() => _BusinessOrderingMenuViewState();
}

class _BusinessOrderingMenuViewState extends State<BusinessOrderingMenuView> {
  bool isFavorite = false;
  List<Map<String, dynamic>> recommendedProducts = [];
  List<Map<String, dynamic>> allProducts = [];
  bool isLoading = true;

  Future<void> _loadRecommendedProducts() async {
    final productMap = await BusinessOrderingMenuController.fetchProducts(widget.businessId);
    setState(() {
      recommendedProducts = productMap['recommendedProducts'] ?? [];
      allProducts = productMap['allProducts'] ?? [];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecommendedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.soapstone,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background with DecoratedBox (limited height)
            SizedBox(
              height: 150,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.businessImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Foreground content
            Column(
              children: [
                const SizedBox(height: 20), // Push content below the image

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
                      isFavorite = !isFavorite;
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
                    final route = '/business/detail/${widget.businessId}/review';
                    context.push(route, extra: {
                      'business_id': widget.businessId,
                      'business_name': widget.businessName,
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
                                title: 'Rekomendasi Produk',
                                heightCard: 200,
                                products: recommendedProducts,
                              ),
                              const SizedBox(height: 14),
                              ProductListWidget(
                                title: 'Semua Produk',
                                products: allProducts,
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
    );
  }
}