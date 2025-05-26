import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';

import '../../../shared/utils/google_auth_service.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import 'profile_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: CustomAppBar(title: 'Menu Profil', showBackButton: true),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const ProfileCard(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    titleText: 'Apakah yakin ingin logout dari akun Anda?',
                    confirmText: 'Logout',
                    cancelText: 'Batalkan',
                    onConfirm: () async {
                      final connectivityResult = await Connectivity().checkConnectivity();
                      if (connectivityResult.contains(ConnectivityResult.none)) {
                        Fluttertoast.showToast(
                          msg: 'Logout tidak berhasil. \nSilakan coba lagi.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }

                      await GoogleAuthService.signOutGoogle();
                      Fluttertoast.showToast(
                        msg: 'Logout berhasil.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      context.push('/login'); // Navigate to login page after logout
                    },
                  );
                },
              );
            },
            child: const Text('Logout Akun'),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Akun',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.dark, width: 0.6),
                bottom: BorderSide(color: AppColors.dark, width: 0.6),
              ),
            ),
            child: Column(
              children: [
                ProfileMenuList(title: 'Favorit', navigate: () {}),
                ProfileMenuList(title: 'Promo', navigate: () => context.push('/restaurantpromo')),
                ProfileMenuList(title: 'Histori Transaksi', navigate: () => context.push('/donehistory')),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'General',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontBold,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.dark, width: 0.4),
                bottom: BorderSide(color: AppColors.dark, width: 0.6),
              ),
            ),
            child: Column(
              children: [
                ProfileMenuList(title: 'Pengaturan', navigate: () {}),
                ProfileMenuList(title: 'Layanan Bantuan', navigate: () {}),
                ProfileMenuList(title: 'Keamanan', navigate: () {}),
                ProfileMenuList(title: 'Pengaturan Bahasa', navigate: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}