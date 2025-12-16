import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances/database/transactions_dao.dart';
import 'package:personal_finances/database/transactions_database.dart';
import 'package:personal_finances/repository/transactions_repository_impl.dart';
import 'package:personal_finances/repository/transaction.dart';

void main() {
  group('TransactionsRepositoroyImpl tests', () {
    test('verify properly maps db items', () async {
      // given
      final dao = _FakeDao();
      final repository = TransactionsRepositoryImpl(dao);

      // when
      final result = await repository.loadFinancialData().first;

      // then
      expect(result.balance, 50.0);
      expect(result.transactions.length, 2);
      expect(result.transactions[0].amount, 15.0);
      expect(result.transactions[0].category, 'Personal');
      expect(result.transactions[0].date, DateTime.utc(2022, 12, 1));
      expect(result.transactions[0].transactionType, TransactionType.income);
      expect(result.transactions[0].notes, isNull);
      expect(result.transactions[1].amount, 39.9);
      expect(result.transactions[1].category, 'Company');
      expect(result.transactions[1].date, DateTime.utc(2022, 12, 2));
      expect(result.transactions[1].transactionType, TransactionType.expense);
      expect(result.transactions[1].notes, 'new notepad');
    });

    test(
      'should insert item with positive amount when item is income',
      () async {
        // given
        final dao = _MockDao();
        when(
          () => dao.insertTransaction(any(), any(), any(), any()),
        ).thenAnswer((_) => Future.value(1));
        final repository = TransactionsRepositoryImpl(dao);
        final transaction = Transaction(
          100.0,
          'Salary',
          DateTime.utc(2025, 1, 1),
          TransactionType.income,
          'January salary',
        );
        // when
        repository.insertTransaction(transaction);

        // then
        verify(
          () => dao.insertTransaction(
            100.0,
            'Salary',
            DateTime.utc(2025, 1, 1).fromDaysSinceEpoch,
            'January salary',
          ),
        ).called(1);
      },
    );

    test(
      'should insert item with negavive amount when item is expense',
      () async {
        // given
        final dao = _MockDao();
        when(
          () => dao.insertTransaction(any(), any(), any(), any()),
        ).thenAnswer((_) => Future.value(1));
        final repository = TransactionsRepositoryImpl(dao);
        final transaction = Transaction(
          20.0,
          'Food',
          DateTime.utc(2025, 1, 2),
          TransactionType.expense,
          'Hungry',
        );
        // when
        repository.insertTransaction(transaction);

        // then
        verify(
          () => dao.insertTransaction(
            -20.0,
            'Food',
            DateTime.utc(2025, 1, 2).fromDaysSinceEpoch,
            'Hungry',
          ),
        ).called(1);
      },
    );

    test('should properly return list of categories', () async {
      // given
      final dao = _FakeDao();
      final repository = TransactionsRepositoryImpl(dao);

      // when
      final result = await repository.loadCategories();

      // then
      expect(result, ['Food', 'Clothes', 'Car', 'Personal']);
    });
  });
}

class _FakeDao implements TransactionsDao {
  @override
  Stream<List<TransactionItemData>> observeTransactions() => Stream.fromFuture(
    Future.value([
      TransactionItemData(
        id: 1,
        amount: 15.0,
        category: 'Personal',
        transactionDate: DateTime.utc(2022, 12, 1).fromDaysSinceEpoch,
        notes: null,
      ),
      TransactionItemData(
        id: 2,
        amount: -39.9,
        category: 'Company',
        transactionDate: DateTime.utc(2022, 12, 2).fromDaysSinceEpoch,
        notes: 'new notepad',
      ),
    ]),
  );

  @override
  Future<double> calculateBalance() {
    return Future.value(50.0);
  }

  @override
  Future<int> insertTransaction(
    double amount,
    String category,
    int transactionDate,
    String? notes,
  ) {
    return Future.value(0);
  }

  @override
  Future<List<String>> loadCategories() {
    return Future.value(['Food', 'Clothes', 'Car', 'Personal']);
  }
}

class _MockDao extends Mock implements TransactionsDao {}
