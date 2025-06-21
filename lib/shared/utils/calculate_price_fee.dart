int calculateDeliveryFee(bool isFreeShipment, double businessDistance) {
  if (isFreeShipment) return 0;
  if (businessDistance < 0.5) return 500;
  return 500 + ((businessDistance - 0.5).ceil() * 1000);
}

int getProductPrice(int baseProductPrice, int addOnsPrice, int quantity, int? discountNumber) {
  final baseTotal = baseProductPrice * quantity;
  final addOnsTotal = addOnsPrice * quantity; // Multiply add-ons by quantity
  final total = baseTotal + addOnsTotal;

  if (discountNumber != null && discountNumber > 0) {
    final discountAmount = baseTotal * discountNumber ~/ 100;
    return total - discountAmount;
  }

  return total;
}

int calculateFinalOrderTotal(List<Map<String, dynamic>> selectedProducts, int serviceFee, bool isFreeShipment, double businessDistance, int Function(bool isFreeShipment, double distance) deliveryFeeCalculator) {
  int productTotal = 0;

  for (var product in selectedProducts) {
    final productPrice = product['product_price'] as int;
    final quantity = product['qty_product'] as int;
    final addOns = product['add_ons_details'] as List<Map<String, dynamic>>?;

    // Base price per product * quantity
    int totalPerProduct = productPrice * quantity;

    // Add-on prices * quantity
    if (addOns != null && addOns.isNotEmpty) {
      for (var addOn in addOns) {
        final addOnPrice = addOn['add_ons_price'] as int;
        totalPerProduct += addOnPrice * quantity;
      }
    }

    productTotal += totalPerProduct;
  }

  final deliveryFee = deliveryFeeCalculator(isFreeShipment, businessDistance);

  return productTotal + serviceFee + deliveryFee;
}