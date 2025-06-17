import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

import '../../shared/utils/handling_choose_image.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  File? _image;
  String userName = 'John Doe';
  String userEmail = 'johndoe@gmail.com';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'John Doe';
      userEmail = prefs.getString('userEmail') ?? 'johndoe@gmail.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.dark, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : const AssetImage('assets/images/dummy/chat/driver.png') as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(userEmail),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final selectedImage = await profileImageChoose();
                    if (selectedImage != null) {
                      setState(() => _image = selectedImage);
                    }
                  },
                  child: const Text(
                    'Edit Profil',
                    style: TextStyle(
                      color: AppColors.blueDress,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),          
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuList extends StatelessWidget {
  final String title;
  final VoidCallback? navigate;

  const ProfileMenuList({
    super.key,
    required this.title,
    this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ecruWhite,
      child: InkWell(
        onTap: navigate,
        hoverColor: AppColors.soapstone.withValues(alpha: 0.3),
        splashColor: AppColors.darkGray.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.dark, width: 0.6),
              bottom: BorderSide(color: AppColors.dark, width: 0.6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.dark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.dark),
            ],
          ),
        ),
      ),
    );
  }
}