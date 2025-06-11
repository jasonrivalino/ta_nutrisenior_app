import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import 'business_ordering_menu_widget.dart';

class BusinessOrderingMenuView extends StatefulWidget {
  final int id;
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
    required this.id,
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
      id: extra['business_id'],
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

  void _toggleFavorite() {
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
  }

  void _handleRatingClick() {
    // Your rating logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.soapstone,
      body: Stack(
        children: [
          // Background image
          Column(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.asset(
                  widget.businessImage,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 105),
            ],
          ),
          // Header Bar
          BusinessHeaderBar(
            isFavorite: isFavorite,
            onFavoritesClick: _toggleFavorite,
            onRatingClick: _handleRatingClick,
          ),
          // Business Info Card
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
          // TODO: Add the menu items list here
        ],
      ),
    );
  }
}