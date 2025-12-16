import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances/list/cubit/transactions_list_cubit.dart';
import 'package:personal_finances/repository/financial_data.dart';
import 'package:personal_finances/repository/transaction.dart';
import 'package:personal_finances/repository/transactions_repository.dart';

void main() {
  late _MockTransactionsRepository repository;
  late StreamController<FinancialData> controller;

  setUp(() {
    repository = _MockTransactionsRepository();
    controller = StreamController<FinancialData>();

    when(
      () => repository.loadFinancialData(),
    ).thenAnswer((_) => controller.stream);
  });

  tearDown(() async {
    await controller.close();
  });

  group('TransactionsListCubit tests', () {
    test('should have proper initial state', () async {
      // given
      final cubit = TransactionsListCubit(repository);

      // when
      expect(cubit.state, const TransactionsListState(FinancialData([], 0.0)));

      // then
      cubit.close();
    });

    test('should cancel subscription when closed', () async {
      // given
      final cubit = TransactionsListCubit(repository);

      // expect
      expect(controller.hasListener, isTrue);

      // when
      await cubit.close();

      // then
      expect(controller.hasListener, isFalse);
    });

    blocTest<TransactionsListCubit, TransactionsListState>(
      'should emit new state when repotitory emits item',
      build: () => TransactionsListCubit(repository),
      act: (cubit) async {
        final transaction1 = Transaction(
          100.0,
          'Salary',
          DateTime.utc(2025, 1, 1),
          TransactionType.income,
          'January salary',
        );

        final transaction2 = Transaction(
          20.0,
          'Food',
          DateTime.utc(2025, 1, 2),
          TransactionType.expense,
          null,
        );

        controller.add(FinancialData([transaction1], 100.0));
        controller.add(FinancialData([transaction1, transaction2], 80.0));

        // daj szansę event loopowi przepchnąć emisje
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => [
        TransactionsListState(
          FinancialData([
            Transaction(
              100.0,
              'Salary',
              DateTime.utc(2025, 1, 1),
              TransactionType.income,
              'January salary',
            ),
          ], 100.0),
        ),
        TransactionsListState(
          FinancialData([
            Transaction(
              100.0,
              'Salary',
              DateTime.utc(2025, 1, 1),
              TransactionType.income,
              'January salary',
            ),
            Transaction(
              20.0,
              'Food',
              DateTime.utc(2025, 1, 2),
              TransactionType.expense,
              null,
            ),
          ], 80.0),
        ),
      ],
    );
  });
}

class _MockTransactionsRepository extends Mock
    implements TransactionsRepository {}
