import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../features/SplashScreen/splashscreen.dart';

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
    if (_showSplash) {
      return const MaterialApp(
        home: SplashScreen(),
      );
    }

    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}