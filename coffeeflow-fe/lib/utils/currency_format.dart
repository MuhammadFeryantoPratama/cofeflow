import 'package:intl/intl.dart';

/// Utility class for formatting currency values to Indonesian Rupiah
class CurrencyFormat {
  CurrencyFormat._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  /// Format a number to Rupiah currency string
  /// Example: 18000 -> "Rp18.000"
  static String format(double amount) {
    return _formatter.format(amount);
  }

  /// Parse a Rupiah currency string back to double
  static double parse(String formatted) {
    try {
      return _formatter.parse(formatted).toDouble();
    } catch (_) {
      return 0;
    }
  }
}
