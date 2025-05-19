import 'package:flutter/material.dart';

import '../features/LoginProcess/LoginOption/login_view.dart';
import '../features/LoginProcess/PhoneNumber/phone_number_login_view.dart';
import '../features/LoginProcess/OTPVerification/otp_verification_view.dart';

import '../features/OrderSection/HomePage/homepage_view.dart';
import '../features/OrderSection/Profile/profile_view.dart';

import '../features/PromoSection/data/recommend_market_promo_data.dart';
import '../features/PromoSection/data/recommend_restaurant_promo_data.dart';
import '../features/PromoSection/recommend_promo_view.dart';
import '../features/PromoSection/PromoDetail/promo_detail_view.dart';

import '../features/HistorySection/DoneHistory/done_history_list_view.dart';

import '../features/ContactSection/ChatList/chat_list_view.dart';
import '../features/ContactSection/ChatDetails/chat_details_view.dart';

class Routes {
  // Login Process
  static const String loginOptions = '/login';
  static const String phoneNumberLogin = '/login/phone';
  static const String otpVerification = '/login/phone/otp';

  // Main Application to Order Section
  static const String homePage = '/homepage';
  static const String profile = '/profile';

  // Promo Section
  static const String recommendRestaurantPromo = '/restaurantpromo';
  static const String recommendMarketPromo = '/marketpromo';
  static const String restaurantPromoDiscountDetail = '/restaurantpromo/discount/detail';
  static const String marketPromoDiscountDetail = '/marketpromo/discount/detail';
  static const String restaurantPromoFreeShipmentDetail = '/restaurantpromo/free_shipment/detail';
  static const String marketPromoFreeShipmentDetail = '/marketpromo/free_shipment/detail';

  // Transaction History Section
  static const String doneHistory = '/donehistory';

  // Chat Feature Section
  static const String chatList = '/chatlist';
  static const String chatDetail = '/chatlist/detail';

  static final Map<String, WidgetBuilder> appRoutes = {
    // Login Process
    loginOptions: (_) => const LoginView(),
    phoneNumberLogin: (_) => const PhoneNumberLoginView(),
    otpVerification: (_) => const OTPVerificationView(),

    // Main Application to Order Section
    homePage: (_) => HomePageView(),
    profile: (_) => const ProfileView(),
    
    // Promo Section
    // Restaurant and Market Promo Recommendation
    recommendRestaurantPromo: (_) => const RecommendPromoView(
      initialIndex: 0,
      restoRoute: recommendRestaurantPromo,
      marketRoute: recommendMarketPromo,
      discountRouteDetail: restaurantPromoDiscountDetail,
      freeShipmentRouteDetail: restaurantPromoFreeShipmentDetail,
      discountBusinesses: discountRestaurant,
      freeShipmentBusinesses: freeShipmentRestaurant,
    ),
    recommendMarketPromo: (_) => const RecommendPromoView(
      initialIndex: 1,
      restoRoute: recommendRestaurantPromo,
      marketRoute: recommendMarketPromo,
      discountRouteDetail: marketPromoDiscountDetail,
      freeShipmentRouteDetail: marketPromoFreeShipmentDetail,
      discountBusinesses: discountMarket,
      freeShipmentBusinesses: freeShipmentMarket,
    ),

    // Discount Detail
    restaurantPromoDiscountDetail: (_) => const PromoDetailView(
      initialIndex: 0,
      promoTitle: 'Promo Diskon',
      restoRoute: restaurantPromoDiscountDetail,
      marketRoute: marketPromoDiscountDetail,
      freeShipmentBusinesses: discountRestaurant,
    ),
    marketPromoDiscountDetail: (_) => const PromoDetailView(
      initialIndex: 1,
      promoTitle: 'Promo Diskon',
      restoRoute: restaurantPromoDiscountDetail,
      marketRoute: marketPromoDiscountDetail,
      freeShipmentBusinesses: discountMarket,
    ),

    // Free Shipment Detail
    restaurantPromoFreeShipmentDetail: (_) => const PromoDetailView(
      initialIndex: 0,
      promoTitle: 'Gratis Ongkir',
      restoRoute: restaurantPromoFreeShipmentDetail,
      marketRoute: marketPromoFreeShipmentDetail,
      freeShipmentBusinesses: freeShipmentRestaurant,
    ),
    marketPromoFreeShipmentDetail: (_) => const PromoDetailView(
      initialIndex: 1,
      promoTitle: 'Gratis Ongkir',
      restoRoute: restaurantPromoFreeShipmentDetail,
      marketRoute: marketPromoFreeShipmentDetail,
      freeShipmentBusinesses: freeShipmentMarket,
    ),
    
    // Transaction History Section
    doneHistory: (_) => const DoneHistoryListView(),

    // Chat Feature Section
    chatList: (_) => const ChatListView(),
    chatDetail: (_) => const ChatDetailView(),
  };
}