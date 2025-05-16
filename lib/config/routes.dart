// config/routes.dart
import 'package:flutter/material.dart';

import '../features/LoginProcess/PhoneNumber/phone_number_login_view.dart';
import '../features/LoginProcess/OTPVerification/otp_verification_view.dart';

import '../features/OrderSection/HomePage/homepage_view.dart';
import '../features/PromoSection/RestaurantPromo/recommend_restaurant_promo_view.dart';
import '../features/HistorySection/DoneHistory/done_history_list_view.dart';
import '../features/ContactSection/ChatList/chat_list_view.dart';

class Routes {
  static const String phoneNumberLogin = '/login/phone';
  static const String otpVerification = '/login/phone/otp';

  static const String homePage = '/homepage';
  static const String recommendRestaurantPromo = '/restaurantpromo';
  static const String chatList = '/chatlist';
  static const String doneHistory = '/donehistory';

  static final Map<String, WidgetBuilder> appRoutes = {
    // Login Process
    phoneNumberLogin: (_) => const PhoneNumberLoginView(),
    otpVerification: (_) => const OTPVerificationView(),

    // Main Application
    homePage: (_) => HomePageView(),
    recommendRestaurantPromo: (_) => const RecommendRestaurantPromoView(),
    doneHistory: (_) => const DoneHistoryListView(),
    chatList: (_) => const ChatListView(),
  };
}