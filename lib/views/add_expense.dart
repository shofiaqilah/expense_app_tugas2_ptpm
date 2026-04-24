import 'package:expense_tracker_app/controllers/expense_controller.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/views/home_view.dart';
import 'package:expense_tracker_app/views/kursAPI_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddExpenseView extends StatefulWidget {
  final int? index;
  final Expense? expense;
  const AddExpenseView({super.key, this.index, this.expense});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _formKey = GlobalKey<FormState>();

  final _controller = ExpenseController();
  final _titleController = TextEditingController();
  final _nominalController = TextEditingController();
  String _type = 'expense';
  String _category = 'Makan';
  DateTime _selectDate = DateTime.now();

  bool _isEditMode = false;

  // list kategori
  final List<String> categories = [
    'Makan',
    'Transportasi',
    'Hiburan',
    'Belanja',
    'Others',
  ];

  @override
  void initState() {
    _isEditMode = widget.index == null && widget.expense == null ? false : true;

    super.initState();
    if (_isEditMode) {
      _titleController.text = widget.expense!.title;
      _nominalController.text = widget.expense!.nominal.toString();
      _type = widget.expense!.type;
      _category = widget.expense!.category;
      _selectDate = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _nominalController.dispose();
  }

  // pilih tanggal
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectDate = picked;
      });
    }
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
        title: Text(_isEditMode ? "Edit Transaksi" : "Tambah Transaksi"),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  hintText: 'Contoh: Mie Ayam Bang Asep',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Data tidak boleh kosong!";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // NOMINAL
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  hintText: 'Contoh: 100000',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nominal tidak boleh kosong";
                  }

                  final number = int.tryParse(value);
                  if (number == null) {
                    return "Harus berupa angka";
                  }

                  if (number <= 0) {
                    return "Nominal harus lebih dari 0";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // CATEGORY
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // TYPE
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Jenis Transaksi',
                  prefixIcon: Icon(Icons.swap_vert),
                  border: OutlineInputBorder(),
                ),
                items: ['income', 'expense']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _type = val!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // DATE PICKER
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_selectDate.toLocal().toString().split(' ')[0]),
                ),
              ),

              const SizedBox(height: 24),

              // BUTTON
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final newExpense = Expense(
                      title: _titleController.text,
                      nominal: int.parse(_nominalController.text),
                      type: _type,
                      category: _category,
                      date: _selectDate,
                    );

                    if (_isEditMode) {
                      await _controller.updateExpense(
                        widget.index!,
                        newExpense,
                      );
                    } else {
                      await _controller.addExpense(newExpense);
                    }

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(
                    _isEditMode ? "Update Transaksi" : "Simpan Transaksi",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.green[100],
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
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (_) => AddExpenseView()),
      //       );
      //     }

      //     if (index == 2) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (_) => KursAPIView()),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
