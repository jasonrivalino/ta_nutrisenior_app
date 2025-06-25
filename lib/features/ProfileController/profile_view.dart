import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/styles/colors.dart';
import '../../shared/styles/texts.dart';
import '../../shared/utils/google_auth_service.dart';
import '../../shared/widgets/appbar.dart';
import '../../shared/widgets/confirm_dialog.dart';

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
              backgroundColor: AppColors.persianRed,
              foregroundColor: AppColors.soapstone,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              // Capture a stable context before any dialogs
              final rootContext = context;

              showDialog(
                context: rootContext,
                builder: (BuildContext dialogContext) {
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

                      // Show loading dialog using safe root context
                      showDialog(
                        context: rootContext,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      // Sign out from Google
                      await GoogleAuthService.signOutGoogle();

                      // Clear SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      
                      await Future.delayed(const Duration(seconds: 2));

                      rootContext.pop();
                                    
                      Fluttertoast.showToast(
                        msg: 'Logout berhasil.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      rootContext.go('/login');
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
                style: AppTextStyles.textBold(
                  size: 20,
                  color: AppColors.dark,
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
                ProfileMenuList(title: 'Favorit', navigate: () => context.push('/favorite/restaurant')),
                ProfileMenuList(title: 'Promo', navigate: () => context.push('/restaurantpromo')),
                ProfileMenuList(title: 'Histori Transaksi', navigate: () => context.push('/historyDone')),
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
                style: AppTextStyles.textBold(
                  size: 20,
                  color: AppColors.dark,
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