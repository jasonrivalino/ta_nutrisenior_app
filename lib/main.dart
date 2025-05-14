import 'package:flutter/material.dart';
import '../features/LoginProcess/PhoneNumber/phone_number_login_notification.dart';

import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // Initialize notifications
  runApp(const MyApp());
}