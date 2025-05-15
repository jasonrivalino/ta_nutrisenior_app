import 'package:flutter/material.dart';

import '../../../shared/widgets/bottom_navbar.dart';

class DoneHistoryListView extends StatelessWidget {
  const DoneHistoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: Center(
        child: Text(
          'This is done history page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}