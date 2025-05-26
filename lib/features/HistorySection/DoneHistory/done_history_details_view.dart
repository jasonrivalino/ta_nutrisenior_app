import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'done_history_details_data.dart';

class DoneHistoryDetailsView extends StatelessWidget {
  const DoneHistoryDetailsView({super.key, required int id});

  @override
  Widget build(BuildContext context) {
    final order = doneHistoryDetailsList[0];

    int totalOrderPrice = order['orderList']
        .fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));

    num totalPrice = totalOrderPrice + order['serviceFee'] + order['deliveryFee'];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: const Text('Detail Pembelian'),
        backgroundColor: const Color(0xFFDDE3C1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Waktu & Pengemudi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Waktu Pesan", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(DateFormat('d MMM y, HH:mm').format(order['orderDate'])),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pengemudi", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(order['driverName']),
            ],
          ),
          const SizedBox(height: 16),

          // Nama Restoran & Alamat
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8EA),
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.restaurant, size: 18),
                    const SizedBox(width: 6),
                    const Text('Nama Restoran', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(order['businessName']),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    const Text('Alamat Penerima', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(order['addressReceiver']),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Detail Pesanan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Detail Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),

                ...order['orderList'].map<Widget>((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item['quantity']}x ', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name']),
                              if (item['notes'] != null && item['notes'].toString().isNotEmpty)
                                Text('Note: ${item['notes']}', style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Text('Rp${(item['price'] * item['quantity']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'),
                      ],
                    ),
                  );
                }).toList(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Harga pelayanan"),
                    Text('Rp${order['serviceFee'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Harga ongkir"),
                    Text('Rp${order['deliveryFee'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Harga", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Rp${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Metode bayar"),
                    Text(order['paymentMethod']),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFDDE3C1),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Yuk berikan penilaian!", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF78824B)),
                  onPressed: () {},
                  child: const Text("Pengemudi"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF78824B)),
                  onPressed: () {},
                  child: const Text("Restoran"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
