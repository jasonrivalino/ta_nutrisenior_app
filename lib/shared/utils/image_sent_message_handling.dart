import 'package:shared_preferences/shared_preferences.dart';

Future<String> imageSentMessageHandling({
  required String messageText,
  required bool isUser,
  required String driverName,
}) async {
  if (messageText.trim().startsWith('assets/images/')) {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? 'You';
    final senderName = isUser ? userName : driverName;
    return '$senderName sent a photo';
  }
  return messageText;
}
