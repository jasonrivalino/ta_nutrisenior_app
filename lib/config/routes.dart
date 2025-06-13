import 'package:go_router/go_router.dart';

import '../features/LoginProcess/LoginOption/login_view.dart';
import '../features/LoginProcess/PhoneNumber/phone_number_login_view.dart';
import '../features/LoginProcess/OTPVerification/otp_verification_view.dart';

import '../features/OrderSection/HomePage/homepage_view.dart';
import '../features/OrderSection/HomePage/homepage_controller.dart';
import '../features/OrderSection/FavoritesData/favorites_controller.dart';
import '../features/ProfileController/profile_view.dart';
import '../features/OrderSection/SearchingMenu/search_view.dart';
import '../features/OrderSection/BusinessListPage/business_list_view.dart';

import '../features/OrderSection/OrderingMenu/business_ordering_menu_view.dart';
import '../features/OrderSection/BusinessReviewMenu/review_business_view.dart';

import '../features/PromoSection/recommend_promo_controller.dart';
import '../features/PromoSection/recommend_promo_view.dart';

import '../features/HistorySection/history_list_view.dart';
import '../features/HistorySection/DoneHistory/done_history_details_view.dart';
import '../features/HistorySection/DoneHistory/Rating/rating_view.dart';
import '../features/HistorySection/DoneHistory/Report/report_view.dart';
import '../features/HistorySection/DoneHistory/Report/report_success_view.dart';
import '../features/HistorySection/OngoingHistory/ongoing_history_details_view.dart';
import '../features/HistorySection/OngoingHistory/CancelOrder/cancel_order_view.dart';

import '../features/ContactSection/ChatList/chat_list_view.dart';
import '../features/ContactSection/ChatDetails/chat_details_view.dart';
import '../shared/utils/page_not_found.dart';

import '../features/ContactSection/chat_controller.dart';

class Routes {
  // Login Process
  static const String loginOptions = '/login';
  static const String phoneNumberLogin = '/login/phone';
  static const String otpVerification = '/login/phone/otp';

  // Main Application to Order Section - Choosing
  static const String homePage = '/homepage';
  static const String favoriteRestaurant = '/favorite/restaurant';
  static const String favoriteMarket = '/favorite/market';
  static const String profile = '/profile';
  static const String search = '/search';
  // Recommend Section
  static const String recommendRestaurantDetail = '/recommend/restaurant/detail';
  static const String recommendMarketDetail = '/recommend/market/detail';
  // Main Application to Order Section - Ordering Process
  static const String businessDetail = '/business/detail/:id';
  // Rating and Review
  static const String businessReview = '/business/detail/:id/review';

  // Promo Section
  static const String recommendRestaurantPromo = '/restaurantpromo';
  static const String recommendMarketPromo = '/marketpromo';
  static const String restaurantPromoDiscountDetail = '/restaurantpromo/discount/detail';
  static const String marketPromoDiscountDetail = '/marketpromo/discount/detail';
  static const String restaurantPromoFreeShipmentDetail = '/restaurantpromo/free_shipment/detail';
  static const String marketPromoFreeShipmentDetail = '/marketpromo/free_shipment/detail';

  // Transaction History Section - Done History
  static const String historyDone = '/historyDone';
  static const String historyOngoing = '/historyOngoing';
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
  static const String chatDetail = '/chatlist/detail/:driverId';

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

    // Main Application - Order Section
    // Order Section - Choosing
    // Homepage
    GoRoute(
      path: Routes.homePage,
      builder: (context, state) => HomePageView(),
    ),
    // Favorite Page
    GoRoute(
      path: Routes.favoriteRestaurant,
      builder: (context, state) => BusinessListView(
        initialIndex: 0,
        appBarTitle: 'Restoran Favorit',
        restoRoute: Routes.favoriteRestaurant,
        marketRoute: Routes.favoriteMarket,
        bottomNavIndex: 0,
        businessesData: FavoritesController.favoritesRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.favoriteMarket,
      builder: (context, state) => BusinessListView(
        initialIndex: 1,
        appBarTitle: 'Pusat Belanja Favorit',
        restoRoute: Routes.favoriteRestaurant,
        marketRoute: Routes.favoriteMarket,
        bottomNavIndex: 0,
        businessesData: FavoritesController.favoritesMarket,
      ),
    ),
    // Profile Page
    GoRoute(
      path: Routes.profile,
      builder: (context, state) => const ProfileView(),
    ),
    // Search Page
    GoRoute(
      path: Routes.search,
      builder: (context, state) => const SearchView(),
    ),
    // Recommend Page
    GoRoute(
      path: Routes.recommendRestaurantDetail,
      builder: (context, state) => BusinessListView(
        initialIndex: 0,
        appBarTitle: 'Restoran Pilihan',
        restoRoute: Routes.recommendRestaurantDetail,
        marketRoute: Routes.recommendMarketDetail,
        bottomNavIndex: 0,
        businessesData: HomePageController.recommendedRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.recommendMarketDetail,
      builder: (context, state) => BusinessListView(
        initialIndex: 1,
        appBarTitle: 'Pusat Belanja Pilihan',
        restoRoute: Routes.recommendRestaurantDetail,
        marketRoute: Routes.recommendMarketDetail,
        bottomNavIndex: 0,
        businessesData: HomePageController.recommendedMarket,
      ),
    ),
    // Order Section - Ordering Process
    GoRoute(
      path: Routes.businessDetail,
      builder: (context, state) => BusinessOrderingMenuView.fromExtra(context, state),
    ),
    // Rating and Review
    GoRoute(
      path: Routes.businessReview,
      builder: (context, state) => ReviewBusinessView.fromExtra(context, state),
    ),

    // Promo Section
    GoRoute(
      path: Routes.recommendRestaurantPromo,
      builder: (context, state) => RecommendPromoView(
        initialIndex: 0,
        restoRoute: Routes.recommendRestaurantPromo,
        marketRoute: Routes.recommendMarketPromo,
        discountRouteDetail: Routes.restaurantPromoDiscountDetail,
        freeShipmentRouteDetail: Routes.restaurantPromoFreeShipmentDetail,
        discountBusinesses: PromoController.promoDiscountRestaurant,
        freeShipmentBusinesses: PromoController.promoFreeShipmentRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.recommendMarketPromo,
      builder: (context, state) => RecommendPromoView(
        initialIndex: 1,
        restoRoute: Routes.recommendRestaurantPromo,
        marketRoute: Routes.recommendMarketPromo,
        discountRouteDetail: Routes.marketPromoDiscountDetail,
        freeShipmentRouteDetail: Routes.marketPromoFreeShipmentDetail,
        discountBusinesses: PromoController.promoDiscountMarket,
        freeShipmentBusinesses: PromoController.promoFreeShipmentMarket,
      ),
    ),
    GoRoute(
      path: Routes.restaurantPromoDiscountDetail,
      builder: (context, state) => BusinessListView(
        initialIndex: 0,
        promoTitle: 'Promo Diskon',
        restoRoute: Routes.restaurantPromoDiscountDetail,
        marketRoute: Routes.marketPromoDiscountDetail,
        bottomNavIndex: 1,
        businessesData: PromoController.promoDiscountRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.marketPromoDiscountDetail,
      builder: (context, state) => BusinessListView(
        initialIndex: 1,
        promoTitle: 'Promo Diskon',
        restoRoute: Routes.restaurantPromoDiscountDetail,
        marketRoute: Routes.marketPromoDiscountDetail,
        bottomNavIndex: 1,
        businessesData: PromoController.promoDiscountMarket,
      ),
    ),
    GoRoute(
      path: Routes.restaurantPromoFreeShipmentDetail,
      builder: (context, state) => BusinessListView(
        initialIndex: 0,
        promoTitle: 'Gratis Ongkir',
        restoRoute: Routes.restaurantPromoFreeShipmentDetail,
        marketRoute: Routes.marketPromoFreeShipmentDetail,
        bottomNavIndex: 1,
        businessesData: PromoController.promoFreeShipmentRestaurant,
      ),
    ),
    GoRoute(
      path: Routes.marketPromoFreeShipmentDetail,
      builder: (context, state) => BusinessListView(
        initialIndex: 1,
        promoTitle: 'Gratis Ongkir',
        restoRoute: Routes.restaurantPromoFreeShipmentDetail,
        marketRoute: Routes.marketPromoFreeShipmentDetail,
        bottomNavIndex: 1,
        businessesData: PromoController.promoFreeShipmentMarket,
      ),
    ),


    // History Section
    // Done History
    GoRoute(
      path: Routes.historyDone,
      builder: (context, state) {
        final id = state.extra != null && state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['history_id'] as int?
            : int.tryParse(state.pathParameters['history_id'] ?? '');

        return HistoryListView(routeIndex: 0, historyId: id);
      },
    ),
    // Ongoing History
    GoRoute(
      path: Routes.historyOngoing,
      builder: (context, state) {
        final id = state.extra != null && state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['history_id'] as int?
            : int.tryParse(state.pathParameters['history_id'] ?? '');

        return HistoryListView(routeIndex: 1, historyId: id);
      },
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

    // Ongoing History
    GoRoute(
      path: Routes.processingHistoryDetails,
      builder: (context, state) {
        return OngoingHistoryDetailsView.fromExtra(context, state);
      },
    ),
    GoRoute(
      path: Routes.processingHistoryCancel,
      builder: (context, state) {
        final id = state.extra != null && state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['id'] as int?
            : int.tryParse(state.pathParameters['id'] ?? '');

        return CancelOrderView(historyId: id ?? 0);
      },
    ),
    GoRoute(
      path: Routes.deliveringHistoryDetails,
      builder: (context, state) {
        return OngoingHistoryDetailsView.fromExtra(context, state);
      },
    ),

    // Chat Feature Section
    GoRoute(
      path: Routes.chatList,
      builder: (context, state) {
        final chatData = ChatListController.fetchChatListData(
          route: '/chatlist',
        );
        return ChatListView(chatListData: chatData);
      },
    ),
    GoRoute(
      path: Routes.chatDetail,
      builder: (context, state) {
        final data = state.extra != null && state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)
            : null;
        final chatData = ChatListController.fetchChatListData(
          route: '/chatlist/detail/:driverId',
          driverId: state.pathParameters['driverId'],
        );

        return ChatDetailView(
          driverId: data?['driver_id'],
          driverName: data?['driver_name'],
          driverImage: data?['driver_image'],
          chatDetailsData: chatData,
        );
      },
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