import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

class ExpenseController {
  static final ExpenseController _instance = ExpenseController._internal();

  // factory akan mengembalikan objek yang sama ke ExpenseController
  factory ExpenseController() => _instance; //Singleton
  ExpenseController._internal();

  ValueListenable<Box<Expense>> get expense =>
      Hive.box<Expense>('expenses').listenable();

  Future<void> addExpense(Expense expense) async {
    final Box<Expense> box = Hive.box<Expense>('expenses');
    await box.add(expense);
  }

  Future<void> updateExpense(int index, Expense expense) async {
    final Box<Expense> box = Hive.box<Expense>('expenses');
    await box.put(index, expense);
  }

  Future<void> delExpense(int index) async {
    final Box<Expense> box = Hive.box<Expense>('expenses');
    await box.delete(index);
  }
}
