// config/routes.dart
import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/features/OrderSection/Profile/profile_view.dart';

import '../features/LoginProcess/LoginOption/login_view.dart';
import '../features/LoginProcess/PhoneNumber/phone_number_login_view.dart';
import '../features/LoginProcess/OTPVerification/otp_verification_view.dart';

import '../features/OrderSection/HomePage/homepage_view.dart';
import '../features/PromoSection/RestaurantPromo/recommend_restaurant_promo_view.dart';
import '../features/HistorySection/DoneHistory/done_history_list_view.dart';

import '../features/ContactSection/ChatDetails/chat_details_view.dart';
import '../features/ContactSection/ChatList/chat_list_view.dart';

class Routes {
  static const String loginOptions = '/login';
  static const String phoneNumberLogin = '/login/phone';
  static const String otpVerification = '/login/phone/otp';

  static const String homePage = '/homepage';
  static const String profile = '/profile';
  static const String recommendRestaurantPromo = '/restaurantpromo';
  static const String doneHistory = '/donehistory';

  // Chat Feature
  static const String chatList = '/chatlist';
  static const String chatDetail = '/chatlist/detail';

  static final Map<String, WidgetBuilder> appRoutes = {
    // Login Process
    loginOptions: (_) => const LoginView(),
    phoneNumberLogin: (_) => const PhoneNumberLoginView(),
    otpVerification: (_) => const OTPVerificationView(),

    // Main Application
    homePage: (_) => HomePageView(),
    profile: (_) => const ProfileView(),
    
    recommendRestaurantPromo: (_) => const RecommendRestaurantPromoView(),
    doneHistory: (_) => const DoneHistoryListView(),

    // Chat Feature
    chatList: (_) => const ChatListView(),
    chatDetail: (_) => const ChatDetailView(),
  };
}