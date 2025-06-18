import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../styles/colors.dart';

Future<File?> profileImageChoose() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<XFile?> handleChooseImage({
  required BuildContext context,
  required int currentImageCount,
}) async {
  if (currentImageCount >= 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Maximum 3 images allowed')),
    );
    return null;
  }

  final source = await showModalBottomSheet<ImageSource?>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: AppColors.soapstone, // Custom background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(ImageSource.camera),
                child: const ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Ambil dari kamera'),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(ImageSource.gallery),
                child: const ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pilih dari galeri'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  if (source == null) return null;

  final permission = source == ImageSource.camera
      ? await Permission.camera.request()
      : await Permission.photos.request();

  if (!permission.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permission denied')),
    );
    return null;
  }

  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);

  return image;
}