import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';
import '../../../shared/widgets/elevated_button.dart';

class OrderLocationSelection extends StatelessWidget {
  final Map<String, dynamic> selectedAddress;
  final Function(Map<String, dynamic>) onAddressChanged;
  final VoidCallback onTap;

  const OrderLocationSelection({
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
                Text(
                  'Lokasi Penerima',
                  style: AppTextStyles.textMedium(
                    size: 14,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  selectedAddress['address_name'] ?? 'Pilih Alamat Pengantaran',
                  style: AppTextStyles.textBold(
                    size: 16,
                    color: AppColors.dark,
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
              cursorColor: AppColors.dark,
              decoration: InputDecoration(
                hintText: 'Cari pesanan pilihanmu...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                  borderSide: BorderSide(color: AppColors.dark, width: 1.5),
                ),
              ),
              style: AppTextStyles.textMedium(
                size: 16,
                color: AppColors.dark, // Warna teks yang diketik
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
                style: AppTextStyles.textBold(
                  size: 18,
                  color: AppColors.dark,
                  decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
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
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Pencarian Sebelumnya',
            style: AppTextStyles.textBold(
              size: 16,
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

            // Cek tipe bisnis
            final isMarket = item['business_type'] == 'market';
            final iconData = isMarket ? Icons.shopping_cart : Icons.restaurant;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onItemTapped(item),
                  splashColor: AppColors.woodland.withAlpha(50),
                  highlightColor: AppColors.woodland.withAlpha(25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.woodland,
                          child: Icon(iconData, color: AppColors.soapstone, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['business_name'],
                          style: AppTextStyles.textMedium(
                            size: 16,
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

class SortFilterOverlay extends StatefulWidget {
  final String businessType;
  final int selectedOption;
  final Future<bool> Function(int) onApply;

  const SortFilterOverlay({
    super.key,
    required this.businessType,
    required this.selectedOption,
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
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.ecruWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // CHANGE TEXT BASED ON BUSINESS TYPE
            widget.businessType == 'market'
                ? 'Urutkan Pusat Belanja berdasarkan:'
                : 'Urutkan Restoran berdasarkan:',
            style: AppTextStyles.textBold(
              size: 20,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          _buildRadio(0, 'Rekomendasi'),
          _buildRadio(1, 'Rating penilaian'),
          _buildRadio(2, 'Jarak lokasi'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButtonWidget.bottomButton(
              onPressed: () async {
                final success = await widget.onApply(_selectedOption);
                if (success) context.pop();
              },
              child: Text(
                'Pilih Urutan',
                style: AppTextStyles.textBold(
                  size: 16,
                  color: AppColors.soapstone,
                ),
              ),
            ),
          ),
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
        style: AppTextStyles.textMedium(
          size: 16,
          color: AppColors.dark,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
    );
  }
}