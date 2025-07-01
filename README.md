# Proyek Tugas Akhir - Nutrisenior Mobile App
**Nutrisenior - <i>Food E-Commerce App for Elderly People</i> 👵👴🍽️**

## Author
- **Nama**: Jason Rivalino  
- **NIM**: 13521008 
- **Institusi**: Institut Teknologi Bandung 
- **Jurusan**: Teknik Informatika

## Table of Contents
* [Deskripsi Proyek](#deskripsi-proyek)
* [Tech Stack](#tech-stack)
* [Daftar Fitur Aplikasi](#daftar-fitur-aplikasi)
* [Struktur Direktori File dan Class](#struktur-direktori-file-dan-class)
* [Acknowledgements](#acknowledgements)

## Deskripsi Proyek
**NutriSenior** adalah aplikasi <i>Food E-Commerce</i> berbasis <i>Mobile</i> yang dirancang khusus untuk memudahkan lansia dalam memilih dan memesan makanan sehat yang sesuai dengan kebutuhan nutrisi mereka. Aplikasi ini menyediakan fitur pemesanan makanan dari berbagai restoran dan pasar sehat serta rancangan antarmuka yang ramah pengguna untuk pengguna usia lanjut.
<br><br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/f523d958-1852-4fda-97cc-9f48ba47d582" alt="NutriSenior App For Android" width="200" style="border-radius: 16px;" />
  <br/>
  <strong>NutriSenior App Logo</strong>
</div>
<br><br>
Proyek ini dikembangkan sebagai bagian dari pengerjaan Tugas Akhir guna memenuhi salah satu syarat kelulusan program sarjana (S1) pada Program Studi Teknik Informatika, Institut Teknologi Bandung.

## Tech Stack
**Flutter 3.29.3 Version** 

## Daftar Fitur Aplikasi
|  ID   | Nama Fitur                                                                                                  |
|:-----:|:------------------------------------------------------------------------------------------------------------|
| F-01 | Fitur untuk registrasi dan login masuk ke dalam akun pengguna.                                               |
| F-02 | Fitur pemberian informasi rekomendasi restoran ataupun pusat belanja kepada pengguna.                        |
| F-03 | Fitur pencarian restoran ataupun pusat belanja yang diinginkan dengan search bar ataupun sort filter.        |
| F-04 | Fitur untuk pemilihan makanan ataupun belanjaan yang diinginkan pada restoran atau pusat belanja.            |
| F-05 | Fitur untuk melakukan pemesanan terhadap makanan ataupun belanjaan yang diinginkan.                          |
| F-06 | Fitur untuk melakukan pengecekan terhadap status informasi keberadaan dari pengiriman pesanan.               |
| F-07 | Fitur untuk melakukan pemberian rating dan komentar setelah melakukan pemesanan.                             |
| F-08 | Fitur untuk melakukan pengecekan terhadap rating dan komentar dari berbagai restoran dan pusat belanja.      |
| F-09 | Fitur untuk melakukan pengecekan terhadap riwayat daftar pembelian yang telah dilakukan sebelumnya.          |
| F-10 | Fitur untuk menandai dan mengecek berbagai restoran dan pusat belanja sebagai favorit.                       |
| F-11 | Fitur pemberian informasi terkait dengan daftar promo ataupun diskon pada restoran ataupun pusat belanja.    |
| F-12 | Fitur pelaporan restoran ataupun pusat belanja pada pusat layanan aplikasi.                                  |

## Struktur Direktori File dan Class
```
├── assets
├── config
│   ├── constants.dart
│   └── routes.dart
│
├── database
│   ├── addons_list_table.dart
│   ├── address_list_table.dart
│   ├── business_list_table.dart
│   ├── business_product_list_table.dart
│   ├── business_promo_list_table.dart
│   ├── chat_list_table.dart
│   ├── driver_list_table.dart
│   ├── favorites_list_table.dart
│   ├── history_add_ons_list_table.dart
│   ├── history_list_table.dart
│   ├── history_order_list_table.dart
│   ├── history_rating_image_list_table.dart
│   ├── history_rating_list_table.dart
│   ├── number_message_received_list_table.dart
│   ├── other_user_rating_image_list_table.dart
│   ├── other_user_rating_list_table.dart
│   ├── product_list_table.dart
│   ├── recommended_business_list_table.dart
│   ├── recommended_product_list_table.dart
│   ├── report_image_list_table.dart
│   └── report_list_table.dart
│
├── features
│   ├── ContactSection
│   │   ├── ChatDetails
│   │   │   ├── chat_details_view.dart
│   │   │   └── chat_details_widget.dart
│   │   │         ├── class: ChatAppBar
│   │   │         └── class: BottomChatWidget
│   │   ├── ChatList
│   │   │   ├── chat_list_view.dart
│   │   │   └── chat_list_widget.dart
│   │   │         └── class: ChatMessageTile
│   │   └── chat_controller.dart
│   │         ├── class: ChatListController
│   │         ├── class: NumberMessageReceivedController
│   │         └── class: SendMessageController
│   ├── HistorySection
│   │   ├── DoneHistory
│   │   │   ├── Rating
│   │   │   │   ├── rating_controller.dart
│   │   │   │   │   ├── class: DriverRatingController
│   │   │   │   │   └── class: BusinessRatingController
│   │   │   │   ├── rating_view.dart
│   │   │   │   └── rating_widget.dart
│   │   │   │         └── class: RatingCard
│   │   │   ├── Report
│   │   │   │   ├── report_controller.dart
│   │   │   │   │   └── class: ReportFillController
│   │   │   │   ├── report_data.dart
│   │   │   │   │   ├── list: driverReportReason
│   │   │   │   │   ├── list: restaurantReportReason
│   │   │   │   │   └── list: marketReportReason
│   │   │   │   ├── report_success_view.dart
│   │   │   │   └── report_view.dart
│   │   │   ├── done_history_details_view.dart
│   │   │   ├── done_history_details_widget.dart
│   │   │   │   ├── class: DoneOrderTimeDriverCard
│   │   │   │   ├── class: DoneOrderAddressCard
│   │   │   │   ├── class: DoneOrderDetailsCard
│   │   │   │   ├── class: FeedbackInformationBox
│   │   │   │   └── class: GiveFeedbackBottomNavbar
│   │   │   └── done_history_rating_controller.dart
│   │   │         ├── class: HistoryRatingController
│   │   │         └── class: HistoryReportController
│   │   ├── OngoingHistory
│   │   │   ├── CancelOrder
│   │   │   │   ├── cancel_order_controller.dart
│   │   │   │   │   └── class: CancelledOrderController
│   │   │   │   ├── cancel_order_data.dart
│   │   │   │   │   └── list: marketReportReason
│   │   │   │   └── cancel_order_view.dart
│   │   │   ├── ongoing_history_details_view.dart
│   │   │   └── ongoing_history_details_widget.dart
│   │   │         ├── class: EstimatedTimeCard
│   │   │         ├── class: OrderStatusDetails
│   │   │         ├── class: OrderListDetails
│   │   │         └── class: DeliverDriverCard
│   │   ├── history_controller.dart
│   │   │   └── class: HistoryController
│   │   └── history_list_view.dart
│   │
│   ├── LoginProcess
│   │   ├── LoginOption
│   │   │   ├── login_view.dart
│   │   │   └── login_widget.dart
│   │   │         └── class: LoginButton
│   │   ├── OTPVerification
│   │   │   ├── otp_verification_view.dart
│   │   │   └── otp_verifivation_widget.dart
│   │   │         └── class: OTPVerificationInput
│   │   └── PhoneNumber
│   │         ├── phone_number_login_view.dart
│   │         └── phone_number_login_widget.dart
│   │               └── class: PhoneNumberInput
│   │
│   ├── OrderSection
│   │   ├── BusinessListPage
│   │   │   ├── business_list_view.dart
│   │   │   └── business_list_widget.dart
│   │   │         └── class: BusinessListItem
│   │   ├── BusinessReviewMenu
│   │   │   ├── review_business_controller.dart
│   │   │   │   └── class: ReviewBusinessController
│   │   │   ├── review_business_view.dart
│   │   │   └── review_business_widget.dart
│   │   │         ├── class: RatingFilterButton
│   │   │         └── class: BusinessRatingItem
│   │   ├── FavoritesData
│   │   │   └── favorites_controller.dart
│   │   │         └── class: FavoritesController
│   │   ├── HomePage
│   │   │   ├── homepage_controller.dart
│   │   │   │   └── class: HomePageController
│   │   │   ├── homepage_view.dart
│   │   │   └── homepage_widget.dart
│   │   │         ├── class: HomeTopBarSection
│   │   │         ├── class: RecommendedTodayCarousel
│   │   │         └── class: RecommendedHomeSection
│   │   ├── OrderingMenu
│   │   │   ├── ConfirmationOrdering
│   │   │   │   ├── confirmation_ordering_controller.dart
│   │   │   │   │   ├── class: AddressRecipientChooseController
│   │   │   │   │   ├── class: UpdateBusinessDistanceController
│   │   │   │   │   └── class: OrderConfirmationController
│   │   │   │   ├── confirmation_ordering_view.dart
│   │   │   │   └── confirmation_ordering_widget.dart
│   │   │   │   │   ├── class: RecipientLocationBox
│   │   │   │   │   ├── class: DriverNoteOverlay
│   │   │   │   │   ├── class: OrderDetailListBox
│   │   │   │   │   ├── class: AddMoreOrderButtonBox
│   │   │   │   │   └── class: PaymentMethodBox
│   │   │   ├── DetailOrdering
│   │   │   │   ├── detail_ordering_controller.dart
│   │   │   │   │   └── class: AddOnsController
│   │   │   │   ├── detail_ordering_view.dart
│   │   │   │   └── detail_ordering_widget.dart
│   │   │   │         ├── class: ProductDetailInfoBox
│   │   │   │         ├── class: ProductAddOnsSelectionBox
│   │   │   │         ├── class: ProductNoteInputBox
│   │   │   │         └── class: SetQuantityBottomNavbar
│   │   │   ├── business_ordering_menu_controller.dart
│   │   │   │   ├── class: BusinessOrderingMenuController
│   │   │   │   └── class: FavoritesBusinessController
│   │   │   ├── business_ordering_menu_view.dart
│   │   │   └── business_ordering_menu_widget.dart
│   │   │         ├── class: BusinessHeaderBar
│   │   │         ├── class: RecommendedProductSection
│   │   │         └── class: ProductListSection
│   │   └── SearchingMenu
│   │         ├── search_controller.dart
│   │         │   ├── class: RecentSearchController
│   │         │   ├── class: SearchPageController
│   │         │   ├── class: AddressListController
│   │         │   └── class: RecipientAddressController
│   │         ├── search_view.dart
│   │         └── search_widget.dart
│   │               ├── class: OrderLocationSelection
│   │               ├── class: SearchBarWithFilter
│   │               ├── class: BusinessSelectionSearch
│   │               ├── class: RecentSearchList
│   │               └── class: SortFilterOverlay
│   │
│   ├── ProfileController
│   │   ├── profile_view.dart
│   │   └── profile_widget.dart
│   │         ├── class: ProfileCard
│   │         └── class: ProfileMenuList
│   │
│   ├── PromoSection
│   │   ├── recommend_promo_controller.dart
│   │         └── class: PromoController
│   │   ├── recommend_promo_view.dart
│   │   └── recommend_promo_widget.dart
│   │         └── class: RecommendedPromoCardList
│   │
│   └── SplashScreen
│         └── splashscreen.dart
│
├── shared
│   ├── styles
│   │   ├── colors.dart
│   │   ├── fonts.dart
│   │   └── texts.dart
│   │
│   ├── utils
│   │   ├── calculate_price_fee.dart
│   │   │   ├── function: getProductPrice
│   │   │   ├── function: calculateTotalAddOnsPrice
│   │   │   ├── function: getDeliveryFee
│   │   │   └── function: calculateFinalOrderTotal
│   │   ├── carousel_card.dart
│   │   │   ├── function: getLoopedBusiness
│   │   │   └── function: handlePageChanged
│   │   ├── format_currency.dart
│   │   │   └── function: formatCurrency
│   │   ├── formatted_time.dart
│   │   │   ├── function: formatTime
│   │   │   ├── function: formatDate
│   │   │   └── function: formatFullDateTime
│   │   ├── fullscreen_image_view.dart
│   │   │   └── class: FullScreenImageView
│   │   ├── generate_random_driver_phone_number.dart
│   │   │   └── function: generatePhoneNumber
│   │   ├── google_auth_service.dart
│   │   │   └── class: GoogleAuthService
│   │   ├── handling_chat_send.dart
│   │   │   ├── class: MessageStatusIcon
│   │   │   ├── function: handleSendTextMessages
│   │   │   ├── function: handleSendImageMessages
│   │   │   └── function: updateMessageStatus
│   │   ├── handling_choose_image.dart
│   │   │   ├── function: profileImageChoose
│   │   │   └── function: handleChooseImage
│   │   ├── is_business_open.dart
│   │   │   └── function: isBusinessOpen
│   │   ├── otp_notification.dart
│   │   │   └── class: OTPNotificationService
│   │   ├── page_not_found.dart
│   │   │   └── class: PageNotFound
│   │   └── validate_otp.dart
│   │         └── function: validateOTP
│   │
│   └── widgets
│         ├── detail_card
│         │   ├── business_detail_card.dart
│         │   ├── card_box.dart
│         │   ├── card_list.dart
│         │   └── history_card_list.dart
│         ├── list_helper
│         │   ├── list_title.dart
│         │   └── resto_market_selector.dart
│         ├── address_selection_overlay.dart
│         ├── appbar.dart
│         ├── bottom_navbar.dart
│         ├── confirm_dialog.dart
│         ├── elevated_button.dart
│         ├── feedback_input_card.dart
│         └── order_bottom_navbar.dart
│
├── app.dart  
└── main.dart
```

## Acknowledgements
- Tuhan Yang Maha Esa
- Bapak Adi Mulyanto, S.T., M.T., selaku dosen pembimbing yang telah memberikan ilmu dan bimbingan selama pengerjaan Tugas Akhir
- Ibu Tricya Esterina Widagdo, S.T., M.Sc. selaku dosen koordinator untuk pelaksanaan Tugas Akhir
- Djoni Budijono dan Emma sebagai kedua orang tua dan Sherin Chelycia sebagai saudara kandung yang selalu memberikan semangat, doa, dan dukungan terhadap kelancaran dalam pengerjaan Tugas Akhir
- Rekan-rekan mahasiswa Teknik Informatika yang telah memberikan semangat dan motivasi kepada penulis
- Semua pihak lain yang memberikan bantuan, semangat dan doa pada penulis dalam menyelesaikan pengerjaan draf Tugas Akhir
