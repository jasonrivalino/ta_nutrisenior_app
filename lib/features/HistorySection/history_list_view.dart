import 'package:flutter/material.dart';

import '../../shared/styles/colors.dart';
import '../../shared/styles/texts.dart';
import '../../shared/widgets/appbar.dart';
import '../../shared/widgets/bottom_navbar.dart';
import '../../shared/widgets/detail_card/history_card_list.dart';

import '../../shared/widgets/elevated_button.dart';
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
  bool showCanceled = false;

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
      if (showDone) {
        return status == 'selesai';
      } else {
        // If showing canceled only, ignore other statuses
        if (showCanceled) {
          return status == 'dibatalkan';
        } else {
          return status == 'diproses' || status == 'dikirim';
        }
      }
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
          SizedBox(
            height: 34, // consistent height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showDone = true;
                            showCanceled = false;
                          });
                        },
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Histori',
                                style: AppTextStyles.textBold(
                                  size: 18,
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
                                style: AppTextStyles.textBold(
                                  size: 18,
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
                  // Keep space for the button consistently
                  SizedBox(
                    height: 34,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: showDone ? 0 : 1,
                      child: showDone
                          ? const SizedBox.shrink()
                          : ElevatedButtonWidget(
                              onPressed: () {
                                setState(() {
                                  showCanceled = !showCanceled;
                                });
                              },
                              backgroundColor: showCanceled ? AppColors.woodland : AppColors.persianRed,
                              foregroundColor: AppColors.soapstone,
                              minimumSize: const Size(0, 35),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                showCanceled ? 'Berlangsung' : 'Dibatalkan',
                                style: AppTextStyles.textMedium(
                                  size: 14,
                                  color: AppColors.soapstone,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: displayList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        showDone
                            ? 'Histori pemesanan belum ada. \nAyo lakukan pemesanan.'
                            : showCanceled
                                ? 'Tidak ada pesanan yang dibatalkan'
                                : 'Tidak ada pesanan yang sedang diproses',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textMedium(
                          size: 16,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                  )
                : Container(
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