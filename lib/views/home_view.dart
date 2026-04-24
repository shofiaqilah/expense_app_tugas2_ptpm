import 'package:expense_tracker_app/controllers/expense_controller.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/views/add_expense.dart';
import 'package:expense_tracker_app/views/detail_page.dart';
import 'package:expense_tracker_app/views/kursAPI_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker_app/views/login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = ExpenseController();
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLogin");

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: ValueListenableBuilder(
          valueListenable: _controller.expense,
          builder: (context, Box value, child) {
            /// HITUNG SALDO
            int total = 0;
            for (int i = 0; i < value.length; i++) {
              final Expense e = value.getAt(i);

              if (e.type == 'income') {
                total += e.nominal;
              } else {
                total -= e.nominal;
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Saldo",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rp $total",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🧾 TITLE LIST
                const Text(
                  "Riwayat Transaksi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

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

                                /// TITLE
                                title: Text(expense.title),

                                /// DATE
                                subtitle: Text(
                                  expense.date.toString().split(' ')[0],
                                ),

                                /// NOMINAL
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Rp ${expense.nominal}",
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
