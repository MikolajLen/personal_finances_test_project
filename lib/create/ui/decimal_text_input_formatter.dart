
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({required this.decimalRange});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '.');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      return oldValue;
    }

    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 2) return oldValue;

      if (parts[1].length > decimalRange) {
        return oldValue;
      }
    }

    return newValue.copyWith(text: text);
  }
}
