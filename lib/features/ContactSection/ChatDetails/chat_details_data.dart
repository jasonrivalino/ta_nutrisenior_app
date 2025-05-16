import 'package:intl/intl.dart';

final now = DateTime.now();
final timeFormat = DateFormat('HH:mm');

final List<Map<String, dynamic>> chatDetailsData = [
  {
    'text': 'Halo, kak! Apakah pesanan saya sudah dalam perjalanan?',
    'isMe': true,
    'time': timeFormat.format(now.subtract(const Duration(minutes: 9))),
  },
  {
    'text': 'Halo! Iya, pesanan sudah saya antar dan sedang dalam perjalanan.',
    'isMe': false,
    'time': timeFormat.format(now.subtract(const Duration(minutes: 8))),
  },
  {
    'text': 'Kalau sudah dekat, bisa dititipkan di resepsionis ya?',
    'isMe': true,
    'time': timeFormat.format(now.subtract(const Duration(minutes: 6))),
  },
  {
    'text': 'Baik, saya akan titipkan di resepsionis saat sampai.',
    'isMe': false,
    'time': timeFormat.format(now.subtract(const Duration(minutes: 4))),
  },
  {
    'text': 'Terima kasih banyak, kak! Hati-hati di jalan.',
    'isMe': true,
    'time': timeFormat.format(now.subtract(const Duration(minutes: 3))),
  },
  {
    'text': 'Sama-sama! Selamat menikmati makanannya!',
    'isMe': false,
    'time': timeFormat.format(now.subtract(const Duration(minutes: 2))),
  },
];
