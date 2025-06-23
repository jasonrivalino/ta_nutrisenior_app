import '../../../../database/report_image_list_table.dart';
import '../../../../database/report_list_table.dart';

class ReportFillController {
  static int addReport({
    required int? businessId,
    required int? driverId,
    required String reportReason,
    required String reportDescription,
    required List<String> reportImages, // tambahkan ini
  }) {
    final newId = reportListTable.isNotEmpty
        ? reportListTable.last['report_id'] + 1
        : 1;

    // Simpan laporan
    reportListTable.add({
      'report_id': newId,
      'business_id': businessId,
      'driver_id': driverId,
      'report_reason': reportReason,
      'report_description': reportDescription,
    });

    // Simpan gambar-gambar terkait laporan
    for (final imagePath in reportImages) {
      reportImageListTable.add({
        'report_id': newId,
        'report_image': imagePath,
      });
    }

    return newId;
  }
}