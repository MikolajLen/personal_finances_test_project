import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final double amount;
  final String category;
  final DateTime date;
  final String? notes;
  final TransactionType transactionType;

  const Transaction(this.amount, this.category, this.date, this.transactionType, this.notes);

  @override
  List<Object?> get props => [amount, category, date, transactionType, notes];
}

enum TransactionType {
  income, expense
}