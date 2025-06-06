import 'package:flutter/material.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';
import '../../../shared/widgets/product_card/history_card_list.dart';

import 'history_list_data.dart';

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  bool showDone = true;

  @override
  Widget build(BuildContext context) {
    final historyList = showDone ? doneHistoryList : ongoingHistoryList;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Aktivitas Pembelian',
        showBackButton: false,
      ),
      backgroundColor: AppColors.soapstone,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                // Histori Tab
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showDone = true;
                    });
                  },
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Histori',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 2,
                          color: showDone ? AppColors.dark : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Dalam Proses Tab
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showDone = false;
                    });
                  },
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dalam Proses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 2,
                          color: !showDone ? AppColors.dark : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
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
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final item = historyList[index];
                  return HistoryCardList(
                    historyData: item,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}