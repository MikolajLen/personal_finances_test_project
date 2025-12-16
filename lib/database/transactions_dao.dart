import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finances/database/transactions_database.dart';

@lazySingleton
class TransactionsDao {
  final TransactionsDatabase _transactionsDatabase;

  TransactionsDao(this._transactionsDatabase);

  Future<int> insertTransaction(
    double amount,
    String category,
    int transactionDate,
    String? notes,
  ) {
    return _transactionsDatabase
        .into(_transactionsDatabase.transactionItem)
        .insert(
          TransactionItemCompanion.insert(
            amount: amount,
            category: category,
            transactionDate: transactionDate,
            notes: Value(notes),
          ),
        );
  }

  Future<double> calculateBalance() async {
    final calculateAmountQuery = _transactionsDatabase.selectOnly(
      _transactionsDatabase.transactionItem,
    )..addColumns([_transactionsDatabase.transactionItem.amount.sum()]);
    final calculatedResult = await calculateAmountQuery.getSingle();
    return calculatedResult.read(
          _transactionsDatabase.transactionItem.amount.sum(),
        ) ??
        0.0;
  }

  Stream<List<TransactionItemData>> observeTransactions() {
    final query = _transactionsDatabase.select(
      _transactionsDatabase.transactionItem,
    )..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]);
    return query.watch();
  }

  Future<List<String>> loadCategories() async {
    final query = _transactionsDatabase.selectOnly(
      _transactionsDatabase.transactionItem,
      distinct: true,
    )..addColumns([_transactionsDatabase.transactionItem.category]);

    final result = await query.get();
    return result
        .map((row) => row.read(_transactionsDatabase.transactionItem.category)!)
        .toList();
  }
}
