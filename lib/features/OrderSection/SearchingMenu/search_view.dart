import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

import 'search_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  int selectedIndex = 0;

  final List<Map<String, dynamic>> recentSearches = [
    {'name': 'Ristorante', 'type': 'restaurant'},
    {'name': 'Glow Kitchen', 'type': 'restaurant'},
    {'name': 'Red Lantern Court', 'type': 'restaurant'},
  ];

  @override
  Widget build(BuildContext context) {
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
          SizedBox(height: 12),
          // Search Field + Filter Icon
          SearchBarWithFilter(
            controller: _searchController,
            onChanged: (value) {
              // Add live search logic here
            },
            onFilterPressed: () {
              // Open filter dialog or action
            },
          ),

          SizedBox(height: 24),
          // Tabs: Restoran | Pusat Belanja
          BusinessSelectionSearch(
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              setState(() => selectedIndex = index);
            },
          ),

          RecentSearchList(
            items: recentSearches,
            onItemTapped: (name) {
              _searchController.text = name;
            },
          ),
        ],
      ),
    );
  }
}