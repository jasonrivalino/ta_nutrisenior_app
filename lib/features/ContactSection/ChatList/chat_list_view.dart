import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';
import 'chat_list_widget.dart';

class ChatListView extends StatelessWidget {
  final List<Map<String, dynamic>> chatListData;

  const ChatListView({
    super.key, 
    required this.chatListData
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kontak',
        showBackButton: false,
      ),
      backgroundColor: AppColors.soapstone,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 5),
        children: chatListData.asMap().entries.map((entry) {
          final chat = entry.value;

          return ChatMessageTile(
            driverImage: chat['driver_image'] as String,
            driverName: chat['driver_name'] as String,
            messageText: chat['message_text'] as String,
            messageTime: chat['message_time'] as String,
            numberMessageReceived: chat['numberMessageReceived'] as int?,
            onTap: () {
              context.push('/chatlist/detail/${chat['driver_id']}', 
              extra: {
                'driver_id': chat['driver_id'],
                'driver_name': chat['driver_name'],
                'driver_image': chat['driver_image'],
              });
            }
          );
        }).toList(),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}