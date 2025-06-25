import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';

class LoginButton extends StatelessWidget {
  final FaIcon? icon;
  final String? imagePath;
  final String text;
  final VoidCallback? onPressed;

  const LoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : imagePath = null;

  const LoginButton.withImage({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onPressed,
  }) : icon = null;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.woodland,
        foregroundColor: AppColors.soapstone,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.soapstone,
            ),
            alignment: Alignment.center,
            child: icon != null
                ? FaIcon(
                    icon!.icon,
                    color: AppColors.dark,
                    size: 20,
                  )
                : Image.asset(imagePath!, width: 20, height: 20),
          ),
          const SizedBox(width: 12), // Gap between icon and text
          Text(
            text,
            style: AppTextStyles.textBold(
              size: 18,
              color: AppColors.soapstone,
            ),
          ),
        ],
      ),
    );
  }
}