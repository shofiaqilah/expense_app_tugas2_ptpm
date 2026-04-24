import 'package:expense_tracker_app/controllers/expense_controller.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/views/home_view.dart';
import 'package:expense_tracker_app/views/kursAPI_view.dart';
import 'package:flutter/material.dart';

class AddExpenseView extends StatefulWidget {
  final int? index;
  final Expense? expense;
  const AddExpenseView({super.key, this.index, this.expense});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
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
    final datePicked = await showDatePicker(
      context: context,
      initialDate: _selectDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Transaksi")),

      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: ListView(
          children: [
            // judul input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),

            const SizedBox(height: 16),

            // nominal input
            TextField(
              controller: _nominalController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nominal (Rp)',
              ),
            ),

            const SizedBox(height: 10),

            // category input
            DropdownButtonFormField(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Kategori',
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

            const SizedBox(height: 10),

            // tipe (pengeluaran/pemasukan)
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Jenis Transaksi',
                border: OutlineInputBorder(),
              ),
              items: [
                'income',
                'expense',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() {
                  _type = val!;
                });
              },
            ),

            const SizedBox(height: 10),

            // pilih tanggal
            ListTile(
              title: Text(
                "Tanggal: ${_selectDate.toLocal().toString().split(' ')[0]}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),

            const SizedBox(height: 20),

            // button
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _nominalController.text.isEmpty) {
                  return;
                }

                final newExpense = Expense(
                  title: _titleController.text,
                  nominal: int.parse(_nominalController.text),
                  type: _type,
                  category: _category,
                  date: _selectDate,
                );

                if (_isEditMode) {
                  await _controller.updateExpense(widget.index!, newExpense);
                } else {
                  await _controller.addExpense(newExpense);
                }

                if (context.mounted) Navigator.pop(context);
              },
              child: Text(_isEditMode ? "Edit Expense" : "Add Expense"),
            ),
          ],
        ),
      ),

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
