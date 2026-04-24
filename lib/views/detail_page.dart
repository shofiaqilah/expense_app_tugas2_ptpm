import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Expense expense;

  const DetailPage({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Judul: ${expense.title}"),
                const SizedBox(height: 10),

                Text("Nominal: Rp ${expense.nominal}"),
                const SizedBox(height: 10),

                Text("Jenis: ${expense.type}"),
                const SizedBox(height: 10),

                Text("Kategori: ${expense.category}"),
                const SizedBox(height: 10),

                Text("Tanggal: ${expense.date.toString().split(' ')[0]}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
