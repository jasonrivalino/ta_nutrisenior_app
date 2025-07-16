import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../database/chat_list_table.dart';
import '../../database/driver_list_table.dart';
import '../../database/number_message_received_list_table.dart';
import '../../database/report_list_table.dart';

class ChatListController {
  static List<Map<String, dynamic>> fetchChatListData({required String? route, String? driverId}) {
    if (route == '/chatlist') {
      final sortedChats = [...chatListTable]
        ..sort((a, b) => (b['message_time'] as DateTime)
            .compareTo(a['message_time'] as DateTime));

      final seenDriverIds = <int>{};
      final latestChats = <Map<String, dynamic>>[];

      for (final chat in sortedChats) {
        final chatDriverId = chat['driver_id'] as int;
        if (!seenDriverIds.contains(chatDriverId)) {
          seenDriverIds.add(chatDriverId);
          latestChats.add(chat);
        }
      }

      return latestChats.map((chat) {
        final driverId = chat['driver_id'];

        final driver = driverListTable.firstWhere(
          (d) => d['driver_id'] == driverId,
          orElse: () => {'driver_name': 'Unknown', 'driver_image': ''},
        );

        final DateTime messageTime = chat['message_time'];
        final now = DateTime.now();

        final isSameDay = messageTime.year == now.year &&
            messageTime.month == now.month &&
            messageTime.day == now.day;

        final formattedTime = isSameDay
            ? DateFormat('HH:mm').format(messageTime)
            : DateFormat('dd/MM').format(messageTime);

        final match = numberMessageReceivedListTable.firstWhere(
          (item) => item['driver_id'] == driverId,
          orElse: () => {'numberMessageReceived': 0},
        );

        final isReported = reportListTable.any(
          (report) => report['driver_id'] == driverId,
        );

        return {
          'driver_id': driverId,
          'driver_image': driver['driver_image'],
          'driver_name': driver['driver_name'],
          'driver_phone_number': driver['driver_phone_number'],
          'is_user': chat['is_user'],
          'message_sent': chat['message_sent'],
          'message_time': formattedTime,
          'numberMessageReceived': match['numberMessageReceived'] ?? 0,
          'is_reported': isReported,
        };
      }).toList();
    }

    // Show all messages for the selected driver
    else if (route!.startsWith('/chatlist/detail/') && driverId != null) {
      final driverChats = chatListTable.where((chat) =>
          chat['driver_id'].toString() == driverId).toList();

      return driverChats.map((chat) {
        return {
          'is_user': chat['is_user'],
          'message_sent': chat['message_sent'],
          'message_time': chat['message_time'],
        };
      }).toList();
    }

    return [];
  }
}

class NumberMessageReceivedController {
  void clearNumberMessageReceived({required int driverId}) {
    numberMessageReceivedListTable.removeWhere(
      (entry) => entry['driver_id'] == driverId,
    );
  }
}

class SendMessageController {
  final int driverId;

  SendMessageController({required this.driverId});

  List<Map<String, dynamic>> sendMessage({
    required TextEditingController controller,
    required List<XFile> selectedImages,
    required VoidCallback onClearImages,
  }) {
    final text = controller.text.trim();
    final now = DateTime.now();
    int latestId = chatListTable.isNotEmpty
        ? chatListTable.map((e) => e['chat_id'] as int).reduce((a, b) => a > b ? a : b)
        : 0;

    final List<Map<String, dynamic>> newMessageList = [];
    DateTime currentTime = now;

    for (var image in selectedImages) {
      currentTime = currentTime.add(const Duration(milliseconds: 1));
      final chatEntry = {
        'chat_id': ++latestId,
        'driver_id': driverId,
        'is_user': true,
        'message_sent': image.path,
        'message_time': currentTime,
      };
      chatListTable.add(chatEntry);

      newMessageList.add({
        'image': image,
        'isMe': true,
        'time': currentTime,
        'status': 'sending',
      });
    }

    if (text.isNotEmpty) {
      currentTime = currentTime.add(const Duration(milliseconds: 1));
      final chatEntry = {
        'chat_id': ++latestId,
        'driver_id': driverId,
        'is_user': true,
        'message_sent': text,
        'message_time': currentTime,
      };
      chatListTable.add(chatEntry);

      newMessageList.add({
        'text': text,
        'isMe': true,
        'time': currentTime,
        'status': 'sending',
      });
    }

    controller.clear();
    onClearImages();

    return newMessageList;
  }
}