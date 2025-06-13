import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';
import 'package:ta_nutrisenior_app/shared/styles/fonts.dart';

class CustomLocationAppBarTitle extends StatelessWidget {
  const CustomLocationAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          const SizedBox(width: 4),
          CircleAvatar(
            radius: 20, // Slightly larger
            backgroundColor: AppColors.woodland,
            child: const Icon(
              Icons.location_on,
              size: 22, // Match nicely with CircleAvatar
              color: AppColors.soapstone,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lokasi',
                style: TextStyle(
                  fontFamily: AppFonts.fontMedium,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Rumah Wisma Teduh',
                style: TextStyle(
                  fontFamily: AppFonts.fontBold,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
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

class SortFilterOverlay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.berylGreen,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                onPressed: onApply,
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
      ),
    );
  }

  Widget _buildRadio(int value, String text) {
    return RadioListTile<int>(
      value: value,
      groupValue: selectedOption,
      onChanged: (int? value) {
        if (value != null) {
          onOptionSelected(value);
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