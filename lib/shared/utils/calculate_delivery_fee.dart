  int calculateDeliveryFee(bool isFreeShipment, double businessDistance) {
    if (isFreeShipment) return 0;
    if (businessDistance < 0.5) return 500;
    return 500 + ((businessDistance - 0.5).ceil() * 1000);
  }