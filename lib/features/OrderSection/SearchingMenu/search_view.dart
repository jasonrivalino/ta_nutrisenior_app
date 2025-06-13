import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/widgets/appbar.dart';

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
  final TextEditingController _searchController = TextEditingController();
  int selectedIndex = 0;
  String _searchQuery = '';

  bool _showSortOverlay = false;
  int _selectedSortOption = 0;
  int _tempSelectedSortOption = 0;

  final List<int> recentRestaurantSearches = [1, 6, 13];
  final List<int> recentMarketSearches = [8, 10];

  List<Map<String, dynamic>> getRecentSearchData(
      List<int> ids, List<Map<String, dynamic>> source) {
    return ids
        .map((id) => source.firstWhere(
              (b) => b['business_id'] == id,
              orElse: () => {},
            ))
        .where((b) => b.isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tempSelectedSortOption = _selectedSortOption;
  }

  @override
  Widget build(BuildContext context) {
    final businesses = selectedIndex == 0
        ? SearchPageController.restaurantList(sortOption: _selectedSortOption)
        : SearchPageController.marketList(sortOption: _selectedSortOption);

    final recentSearchData = selectedIndex == 0
        ? getRecentSearchData(recentRestaurantSearches, businesses)
        : getRecentSearchData(recentMarketSearches, businesses);

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
              CustomLocationAppBarTitle(),
              const SizedBox(height: 16),
              SearchBarWithFilter(
                controller: _searchController,
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
                onFilterPressed: () {
                  setState(() {
                    _tempSelectedSortOption = _selectedSortOption;
                    _showSortOverlay = true;
                  });
                },
              ),
              const SizedBox(height: 24),
              BusinessSelectionSearch(
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    _searchQuery = '';
                    _searchController.clear();
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
                          _searchController.text = business['business_name'];
                        });
                      },
                    )
                  : Expanded(
                      child: Container(
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
                              businessRate: business['business_rating'],
                              businessLocation: business['business_distance'],
                              discountNumber: business['discount_number'],
                              isFreeShipment: business['is_free_shipment'],
                              isOpen: isOpen,
                              onTap: () {
                                final route = '/business/detail/${business['business_id']}';
                                context.push(route, extra: business);
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
          if (_showSortOverlay) ...[
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withAlpha(76),
            ),
            SortFilterOverlay(
              selectedOption: _tempSelectedSortOption,
              onOptionSelected: (val) {
                setState(() => _tempSelectedSortOption = val);
              },
              onApply: () async {
                final connectivityResult = await Connectivity().checkConnectivity();
                if (connectivityResult.contains(ConnectivityResult.none)) {
                  Fluttertoast.showToast(
                    msg: 'Pengurutan gagal dilakukan.\nSilahkan coba lagi.',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  return;
                }

                setState(() {
                  _selectedSortOption = _tempSelectedSortOption;
                  _showSortOverlay = false;
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}