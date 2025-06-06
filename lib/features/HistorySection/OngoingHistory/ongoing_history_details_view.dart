import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ta_nutrisenior_app/features/HistorySection/OngoingHistory/ongoing_history_details_widget.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';
import 'package:ta_nutrisenior_app/shared/widgets/warning_button.dart';

import '../../../shared/styles/colors.dart';

class OngoingHistoryDetailsView extends StatefulWidget {
  final int id;
  final String businessName;
  final String businessType;
  final String businessImage;
  final String? driverName;
  final String? addressReceiver;
  final String estimatedArrival;
  final List<Map<String, dynamic>>? orderList;
  final int? serviceFee;
  final int? deliveryFee;
  final int? totalPrice;
  final String cardType;

    const OngoingHistoryDetailsView({
    super.key,
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.businessImage,
    this.driverName,
    this.addressReceiver,
    required this.estimatedArrival,
    this.orderList,
    this.serviceFee,
    this.deliveryFee,
    this.totalPrice,
    required this.cardType,
  });

  factory OngoingHistoryDetailsView.fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>? ?? {};

    return OngoingHistoryDetailsView(
      id: extra['id'] ?? 0,
      businessName: extra['businessName'] ?? '',
      businessType: extra['businessType'] ?? '',
      businessImage: extra['businessImage'] ?? '',
      driverName: extra['driverName'] as String?,
      addressReceiver: extra['addressReceiver'] as String?,
      estimatedArrival: extra['estimatedArrival'] ?? '',
      orderList: (extra['orderList'] is List)
        ? (extra['orderList'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => item)
            .toList()
        : [],      
      serviceFee: extra['serviceFee'] as int?,
      deliveryFee: extra['deliveryFee'] as int?,
      totalPrice: extra['totalPrice'] as int?,
      cardType: extra['cardType'] ?? 'diproses',
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
    if (widget.cardType != 'diproses' && customStartMarker == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.woodland,
      appBar: CustomAppBar(
        title: "Detail Transaksi",
        showBackButton: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              if (widget.cardType != 'diproses') ...[
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
                        color: Colors.blue,
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
                top: widget.cardType == 'diproses' ? topPositionProcessing : topPositionDelivering,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height -
                    (widget.cardType == 'diproses' ? topPositionProcessing : topPositionDelivering),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.soapstone,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(
                      top: BorderSide(color: AppColors.dark, width: 1),
                    ),
                  ),
                  child: Column(
                    children: widget.cardType == 'diproses'
                        ? [
                            SafeArea(
                              bottom: false,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: OrderStatusDetails(
                                  businessType: widget.businessType,
                                  cardType: widget.cardType,
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
                                cardType: widget.cardType,
                              ),
                            ),
                            const SizedBox(height: 18),
                            DeliverDriverCard(
                              driverName: widget.driverName,
                              driverRate: 4.5,
                            ),
                            const SizedBox(height: 20),
                          ],
                  ),
                ),
              ),

              EstimatedTimeCard(
                businessName: widget.businessName,
                businessImage: widget.businessImage,
                etaText: widget.estimatedArrival,
                topPosition: (widget.cardType == 'diproses' ? topPositionProcessing : topPositionDelivering) - 40,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: widget.cardType == 'diproses'
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: AppColors.soapstone,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: WarningButton(
                warningText: "Batalkan Pemesanan",
                onPressed: () {
                  // Handle cancel order action
                },
              ),
            )
          : null,
    );
  }
}