import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/widgets/appbar.dart';
import '../../../shared/widgets/bottom_navbar.dart';
import '../../shared/widgets/detail_card/history_card_list.dart';

import 'history_controller.dart';

class HistoryListView extends StatefulWidget {
  final int routeIndex; // 0 = Histori (done), 1 = Dalam Proses (ongoing)

  const HistoryListView({
    super.key,
    required this.routeIndex,
  });

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  late bool showDone;
  List<Map<String, dynamic>> allHistoryList = [];
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only refetch when coming to this route again
    if (!_isFetched) {
      _fetchHistoryData();
      _isFetched = true;
    }
  }

  void _fetchHistoryData() {
    setState(() {
      showDone = widget.routeIndex == 0;
      allHistoryList = HistoryController.fetchHistoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayList = allHistoryList.where((item) {
      final status = item['status'];
      return showDone
          ? status == 'selesai'
          : status == 'diproses' || status == 'dikirim';
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(
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
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final item = displayList[index];
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