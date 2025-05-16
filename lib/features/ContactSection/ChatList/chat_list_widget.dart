import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';

class ChatMessageTile extends StatelessWidget {
  final String profileImage;
  final String driverName;
  final String message;
  final String datetime;
  final int? numberMessageReceived;
  final VoidCallback? onTap; // Optional onTap for routing

  const ChatMessageTile({
    super.key,
    required this.profileImage,
    required this.driverName,
    required this.message,
    required this.datetime,
    this.numberMessageReceived,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile image
          CircleAvatar(
            backgroundImage: AssetImage(profileImage),
            radius: 35,
          ),
          const SizedBox(width: 12),
          // Name and message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and time in a row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.dark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      datetime,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                // Message text and unread count in a row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.dark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (numberMessageReceived != null)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          numberMessageReceived.toString(),
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 14,
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

    // If onTap is provided, make the tile clickable
    return onTap != null
        ? InkWell(
            onTap: onTap,
            splashColor: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            child: tileContent,
          )
        : tileContent;
  }
}