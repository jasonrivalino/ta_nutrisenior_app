import 'package:flutter/material.dart';
import 'features/LoginProcess/LoginOption/login_view.dart';
import '../features/SplashScreen/splashscreen.dart';
import '../config/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _showSplash ? const SplashScreen() : const LoginView(),
      initialRoute: '/', // or '/login'
      routes: Routes.appRoutes, // This must be present
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}