import 'package:shared_preferences/shared_preferences.dart';

Future<String> imageSentMessageHandling({
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
    final userName = prefs.getString('userName') ?? 'You';
    final senderName = isUser ? userName : driverName;
    return '$senderName sent a photo';
  }
  return messageText;
}