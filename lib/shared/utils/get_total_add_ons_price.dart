int getTotalAddOnsPrice({
  required List<Map<String, dynamic>> addOns,
  required List<int> selectedAddOnIds,
}) {
  if (addOns.isEmpty || selectedAddOnIds.isEmpty) return 0;

  final uniqueAddOns = {
    for (var addOn in addOns) addOn['add_ons_id']: addOn
  }.values.toList();

  return uniqueAddOns
      .where((addOn) => selectedAddOnIds.contains(addOn['add_ons_id']))
      .fold(0, (sum, addOn) => sum + (addOn['add_ons_price'] as int));
}