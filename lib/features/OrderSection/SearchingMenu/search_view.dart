import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

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

  final List<int> recentRestaurantSearches = [1, 6, 13];
  final List<int> recentMarketSearches = [8, 10];

  /// Helper to get business data from IDs
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
  Widget build(BuildContext context) {
    final businesses = selectedIndex == 0
        ? SearchPageController.restaurantList
        : SearchPageController.marketList;

    final recentSearchData = selectedIndex == 0
        ? getRecentSearchData(recentRestaurantSearches, businesses)
        : getRecentSearchData(recentMarketSearches, businesses);

    // Filtered by name that contains the query (case-insensitive)
    final filteredBusinesses = _searchQuery.isEmpty
        ? []
        : businesses
            .where((b) =>
                b['business_name'].toString().toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.soapstone,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: AppColors.soapstone,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const CustomLocationAppBarTitle(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          SearchBarWithFilter(
            controller: _searchController,
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
            onFilterPressed: () {
              // Future filter dialog
            },
          ),
          const SizedBox(height: 24),
          BusinessSelectionSearch(
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          _searchQuery.isEmpty
              ? RecentSearchList(
                  items: recentSearchData,
                  onItemTapped: (business) {
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
                            final type = business['business_type'];
                            final route = type == 'restaurant'
                                ? '/restaurant/detail/${business['business_id']}'
                                : '/market/detail/${business['business_id']}';

                            context.push(route, extra: business);
                          },
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}