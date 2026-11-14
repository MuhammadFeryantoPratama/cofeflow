import 'package:flutter_test/flutter_test.dart';
import 'package:coffeeflow/utils/currency_format.dart';

void main() {
  group('CurrencyFormat Tests', () {
    test('formats positive amounts correctly in Rupiah', () {
      final formatted = CurrencyFormat.format(18000);
      expect(formatted.contains('18.000'), isTrue);
      expect(formatted.contains('Rp'), isTrue);
    });

    test('formats zero correctly', () {
      final formatted = CurrencyFormat.format(0);
      expect(formatted.contains('0'), isTrue);
      expect(formatted.contains('Rp'), isTrue);
    });

    test('parses Rupiah formatted string back to double', () {
      final parsed = CurrencyFormat.parse('Rp18.000');
      expect(parsed, 18000.0);
    });
  });
}

