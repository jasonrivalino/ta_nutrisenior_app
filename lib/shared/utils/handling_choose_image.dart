import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    builder: (context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
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