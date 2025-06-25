import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../styles/colors.dart';
import '../styles/texts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Map<String, dynamic>>? customParam1;
  final String? customParam2;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.customParam1,
    this.customParam2,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.textBold(
          size: 24,
          color: AppColors.dark.withValues(alpha: 0.8),
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
                } else if (customParam1 != null && customParam1!.isNotEmpty && customParam2 != null && customParam2!.isNotEmpty) {
                  context.pop({
                    'selected_products': customParam1,
                    'driver_note': customParam2,
                  });
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