import 'package:injectable/injectable.dart';
import 'package:personal_finances/database/transactions_dao.dart';
import 'package:personal_finances/repository/financial_data.dart';
import 'package:personal_finances/repository/transaction.dart';
import 'package:personal_finances/repository/transactions_repository.dart';

@LazySingleton(as: TransactionsRepository)
class TransactionsRepositoryImpl extends TransactionsRepository {
  final TransactionsDao _transactionsDao;

  TransactionsRepositoryImpl(this._transactionsDao);

  @override
  Stream<FinancialData> loadFinancialData() =>
      _transactionsDao.observeTransactions().asyncMap((items) async {
        final transactions = items
            .map(
              (transaction) => Transaction(
                transaction.amount.abs(),
                transaction.category,
                transaction.transactionDate.toDaysSinceEpoch,
                transaction.amount > 0
                    ? TransactionType.income
                    : TransactionType.expense,
                transaction.notes,
              ),
            )
            .toList();
        final balance = await _transactionsDao.calculateBalance();

        return FinancialData(transactions, balance);
      });

  @override
  Future<void> insertTransaction(Transaction transaction) async {
    final amount = transaction.transactionType == TransactionType.expense
        ? transaction.amount * -1
        : transaction.amount;
    final transactionDate = transaction.date.fromDaysSinceEpoch;
    await _transactionsDao.insertTransaction(
      amount,
      transaction.category,
      transactionDate,
      transaction.notes,
    );
  }
}

extension DateTimeDaysSinceEpoch on DateTime {
  int get fromDaysSinceEpoch {
    final utcMidnight = DateTime.utc(year, month, day);
    return utcMidnight.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  }
}

extension IntDaysSinceEpoch on int {
  DateTime get toDaysSinceEpoch {
    return DateTime.fromMillisecondsSinceEpoch(
      this * Duration.millisecondsPerDay,
      isUtc: true,
    );
  }
}
