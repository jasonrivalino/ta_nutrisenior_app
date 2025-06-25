import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/texts.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide? borderSide;
  final TextStyle? textStyle;
  final Size? minimumSize;
  final double elevation;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? tapTargetSize;
  final VoidCallback? onPressed;

  const ElevatedButtonWidget({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
    this.textStyle,
    this.minimumSize,
    this.elevation = 2,
    this.borderRadius = 8,
    this.padding,
    this.tapTargetSize,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        side: borderSide,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        minimumSize: minimumSize,
        textStyle: textStyle,
        elevation: elevation,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        tapTargetSize: tapTargetSize ?? MaterialTapTargetSize.padded,
      ),
      child: child,
    );
  }

  factory ElevatedButtonWidget.bottomButton({
    required VoidCallback onPressed,
    required Widget child,
    Color backgroundColor = AppColors.woodland,
  }) {
    return ElevatedButtonWidget(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.soapstone,
      textStyle: AppTextStyles.textBold(size: 16, color: AppColors.soapstone),
      minimumSize: const Size.fromHeight(45),
      borderRadius: 20,
      child: child,
    );
  }

  factory ElevatedButtonWidget.iconButton({
    required VoidCallback onPressed,
    required Icon icon,
    required String label,
  }) {
    return ElevatedButtonWidget(
      onPressed: onPressed,
      backgroundColor: AppColors.woodland,
      foregroundColor: AppColors.soapstone,
      textStyle: AppTextStyles.textMedium(size: 14, color: AppColors.soapstone),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      minimumSize: const Size(0, 30),
      borderRadius: 6,
      elevation: 0,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  factory ElevatedButtonWidget.warningButton({
    required VoidCallback onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButtonWidget(
      onPressed: onPressed,
      backgroundColor: AppColors.persianRed,
      foregroundColor: AppColors.soapstone,
      textStyle: AppTextStyles.textBold(size: 14, color: AppColors.soapstone),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
      child: child,
    );
  }

  factory ElevatedButtonWidget.submitFormButton({
    required VoidCallback onPressed,
    String text = 'Submit', // ⬅️ customizable text with default
    Color backgroundColor = AppColors.woodland,
  }) {
    return ElevatedButtonWidget(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.soapstone,
      textStyle: AppTextStyles.textBold(size: 18, color: AppColors.soapstone),
      minimumSize: const Size.fromHeight(50),
      borderRadius: 25,
      child: Text(text),
    );
  }
}