import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';
import 'chat_list_data.dart';
import 'chat_list_widget.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kontak',
        showBackButton: false,
      ),
      backgroundColor: AppColors.soapstone,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        children: chatListData.asMap().entries.map((entry) {
          final index = entry.key;
          final chat = entry.value;

          return ChatMessageTile(
            profileImage: chat['profileImage'] as String,
            driverName: chat['driverName'] as String,
            message: chat['message'] as String,
            datetime: chat['datetime'] as String,
            numberMessageReceived: chat['numberMessageReceived'] as int?,
            onTap: index == 4
                ? () {
                    context.push('/chatlist/detail');
                  }
                : null,
          );
        }).toList(),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}