import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';

import '../../features/OrderSection/SearchingMenu/search_controller.dart';

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
    mainAddress = AddressListController.getMainAddress();
    recentAddresses = AddressListController.getAddressesCondition(recentAddressSearches);
    allAddresses = AddressListController.getAllAddresses();
  }

  void _toggleBookmark(Map<String, dynamic> address) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Fluttertoast.showToast(
        msg: "Perubahan penyimpanan alamat gagal. Silahkan coba lagi.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      final isNowBookmarked = !(address['isBookmarked'] ?? false);
      address['isBookmarked'] = isNowBookmarked;

      if (isNowBookmarked &&
          !mainAddress.any((a) => a['address_id'] == address['address_id'])) {
        mainAddress.add(address);
      }

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
                  onChanged: (value) async {
                    final connectivityResult = await Connectivity().checkConnectivity();
                    if (connectivityResult.contains(ConnectivityResult.none)) {
                      Fluttertoast.showToast(
                        msg: "Pencarian gagal dilakukan.\nSilahkan coba lagi.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      setState(() {
                        searchQuery = value;
                        allAddresses = []; // Set to empty so filtered results will be empty
                      });
                      return;
                    }

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
                  if (filteredSearchResults.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Tidak ada hasil ditemukan.',
                          style: TextStyle(
                            color: AppColors.dark.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.fontMedium,
                          ),
                        ),
                      ),
                    )
                  else
                    ...filteredSearchResults.map((addr) => _buildAddressTile(addr)),
                ],
              ],
            ),
          ),
        ),

        // Sticky Submit Button
        if (selectedAddress != null)
          Container(
            decoration: BoxDecoration(
              color: AppColors.berylGreen,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 25),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final connectivityResult = await Connectivity().checkConnectivity();
                  if (connectivityResult.contains(ConnectivityResult.none)) {
                    Fluttertoast.showToast(
                      msg: "Alamat gagal dipilih.\nSilahkan coba lagi.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    return;
                  }

                  final selectedId = selectedAddress!['address_id'];
                  RecipientAddressController.updateBusinessDistances(selectedId);

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