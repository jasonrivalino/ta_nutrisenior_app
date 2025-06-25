import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/texts.dart';
import '../widgets/appbar.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '404 Not Found',
        showBackButton: true
      ),
      body: Center(
        child: Text(
          'Halaman tidak ditemukan',
          style: AppTextStyles.textBold(
            size: 25,
            color: AppColors.dark,
          ),
        ),
      ),
    );
  }
}