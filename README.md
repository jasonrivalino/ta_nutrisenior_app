# Final Project Assignment - Nutrisenior Mobile App
**Nutrisenior - <i>Food E-Commerce App for Elderly People</i>**

## Author
- **Name**: Jason Rivalino  
- **NIM**: 13521008 
- **Institute**: Bandung Institute of Technology
- **Major**: Informatics Engineering

## Table of Contents
* [Project Description](#project-description)
* [Application Interface Preview](#application-interface-preview)
* [Tech Stack](#tech-stack)
* [System Functionality List](#system-functionality-list)
* [File and Class Directory Structure](#file-and-class-directory-structure)
* [Poster](#poster)
* [Documentation Link](#documentation-link)
* [Acknowledgements](#acknowledgements)

## Project Description
NutriSenior is a mobile-based food e-commerce application specifically designed to help the elderly easily select and order healthy meals that meet their nutritional needs. The application offers food ordering from various businesses, including restaurants and health markets, and features a user-friendly interface for senior users.
<br><br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/f523d958-1852-4fda-97cc-9f48ba47d582" alt="NutriSenior App For Android" width="200" style="border-radius: 16px;" />
  <br/>
  <strong>NutriSenior App Logo</strong>
</div>
<br><br>
This project was developed as part of the Final Project to complete the Bachelor’s degree program in Informatics Engineering at Bandung Institute of Technology.

## Application Interface Preview
<br>
<p align="center">
  <img width="650" height="550" alt="Purple Pink Gradient Mobile Application Presentation-Photoroom (2)" src="https://github.com/user-attachments/assets/b7676ef2-4e63-4606-bb16-54b740126505" />
</p>

## Tech Stack
**Flutter 3.29.3 Version** 

## System Functionality List
| KF-ID | System Functionality                                                                                                              |
|:-----:|:----------------------------------------------------------------------------------------------------------------------------------|
| KF-01 | Registration or login process to access each personal account.                                                                    |
| KF-02 | Logout option to exit the personal account and switch to another account.                                                         |
| KF-03 | List of recommended businesses.                                                                                                   |
| KF-04 | Search and sorting for finding businesses.                                                                                        |
| KF-05 | List of businesses offering sales promotions.                                                                                     |
| KF-06 | Mark or unmark a business as a favorite.                                                                                          |
| KF-07 | List of businesses marked as favorites.                                                                                           |
| KF-08 | Detailed information about a business with a layout that is easy to view and content that is easy to understand.                  |
| KF-09 | Detailed information about products sold by a business with a layout that is easy to view and content that is easy to understand. |
| KF-10 | Customize the product to be ordered.                                                                                              |
| KF-11 | Choose the delivery address for an order.                                                                                         |
| KF-12 | Add delivery notes for the driver.                                                                                                |
| KF-13 | Select a payment method for an order.                                                                                             |
| KF-14 | Confirm an order for selected products along with the previously entered information.                                             |
| KF-15 | Detailed information about the status and location of a previously placed order.                                                  |
| KF-16 | Cancel an order that is still in processing.                                                                                      |
| KF-17 | Chat with the delivery driver.                                                       |
| KF-18 | Show a simple and easy-to-understand message upon success or failure of an action.   |
| KF-19 | Detailed history of completed orders.                                                |
| KF-20 | Reorder from a previously ordered business.                                          |
| KF-21 | Give rating and comment for the driver or business that ordered from previously.     |
| KF-22 | View all ratings and comments for a business.                                        |

## File and Class Directory Structure
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

## Poster
<img width="1587" height="2245" alt="Blue Illustration Process of Hospital Patient Admission Flowchart Poster" src="https://github.com/user-attachments/assets/88c81aad-4f8d-4290-b947-42a43e9a4251" />

## Documentation Link
1. Application Demo Link: <br>
https://youtu.be/Thlf4yUwftU
2. Technical Document Link: <br>
https://drive.google.com/file/d/11Qlss4Sy9Rr5Bxy_UVJZ-1W2w4VSf0EU
3. Prototype Design Link: <br>
https://www.figma.com/design/gJuODaLsdT8PQrgCz9ttUP/NutriSenior-App-for-TA?node-id=0-1&t=xJcGBQeaZ231TDM5-1 
4. Full Documentation Link: <br>
https://drive.google.com/drive/folders/1Nhfk7d_hv1i-yWmdAn9y-foLKIhDpc5C

## Acknowledgements
- Mr. Adi Mulyanto, S.T., M.T., as the thesis supervisor who has provided knowledge and guidance throughout the completion of this final project.
- Mrs. Tricya Esterina Widagdo, S.T., M.Sc., and Ir. Robithoh Annur, S.T., M.Eng., Ph.D., as the course coordinators for the implementation of the final project course.
- All lecturers and teaching staff of the Informatics Engineering Department who have imparted knowledge during the study period, which greatly contributed to the completion of this final project.
- Djoni Budijono and Emma as my beloved parents, and Sherin Chelycia as my sibling, who have always been there to provide encouragement, prayers, and unwavering support throughout the entire process of completing this final project.
- Fellow Informatics Engineering students, especially those from Informatics Engineering Jatinangor (Angger, Bintang, Henry, Kelvin, Azmi, Matthew, Christo, Salman, Afnan, Haikal, Eunice, Syauqi, Willy, Laila, Syarifa, Ditra, Varraz, Wilson, Radit, Kenny, Nadil, Haidar, Copa, Agsha, Zulfiansyah, Malik, Jauza, and Fahrian) who have given encouragement and motivational support to the author in completing this final project.
- All active crew members of Liga Film Mahasiswa ITB, from Kruinz, Krusans, Krusuhan, to Kruwala, who provided many enjoyable experiences during the final project period.
- Darren and Cilla as members of ‘Bulbul,’ who were always there to provide encouragement and advice that motivated the author in completing this final project.
- Naomi, Risma, Gege, and Shaula as members of ‘Keluarga Berada,’ who were companions in struggle from the internship period to the completion of this final project.
- The author’s laptop and Kopi Kenangan, which faithfully accompanied the final project journey.
- All respondents involved in the process, from data collection to application testing and evaluation.
- All other parties who have given assistance, encouragement, and prayers to the author in completing this final project.
