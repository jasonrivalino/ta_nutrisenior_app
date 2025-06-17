int calculateDeliveryFee(bool isFreeShipment, double businessDistance) {
  if (isFreeShipment) return 0;
  if (businessDistance < 0.5) return 500;
  return 500 + ((businessDistance - 0.5).ceil() * 1000);
}

int getFinalPrice(int baseProductPrice, int addOnsPrice, int quantity, int? discountNumber){
  final baseTotal = baseProductPrice * quantity;
  final total = baseTotal + addOnsPrice;
  if (discountNumber != null && discountNumber > 0) {
    final discountAmount = baseTotal * discountNumber ~/ 100;
    return total - discountAmount;
  }
  return total;
}