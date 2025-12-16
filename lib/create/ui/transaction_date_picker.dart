import 'package:flutter/material.dart';
import 'package:personal_finances/utils/clock.dart';

class TransactionDatePicker extends StatelessWidget {
  final Clock clock;
  final DateTime? date;
  final void Function(DateTime) setDate;

  const TransactionDatePicker({super.key, this.date, required this.setDate, required this.clock});

  @override
  Widget build(BuildContext context) {
    final dateText = date == null
        ? 'Select transaction date'
        : '${date!.year.toString().padLeft(4, '0')}-'
              '${date!.month.toString().padLeft(2, '0')}-'
              '${date!.day.toString().padLeft(2, '0')}';
    return OutlinedButton.icon(
      onPressed: () => _pickDate(context),
      icon: const Icon(Icons.calendar_month),
      label: Text(dateText),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = clock.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) setDate(picked);
  }
}