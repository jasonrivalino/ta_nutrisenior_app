import 'package:intl/intl.dart';

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

String formatFullDateTime(dynamic time) {
  if (time is DateTime) {
    return DateFormat('dd MMMM yyyy, HH:mm').format(time);
  } else if (time is String) {
    try {
      final parsed = DateTime.parse(time);
      return DateFormat('dd MMMM yyyy, HH:mm').format(parsed);
    } catch (_) {
      return time; // fallback to raw string if parsing fails
    }
  } else {
    return '';
  }
}

String formatHours(DateTime time) {
  return DateFormat("HH:mm").format(time);
}