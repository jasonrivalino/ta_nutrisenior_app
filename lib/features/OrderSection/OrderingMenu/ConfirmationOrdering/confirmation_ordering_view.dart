import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../database/business_list_table.dart';
import '../../../../shared/styles/colors.dart';
import '../../../../shared/utils/calculate_price_fee.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../SearchingMenu/search_controller.dart';
import '../../SearchingMenu/search_widget.dart';
import '../business_ordering_menu_widget.dart';
import 'confirmation_ordering_controller.dart';
import 'confirmation_ordering_widget.dart';

class OrderConfirmationView extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final int serviceFee;
  final int businessId;
  final String businessName;
  final String businessType;
  final String businessImage;
  final double businessDistance;
  final String businessEstimatedDelivery;
  final int? discountNumber;
  final bool isFreeShipment;
  final int totalPrice;
  final int selectedAddressId;

  const OrderConfirmationView({
    super.key,
    required this.selectedProducts,
    required this.businessId,
    required this.businessName,
    required this.businessType,
    required this.businessImage,
    required this.businessDistance,
    required this.businessEstimatedDelivery,
    this.discountNumber,
    required this.isFreeShipment,
    required this.serviceFee,
    required this.totalPrice,
    required this.selectedAddressId,
  });

  static OrderConfirmationView fromExtra(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>;
    print("Address ID: ${extra['selected_address_id']}");

    return OrderConfirmationView(
      selectedProducts: extra['selected_products'] as List<Map<String, dynamic>>,
      businessId: extra['business_id'] as int,
      businessName: extra['business_name'] as String,
      businessType: extra['business_type'] as String,
      businessImage: extra['business_image'] as String,
      businessDistance: extra['business_distance'] as double,
      businessEstimatedDelivery: extra['business_estimated_delivery'] as String,
      discountNumber: extra['discount_number'] as int?,
      isFreeShipment: extra['is_free_shipment'] as bool,
      serviceFee: extra['service_fee'] as int,
      totalPrice: extra['total_price'] as int,
      selectedAddressId: extra['selected_address_id'] as int,
    );
  }

  @override
  State<OrderConfirmationView> createState() => _OrderConfirmationViewState();
}

class _OrderConfirmationViewState extends State<OrderConfirmationView> {
  late List<Map<String, dynamic>> _selectedProducts;
  String driverNote = "-";
  String _selectedPaymentMethod = 'Pembayaran Tunai';

  late Map<String, dynamic> _selectedAddress;
  final TextEditingController _searchAddressController = TextEditingController();

  late double _businessDistance;
  late int _deliveryFee;

  @override
  void initState() {
    super.initState();

    _selectedProducts = List<Map<String, dynamic>>.from(widget.selectedProducts);

    // Check if there's persisted state
    final persistedId = AddressChangeController.lastSelectedAddressId;
    final persistedDistance = AddressChangeController.lastBusinessDistance;
    final persistedFee = AddressChangeController.lastDeliveryFee;

    if (persistedId != null &&
        persistedDistance != null &&
        persistedFee != null &&
        persistedId != widget.selectedAddressId) {
      // Use persisted state
      _selectedAddress = AddressOrderController.getAddressById(persistedId) ?? {};
      _businessDistance = persistedDistance;
      _deliveryFee = persistedFee;
    } else {
      // Use initial values from constructor
      _selectedAddress =
          AddressOrderController.getAddressById(widget.selectedAddressId) ?? {};
      _businessDistance = widget.businessDistance;
      _deliveryFee =
          calculateDeliveryFee(widget.isFreeShipment, _businessDistance);

      // Persist for first time
      AddressChangeController.lastSelectedAddressId = widget.selectedAddressId;
      AddressChangeController.lastBusinessDistance = _businessDistance;
      AddressChangeController.lastDeliveryFee = _deliveryFee;
    }
  }


  int _calculateUpdatedTotalPrice() {
    int productTotal = 0;

    for (var product in _selectedProducts) {
      final productPrice = product['product_price'] as int;
      final quantity = product['qty_product'] as int;
      final addOns = product['add_ons_details'] as List<Map<String, dynamic>>?;

      // Product price
      int totalPerProduct = productPrice * quantity;

      // Add-ons price
      if (addOns != null && addOns.isNotEmpty) {
        for (var addOn in addOns) {
          final addOnPrice = addOn['add_ons_price'] as int;
          totalPerProduct += addOnPrice;
        }
      }

      productTotal += totalPerProduct;
    }

    final deliveryFee = calculateDeliveryFee(widget.isFreeShipment, _businessDistance);

    return productTotal + widget.serviceFee + deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    print("Selected Products: $_selectedProducts");
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        context.pop(_selectedProducts);
      },
      child: Scaffold(
        backgroundColor: AppColors.soapstone,
        appBar: CustomAppBar(
          title: "Konfirmasi Pesanan",
          showBackButton: true,
          customParam: _selectedProducts,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecipientLocationBox(
                onAddressClick: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => DraggableScrollableSheet(
                      initialChildSize: 0.81,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      expand: false,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: AppColors.berylGreen,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: AddressSelectionOverlay(
                            controller: _searchAddressController,
                            onChanged: (value) {
                              setState(() {
                                _searchAddressController.text = value;
                              });
                            },
                            onAddressSelected: (newAddress) {
                              final newAddressId = newAddress['address_id'];

                              // Update business list distances globally
                              AddressChangeController.updateBusinessDistances(newAddressId);

                              // Get updated distance for current business
                              final updatedBusiness = businessListTable.firstWhere(
                                (b) => b['business_id'] == widget.businessId,
                                orElse: () => {},
                              );

                              final newDistance = updatedBusiness['business_distance'] ?? _businessDistance;
                              final newDeliveryFee = calculateDeliveryFee(widget.isFreeShipment, newDistance);

                              setState(() {
                                _selectedAddress = newAddress;
                                _businessDistance = newDistance;
                                _deliveryFee = newDeliveryFee;
                              });

                              // Persist new state
                              AddressChangeController.lastSelectedAddressId = newAddressId;
                              AddressChangeController.lastBusinessDistance = newDistance;
                              AddressChangeController.lastDeliveryFee = newDeliveryFee;
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                onNotesClick: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.ecruWhite,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return DriverNoteOverlay(
                        initialNote: driverNote,
                        onNoteSubmitted: (newNote) {
                          setState(() {
                            driverNote = newNote;
                          });
                          print("Note Pengantar: $driverNote");
                        },
                      );
                    },
                  );
                },
                note: driverNote,
                addressName: _selectedAddress['address_name'] ?? '-',
                addressDetail: _selectedAddress['address_detail'] ?? '-',
              ),
              const SizedBox(height: 8),

              OrderDetailListBox(
                selectedProducts: _selectedProducts,
                serviceFee: widget.serviceFee,
                deliveryFee: _deliveryFee,
                discountNumber: widget.discountNumber,
                businessId: widget.businessId,
                businessType: widget.businessType,
                onCountChanged: (productId, newQty) {
                  setState(() {
                    _selectedProducts.removeWhere((p) {
                      final matches = p['product_id'].toString() == productId;
                      if (matches && newQty == 0) return true;
                      if (matches) p['qty_product'] = newQty;
                      return false;
                    });
                  });
                },
                onNotesChanged: (productId, notes) {
                  setState(() {
                    final index = _selectedProducts.indexWhere(
                      (p) => p['product_id'].toString() == productId,
                    );
                    if (index != -1) {
                      _selectedProducts[index]['notes'] = notes;
                    }
                  });
                },
                onAddOnsChanged: (productId, addOns) {
                  setState(() {
                    final index = _selectedProducts.indexWhere(
                      (p) => p['product_id'].toString() == productId,
                    );
                    if (index != -1) {
                      _selectedProducts[index]['add_ons_details'] = addOns;
                    }
                  });
                },
              ),
              const SizedBox(height: 8),

              AddMoreOrderButtonBox(
                onAddMorePressed: () {
                  context.pop(_selectedProducts);
                },
              ),
              const SizedBox(height: 8),

              PaymentMethodBox(
                selectedMethod: _selectedPaymentMethod,
                onMethodSelected: (method) {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        bottomNavigationBar: OrderBottomNavbar(
          totalPrice: _calculateUpdatedTotalPrice(),
          buttonText: "Lakukan Pemesanan",
          onOrderPressed: () async {
            final connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult.contains(ConnectivityResult.none)) {
              Fluttertoast.showToast(
                msg: 'Pemesanan gagal dilakukan.\nSilahkan coba lagi.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
              return;
            }

            final int updatedTotalPrice = _calculateUpdatedTotalPrice();

            print("=== Order Confirmation Debug Info ===");
            print("Selected Products:");
            for (var product in _selectedProducts) {
              print(
                "Product ID: ${product['product_id']}, Name: ${product['product_name']}, "
                "Price: ${product['product_price']}, Quantity: ${product['qty_product']}, "
                "Notes: ${product['notes'] ?? '-'}",
              );
            }
            print("Service Fee: ${widget.serviceFee}");
            print("Delivery Fee: $_deliveryFee");
            print("Total Price: $updatedTotalPrice");
            print("Address Delivery: ${_selectedAddress['address_detail']}");
            print("Driver Note: $driverNote");
            print("Payment Method: $_selectedPaymentMethod");

            final int historyId = OrderConfirmationController.addOrder(
              businessId: widget.businessId,
              selectedProducts: _selectedProducts,
              estimatedDelivery: widget.businessEstimatedDelivery,
              deliveryFee: _deliveryFee,
              paymentMethod: _selectedPaymentMethod,
              addressDetail: _selectedAddress['address_detail'],
            );

            AddressChangeController.updateBusinessDistances(1);
            AddressChangeController.lastSelectedAddressId = null;
            AddressChangeController.lastBusinessDistance = null;
            AddressChangeController.lastDeliveryFee = null;

            context.push(
              '/history/processing/$historyId',
              extra: {
                'history_id': historyId,
                'business_name': widget.businessName,
                'business_type': widget.businessType,
                'business_image': widget.businessImage,
                'estimated_arrival_time': widget.businessEstimatedDelivery,
                'order_list': _selectedProducts,
                'service_fee': widget.serviceFee,
                'delivery_fee': _deliveryFee,
                'total_price': updatedTotalPrice,
                'status': 'diproses',
              },
            );
          },
        ),
      ),
    );
  }
}