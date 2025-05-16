import 'package:flutter/material.dart';

import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        showBackButton: false,
      ),
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Text(
          'This is home page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}