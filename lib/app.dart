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

    // Delay splash screen logic
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showSplash = false;
      });
    });

    // Schedule a callback after first frame to safely access MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaQuery = MediaQuery.of(context);
      final deviceWidth = mediaQuery.size.width;
      final deviceHeight = mediaQuery.size.height;
      final pixelRatio = mediaQuery.devicePixelRatio;

      print('Device Width: $deviceWidth');
      print('Device Height: $deviceHeight');
      print('Device Pixel Ratio: $pixelRatio');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}