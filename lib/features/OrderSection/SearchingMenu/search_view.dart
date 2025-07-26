import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';
import '../../../shared/utils/is_business_open.dart';
import '../../../shared/widgets/address_selection_overlay.dart';
import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/detail_card/card_list.dart';

import 'search_widget.dart';
import 'search_controller.dart';

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

  final List<int> defaultAddress = [1];
  late Map<String, dynamic> _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress = AddressListController.getAddressesCondition(defaultAddress).first;

    final selectedId = _selectedAddress['address_id'];
    RecipientAddressController.updateBusinessDistances(selectedId);
  }

  @override
  Widget build(BuildContext context) {
    final businesses = selectedIndex == 0
        ? SearchPageController.restaurantList(sortOption: _selectedSortOption)
        : SearchPageController.marketList(sortOption: _selectedSortOption);

    final recentSearchData = SearchPageController.getRecentSearchBusinesses(
      RecentSearchController.getRecentSearches(selectedIndex == 0 ? 'restaurant' : 'market'),
      selectedIndex == 0 ? 'restaurant' : 'market',
    );

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
              OrderLocationSelection(
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
                    backgroundColor: AppColors.ecruWhite,
                    builder: (_) => DraggableScrollableSheet(
                      initialChildSize: 0.81,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      expand: false,
                      builder: (context, scrollController) {
                        return SafeArea(
                          top: false, // optional: allow it to reach top edge if needed
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.ecruWhite,
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
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }
                  setState(() => _searchQuery = value);
                },
                onFilterPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.ecruWhite,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: SortFilterOverlay(
                          businessType: selectedIndex == 0 ? 'restaurant' : 'market',
                          selectedOption: _selectedSortOption,
                          onApply: (newOption) async {
                            final connectivityResult = await Connectivity().checkConnectivity();
                            if (connectivityResult.contains(ConnectivityResult.none)) {
                              Fluttertoast.showToast(
                                msg: 'Pengurutan gagal dilakukan.\nSilahkan coba lagi.',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return false;
                            }

                            setState(() {
                              _selectedSortOption = newOption;
                            });
                            return true;
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BusinessSelectionSearch(
                selectedIndex: selectedIndex,
                  onTabSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                      // Keep the current text; don't clear
                      _searchQuery = _searchBusinessController.text;
                    });
                  },
              ),
              SizedBox(height: 10),
              _searchQuery.isEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: RecentSearchList(
                        items: recentSearchData,
                        onItemTapped: (business) async {
                          final connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult.contains(ConnectivityResult.none)) {
                            Fluttertoast.showToast(
                              msg: 'Pencarian gagal dilakukan.\nSilahkan coba lagi.',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                            );
                            return;
                          }

                          setState(() {
                            _searchQuery = business['business_name'];
                            _searchBusinessController.text = business['business_name'];
                          });
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: filteredBusinesses.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'Pencarian ${selectedIndex == 0 ? "Restoran" : "Pusat Belanja"} tidak ditemukan.',
                                style: AppTextStyles.textMedium(
                                  size: 16,
                                  color: AppColors.dark.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 6),
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
                                    RecentSearchController.addToRecent(
                                      business['business_id'],
                                      business['business_type'],
                                    );

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
                                        'is_halal': business['is_halal'],
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