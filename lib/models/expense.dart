import 'package:hive/hive.dart';
part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final int nominal;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  

  Expense({required this.title, required this.nominal, required this.type, required this.category, required this.date});
}
