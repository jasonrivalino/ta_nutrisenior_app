import 'package:go_router/go_router.dart';

import '../features/LoginProcess/LoginOption/login_view.dart';
import '../features/LoginProcess/PhoneNumber/phone_number_login_view.dart';
import '../features/LoginProcess/OTPVerification/otp_verification_view.dart';

import '../features/OrderSection/HomePage/homepage_view.dart';
import '../features/OrderSection/Profile/profile_view.dart';

import '../features/PromoSection/data/recommend_market_promo_data.dart';
import '../features/PromoSection/data/recommend_restaurant_promo_data.dart';
import '../features/PromoSection/recommend_promo_view.dart';
import '../features/PromoSection/PromoDetail/promo_detail_view.dart';

import '../features/HistorySection/history_list_view.dart';
import '../features/HistorySection/DoneHistory/done_history_details_view.dart';
import '../features/HistorySection/DoneHistory/Rating/rating_view.dart';
import '../features/HistorySection/DoneHistory/Report/report_view.dart';

import '../features/ContactSection/ChatList/chat_list_view.dart';
import '../features/ContactSection/ChatDetails/chat_details_view.dart';
import '../shared/utils/page_not_found.dart';

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
  static const String history = '/history';
  static const String doneHistoryDetails = '/history/done/details/:id';
  static const String doneHistoryRating = '/history/done/details/:id/rating';
  static const String doneHistoryReport = '/history/done/details/:id/report';

  // Chat Feature Section
  static const String chatList = '/chatlist';
  static const String chatDetail = '/chatlist/detail';

  // Handling
  static const String notFound = '/page-not-found';
}

final GoRouter router = GoRouter(
  initialLocation: Routes.loginOptions,
  routes: [
    // Login Process
    GoRoute(
      path: Routes.loginOptions,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: Routes.phoneNumberLogin,
      builder: (context, state) => const PhoneNumberLoginView(),
    ),
    GoRoute(
      path: Routes.otpVerification,
      builder: (context, state) => const OTPVerificationView(),
    ),

    // Main Application
    GoRoute(
      path: Routes.homePage,
      builder: (context, state) => HomePageView(),
    ),
    GoRoute(
      path: Routes.profile,
      builder: (context, state) => const ProfileView(),
    ),

    // Promo Section
    GoRoute(
      path: Routes.recommendRestaurantPromo,
      builder: (context, state) => const RecommendPromoView(
        initialIndex: 0,
        restoRoute: Routes.recommendRestaurantPromo,
        marketRoute: Routes.recommendMarketPromo,
        discountRouteDetail: Routes.restaurantPromoDiscountDetail,
        freeShipmentRouteDetail: Routes.restaurantPromoFreeShipmentDetail,
        discountBusinesses: discountRestaurant,
        freeShipmentBusinesses: freeShipmentRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.recommendMarketPromo,
      builder: (context, state) => const RecommendPromoView(
        initialIndex: 1,
        restoRoute: Routes.recommendRestaurantPromo,
        marketRoute: Routes.recommendMarketPromo,
        discountRouteDetail: Routes.marketPromoDiscountDetail,
        freeShipmentRouteDetail: Routes.marketPromoFreeShipmentDetail,
        discountBusinesses: discountMarket,
        freeShipmentBusinesses: freeShipmentMarket,
      ),
    ),
    GoRoute(
      path: Routes.restaurantPromoDiscountDetail,
      builder: (context, state) => const PromoDetailView(
        initialIndex: 0,
        promoTitle: 'Promo Diskon',
        restoRoute: Routes.restaurantPromoDiscountDetail,
        marketRoute: Routes.marketPromoDiscountDetail,
        freeShipmentBusinesses: discountRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.marketPromoDiscountDetail,
      builder: (context, state) => const PromoDetailView(
        initialIndex: 1,
        promoTitle: 'Promo Diskon',
        restoRoute: Routes.restaurantPromoDiscountDetail,
        marketRoute: Routes.marketPromoDiscountDetail,
        freeShipmentBusinesses: discountMarket,
      ),
    ),
    GoRoute(
      path: Routes.restaurantPromoFreeShipmentDetail,
      builder: (context, state) => const PromoDetailView(
        initialIndex: 0,
        promoTitle: 'Gratis Ongkir',
        restoRoute: Routes.restaurantPromoFreeShipmentDetail,
        marketRoute: Routes.marketPromoFreeShipmentDetail,
        freeShipmentBusinesses: freeShipmentRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.marketPromoFreeShipmentDetail,
      builder: (context, state) => const PromoDetailView(
        initialIndex: 1,
        promoTitle: 'Gratis Ongkir',
        restoRoute: Routes.restaurantPromoFreeShipmentDetail,
        marketRoute: Routes.marketPromoFreeShipmentDetail,
        freeShipmentBusinesses: freeShipmentMarket,
      ),
    ),

    // History
    GoRoute(
      path: Routes.history,
      builder: (context, state) => const HistoryListView(),
    ),
    GoRoute(
      path: Routes.doneHistoryDetails,
      builder: (context, state) {
        final id = state.extra != null && state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['id'] as int?
            : int.tryParse(state.pathParameters['id'] ?? '');

        return DoneHistoryDetailsView(id: id ?? 0);
      },
    ),
    GoRoute(
      path: Routes.doneHistoryRating,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final id = extra?['id'] ?? 0;
        final driverName = extra?['driverName'];
        final businessName = extra?['businessName'];
        final businessType = extra?['businessType'];
        final businessImage = extra?['businessImage'];

        return RatingView(
          id: id,
          driverName: driverName,
          businessName: businessName,
          businessType: businessType,
          businessImage: businessImage,
        );
      },
    ),
    GoRoute(
      path: Routes.doneHistoryReport,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final id = extra?['id'] ?? 0;
        final isDriver = extra?['isDriver'] ?? false;
        final businessType = extra?['businessType'];

        return ReportView(
          id: id,
          isDriver: isDriver,
          businessType: businessType,
        );
      },
    ),

    // Chat
    GoRoute(
      path: Routes.chatList,
      builder: (context, state) => const ChatListView(),
    ),
    GoRoute(
      path: Routes.chatDetail,
      builder: (context, state) => const ChatDetailView(),
    ),

    // other routes
    // Not Found
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePageView(),
    ),
    GoRoute(
      path: Routes.notFound,
      builder: (context, state) => const PageNotFound(),
    ),
  ], errorBuilder: (context, state) => const PageNotFound(),
);