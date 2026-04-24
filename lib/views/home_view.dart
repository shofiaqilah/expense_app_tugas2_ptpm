import 'package:expense_tracker_app/controllers/expense_controller.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/views/add_expense.dart';
import 'package:expense_tracker_app/views/detail_page.dart';
import 'package:expense_tracker_app/views/kursAPI_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:expense_tracker_app/views/login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = ExpenseController();
  // void _logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove("isLogin");

  //   if (mounted) {
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => LoginView()),
  //       (route) => false,
  //     );
  //   }
  // }

  int hitungSaldo(Box value) {
    int total = 0;
    for (int i = 0; i < value.length; i++) {
      final Expense e = value.getAt(i);

      if (e.type == 'income') {
        total += e.nominal;
      } else {
        total -= e.nominal;
      }
    }
    return total;
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
      appBar: AppBar(title: Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: ValueListenableBuilder(
          valueListenable: _controller.expense,
          builder: (context, Box value, child) {
            final total = hitungSaldo(value);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 50, 138, 38),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Saldo",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatRupiah(total),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: const Text(
                    "Riwayat Transaksi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: value.isEmpty
                      ? const Center(child: Text("Belum ada transaksi"))
                      : ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final expense = value.getAt(index);

                            return Card(
                              elevation: 3,
                              child: ListTile(
                                onLongPress: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddExpenseView(
                                      index: index,
                                      expense: expense,
                                    ),
                                  ),
                                ),

                                leading: CircleAvatar(
                                  backgroundColor: expense.type == 'income'
                                      ? Colors.green[100]
                                      : Colors.red[100],
                                  child: Icon(
                                    expense.type == 'income'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: expense.type == 'income'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),

                                // atur title
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expense.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      expense.date.toString().split(' ')[0],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0,
                                      ).format(expense.nominal),
                                      style: TextStyle(
                                        color: expense.type == 'income'
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _controller.delExpense(index);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(expense: expense),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseView()),
          );
        },
      ),

      // bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pinkAccent[80],
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.green[600]),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.green[600]),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp, color: Colors.green[600]),
            label: 'Kurs API',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            return;
          }

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddExpenseView()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KursAPIView()),
            );
          }
        },
      ),
    );
  }
}
