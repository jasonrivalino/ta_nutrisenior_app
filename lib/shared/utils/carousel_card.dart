import 'dart:async';

import 'package:flutter/material.dart';

/// Returns a list with the last element at the start and the first at the end
List<Map<String, dynamic>> getLoopedBusinesses(List<Map<String, dynamic>> businesses) {
  if (businesses.length <= 1) return businesses;
  return [businesses.last, ...businesses, businesses.first];
}

/// Handles looping logic in an infinite carousel
void handlePageChanged({
  required int index,
  required int realLength,
  required PageController controller,
  required void Function(int) setCurrentIndex,
  required TickerProvider tickerProvider, // for safe use of Future.delayed if needed
}) {
  setCurrentIndex(index);

  if (index == 0) {
    Future.delayed(const Duration(milliseconds: 350), () {
      controller.jumpToPage(realLength);
      setCurrentIndex(realLength);
    });
  } else if (index == realLength + 1) {
    Future.delayed(const Duration(milliseconds: 350), () {
      controller.jumpToPage(1);
      setCurrentIndex(1);
    });
  }
}