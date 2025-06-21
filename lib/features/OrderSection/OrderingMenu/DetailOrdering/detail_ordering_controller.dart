import '../../../../database/addons_list_table.dart';
import '../../../../database/business_product_list_table.dart';

List<Map<String, dynamic>> getAddOnsForProductController({
  required int productId,
  required int businessId,
}) {
  // Get all add_ons_ids linked to the product
  final linkedAddOnsIds = businessProductListTable
      .where((entry) =>
          entry['product_id'] == productId && entry['business_id'] == businessId)
      .map((entry) => entry['add_ons_id'])
      .toSet();

  // Join with addOnsListTable
  final result = addOnsListTable
      .where((addOn) => linkedAddOnsIds.contains(addOn['add_ons_id']))
      .map((addOn) => {
            ...addOn,
            'product_id': productId,
          })
      .toList();

  return result;
}
