import 'package:intl/date_symbol_data_local.dart';
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

// Format day time (dd MMMM yyyy)
String formatDayTime(dynamic time) {
  initializeDateFormatting('id_ID', '');
  if (time is DateTime) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(time);
  } else if (time is String) {
    try {
      final parsed = DateTime.parse(time);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(parsed);
    } catch (_) {
      return time;
    }
  } else {
    return '';
  }
}

// Format full date and time (dd MMMM yyyy, HH:mm)
String formatFullDateTime(dynamic time) {
  initializeDateFormatting('id_ID', '');
  if (time is DateTime) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(time);
  } else if (time is String) {
    try {
      final parsed = DateTime.parse(time);
      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(parsed);
    } catch (_) {
      return time;
    }
  } else {
    return '';
  }
}