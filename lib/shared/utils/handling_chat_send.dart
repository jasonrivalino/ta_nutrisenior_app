import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../styles/colors.dart';

/// Function to handle sending messages and images
void handleSendMessages({
  required TextEditingController controller,
  required List<Map<String, dynamic>> messages,
  required List<XFile> selectedImages,
  required VoidCallback onClearImages,
}) {
  final text = controller.text.trim();
  final DateTime now = DateTime.now(); // simpan objek DateTime

  if (text.isNotEmpty) {
    messages.insert(0, {
      'text': text,
      'isMe': true,
      'time': now,
      'status': 'sending',
    });
  }

  for (var image in selectedImages) {
    messages.insert(0, {
      'image': image,
      'isMe': true,
      'time': now,
      'status': 'sending',
    });
  }

  controller.clear();
  onClearImages();
}

// Function conditionally to show the image or text message
class MessageStatusIcon extends StatelessWidget {
  final String? status;

  const MessageStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 'sending') {
      return const Icon(Icons.access_time, size: 14, color: AppColors.soapstone);
    } else if (status == 'sent') {
      return const Icon(Icons.check, size: 14, color: AppColors.soapstone);
    } else {
      return const Icon(Icons.done_all, size: 14, color: AppColors.soapstone);
    }
  }
}

// Function to update message status
void updateMessageStatus({
  required List<Map<String, dynamic>> messages,
  required int newMessagesCount,
  required VoidCallback onUpdate,
  required State state,
}) async {
  // Function to handle the message status update flow
  void proceedWithStatusUpdate() {
    for (int i = 0; i < newMessagesCount; i++) {
      final index = i;

      Future.delayed(const Duration(seconds: 2), () {
        if (state.mounted &&
            messages.length > index &&
            messages[index]['status'] == 'sending') {
          messages[index]['status'] = 'sent';
          onUpdate();
        }
      });

      Future.delayed(const Duration(seconds: 7), () {
        if (state.mounted &&
            messages.length > index &&
            messages[index]['status'] == 'sent') {
          messages[index]['status'] = 'delivered';
          onUpdate();
        }
      });
    }
  }

  final initialConnectivity = await Connectivity().checkConnectivity();

  if (initialConnectivity.contains(ConnectivityResult.none)) {
    // Show error toast after a short delay
    Future.delayed(const Duration(seconds: 4), () {
      if (!state.mounted) return;

      for (int i = 0; i < newMessagesCount; i++) {
        if (messages.length > i && messages[i]['status'] == 'sending') {
          Fluttertoast.showToast(
            msg: "Gagal mengirim pesan. \nSilakan coba lagi.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    });

    // Wait for connectivity restoration
    StreamSubscription? subscription;
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (!result.contains(ConnectivityResult.none)) {
        // Once online, proceed and cancel listener
        subscription?.cancel();
        proceedWithStatusUpdate();
      }
    });
  } else {
    // Already online: proceed directly
    proceedWithStatusUpdate();
  }
}