import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';

import '../../../shared/styles/fonts.dart';
import '../../../shared/utils/is_business_open.dart';
import '../../../shared/widgets/product_card/card_list.dart';
import 'search_controller.dart';
import 'search_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchBusinessController = TextEditingController();
  final TextEditingController _searchAddressController = TextEditingController();
  int selectedIndex = 0;
  String _searchQuery = '';

  int _selectedSortOption = 0;
  int _tempSelectedSortOption = 0;

  final List<int> recentRestaurantSearches = [1, 6, 13];
  final List<int> recentMarketSearches = [8, 10];

  final List<int> defaultAddress = [1];

  late Map<String, dynamic> _selectedAddress;

  @override
  void initState() {
    super.initState();
    _tempSelectedSortOption = _selectedSortOption;
    _selectedAddress = AddressChooseController.getAddressesCondition(defaultAddress).first;

    // Call update distances here using selected default address
    final selectedId = _selectedAddress['address_id'];
    AddressChangeController.updateBusinessDistances(selectedId);
  }

  @override
  Widget build(BuildContext context) {
    final businesses = selectedIndex == 0
        ? SearchPageController.restaurantList(sortOption: _selectedSortOption)
        : SearchPageController.marketList(sortOption: _selectedSortOption);

    final recentSearchData = selectedIndex == 0
        ? SearchPageController.getRecentSearchBusinesses(
            recentRestaurantSearches, 'restaurant')
        : SearchPageController.getRecentSearchBusinesses(
            recentMarketSearches, 'market');

    final filteredBusinesses = _searchQuery.isEmpty
        ? []
        : businesses
            .where((b) => b['business_name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

  return Scaffold(
    backgroundColor: AppColors.soapstone,
    appBar: CustomAppBar(title: 'Menu Pencarian', showBackButton: true),
    body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            CustomLocationAppBarTitle(
              selectedAddress: _selectedAddress,
              onAddressChanged: (newAddress) {
                setState(() {
                  _selectedAddress = newAddress;
                });
              },
              onTap: () {
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
                            setState(() => _selectedAddress = newAddress);
                          },
                        ),
                      );
                    },
                  ),
                );
                },
              ),
              const SizedBox(height: 16),
              SearchBarWithFilter(
                controller: _searchBusinessController,
                onChanged: (value) async {
                  final connectivityResult = await Connectivity().checkConnectivity();
                  if (connectivityResult.contains(ConnectivityResult.none)) {
                    Fluttertoast.showToast(
                      msg: 'Pencarian gagal dilakukan.\nSilahkan coba lagi.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }
                  setState(() => _searchQuery = value);
                },
                onFilterPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SortFilterOverlay(
                      selectedOption: _selectedSortOption,
                        onApply: (newOption) async {
                          final connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult.contains(ConnectivityResult.none)) {
                            Fluttertoast.showToast(
                              msg: 'Pengurutan gagal dilakukan.\nSilahkan coba lagi.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            return false;
                          }

                          setState(() {
                            _selectedSortOption = _tempSelectedSortOption;
                          });
                          return true;
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              BusinessSelectionSearch(
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    _searchQuery = '';
                    _searchBusinessController.clear();
                  });
                },
              ),
              _searchQuery.isEmpty
                  ? RecentSearchList(
                      items: recentSearchData,
                      onItemTapped: (business) async {
                        final connectivityResult = await Connectivity().checkConnectivity();
                        if (connectivityResult.contains(ConnectivityResult.none)) {
                          Fluttertoast.showToast(
                            msg: 'Pencarian gagal dilakukan.\nSilahkan coba lagi.',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        setState(() {
                          _searchQuery = business['business_name'];
                          _searchBusinessController.text = business['business_name'];
                        });
                      },
                    )
                  : Expanded(
                      child: filteredBusinesses.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'Pencarian ${selectedIndex == 0 ? "Restoran" : "Pusat Belanja"} tidak ditemukan.',
                                  style: TextStyle(
                                    color: AppColors.dark.withValues(alpha: 0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.fontMedium,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: AppColors.darkGray,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: ListView.builder(
                                itemCount: filteredBusinesses.length,
                                itemBuilder: (context, index) {
                                  final business = filteredBusinesses[index];
                                  final isOpen = isBusinessOpen(
                                    business['business_open_hour'],
                                    business['business_close_hour'],
                                  );

                                  return CardList(
                                    businessImage: business['business_image'],
                                    businessName: business['business_name'],
                                    businessType: business['business_type'],
                                    businessRate: business['business_rating'],
                                    businessLocation: business['business_distance'],
                                    discountNumber: business['discount_number'],
                                    isFreeShipment: business['is_free_shipment'],
                                    isOpen: isOpen,
                                    onTap: () {
                                      final route = '/business/detail/${business['business_id']}';

                                      context.push(
                                        route,
                                        extra: {
                                          'business_id': business['business_id'],
                                          'business_name': business['business_name'],
                                          'business_type': business['business_type'],
                                          'business_image': business['business_image'],
                                          'business_rating': business['business_rating'],
                                          'business_distance': business['business_distance'],
                                          'business_address': business['business_address'],
                                          'business_open_hour': business['business_open_hour'],
                                          'business_close_hour': business['business_close_hour'],
                                          'estimated_delivery': business['estimated_delivery'],
                                          'discount_number': business['discount_number'],
                                          'is_free_shipment': business['is_free_shipment'],
                                          'service_fee': business['service_fee'],
                                          'selected_address_id': _selectedAddress['address_id'],
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}