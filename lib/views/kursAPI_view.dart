import 'package:expense_tracker_app/api/api_service.dart';
import 'package:expense_tracker_app/views/add_expense.dart';
import 'package:expense_tracker_app/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/currency.dart';

class KursAPIView extends StatefulWidget {
  const KursAPIView({super.key});

  @override
  State<KursAPIView> createState() => _KursAPIViewState();
}

class _KursAPIViewState extends State<KursAPIView> {
  final TextEditingController _amountController = TextEditingController();

  String _selectedCurrency = 'USD';
  Currency? _data;
  double? _result;
  bool _isLoading = false;

  List<String> currencies = [];

  @override
  void initState() {
    super.initState();
    fetchRates();
  }

  /// 🔥 ambil data dari API
  Future<void> fetchRates() async {
    setState(() => _isLoading = true);

    try {
      final data = await ApiService.getRates("IDR");

      setState(() {
        _data = data;
        currencies = ['USD', 'EUR', 'JPY'];
        _selectedCurrency = currencies.first;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => _isLoading = false);
  }

  /// 🔥 convert
  void convert() {
    if (_data == null) return;

    double amount = double.tryParse(_amountController.text) ?? 0;

    setState(() {
      _result = amount * (_data!.rates[_selectedCurrency] ?? 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konversi Mata Uang")),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// INPUT NOMINAL
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Nominal (IDR)",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// DROPDOWN DARI API
                  DropdownButtonFormField(
                    initialValue: _selectedCurrency,
                    items: currencies
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCurrency = val!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Pilih Mata Uang",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON CONVERT
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: convert,
                      child: const Text("Konversi Sekarang"),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// HASIL
                  if (_result != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Hasil: $_selectedCurrency ${_result!.toStringAsFixed(4)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
             // bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tambah'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Kurs API',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeView()),
            );
          }

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AddExpenseView()),
            );
          }

          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => KursAPIView()),
            );
          }
        },
      ),
    );
  }
}
