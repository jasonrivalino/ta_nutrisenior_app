import 'package:intl/intl.dart';

// Import database tables
import '../../database/driver_list_table.dart';
import '../../database/chat_list_table.dart';
import '../../database/number_message_received_list_table.dart';

class ChatListController {
  static List<Map<String, dynamic>> fetchChatListData({required String? route, String? driverId}) {
    // Handling fetch based on the route

    // If route is '/chatlist', show latest chat for each driver
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
        final driver = driverListTable.firstWhere(
          (d) => d['driver_id'] == chat['driver_id'],
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

        // Find number of received messages from the corresponding table
        final driverId = chat['driver_id'];
        final match = numberMessageReceivedListTable.firstWhere(
          (item) => item['driver_id'] == driverId,
          orElse: () => {'numberMessageReceived': 0},
        );

        return {
          'driver_id': driverId,
          'driver_image': driver['driver_image'],
          'driver_name': driver['driver_name'],
          'is_user': chat['is_user'],
          'message_sent': chat['message_sent'],
          'message_time': formattedTime,
          'numberMessageReceived': match['numberMessageReceived'] ?? 0,
        };
      }).toList();
    }

    // If route is '/chatlist/detail/:driverId', show all messages for that driver
    else if (route!.startsWith('/chatlist/detail/') && driverId != null) {
      // Extract the driver ID from the route
      final driverChats = chatListTable.where((chat) =>
          chat['driver_id'].toString() == driverId).toList();

      // Return the chat messages for the specific driver
      return driverChats.map((chat) {
        return {
          'is_user': chat['is_user'],
          'message_sent': chat['message_sent'],
          'message_time': chat['message_time'],
        };
      }).toList();
    }

    // Fallback to empty list
    return [];
  }
}