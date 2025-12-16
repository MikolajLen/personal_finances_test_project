import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances/create/cubit/create_transaction_cubit.dart';
import 'package:personal_finances/repository/transaction.dart';
import 'package:personal_finances/repository/transactions_repository.dart';

class _MockTransactionsRepository extends Mock implements TransactionsRepository {}

class _FakeTransaction extends Fake implements Transaction {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TransactionsRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeTransaction());
  });

  setUp(() {
    repository = _MockTransactionsRepository();
    when(() => repository.loadCategories()).thenAnswer((_) async => <String>[]);
    when(() => repository.insertTransaction(any())).thenAnswer((_) async {});
  });

  group('CreateTransactionCubit', () {
    test('constructor loads categories and emits updated state', () async {
      // given
      when(() => repository.loadCategories())
          .thenAnswer((_) async => <String>['Food', 'Rent']);

      // when
      final cubit = CreateTransactionCubit(repository);

      // then
      await expectLater(
        cubit.stream,
        emits(
          isA<CreateTransactionState>().having(
            (s) => s.categories,
            'categories',
            <String>['Food', 'Rent'],
          ),
        ),
      );
      await cubit.close();
    });

    blocTest<CreateTransactionCubit, CreateTransactionState>(
      'setCategory trims value',
      build: () => CreateTransactionCubit(repository),
      act: (c) => c.setCategory('  Food  '),
      expect: () => [
        isA<CreateTransactionState>().having((s) => s.category, 'category', 'Food'),
      ],
    );

    blocTest<CreateTransactionCubit, CreateTransactionState>(
      'setCategory with null sets category to null',
      build: () => CreateTransactionCubit(repository),
      act: (c) => c.setCategory(null),
      expect: () => [
        isA<CreateTransactionState>().having((s) => s.category, 'category', isNull),
      ],
    );

    blocTest<CreateTransactionCubit, CreateTransactionState>(
      'setType updates type',
      build: () => CreateTransactionCubit(repository),
      act: (c) => c.setType(TransactionType.income),
      expect: () => [
        isA<CreateTransactionState>().having(
          (s) => s.type,
          'type',
          TransactionType.income,
        ),
      ],
    );

    blocTest<CreateTransactionCubit, CreateTransactionState>(
      'setDate updates date',
      build: () => CreateTransactionCubit(repository),
      act: (c) => c.setDate(DateTime(2025, 1, 2)),
      expect: () => [
        isA<CreateTransactionState>().having(
          (s) => s.date,
          'date',
          DateTime(2025, 1, 2),
        ),
      ],
    );
  });
}
