import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String image;
  final String driverPhoneNumber;

  const ChatAppBar({
    super.key,
    required this.title,
    required this.image,
    required this.driverPhoneNumber,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 6);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.berylGreen,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.dark),
        onPressed: () => context.pop(),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.textBold(
                  size: 24,
                  color: AppColors.dark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Material(
            color: AppColors.woodland,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                final status = await Permission.phone.request();
                print('Driver phone number: $driverPhoneNumber');

                if (status.isGranted) {
                  final Uri callUri = Uri(scheme: 'tel', path: driverPhoneNumber);
                  if (await canLaunchUrl(callUri)) {
                    await launchUrl(callUri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tidak dapat membuka aplikasi telepon')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Izin telepon ditolak')),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.phone,
                  size: 25,
                  color: AppColors.soapstone,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomChatWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChooseImage;
  final List<XFile> selectedImages;
  final void Function(int) onRemoveImage;
  final VoidCallback onSendMessage;
  final bool isReported;

  const BottomChatWidget({
    super.key,
    required this.controller,
    required this.onChooseImage,
    required this.selectedImages,
    required this.onRemoveImage,
    required this.onSendMessage,
    this.isReported = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
        decoration: BoxDecoration(
          color: AppColors.soapstone,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: isReported
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Pengemudi telah dilaporkan',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textBold(
                    size: 18,
                    color: AppColors.persianRed,
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedImages.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(selectedImages[index].path),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => onRemoveImage(index),
                                  child: const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.dark,
                                    child: Icon(Icons.close, size: 14, color: AppColors.soapstone),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          cursorColor: AppColors.dark,
                          decoration: InputDecoration(
                            hintText: "Ketik pesan...",
                            hintStyle: AppTextStyles.textBold(
                              size: 16,
                              color: AppColors.darkGray,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppColors.dark),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppColors.dark),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppColors.dark, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.image),
                        color: AppColors.woodland,
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        onPressed: onChooseImage,
                      ),
                      IconButton(
                        onPressed: onSendMessage,
                        icon: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.woodland,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.send, color: AppColors.soapstone, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}