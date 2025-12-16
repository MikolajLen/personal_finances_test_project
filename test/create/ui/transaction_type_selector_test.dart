import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances/create/ui/transaction_type_selector.dart';
import 'package:personal_finances/repository/transaction.dart';

class _MockCallbacks extends Mock {
  void onChanged(TransactionType? value);
  void setType(TransactionType value);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TransactionTypeSelector', () {
    testWidgets('renders both options and two radios', (tester) async {
      // given
      final cb = _MockCallbacks();

      // when
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TransactionTypeSelector(
              groupValue: null,
              onChanged: cb.onChanged,
              setType: cb.setType,
            ),
          ),
        ),
      );

      // then
      expect(find.text('Expense'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.byType(Radio<TransactionType>), findsNWidgets(2));
      expect(
        find.byWidgetPredicate(
          (w) => w is Radio<TransactionType> && w.value == TransactionType.expense,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Radio<TransactionType> && w.value == TransactionType.income,
        ),
        findsOneWidget,
      );
    });

    testWidgets('tap on Expense InkWell calls setType(expense) exactly once', (tester) async {
      // given
      final cb = _MockCallbacks();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TransactionTypeSelector(
              groupValue: null,
              onChanged: cb.onChanged,
              setType: cb.setType,
            ),
          ),
        ),
      );

      // when
      await tester.tap(find.text('Expense'));
      await tester.pump();

      // then
      verify(() => cb.setType(TransactionType.expense)).called(1);
      verifyNever(() => cb.setType(TransactionType.income));
    });

    testWidgets('tap on Income InkWell calls setType(income) exactly once', (tester) async {
      // given
      final cb = _MockCallbacks();
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TransactionTypeSelector(
              groupValue: null,
              onChanged: cb.onChanged,
              setType: cb.setType,
            ),
          ),
        ),
      );

      // when
      await tester.tap(find.text('Income'));
      await tester.pump();

      //then
      verify(() => cb.setType(TransactionType.income)).called(1);
      verifyNever(() => cb.setType(TransactionType.expense));
    });

    testWidgets('tapping Radio triggers onChanged with matching value (expense)', (tester) async {
      // given
      final cb = _MockCallbacks();
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TransactionTypeSelector(
              groupValue: null,
              onChanged: cb.onChanged,
              setType: cb.setType,
            ),
          ),
        ),
      );

      final expenseRadioFinder = find.byWidgetPredicate(
        (w) => w is Radio<TransactionType> && w.value == TransactionType.expense,
      );

      // when
      await tester.tap(expenseRadioFinder);
      await tester.pump();

      // then
      verify(() => cb.onChanged(TransactionType.expense)).called(1);
    });

    testWidgets('tapping Radio triggers onChanged with matching value (income)', (tester) async {
      // given
      final cb = _MockCallbacks();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TransactionTypeSelector(
              groupValue: null,
              onChanged: cb.onChanged,
              setType: cb.setType,
            ),
          ),
        ),
      );

      final incomeRadioFinder = find.byWidgetPredicate(
        (w) => w is Radio<TransactionType> && w.value == TransactionType.income,
      );

      // when
      await tester.tap(incomeRadioFinder);
      await tester.pump();

      // then
      verify(() => cb.onChanged(TransactionType.income)).called(1);
    });

  
    testWidgets('layout: has Row with two Expanded children', (tester) async {
      // given
      final cb = _MockCallbacks();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TransactionTypeSelector(
              groupValue: null,
              onChanged: cb.onChanged,
              setType: cb.setType,
            ),
          ),
        ),
      );

      // when
      final rootRow = tester.widget<Row>(find.byType(Row).first);

      // then
      expect(rootRow.children.length, 2);
      expect(find.byType(Expanded), findsNWidgets(2));
      expect(find.byType(InkWell), findsNWidgets(2));
    });
  });
}
