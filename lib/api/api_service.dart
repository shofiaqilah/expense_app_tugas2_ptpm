import 'dart:convert';
import 'package:expense_tracker_app/models/currency.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.frankfurter.dev/v1/latest';

  static Future<Currency> getRates(String from) async {
    final url = Uri.parse('$baseUrl?from=$from');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Currency.fromJson(data);
    } else {
      throw Exception('Failed to load currency rates');
    }
  }
}
