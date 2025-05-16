import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ta_nutrisenior_app/features/ContactSection/ChatDetails/chat_details_data.dart';
import 'package:ta_nutrisenior_app/features/ContactSection/ChatDetails/chat_details_widget.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/utils/handling_chat_send.dart';
import '../../../shared/utils/handling_choose_image.dart';

class ChatDetailView extends StatefulWidget {
  const ChatDetailView({super.key});

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Dummy data for chat messages
  final List<Map<String, dynamic>> _messages = List.from(chatDetailsData.reversed);
  final List<XFile> _selectedImages = [];

  void _handleSendMessage() {
    final previousLength = _messages.length;

    handleSendMessages(
      controller: _messageController,
      messages: _messages,
      selectedImages: _selectedImages,
      onClearImages: () {
        setState(() {
          _selectedImages.clear();
        });
      },
    );

    final newMessagesCount = _messages.length - previousLength;

    updateMessageStatus(
      messages: _messages,
      newMessagesCount: newMessagesCount,
      onUpdate: () => setState(() {}),
      tickerProvider: this, state: this,
    );
  }

  void _handleChooseImage() async {
    final image = await handleChooseImage(
      context: context,
      currentImageCount: _selectedImages.length,
    );

    if (image != null && _selectedImages.length < 3) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ecruWhite,
      appBar: ChatAppBar(title: 'Driver #5'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isMe = message['isMe'] ?? false;
                final String? text = message['text'];
                final XFile? image = message['image'];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: message.containsKey('text') ? 4 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.drabGreen : AppColors.soapstone,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                      border: Border.all(color: AppColors.dark, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: const Offset(1, -2),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(image.path),
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (text != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              text,
                              style: TextStyle(
                                fontFamily: AppFonts.fontBold,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: isMe ? AppColors.soapstone : AppColors.dark,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              message['time'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: isMe ? AppColors.soapstone : AppColors.dark,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              MessageStatusIcon(status: message['status']),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          BottomChatWidget(
            controller: _messageController,
            onChooseImage: _handleChooseImage,
            selectedImages: _selectedImages,
            onRemoveImage: _removeImage,
            onSendMessage: _handleSendMessage,
          ),
        ],
      ),
    );
  }
}