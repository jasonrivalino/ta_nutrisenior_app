import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

import 'search_controller.dart';

class CustomLocationAppBarTitle extends StatelessWidget {
  final Map<String, dynamic> selectedAddress;
  final Function(Map<String, dynamic>) onAddressChanged;
  final VoidCallback onTap;

  const CustomLocationAppBarTitle({
    super.key,
    required this.selectedAddress,
    required this.onAddressChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            const SizedBox(width: 4),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.woodland,
              child: const Icon(Icons.location_on, size: 22, color: AppColors.soapstone),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lokasi',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  selectedAddress['address_name'] ?? 'Pilih Lokasi',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarWithFilter extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final VoidCallback? onFilterPressed;

  const SearchBarWithFilter({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Cari pesanan pilihanmu...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onFilterPressed,
            child: const CircleAvatar(
              backgroundColor: AppColors.woodland,
              child: Icon(Icons.tune, color: AppColors.soapstone),
            ),
          ),
        ],
      ),
    );
  }
}


final List<String> tabs = ['Restoran', 'Pusat Belanja'];
class BusinessSelectionSearch extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const BusinessSelectionSearch({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onTabSelected(index),
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.fontBold,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  decoration:
                      isSelected ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}


class RecentSearchList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onItemTapped;

  const RecentSearchList({
    super.key,
    required this.items,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Limit items to max 5
    final limitedItems = items.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Pencarian Sebelumnya',
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppFonts.fontBold,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: limitedItems.length,
          itemBuilder: (context, index) {
            final item = limitedItems[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onItemTapped(item),
                  splashColor: AppColors.woodland.withAlpha(50),
                  highlightColor: AppColors.woodland.withAlpha(25),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.woodland,
                          child: Icon(Icons.restaurant,
                              color: AppColors.soapstone, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['business_name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.fontMedium,
                            fontWeight: FontWeight.w500,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AddressSelectionOverlay extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddressSelected;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const AddressSelectionOverlay({
    super.key,
    required this.onAddressSelected,
    required this.controller,
    this.onChanged,
  });

  @override
  State<AddressSelectionOverlay> createState() => _AddressSelectionOverlayState();
}

class _AddressSelectionOverlayState extends State<AddressSelectionOverlay> {
  final List<int> recentAddressSearches = [4, 9];

  late List<Map<String, dynamic>> mainAddress;
  late List<Map<String, dynamic>> recentAddresses;
  late List<Map<String, dynamic>> allAddresses;

  String searchQuery = '';
  Map<String, dynamic>? selectedAddress;

  @override
  void initState() {
    super.initState();
    mainAddress = AddressChooseController.getMainAddress();
    recentAddresses = AddressChooseController.getAddressesCondition(recentAddressSearches);
    allAddresses = AddressChooseController.getAllAddresses();
  }

  void _toggleBookmark(Map<String, dynamic> address) {
    setState(() {
      final isNowBookmarked = !(address['isBookmarked'] ?? false);
      address['isBookmarked'] = isNowBookmarked;

      // If it becomes bookmarked and not already in mainAddress, add it
      if (isNowBookmarked &&
          !mainAddress.any((a) => a['address_id'] == address['address_id'])) {
        mainAddress.add(address);
      }

      // If unbookmarked, remove from mainAddress
      if (!isNowBookmarked) {
        mainAddress.removeWhere((a) => a['address_id'] == address['address_id']);
      }
    });

    Fluttertoast.showToast(
      msg: address['isBookmarked'] == true
          ? 'Alamat berhasil disimpan'
          : 'Alamat berhasil dihapus',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSearchResults = allAddresses
        .where((addr) => addr['address_name']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Alamat Detail',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (recentAddresses.isNotEmpty) {
                          setState(() => selectedAddress = recentAddresses.first);
                        }
                      },
                      icon: const Icon(Icons.my_location, size: 18),
                      label: Text(
                        'Lokasi Sekarang',
                        style: TextStyle(
                          color: AppColors.soapstone,
                          fontSize: 14,
                          fontFamily: AppFonts.fontMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.woodland,
                        foregroundColor: AppColors.soapstone,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        minimumSize: const Size(0, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  controller: widget.controller,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                    if (widget.onChanged != null) widget.onChanged!(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Alamat...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    filled: true,
                    fillColor: AppColors.soapstone,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.dark),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.dark),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.woodland, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (searchQuery.isEmpty) ...[
                  if (mainAddress.any((addr) => addr['isBookmarked'] == true)) ...[
                    Text(
                      'Alamat Disimpan',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...mainAddress
                        .where((addr) => addr['isBookmarked'] == true)
                        .map((addr) => _buildAddressTile(addr)),
                    const SizedBox(height: 16),
                  ],
                  if (recentAddresses.isNotEmpty) ...[
                    Text(
                      'Riwayat Alamat',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.fontBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...recentAddresses.map((addr) => _buildAddressTile(addr)),
                  ],
                ] else ...[
                  Text(
                    'Pencarian Alamat',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.fontBold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...filteredSearchResults.map((addr) => _buildAddressTile(addr)),
                ],
              ],
            ),
          ),
        ),

        // Sticky Submit Button
        if (selectedAddress != null)
          Container(
            decoration: const BoxDecoration(
              color: AppColors.berylGreen,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 25),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final selectedId = selectedAddress!['address_id'];

                  // Update distances based on selected address
                  AddressChangeController.updateBusinessDistances(selectedId);

                  widget.onAddressSelected(selectedAddress!);
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.woodland,
                  foregroundColor: AppColors.soapstone,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pilih Alamat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
}

  Widget _buildAddressTile(Map<String, dynamic> addr) {
    final isSelected = selectedAddress == addr;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.frogGreen : AppColors.berylGreen,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.woodland.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        tileColor: Colors.transparent, // Set to transparent so Container color applies
        leading: Icon(
          searchQuery.isEmpty
              ? (mainAddress.contains(addr)
                  ? Icons.location_on
                  : Icons.access_time)
              : Icons.search,
          color: AppColors.dark,
        ),
        title: Text(
          addr['address_name'],
          style: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          addr['address_detail'],
          style: TextStyle(
            color: AppColors.dark,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            addr['isBookmarked'] == true ? Icons.bookmark : Icons.bookmark_border,
            color: AppColors.dark,
          ),
          onPressed: () => _toggleBookmark(addr),
        ),
        onTap: () {
          setState(() {
            selectedAddress = addr;
          });
        },
      ),
    );
  }
}

class SortFilterOverlay extends StatefulWidget {
  final int selectedOption;
  final Function(int) onOptionSelected;
  final VoidCallback onApply;

  const SortFilterOverlay({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.onApply,
  });

  @override
  State<SortFilterOverlay> createState() => _SortFilterOverlayState();
}

class _SortFilterOverlayState extends State<SortFilterOverlay> {
  late int _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.berylGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Urutkan Restoran berdasarkan:',
            style: TextStyle(
              color: AppColors.dark,
              fontFamily: AppFonts.fontBold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildRadio(0, 'Rekomendasi'),
          _buildRadio(1, 'Rating penilaian'),
          _buildRadio(2, 'Jarak lokasi'),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onOptionSelected(_selectedOption);
                widget.onApply();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.woodland,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Pilih Urutan',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.fontBold,
                  fontWeight: FontWeight.bold,
                  color: AppColors.soapstone,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildRadio(int value, String text) {
    return RadioListTile<int>(
      value: value,
      groupValue: _selectedOption,
      onChanged: (int? value) {
        if (value != null) {
          setState(() => _selectedOption = value);
        }
      },
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: AppFonts.fontMedium,
          fontWeight: FontWeight.w500,
          color: AppColors.dark,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
    );
  }
}