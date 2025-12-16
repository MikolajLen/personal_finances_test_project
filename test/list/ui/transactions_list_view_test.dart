import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finances/list/ui/transactions_list_view.dart';
import 'package:personal_finances/repository/transaction.dart';
import 'package:personal_finances/utils/clock.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('should properly display list and balance', (
    WidgetTester tester,
  ) async {
    // given
    final balance = 11450.34;
    final testWidget = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test app'),
        ),
        body: TransactionsListView(transactions: _transactions, balance: balance, clock: _FakeClock()),
      ),
    );

    // when
    await tester.pumpWidget(testWidget);

    // then
    //balance
    expect(find.text('Current balance: 11450.34'), findsOneWidget);
    //common part
    expect(find.text('Income'), findsExactly(2));
    expect(find.text('Expense'), findsExactly(2));
    //first item
    expect(find.text('50.00'), findsOneWidget);
    expect(find.text('personal'), findsOneWidget);
    expect(find.text('lorem ipsum'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    //second item
    expect(find.text('39.90'), findsOneWidget);
    expect(find.text('salary'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    //third item
    expect(find.text('123.40'), findsOneWidget);
    expect(find.text('shopping'), findsOneWidget);
    expect(find.text('11.10.2025'), findsOneWidget);
    //forth item
    expect(find.text('1250.00'), findsOneWidget);
    expect(find.text('previous year summary'), findsOneWidget);
    expect(find.text('01.01.2025'), findsOneWidget);
  });
}

class _FakeClock implements Clock {
  @override
  DateTime now() {
    return DateTime.utc(2025, 12, 31);
  }
}

final _transactions = [
  Transaction(
    50.0,
    'personal',
    DateTime.utc(2025, 12, 31),
    TransactionType.expense,
    'lorem ipsum',
  ),
  Transaction(
    39.9,
    'salary',
    DateTime.utc(2025, 12, 30),
    TransactionType.income,
    null,
  ),
  Transaction(
    123.4,
    'shopping',
    DateTime.utc(2025, 10, 11),
    TransactionType.expense,
    null,
  ),
  Transaction(
    1250.0,
    'previous year summary',
    DateTime.utc(2025, 1, 1),
    TransactionType.income,
    null,
  ),
];
