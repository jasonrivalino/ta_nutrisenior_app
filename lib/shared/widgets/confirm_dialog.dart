import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'elevated_button.dart';
import '../styles/colors.dart';
import '../styles/texts.dart';

class ConfirmDialog extends StatelessWidget {
  final String titleText;
  final String confirmText;
  final String cancelText;
  final Future<void> Function() onConfirm;

  const ConfirmDialog({
    super.key,
    required this.titleText,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.soapstone,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: AppTextStyles.textBold(
                size: 20,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButtonWidget.warningButton(
                onPressed: () async {
                  context.pop();
                  await onConfirm();
                },
                child: Text(
                  confirmText,
                  style: AppTextStyles.textBold(
                    size: 16,
                    color: AppColors.soapstone,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButtonWidget(
                onPressed: () => context.pop(),
                backgroundColor: AppColors.dark,
                foregroundColor: AppColors.soapstone,
                textStyle: AppTextStyles.textBold(size: 16, color: AppColors.soapstone),
                borderRadius: 8,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  cancelText,
                  style: AppTextStyles.textBold(size: 16, color: AppColors.soapstone),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}