bool isBusinessOpen(DateTime? openHour, DateTime? closeHour) {
  if (openHour == null || closeHour == null) return true;

  final now = DateTime.now();
  final todayOpen = DateTime(now.year, now.month, now.day, openHour.hour, openHour.minute);
  final todayClose = DateTime(now.year, now.month, now.day, closeHour.hour, closeHour.minute);

  return now.isAfter(todayOpen) && now.isBefore(todayClose);
}