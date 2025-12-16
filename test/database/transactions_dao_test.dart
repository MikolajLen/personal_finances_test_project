import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finances/database/transactions_dao.dart';
import 'package:personal_finances/database/transactions_database.dart';

void main() {
  late TransactionsDatabase transactionsDatabase;
  late TransactionsDao transactionsDao;
  group('TransactionsDatabase tests', () {
    setUp(() {
      transactionsDatabase = TransactionsDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );
      transactionsDao = TransactionsDao(transactionsDatabase);
    });

    tearDown(() async {
      await transactionsDatabase.close();
    });

    test('verify db properly store and return items', () async {
      // given
      final testAmount = -49.9;
      final testCategory = 'personal';
      final testDate = 1000;
      final testNotes = 'some example note';

      final stream = transactionsDao.observeTransactions();
      final initial = await stream.first;

      // expected
      expect(initial, isEmpty);

      // given
      final next = stream.skip(1).first;

      // when
      await transactionsDao.insertTransaction(
        testAmount,
        testCategory,
        testDate,
        testNotes,
      );

      // then
      final afterInsert = await next;
      expect(afterInsert.length, 1);
      expect(afterInsert[0].amount, testAmount);
      expect(afterInsert[0].category, testCategory);
      expect(afterInsert[0].transactionDate, testDate);
      expect(afterInsert[0].notes, testNotes);
    });

    test('check if balance is calculated properly', () async {
      // given
      await transactionsDao.insertTransaction(-49.9, 'category', 1000, null);
      await transactionsDao.insertTransaction(120.0, 'category', 1000, null);
      await transactionsDao.insertTransaction(-30.0, 'category', 1000, null);
      await transactionsDao.insertTransaction(19.9, 'category', 1000, null);

      // when
      final result = await transactionsDao.calculateBalance();

      // then
      expect(result, 60.0);
    });

    test('verify db properly returns categories', () async {
      // given
      await transactionsDao.insertTransaction(-49.9, 'food', 1000, null);
      await transactionsDao.insertTransaction(120.0, 'personal', 1000, null);
      await transactionsDao.insertTransaction(-30.0, 'standard', 1000, null);
      await transactionsDao.insertTransaction(19.9, 'personal', 1000, null);
      await transactionsDao.insertTransaction(-5.9, 'food', 1000, null);

      // when
      final result = await transactionsDao.loadCategories();

      // then
      expect(result, ['food', 'personal', 'standard']);
    });
  });
}
