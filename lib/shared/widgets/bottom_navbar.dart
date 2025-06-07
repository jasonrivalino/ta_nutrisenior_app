import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.push('/homepage');
        break;
      case 1:
        context.push('/restaurantpromo');
        break;
      case 2:
        context.push('/historyDone');
        break;
      case 3:
        context.push('/chatlist');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.soapstone,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house, size: 20),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.percent, size: 20),
              label: 'Promo',
            ),
            BottomNavigationBarItem(
              icon: 	FaIcon(FontAwesomeIcons.clipboardList, size: 20),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.chat, size: 20),
              label: 'Kontak',
            ),
          ],
          selectedItemColor: AppColors.dark,
          unselectedItemColor: AppColors.darkGray,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.soapstone,
          elevation: 0,
        ),
      ),
    );
  }
}