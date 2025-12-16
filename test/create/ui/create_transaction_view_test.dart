import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances/create/cubit/create_transaction_cubit.dart';
import 'package:personal_finances/create/ui/create_transaction_view.dart';
import 'package:personal_finances/repository/transaction.dart';

class _MockCallbacks extends Mock {
  void setCategory(String? v);
  void addCategoryAndSelect(String v);
  void setDate(DateTime v);
  void onTransactionTypeChanged(TransactionType? v);
  void setType(TransactionType? v);
  void validate();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateTransactionView', () {
    testWidgets('shows extra error texts when showExtraErrors and missing type/date', (tester) async {
      // given
      final cb = _MockCallbacks();

      final formKey = GlobalKey<FormState>();
      final searchController = TextEditingController();
      final amountController = TextEditingController();
      final notesController = TextEditingController();

      // when
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CreateTransactionView(
              formKey: formKey,
              searchController: searchController,
              amountController: amountController,
              notesController: notesController,
              setCategory: cb.setCategory,
              addCategoryAndSelect: cb.addCategoryAndSelect,
              setDate: cb.setDate,
              onTransactionTypeChanged: cb.onTransactionTypeChanged,
              setType: cb.setType,
              state: const CreateTransactionState(
                categories: [],
                showExtraErrors: true,
                type: null,
                date: null,
              ),
              validate: cb.validate,
            ),
          ),
        ),
      );

      // then
      expect(find.text('Transaction type is required!'), findsOneWidget);
      expect(find.text('Transaction date is required!'), findsOneWidget);

      searchController.dispose();
      amountController.dispose();
      notesController.dispose();
    });

    testWidgets('should show amount error and clear error when enter some amount', (tester) async {
      // given
      final cb = _MockCallbacks();

      final formKey = GlobalKey<FormState>();
      final searchController = TextEditingController();
      final amountController = TextEditingController();
      final notesController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CreateTransactionView(
              formKey: formKey,
              searchController: searchController,
              amountController: amountController,
              notesController: notesController,
              setCategory: cb.setCategory,
              addCategoryAndSelect: cb.addCategoryAndSelect,
              setDate: cb.setDate,
              onTransactionTypeChanged: cb.onTransactionTypeChanged,
              setType: cb.setType,
              state: const CreateTransactionState(categories: []),
              validate: cb.validate,
            ),
          ),
        ),
      );
      amountController.text = '';

      // when
      formKey.currentState!.validate();
      await tester.pump();

      // then
      expect(find.text('Amount cannot be empty'), findsOneWidget);

      amountController.text = '0';

      // when
      formKey.currentState!.validate();
      await tester.pump();

      // then
      expect(find.text('Amount must be greater then 0'), findsOneWidget);

      amountController.text = '1,25';

      // when
      formKey.currentState!.validate();
      await tester.pump();

      // then
      expect(find.text('Amount cannot be empty'), findsNothing);
      expect(find.text('Amount must be greater then 0'), findsNothing);
      searchController.dispose();
      amountController.dispose();
      notesController.dispose();
    });
  });
}
