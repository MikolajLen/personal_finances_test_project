import 'package:flutter/material.dart';
import 'package:personal_finances/repository/transaction.dart';
import 'package:personal_finances/utils/clock.dart';

class TransactionsListView extends StatelessWidget {
  final double balance;
  final List<Transaction> transactions;
  final Clock clock;
  const TransactionsListView({
    super.key,
    required this.transactions,
    required this.balance,
    required this.clock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Current balance: $balance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) =>
                TransactionListItem(transaction: transactions[index], clock: clock),
            separatorBuilder: (_, _) => Divider(),
            itemCount: transactions.length,
          ),
        ),
      ],
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final Clock clock;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.clock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.transactionType == TransactionType.income;

    return ListTile(
      leading: Chip(
        label: Text(isIncome ? 'Income' : 'Expense'),
        visualDensity: VisualDensity.compact,
        side: BorderSide(
          color: isIncome
              ? theme.colorScheme.tertiary
              : theme.colorScheme.error,
        ),
      ),
      title: Text(
        transaction.amount.toStringAsFixed(2),
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transaction.category, style: theme.textTheme.bodyMedium),
          if (transaction.notes != null) ...[
            Text(transaction.notes!, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
      trailing: Text(
        _formatDate(transaction.date, clock.now()),
        style: theme.textTheme.bodySmall,
      ),
    );
  }

  String _formatDate(DateTime date, DateTime today) {
    final todayDate = DateTime(today.year, today.month, today.day);
    final inputDate = DateTime(date.year, date.month, date.day);

    final difference = todayDate.difference(inputDate).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${inputDate.day.toString().padLeft(2, '0')}.'
          '${inputDate.month.toString().padLeft(2, '0')}.'
          '${inputDate.year}';
    }
  }
}
