import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../styles/colors.dart';

/// Function to handle sending messages and images
void handleSendMessages({
  required TextEditingController controller,
  required List<Map<String, dynamic>> messages,
  required List<XFile> selectedImages,
  required VoidCallback onClearImages,
}) {
  final text = controller.text.trim();
  final String currentTime = DateFormat('HH:mm').format(DateTime.now());

  if (text.isNotEmpty) {
    messages.insert(0, {
      'text': text,
      'isMe': true,
      'time': currentTime,
      'status': 'sending',
    });
  }

  for (var image in selectedImages) {
    messages.insert(0, {
      'image': image,
      'isMe': true,
      'time': currentTime,
      'status': 'sending',
    });
  }

  controller.clear();
  onClearImages();
}

// Function conditionally to show the image or text message
class MessageStatusIcon extends StatelessWidget {
  final String? status;

  const MessageStatusIcon({Key? key, required this.status}) : super(key: key);

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
  required State state, required tickerProvider,
}) {
  for (int i = 0; i < newMessagesCount; i++) {
    final index = i;

    // Set to 'sent' after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (state.mounted &&
          messages.length > index &&
          messages[index]['status'] == 'sending') {
        messages[index]['status'] = 'sent';
        onUpdate();
      }
    });

    // Set to 'delivered' after 7 seconds
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