import '../../../../database/report_list_table.dart';

class ReportFillController {
  static int addReport({
    required int? businessId,
    required int? driverId,
    required String reportReason,
    required String reportDescription,
  }) {
    final newId = reportListTable.isNotEmpty
        ? reportListTable.last['report_id'] + 1
        : 1;

    reportListTable.add({
      'report_id': newId,
      'business_id': businessId,
      'driver_id': driverId,
      'report_reason': reportReason,
      'report_description': reportDescription,
    });

    return newId;
  }
}