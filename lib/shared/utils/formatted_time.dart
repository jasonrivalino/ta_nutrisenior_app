import 'package:intl/intl.dart';

// Format time for chat (HH:mm)
String formatTime(dynamic time) {
  if (time is DateTime) {
    return DateFormat.Hm().format(time); // HH:mm
  } else if (time is String) {
    try {
      final parsed = DateTime.parse(time);
      return DateFormat.Hm().format(parsed);
    } catch (_) {
      return '';
    }
  } else {
    return '';
  }
}

// Format date for display (dd/MM/yyyy)
String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

// Format full date and time (dd MMMM yyyy, HH:mm)
String formatFullDateTime(dynamic time) {
  if (time is DateTime) {
    return DateFormat('dd MMMM yyyy, HH:mm').format(time);
  } else if (time is String) {
    try {
      final parsed = DateTime.parse(time);
      return DateFormat('dd MMMM yyyy, HH:mm').format(parsed);
    } catch (_) {
      return time;
    }
  } else {
    return '';
  }
}