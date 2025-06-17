import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ta_nutrisenior_app/features/HistorySection/OngoingHistory/ongoing_history_details_widget.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';
import 'package:ta_nutrisenior_app/shared/widgets/warning_button.dart';

import '../../../shared/styles/colors.dart';

class OngoingHistoryDetailsView extends StatefulWidget {
  final int historyId;
  final String businessName;
  final String businessType;
  final String businessImage;
  final int? driverId;
  final String? driverName;
  final String? driverImage;
  final double? driverRating;
  final String? driverPhoneNumber;
  final String? addressReceiver;
  final String estimatedArrivalTime;
  final List<Map<String, dynamic>>? orderList;
  final int? serviceFee;
  final int? deliveryFee;
  final int? totalPrice;
  final String status;

    const OngoingHistoryDetailsView({
    super.key,
    required this.historyId,
    required this.businessName,
    required this.businessType,
    required this.businessImage,
    this.driverId,
    this.driverName,
    this.driverImage,
    this.driverRating,
    this.driverPhoneNumber,
    this.addressReceiver,
    required this.estimatedArrivalTime,
    this.orderList,
    this.serviceFee,
    this.deliveryFee,
    this.totalPrice,
    required this.status,
  });

  factory OngoingHistoryDetailsView.fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>? ?? {};

    return OngoingHistoryDetailsView(
      historyId: extra['history_id'] as int,
      businessName: extra['business_name'] as String,
      businessType: extra['business_type'] as String,
      businessImage: extra['business_image'] as String,
      driverId: extra['driver_id'] as int?,
      driverName: extra['driver_name'] as String?,
      driverImage: extra['driver_image'] as String?,
      driverRating: extra['driver_rating'] as double?,
      driverPhoneNumber: extra['driver_phone_number'] as String?,
      addressReceiver: extra['address_receiver'] as String?,
      estimatedArrivalTime: extra['estimated_arrival_time'] ?? '',
      orderList: (extra['order_list'] is List)
        ? (extra['order_list'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => item)
            .toList()
        : [],      
      serviceFee: extra['service_fee'] as int?,
      deliveryFee: extra['delivery_fee'] as int?,
      totalPrice: extra['total_price'] as int?,
      status: extra['status'] ?? 'diproses',
    );
  }

  @override
  State<OngoingHistoryDetailsView> createState() => _OngoingHistoryDetailsViewState();
}

class _OngoingHistoryDetailsViewState extends State<OngoingHistoryDetailsView> {
  BitmapDescriptor? customStartMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    final bitmap = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/dummy/motorcycle_delivery.png',
    );
    setState(() {
      customStartMarker = bitmap;
    });
  }

  @override
  Widget build(BuildContext context) {
    int orderCount = widget.orderList?.length ?? 0;
    double topPositionProcessing, topPositionDelivering;
    final screenHeight = MediaQuery.of(context).size.height;

    if (orderCount == 1) {
      topPositionProcessing = screenHeight > 900 ? 300 : 190;
    } else if (orderCount == 2) {
      topPositionProcessing = screenHeight > 900 ? 220 : 115;
    } else {
      topPositionProcessing = screenHeight > 900 ? 140 : 80;
    }

    topPositionDelivering = screenHeight > 900 ? 535 : 435;

    // Show loading while marker is being loaded
    if (widget.status != 'diproses' && customStartMarker == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        context.go('/historyOngoing');
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Detail Transaksi",
          showBackButton: true,
          onBack: () => context.go('/historyOngoing'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                if (widget.status != 'diproses') ...[
                  Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-6.208950, 106.816500),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('start'),
                          position: const LatLng(-6.210000, 106.816000),
                          infoWindow: const InfoWindow(title: 'Start Point'),
                          icon: customStartMarker!,
                        ),
                        Marker(
                          markerId: const MarkerId('arrive'),
                          position: const LatLng(-6.190000, 106.820000),
                          infoWindow: const InfoWindow(title: 'Arrival Point'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        ),
                      },
                      polylines: {
                        const Polyline(
                          polylineId: PolylineId('route'),
                          color: AppColors.blueDress,
                          width: 5,
                          points: [
                            LatLng(-6.210000, 106.816000),
                            LatLng(-6.190000, 106.820000),
                          ],
                        ),
                      },
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ] else
                  Container(color: AppColors.woodland),

                Positioned(
                  top: widget.status == 'diproses' ? topPositionProcessing : topPositionDelivering,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height -
                      (widget.status == 'diproses' ? topPositionProcessing : topPositionDelivering),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.soapstone,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      border: Border(
                        top: BorderSide(color: AppColors.dark, width: 1),
                      ),
                    ),
                    child: Column(
                      children: widget.status == 'diproses'
                          ? [
                              SafeArea(
                                bottom: false,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 60),
                                  child: OrderStatusDetails(
                                    businessType: widget.businessType,
                                    status: widget.status,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(bottom: screenHeight > 900 ? 205 : 185),
                                  child: OrderListDetails(
                                    orderList: widget.orderList,
                                    serviceFee: widget.serviceFee,
                                    deliveryFee: widget.deliveryFee,
                                    totalPrice: widget.totalPrice,
                                  ),
                                ),
                              ),
                            ]
                          : [
                              Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: OrderStatusDetails(
                                  businessType: widget.businessType,
                                  status: widget.status,
                                ),
                              ),
                              const SizedBox(height: 18),
                              DeliverDriverCard(
                                driverId: widget.driverId,
                                driverName: widget.driverName,
                                driverImage: widget.driverImage,
                                driverRate: widget.driverRating,
                                driverPhoneNumber: widget.driverPhoneNumber,
                              ),
                              const SizedBox(height: 20),
                            ],
                    ),
                  ),
                ),

                EstimatedTimeCard(
                  businessName: widget.businessName,
                  businessImage: widget.businessImage,
                  etaText: widget.estimatedArrivalTime,
                  topPosition: (widget.status == 'diproses' ? topPositionProcessing : topPositionDelivering) - 40,
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: widget.status == 'diproses'
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: const BoxDecoration(
                  color: AppColors.soapstone,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: WarningButton(
                  warningText: "Batalkan Pemesanan",
                  onPressed: () {
                    context.push(
                      '/history/processing/:id/cancel',
                      extra: {
                        'id': widget.historyId,
                      },
                    );
                  },
                ),
              )
            : null,
      ),
    );
  }
}