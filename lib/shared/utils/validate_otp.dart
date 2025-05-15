import 'package:flutter/material.dart';

String? validateOTP(List<TextEditingController> controllers, String correctCode) {
  final enteredCode = controllers.map((c) => c.text).join();
  if (enteredCode.length < 6 || controllers.any((c) => c.text.isEmpty)) {
    return 'Kode verifikasi tidak boleh kosong';
  }
  if (enteredCode != correctCode) {
    return 'Kode verifikasi tidak sesuai';
  }
  return null;
}