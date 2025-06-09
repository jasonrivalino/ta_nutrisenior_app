import 'dart:math';

final Random random = Random();

String generatePhoneNumber() {
  // Length between 12 and 13 digits
  int length = random.nextBool() ? 10 : 11; // excluding '08', we need to generate 10 or 11 digits
  String phoneNumber = '08';
  for (int i = 0; i < length; i++) {
    phoneNumber += random.nextInt(10).toString(); // append a random digit (0–9)
  }
  return phoneNumber;
}