import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ta_nutrisenior_app/features/ContactSection/ChatDetails/chat_details_widget.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/utils/formatted_time.dart';
import '../../../shared/utils/fullscreen_image_view.dart';
import '../../../shared/utils/handling_chat_send.dart';
import '../../../shared/utils/handling_choose_image.dart';
import '../chat_controller.dart';

class ChatDetailView extends StatefulWidget {
  final int driverId;
  final String driverName;
  final String driverImage;
  final List<Map<String, dynamic>> chatDetailsData;

  const ChatDetailView({
    super.key,
    required this.driverId,
    required this.driverName,
    required this.driverImage,
    required this.chatDetailsData,
  });

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<XFile> _selectedImages = [];
  late List<Map<String, dynamic>> _messages;
  late final SendMessageController _sendMessageController;

  @override
  void initState() {
    super.initState();

    _sendMessageController = SendMessageController(driverId: widget.driverId);

    _messages = widget.chatDetailsData.map((chat) {
      final dynamic messageContent = chat['message_sent'];
      final bool isImage = messageContent is String &&
          (messageContent.endsWith('.png') ||
          messageContent.endsWith('.jpg') ||
          messageContent.endsWith('.jpeg'));

      return {
        'isMe': chat['is_user'] == true,
        'text': isImage ? null : messageContent,
        'imagePath': isImage ? messageContent : null,
        'time': chat['message_time'],
        'status': 'seen',
      };
    }).toList().reversed.toList();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });
  }

  void _handleSendMessage() {
    final previousLength = _messages.length;

    _sendMessageController.sendMessage(
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
      state: this,
    );

    _scrollToBottom();
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
      appBar: ChatAppBar(title: widget.driverName, image: widget.driverImage),
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
                final String? imagePath = message['imagePath'];
                final XFile? pickedImage = message['image'];

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: (pickedImage != null || imagePath != null) ? 12 : 4,
                      bottom: 4,
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
                          color: AppColors.dark.withValues(alpha: 0.15),
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
                        if (pickedImage != null || imagePath != null)
                          GestureDetector(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullScreenImageView(
                                    imagePath: pickedImage?.path ?? imagePath!,
                                    senderName: isMe
                                        ? (prefs.getString('userName') ?? 'John Doe')
                                        : widget.driverName,
                                    sendTime: message['time']?.toString() ?? '',
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: pickedImage?.path ?? imagePath!,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: pickedImage != null
                                    ? Image.file(
                                        File(pickedImage.path),
                                        width: 180,
                                        fit: BoxFit.cover,
                                      )
                                    : imagePath!.startsWith('/data/')
                                      ? Image.file(
                                          File(imagePath),
                                          width: 180,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          imagePath,
                                          width: 180,
                                          fit: BoxFit.cover,
                                        ),
                              ),
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
                              formatTime(message['time']),
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