import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'shared/utils/otp_notification.dart';

import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await OTPNotificationService.init(); // Initialize notifications
  runApp(const MyApp());
}