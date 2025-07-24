import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';

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

Future<String> handleSendImageMessages({
  required String messageText,
  required bool isUser,
  required String driverName,
}) async {
  // Detect both assets and picked image file paths
  final isImage = messageText.trim().startsWith('assets/images/') ||
      messageText.trim().contains('/data/user/') ||
      messageText.trim().contains('/storage/emulated/');

  if (isImage) {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? 'John Doe';
    final senderName = isUser ? userName : driverName;
    return '$senderName mengirimkan gambar';
  }
  return messageText;
}

// Function to update message status
void updateMessageStatusWithSeenChain({
  required List<Map<String, dynamic>> messages,
  required int newMessagesCount,
  required VoidCallback onUpdate,
  required State state,
}) async {
  void updateStatusesSequentially() {
    for (int i = 0; i < newMessagesCount; i++) {
      final index = i;

      Future.delayed(Duration(seconds: 2 + (i * 2)), () {
        if (!state.mounted) return;

        if (messages.length > index &&
            messages[index]['status'] == 'sending') {
          messages[index]['status'] = 'sent';
          onUpdate();
        }
      });

      Future.delayed(Duration(seconds: 6 + (i * 2)), () {
        if (!state.mounted) return;

        if (messages.length > index && messages[index]['status'] == 'sent') {
          // karena new messages ditambahkan di awal (index 0),
          // maka 'sebelumnya' secara waktu adalah index > current
          final allAfterSeen = messages
              .sublist(index + 1)
              .where((m) => m['isMe'] == true)
              .every((m) => m['status'] == 'seen');

          if (allAfterSeen) {
            messages[index]['status'] = 'seen';
            onUpdate();
          }
        }
      });
    }
  }

  final connectivity = await Connectivity().checkConnectivity();

  if (connectivity.contains(ConnectivityResult.none)) {
    Future.delayed(const Duration(seconds: 4), () {
      if (!state.mounted) return;
      for (int i = 0; i < newMessagesCount; i++) {
        if (messages.length > i && messages[i]['status'] == 'sending') {
          Fluttertoast.showToast(
            msg: "Gagal mengirim pesan. \nSilakan coba lagi.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    });

    StreamSubscription? sub;
    sub = Connectivity().onConnectivityChanged.listen((result) {
      if (!result.contains(ConnectivityResult.none)) {
        sub?.cancel();
        updateStatusesSequentially();
      }
    });
  } else {
    updateStatusesSequentially();
  }
}