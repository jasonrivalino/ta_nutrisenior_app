import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../styles/colors.dart';
import '../styles/fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Map<String, dynamic>>? customParam;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.customParam,
    this.onBack,
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
                if (onBack != null) {
                  onBack!(); // use custom back behavior
                } else if (customParam != null && customParam!.isNotEmpty) {
                  context.pop(customParam);
                } else {
                  context.pop();
                }
              },
            )
          : null,
      automaticallyImplyLeading: showBackButton,
    );
  }
}