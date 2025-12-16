
import 'package:flutter/material.dart';
import 'package:personal_finances/repository/transaction.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionType? groupValue;
  final ValueChanged<TransactionType?> onChanged;
  final void Function(TransactionType) setType;

  const TransactionTypeSelector({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.setType,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<TransactionType>(
      groupValue: groupValue,
      onChanged: onChanged,
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                setType(TransactionType.expense);
              },
              child: Row(
                children: [
                  Radio<TransactionType>(value: TransactionType.expense),
                  const Text('Expense'),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setType(TransactionType.income);
              },
              child: Row(
                children: [
                  Radio<TransactionType>(value: TransactionType.income),
                  const Text('Income'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}