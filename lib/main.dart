import 'package:flutter/material.dart';
import 'shared/utils/otp_notification.dart';

import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OTPNotificationService.init(); // Initialize notifications
  runApp(const MyApp());
}