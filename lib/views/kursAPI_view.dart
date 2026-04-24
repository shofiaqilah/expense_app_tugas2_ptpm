import 'package:expense_tracker_app/api/api_service.dart';
import 'package:expense_tracker_app/views/add_expense.dart';
import 'package:expense_tracker_app/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/currency.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

  void convert() {
    if (_data == null) return;

    double amount = double.tryParse(_amountController.text) ?? 0;

    setState(() {
      _result = amount * (_data!.rates[_selectedCurrency] ?? 1);
    });
  }

  String formatRupiah(int number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text("Konversi Mata Uang"),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 5,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // input nominal (dalam IDR)
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: "Nominal (IDR)",
                      hintText: "Contoh: 100000",
                      prefixText: "Rp ",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payments),
                    ),
                  ),

                  const SizedBox(height: 30),

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

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: convert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Konversi Sekarang",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // hasil konversi
                  if (_result != null)
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Hasil: $_selectedCurrency ${_result!.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      // // bottom navigation bar
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.green[80],
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
      //     BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tambah'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.attach_money_sharp),
      //       label: 'Kurs API',
      //     ),
      //   ],
      //   onTap: (index) {
      //     if (index == 0) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (_) => HomeView()),
      //       );
      //     }

      //     if (index == 1) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (_) => AddExpenseView()),
      //       );
      //     }

      //     if (index == 2) {
      //       return;
      //     }
      //   },
      // ),
    );
  }
}
