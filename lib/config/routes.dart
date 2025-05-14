// config/routes.dart
import 'package:flutter/material.dart';
import '../features/LoginProcess/OTPVerification/otp_verification_view.dart';
import '../features/LoginProcess/PhoneNumber/phone_number_login_view.dart';
import '../features/HomePage/homepage_view.dart';

class Routes {
  static const String phoneNumberLogin = '/login/phone';
  static const String otpVerification = '/login/otp';
  static const String homePage = '/homepage';

  static final Map<String, WidgetBuilder> appRoutes = {
    phoneNumberLogin: (_) => const PhoneNumberLoginView(),
    otpVerification: (_) => const OTPVerificationView(),
    homePage: (_) => const HomePageView(title: 'Flutter Demo Home Page'),
  };
}