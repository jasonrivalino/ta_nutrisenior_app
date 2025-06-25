import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/texts.dart';

class ReportSuccess extends StatefulWidget {
  final int id;

  const ReportSuccess({
    super.key,
    required this.id,
  });

  @override
  State<ReportSuccess> createState() => _ReportSuccessState();
}

class _ReportSuccessState extends State<ReportSuccess> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/historyDone');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.ecruWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: AppColors.dark, size: 180),
              SizedBox(height: mediaQuery.size.height * 0.05),
              Text(
                'Laporan Berhasil',
                style: AppTextStyles.textBold(
                  size: 24,
                  color: AppColors.dark,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.025),
              Text(
                'Laporan berhasil dikirim. Kami akan meninjau laporan Anda sesegera mungkin.',
                textAlign: TextAlign.center,
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}