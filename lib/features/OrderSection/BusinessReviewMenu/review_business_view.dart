import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/appbar.dart';

import 'review_business_widget.dart';
import '../OrderingMenu/business_ordering_menu_widget.dart';
import 'review_business_controller.dart';

class ReviewBusinessView extends StatefulWidget {
  final int businessId;
  final String businessName;
  final String businessType;
  final String businessImage;
  final double businessRating;
  final String businessAddress;

  const ReviewBusinessView({
    super.key,
    required this.businessId,
    required this.businessName,
    required this.businessType,
    required this.businessImage,
    required this.businessRating,
    required this.businessAddress,
  });

  factory ReviewBusinessView.fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;
    print('ReviewBusinessView.fromExtra: $extra');

    return ReviewBusinessView(
      businessId: extra['business_id'] as int,
      businessName: extra['business_name'] as String,
      businessType: extra['business_type'] as String,
      businessImage: extra['business_image'] as String,
      businessRating: extra['business_rating'] as double,
      businessAddress: extra['business_address'] as String,
    );
  }

  @override
  State<ReviewBusinessView> createState() => _ReviewBusinessViewState();
}

class _ReviewBusinessViewState extends State<ReviewBusinessView> {
  late final ReviewBusinessController controller;
  int? selectedRating;

  @override
  void initState() {
    super.initState();
    controller = ReviewBusinessController(businessId: widget.businessId);
    selectedRating = null;
  }

  @override
  Widget build(BuildContext context) {
    final ratings = controller.fetchFilteredRatings(selectedRating);

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(
        title: 'Rating dan Komentar',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            BusinessInfoCard(
              businessImage: widget.businessImage,
              businessType: widget.businessType,
              businessName: widget.businessName,
              businessAddress: widget.businessAddress,
              businessRating: widget.businessRating,
            ),
            const SizedBox(height: 16),

            // Filter bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 6,
                runSpacing: 8,
                children: [
                  RatingFilterButton(
                    label: 'Semua',
                    isSelected: selectedRating == null,
                    onTap: () {
                      setState(() => selectedRating = null);
                    },
                  ),
                  for (int rating = 5; rating >= 1; rating--)
                    RatingFilterButton(
                      label: '$rating',
                      isSelected: selectedRating == rating,
                      onTap: () {
                        setState(() => selectedRating = rating);
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rating list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ratings
                      .map((rating) => BusinessRatingItem(rating: rating))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}