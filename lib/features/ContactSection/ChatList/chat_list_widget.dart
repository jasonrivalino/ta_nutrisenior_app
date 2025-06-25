import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';
import '../../../shared/utils/handling_chat_send.dart';

class ChatMessageTile extends StatefulWidget {
  final String driverImage;
  final String driverName;
  final bool isUser;
  final String messageText;
  final String messageTime;
  final int? numberMessageReceived;
  final VoidCallback? onTap;

  const ChatMessageTile({
    super.key,
    required this.driverImage,
    required this.driverName,
    required this.isUser,
    required this.messageText,
    required this.messageTime,
    this.numberMessageReceived,
    this.onTap,
  });

  @override
  State<ChatMessageTile> createState() => _ChatMessageTileState();
}

class _ChatMessageTileState extends State<ChatMessageTile> {
  String _displayMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDisplayMessage();
  }

  Future<void> _loadDisplayMessage() async {
    final result = await handleSendImageMessages(
      messageText: widget.messageText,
      isUser: widget.isUser,
      driverName: widget.driverName,
    );
    setState(() {
      _displayMessage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tileContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(widget.driverImage),
            radius: 35,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.driverName,
                        style: AppTextStyles.textBold(
                          size: 20,
                          color: AppColors.dark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.messageTime,
                      style: AppTextStyles.textMedium(
                        size: 14,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _displayMessage,
                        style: AppTextStyles.textMedium(
                          size: 14,
                          color: AppColors.dark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (widget.numberMessageReceived != null &&
                        widget.numberMessageReceived! > 0)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.numberMessageReceived.toString(),
                          style: AppTextStyles.textMedium(
                            size: 14,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return widget.onTap != null
        ? InkWell(
            onTap: widget.onTap,
            splashColor: AppColors.darkGray.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
            child: tileContent,
          )
        : tileContent;
  }
}