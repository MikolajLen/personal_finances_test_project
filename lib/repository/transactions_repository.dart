import 'package:personal_finances/repository/financial_data.dart';
import 'package:personal_finances/repository/transaction.dart';

abstract class TransactionsRepository {
  Stream<FinancialData> loadFinancialData();
  Future<void> insertTransaction(Transaction transaction);
}
