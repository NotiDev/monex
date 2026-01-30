import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiUrl = 'https://open.er-api.com/v6/latest/KZT';

  static Future<Map<String, double>> fetchRates() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final Map<String, dynamic> ratesData = data['rates'];
      return ratesData.map((k, v) => MapEntry(k, v.toDouble()));
    } else {
      throw Exception('Failed to load rates');
    }
  }
}