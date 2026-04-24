class Currency {
  final int amount;
  final String base;
  final String date;
  final Map<String, dynamic> rates;

  Currency({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      amount: json['amount'],
      base: json['base'],
      date: json['date'],
      rates: Map<String, dynamic>.from(json['rates']),
    );
  }
}
