import 'package:flutter/material.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/bottom_navbar.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.soapstone,
      body: SafeArea(
        child: Column(
          children: [
            // Custom top section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left aligned text
                  const Text(
                    'Hello, Jane Doe',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Right aligned buttons
                  Row(
                    children: [
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.favorite_border),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // Handle favorite tap
                        },
                      ),
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.account_circle),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main content
            const Expanded(
              child: Center(
                child: Text(
                  'This is home page',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}