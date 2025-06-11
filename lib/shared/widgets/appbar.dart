import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../styles/fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final int? initialIndex;
  final int? selectedIndex;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.initialIndex,
    this.selectedIndex,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: AppFonts.fontBold,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: AppColors.dark,
        ),
      ),
      backgroundColor: AppColors.berylGreen,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (selectedIndex == 0) {
                  context.go('/homepage');
                } else if (initialIndex == 0 && selectedIndex == 1) {
                  context.go('/restaurantpromo');
                } else if (initialIndex == 1 && selectedIndex == 1) {
                  context.go('/marketpromo');
                } else {
                  context.pop(); // fallback to default back
                }
              },
            )
          : null,
      automaticallyImplyLeading: showBackButton,
    );
  }
}