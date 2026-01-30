import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double value) {
    return NumberFormat('#,##0.00').format(value);
  }

  static String formatCryptoPrice(double value) {
    return NumberFormat('#,##0').format(value);
  }

  static String formatPercentage(double value) {
    return '${value > 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
  }
}