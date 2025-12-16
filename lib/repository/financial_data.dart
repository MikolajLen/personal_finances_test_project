import 'package:equatable/equatable.dart';
import 'package:personal_finances/repository/transaction.dart';

class FinancialData extends Equatable{

  final List<Transaction> transactions;
  final double balance;

  const FinancialData(this.transactions, this.balance);

  @override
  List<Object?> get props => [transactions, balance];
}