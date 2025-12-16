import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finances/create/ui/decimal_text_input_formatter.dart';

TextEditingValue _v(String text) => TextEditingValue(text: text);

void main() {
  group('DecimalTextInputFormatter', () {
    test('empty input returns empty text', () {
      // given
      final f = DecimalTextInputFormatter(decimalRange: 2);

      // when
      final res = f.formatEditUpdate(_v('1'), _v(''));

      // then
      expect(res.text, '');
    });

    test('replaces comma with dot', () {
      // given
      final f = DecimalTextInputFormatter(decimalRange: 2);
      
      // when
      final res = f.formatEditUpdate(_v(''), _v('12,3'));

      // then
      expect(res.text, '12.3');
    });

    test('rejects invalid characters', () {
      // given
      final f = DecimalTextInputFormatter(decimalRange: 2);

      // when
      final res = f.formatEditUpdate(_v('12.3'), _v('12.3a'));

      // then
      expect(res.text, '12.3');
    });

    test('rejects more than one dot', () {
      // given
      final f = DecimalTextInputFormatter(decimalRange: 2);

      // when
      final res = f.formatEditUpdate(_v('1.2'), _v('1.2.3'));

      // then
      expect(res.text, '1.2');
    });

    test('rejects when decimal digits exceed range', () {
      // given
      final f = DecimalTextInputFormatter(decimalRange: 2);

      // when
      final res = f.formatEditUpdate(_v('1.23'), _v('1.234'));

      // then
      expect(res.text, '1.23');
    });

    test('accepts valid number with dot and within range', () {
      // given
      final f = DecimalTextInputFormatter(decimalRange: 2);

      // when
      final res = f.formatEditUpdate(_v(''), _v('123.45'));

      // then
      expect(res.text, '123.45');
    });
  });
}
