import 'package:go_router/go_router.dart';

import '../features/HistorySection/OngoingHistory/ongoing_history_details_view.dart';
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
import '../features/HistorySection/DoneHistory/Report/report_success_view.dart';

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

  // Transaction History Section - Done History
  static const String history = '/history';
  static const String doneHistoryDetails = '/history/done/details/:id';
  static const String doneHistoryRating = '/history/done/details/:id/rating';
  static const String doneHistoryReport = '/history/done/details/:id/report';
  static const String doneHistoryReportSuccess = '/history/done/details/:id/report/success';

  // Transaction History Section - Processing History
  static const String processingHistoryDetails = '/history/processing/:id';
  static const String processingHistoryCancel = '/history/processing/:id/cancel';
  static const String deliveringHistoryDetails = '/history/delivering/:id';

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
        if (state.extra != null && state.extra is Map<String, dynamic>) {
          return DoneHistoryDetailsView.fromExtra(context, state);
        }
        return const PageNotFound();
      },
    ),
    GoRoute(
      path: Routes.doneHistoryRating,
      builder: (context, state) {
        return RatingView.fromExtra(context, state);
      },
    ),
    GoRoute(
      path: Routes.doneHistoryReport,
      builder: (context, state) {
        return ReportView.fromExtra(state);
      },
    ),
    GoRoute(
      path: Routes.doneHistoryReportSuccess,
        builder: (context, state) {
        final id = state.extra != null && state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['id'] as int?
            : int.tryParse(state.pathParameters['id'] ?? '');

        return ReportSuccess(id: id ?? 0);
      },
    ),

    // Processing History
    GoRoute(
      path: Routes.processingHistoryDetails,
      builder: (context, state) {
        return OngoingHistoryDetailsView.fromExtra(context, state);
      },
    ),
    // GoRoute(
    //   path: Routes.processingHistoryCancel,
    //   builder: (context, state) {
    //     final id = state.extra != null && state.extra is Map<String, dynamic>
    //         ? (state.extra as Map<String, dynamic>)['id'] as int?
    //         : int.tryParse(state.pathParameters['id'] ?? '');

    //     return ProcessingHistoryCancelView(id: id ?? 0);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.deliveringHistoryDetails,
    //   builder: (context, state) {
    //     final id = state.extra != null && state.extra is Map<String, dynamic>
    //         ? (state.extra as Map<String, dynamic>)['id'] as int?
    //         : int.tryParse(state.pathParameters['id'] ?? '');

    //     return DeliveringHistoryDetailsView(id: id ?? 0);
    //   },
    // ),

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