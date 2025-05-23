import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

import '../../../shared/utils/handling_choose_image.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecruWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
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
                const Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text('johndoe@gmail.com'),
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
                      color: Colors.blue,
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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.dark, width: 0.6),
          bottom: BorderSide(color: AppColors.dark, width: 0.6),
        ),
      ),
      child: ElevatedButton(
        onPressed: navigate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ecruWhite,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: AppColors.dark),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.dark),
          ],
        ),
      ),
    );
  }
}