import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ChatAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 6); // Extra height for vertical padding

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.berylGreen,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.dark),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/dummy/chat/driver.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontBold,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.dark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomChatWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChooseImage;
  final List<XFile> selectedImages;
  final void Function(int) onRemoveImage;
  final VoidCallback onSendMessage;

  const BottomChatWidget({
    super.key,
    required this.controller,
    required this.onChooseImage,
    required this.selectedImages,
    required this.onRemoveImage,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
        decoration: BoxDecoration(
          color: AppColors.soapstone,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
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
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close, size: 14, color: Colors.white),
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
                    decoration: const InputDecoration(
                      hintText: "Ketik chat...",
                      hintStyle: TextStyle(
                        fontFamily: AppFonts.fontBold,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.darkGray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  color: AppColors.woodland,
                  iconSize: 30,
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
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
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