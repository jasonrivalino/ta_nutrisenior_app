import 'package:flutter/material.dart';

import '../../shared/widgets/appbar.dart';

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
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}